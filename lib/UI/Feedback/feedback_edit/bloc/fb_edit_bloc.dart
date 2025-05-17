import 'dart:io';
import 'dart:developer' as d;
import 'package:collection/collection.dart';
import 'package:path/path.dart';
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
  final TextEditingController filePickerController  = TextEditingController();
  late QuillController feedDescriptionController;
  List<dynamic> feedAttachments = [];
  Map<String, dynamic> feedbackResponse = {};
  Map<String, dynamic> commentResponse = {};
  List<dynamic> comments = [];
  List<StatusList> feedbackStatuses = [];
  List<dynamic> commentAttachments = [];
  List<String> commentsAttachments =[];
  dynamic feedBackId;
  dynamic pageId = 0;
  dynamic pageTitle = "";
  dynamic priority = "";
  dynamic status = 0;
  bool isEdit = false;
  int? commentId;
  List<Map<String, dynamic>> attachmentMetadata = [];

  dynamic selectedCommentModel;

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
        feedAttachments = [];
        feedAttachments.addAll((List.from(feedbackResponse['feedback']?['attachments']).isEmpty) ? [] : List.from(feedbackResponse['feedback']?['attachments'] ?? []).map((e) => e['path'].toString().toAttachmentURL).toList());
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

        }
        emit(FBLoadedState());
      } catch (e) {
        d.log("$e", name: "UPLOAD_COMMENT_ERROR 120");
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
      var attachments = List.from(commentAttachments);
      var existingAttachments = List.from(commentAttachments)
          .whereType<File>()
          .map((e) => (e.path))
          .toList();
      for (var element in result) {
        if (!existingAttachments.contains(element.path)) {
          attachments.add(element);
        }
      }
      commentAttachments = attachments;
      filePickerController.text=basename(commentAttachments.lastOrNull?.path ?? "");
      emit(FBCommentAttachments(commentAttachments));
    });

    on<FBCommentRemoveAttachmentEvent>((event, emit) async {
      try{
        if (event.attachment is File) {
          commentAttachments.remove(event.attachment);
        }else if(event.attachment is String){
          emit(FBLoadingState());
          var attachmentId = selectedCommentModel['attachments'].firstWhere(
                  (element) => element['path'] == event.attachment.toString().removeAttachmentURL,
              orElse: () => null)?['id'];
          var response = await _deleteCommentAttachment(attachmentId);
          if(response != null && response['status'] == 202){
            for (var element in comments) {
              if (List.from(element['attachments']).map((e) =>
                  e['id'].toString()).contains(attachmentId.toString())) {
                element['attachments'].removeWhere(
                      (img) => img['id'].toString() == attachmentId.toString(),
                );
              }
            }
            commentAttachments.remove(event.attachment);
          }
        }
        filePickerController.text=commentAttachments.lastOrNull ?? "";
        emit(FBCommentAttachments(commentAttachments));
      }catch(e){
        Console.of.error(e);
        emit(FBErrorState(e.toString()));
        emit(FBCommentAttachments(commentAttachments));
      }

    });

    on<FBCommentSubmitEvent>((event, emit) async {
      if (commentController.text.isEmpty) {
        emit(FBErrorState("Comment field is required"));
        return;
      }
      emit(FBLoadingState());
      try {
        var response = await _uploadComments(feedBackId, comment: commentController.text, files: commentAttachments.whereType<File>().toList());
        if (response != null && response['status'] == 200) {
          comments.add(response['comments']);
          commentController.clear();
          commentAttachments = [];
          filePickerController.clear();
          emit(FBCommentState(comments));
          emit(FBCommentAttachments(commentAttachments));
        }
        emit(FBLoadedState());
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

    on<FBCommentsEditEvent>((event, emit) async {
      isEdit = true;
      selectedCommentModel = event.model;
      commentController.text = event.model?['comment'] ?? "";
      commentId = event.model?['id'];
      List<dynamic> images = selectedCommentModel['attachments'];
      commentAttachments = images.map((e) => e['path'].toString().toAttachmentURL).toList();
      Console.of.log(commentAttachments);
      // filePickerController.text= (commentAttachments.lastOrNull?? "");
      emit(FBCommentState(comments));
      emit(FBCommentAttachments(commentAttachments));
    });

    on<FBCommentsEditCancelEvent>((event, emit) async {
      selectedCommentModel = null;
      commentController.clear();
      isEdit = false;
      commentAttachments = [];
      emit(FBCommentState(comments));
      emit(FBCommentAttachments(commentAttachments));
    });

    on<FBUpdateCommentEvent>((event, emit) async {
      if (commentController.text.isEmpty) {
        emit(FBErrorState("Comment field is required"));
        return;
      }
      emit(FBLoadingState());
      try {
        var response = await _updateComment(event.commentId, comment: commentController.text, files: commentAttachments.whereType<File>().toList());
        commentController.clear();
        commentAttachments = [];
        filePickerController.clear();
        isEdit = false;
        d.log("$response", name: "UPDATE_COMMENT_RESPONSE");
        if (response != null && response['status'] == 200) {
          // REMOVE OLD COMMENT AND ADD NEW COMMENT
          comments.removeWhere((element) => element['id'] == event.commentId);
          comments.add(response['comments']);
          // for (var element in comments) {
          //   if (element['id'].toString() == event.commentId.toString()) {
          //     element = response['comments'];
          //   }
          // }
          // comments.firstWhere((element) => element['id'] == event.commentId)['comment'] = commentController.text;
          emit(FBCommentState(comments));
          emit(FBCommentAttachments(commentAttachments));
        }
      } catch (e){
        d.log("Update comments error $e", name: "UPDATE_COMMENT_ERROR");
      }
    });

  }


  ///////////////////////////////
  Future<Map<String, dynamic>?> _fetchFeedBack(dynamic id) async {
    return await _feedBackRepository.getFeedback(id);
  }

  Future<Map<String, dynamic>?> _fetchFeedBackComments(dynamic id) async {
    return await _feedBackRepository.getFeedBackComments(id);
  }

  Future<Map<String, dynamic>?> _uploadComments(dynamic feedBackId, {dynamic comment, List<File>? files}) async {
    return await _feedBackRepository.addFeedBackComments(feedBackId, comment: comment, files: files);
  }

  Future<Map<String, dynamic>?> _updateComment(dynamic commentId, {dynamic comment, List<File>? files}) async {
    return await _feedBackRepository.updateFeedbackComment(commentId, comment: comment, files: files);
  }

  Future<Map<String, dynamic>?> _deleteCommentAttachment(dynamic attachmentId,) async {
    return await _feedBackRepository.deleteCommentAttachment(attachmentId);
  }

  Future<Map<String, dynamic>?> _deleteComment(dynamic commentId) async {
    return await _feedBackRepository.deleteFeedbackComment(commentId);
  }

  Future<List<StatusList>?> _feedbackStatusApiUrl() async {
    return (await _feedBackRepository.fetchFeedbackStatus())?.statusList;
  }

  Future<Map<String, dynamic>?> _updateFeedBack() async {
    var lastImageIndex = (feedAttachments.whereType<String>().where((element) => element.isNetworkURL).length - 1);
    var lastVideoIndex = (feedAttachments.whereType<String>().where((element) => element.isNetworkURL).length - 1);
    var imageFiles = feedAttachments.whereType<File>().where((element) => element.path.isImage);
    var videoFiles = feedAttachments.whereType<File>().where((element) => !element.path.isImage);
    var converter = QuillDeltaToHtmlConverter(
      feedDescriptionController.document.toDelta().toJson(),
      ConverterOptions.forEmail(),
    );
    var htmlContent = converter.convert();
    d.log(" $lastVideoIndex, $lastImageIndex, ${imageFiles.length} ${videoFiles.length} $htmlContent", name: "BODY_DATA");
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