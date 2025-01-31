import 'dart:io';
import 'dart:math';

import 'package:fairpytasker/Repository/feedback_repository.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_events.dart';
import 'package:fairpytasker/UI/Feedback/feedback_edit/bloc/fb_edit_states.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';

class FBEditBloc extends Bloc<FBEditEvents, FBEditStates> {
  final FeedBackRepository _feedBackRepository = FeedBackRepository();
  final ImagePicker _picker = ImagePicker();
  late TextEditingController feedTitleController;
  late QuillController feedDescriptionController;
  List<dynamic> feedAttachments = [];
  Map<String, dynamic> feedbackResponse = {};
  Map<String, dynamic> commentResponse = {};
  dynamic feedBackId;
  dynamic pageId = 0;
  FBEditBloc() : super(FBLoadingState()) {
    on<FBInitialEvent>((event, emit) async {
      feedBackId = event.feedBackId;
      try {
        emit(FBLoadingState());
        var response = await Future.wait([
          _fetchFeedBack(feedBackId),
          _fetchFeedBackComments(feedBackId)
        ]);
        feedbackResponse = response[0] ?? {};
        commentResponse = response[1] ?? {};
        feedAttachments = (feedbackResponse['feedback']?['attachments'] ?? []).map((e) => e['path'].toString().toAttachmentURL).toList();
        feedAttachments.insert(0, null);
        feedTitleController = TextEditingController(text: "${feedbackResponse['feedback']?['title']}");
        feedDescriptionController = QuillController.basic()..document.insert(0, "${feedbackResponse['feedback']?['title']}");
        emit(FBLoadedState());
        emit(FBFeedbackState(
          feedTitleController,
          feedDescriptionController,
          feedbackResponse['feedback']?['priority']
        ));
      } catch (e) {
        emit(FBErrorState(e.toString()));
      }
    });

    on<FBPageEvent>((event, emit) {
      pageId = event.pageId;
      emit(pageId == 0 ? FBFeedState() : FBCommentState());
    });


    on<FBFeedSubmitEvent>((event, emit) {

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

  }

  Future<Map<String, dynamic>?> _fetchFeedBack(dynamic id) async {
    return await _feedBackRepository.getFeedback(id);
  }

  Future<Map<String, dynamic>?> _fetchFeedBackComments(dynamic id) async {
    return await _feedBackRepository.getFeedBackComments(id);
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