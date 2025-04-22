import 'dart:convert';
import 'dart:io';
import 'dart:developer' as d;

import 'package:fairpytasker/Repository/feedback_repository.dart';
import 'package:fairpytasker/Response/feedback_status_response.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_events.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_states.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/int_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class FBEditBloc extends Bloc<FBEditEvents, FBEditStates> {
  final FeedBackRepository _feedBackRepository = FeedBackRepository();
  final ImagePicker _picker = ImagePicker();
  late TextEditingController feedTitleController;
  final TextEditingController commentController = TextEditingController();
  late QuillController feedDescriptionController;
  List<dynamic> feedAttachments = [];
  Map<String, dynamic> feedbackResponse = {};
  Map<String, dynamic> commentResponse = {};
  List<dynamic> comments = [];
  List<StatusList> feedbackStatuses = [];
  List<File> commentAttachments = [];
  dynamic feedBackId;
  dynamic pageId = 0;
  dynamic pageTitle = "";
  dynamic priority = "";
  dynamic status = 0;

  List<String> statuses = ["Pending", "In Progress", "Review", "Closed", "Feature", "Archive"];

  FBEditBloc() : super(FBLoadingState()) {
    on<FBInitialEvent>((event, emit) async {
      feedBackId = event.feedBackId;
      try {
        emit(FBLoadingState());
        var response = await Future.wait([
          _fetchFeedBack(feedBackId),
          _fetchFeedBackComments(feedBackId),
        ]);
        feedbackResponse = response[0] ?? {};
        commentResponse = response[1] ?? {};
        feedbackStatuses = (await _feedbackStatusApiUrl()) ?? [];
        status = feedbackResponse['feedback']?['status'] ?? 0;
        comments = commentResponse['comments'] ?? [];
        feedAttachments = (List.from(feedbackResponse['feedback']?['attachments']).isEmpty) ? [] : List.from(feedbackResponse['feedback']?['attachments'] ?? []).map((e) => e['path'].toString().toAttachmentURL).toList();
        feedAttachments.insert(0, "");
        pageTitle = "${feedbackResponse['feedback']?['title'] ?? ""}";
        priority = "${feedbackResponse['feedback']?['priority'] ?? "medium"}";
        feedTitleController = TextEditingController(text: pageTitle);
        feedDescriptionController = QuillController.basic();
        if (feedbackResponse['feedback']?['description'].toString().isNotNullOrEmpty ?? false) feedDescriptionController.document = Document.fromDelta(HtmlToDelta().convert(feedbackResponse['feedback']?['description'] ?? ""));
        emit(FBLoadedState());
        emit(FBFeedbackState(
          feedTitleController,
          feedDescriptionController,
            priority,
          status
        ));
      } catch (e) {
        Console.of.error(e);
        emit(FBErrorState(e.toString()));
      }
    });

    on<FBPageEvent>((event, emit) {
      pageId = event.pageId;
      emit((pageId == 0) ? (state is FBFeedbackState) ? (state as FBFeedbackState).copyWith(
          titleController: feedTitleController,
          descriptionController: feedDescriptionController,
          priority: priority,
          status: status
      ) : FBFeedbackState(feedTitleController, feedDescriptionController, priority, status) : FBCommentState(comments));
    });

    on<FBFeedPriorityChangeEvent>((event, emit) async {
      priority = event.priority;
      emit(FBFeedbackState(feedTitleController, feedDescriptionController, priority, status));
    });

    on<FBFeedStatusChangeEvent>((event, emit) {
      status = event.status;
      emit(FBFeedbackState(feedTitleController, feedDescriptionController, priority, status));
    });


    on<FBFeedSubmitEvent>((event, emit) async {
      if (feedTitleController.text.isEmpty) {
        emit(FBErrorState("Title field is required"));
        return;
      }
      if (feedDescriptionController.document.toDelta().toJson().isEmpty) {
        emit(FBErrorState("Description field is required"));
        return;
      }

      if ((priority == null) || (priority.toString().isEmpty) || (priority == "Select Priority".toLowerCase())) {
        emit(FBErrorState("Priority field is required"));
        return;
      }


      emit(FBLoadingState());
      try {
        var response = await _updateFeedBack();
        d.log("$response", name: "UPLOAD_COMMENT_RESPONSE");
        if (response != null && response['status'] == 200) {
          emit(FBLoadedState());
        }
      } catch (e) {
        d.log("$e", name: "UPLOAD_COMMENT_ERROR");
        emit(FBErrorState(e.toString()));
      }
    });

    on<FBFeedAddAttachmentEvent>((event, emit) async {
      var input = await _pickFiles();
        feedAttachments.addAll(input.where((element) => !feedAttachments.contains(element.path)).toList());
        emit(FBFeedAttachmentState(feedAttachments));
    });

    on<FBFeedRemoveAttachmentEvent>((event, emit) {
      if (event.attachment is String) return;
      feedAttachments.remove(event.attachment);
      emit(FBFeedAttachmentState(feedAttachments));
    });

    on<FBFeedViewAttachmentEvent>((event, emit) => emit(FBFeedViewAttachmentState(event.attachment, event.attachments)));

    on<FBCommentAddAttachmentEvent>((event, emit) async {
      var result = await _pickFiles();
      commentAttachments = [...commentAttachments, ...result];
      emit(FBCommentAttachments(commentAttachments));
    });

    on<FBCommentRemoveAttachmentEvent>((event, emit) {
      if (event.attachment is String) return;
      commentAttachments.remove(event.attachment);
      emit(FBCommentAttachments(commentAttachments));
    });

    on<FBCommentSubmitEvent>((event, emit) async {
      if (commentController.text.isEmpty) {
        emit(FBErrorState("Comment field is required"));
        return;
      }
      emit(FBLoadingState());
      try {
        var response = await _uploadComments(feedBackId, comment: commentController.text, files: commentAttachments);
        d.log("$response", name: "UPLOAD_COMMENT_RESPONSE");
        if (response != null && response['status'] == 200) {
          comments.add(response['comments']);
          commentController.clear();
          commentAttachments = [];
          emit(FBCommentState(comments));
          emit(FBCommentAttachments(commentAttachments));
        }
      } catch (e) {
        d.log("$e", name: "UPLOAD_COMMENT_ERROR");
        emit(FBErrorState(e.toString()));
      }
    });

    on<FBCommentDeleteEvent>((event, emit) async {
      emit(FBLoadingState());
      try {
        var response = await _deleteComment(event.commentId);
        d.log("$response", name: "DELETE_COMMENT_RESPONSE");
        if (response != null && response['status'] == 200) {
          comments.removeWhere((element) => element['id'] == event.commentId);
          emit(FBCommentState(comments));
        }
      } catch (e) {
        d.log("$e", name: "DELETE_COMMENT_ERROR");
        emit(FBErrorState(e.toString()));
      }
    });

  }

  Future<Map<String, dynamic>?> _fetchFeedBack(dynamic id) async {
    return await _feedBackRepository.getFeedback(id);
  }

  Future<Map<String, dynamic>?> _fetchFeedBackComments(dynamic id) async {
    return await _feedBackRepository.getFeedBackComments(id);
  }

  Future<Map<String, dynamic>?> _uploadComments(dynamic feedBackId, {dynamic comment, List<File>? files}) async {
    return await _feedBackRepository.addFeedBackComments(feedBackId, comment: comment, files: files);
  }

  Future<Map<String, dynamic>?> _deleteComment(dynamic commentId) async {
    return await _feedBackRepository.deleteFeedbackComment(commentId);
  }

  Future<List<StatusList>?> _feedbackStatusApiUrl() async {
    return (await _feedBackRepository.fetchFeedbackStatus())?.statusList;
  }

  Future<Map<String, dynamic>?> _updateFeedBack() async {
    var lastImageIndex = (feedAttachments.where((element) => ((element as String).isNetworkURL)).length - 1);
    var lastVideoIndex = (feedAttachments.where((element) => ((element as String).isNetworkURL)).length - 1);
    var imageFiles = feedAttachments.where((element) => !((element as String).isNetworkURL)).where((element) => (element as String).isImageFile);
    var videoFiles = feedAttachments.where((element) => !((element as String).isNetworkURL)).where((element) => !((element as String).isImageFile));
    var converter = QuillDeltaToHtmlConverter(
      feedDescriptionController.document.toDelta().toJson(),
      ConverterOptions.forEmail(),
    );
    var htmlContent = converter.convert();
    d.log(" $lastVideoIndex, $lastImageIndex, ${imageFiles.length} ${videoFiles.length} ${htmlContent}", name: "BODY_DATA");
    return await _feedBackRepository.updateFeedback(feedBackId, title: feedTitleController.text, description: htmlContent, priority: priority, status: status, files: [...imageFiles, ...videoFiles], lastImageIndex: lastImageIndex.toPositive, lastVideoIndex: lastVideoIndex.toPositive);

  }

  Future<List<File>> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultipleMedia();
    return pickedFiles.map((e) => File(e.path)).toList();
  }
  
  Future<List<File>> _pickFiles() async {
    var result = await FilePicker.platform.pickFiles(allowMultiple: true,
    allowCompression: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov']
    );
    return result?.paths.where((element) => (element?.isNotEmpty ?? false)).map((e) => File(e!)).toList() ?? [];
  }

}