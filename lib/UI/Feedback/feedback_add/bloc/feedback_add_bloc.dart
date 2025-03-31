import 'dart:async';
import 'dart:io';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:path/path.dart' as p;
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:fairpytasker/UI/Feedback/feedback_add/bloc/feedback_add_events.dart';
import 'package:fairpytasker/UI/Feedback/feedback_add/bloc/feedback_add_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class FeedbackAddBloc extends Bloc<FeedbackAddEvent, FeedbackAddState> {
  final q.QuillController descriptionController = q.QuillController.basic();
  final TextEditingController titleController = TextEditingController();
  final List<String> priority = ['High', 'Medium', 'Low'];
  String? selectedPriority = "Medium";
  List<File> attachments = [];
  final APiRepository _apiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();
  FeedbackAddBloc() : super(FeedbackAddLoadingState()) {
    on<FeedbackAddAttachmentEvent>(_onFeedbackAddAttachmentEvent);
    on<FeedbackSelectedPriorityEvent>(_onFeedbackSelectedPriorityEvent);
    on<FeedbackDeleteAttachmentEvent>(_onFeedbackDeleteAttachmentEvent);
    on<FeedbackSubmitEvent>(_onFeedbackSubmitEvent);
    on<FeedbackViewAttachmentEvent>(_onFeedbackViewAttachmentEvent);
  }

  /// API CALLS
  Future<List<File>> _pickFiles() async => (await ImagePicker().pickMultipleMedia()).map((e) => File(e.path)).toList();
  Future<Map<String, dynamic>?> _addFeedback(Map<String, dynamic> data, List<Map<String, String?>>? files) async => await _apiRepository.uploadFeedback(body: data, infusedFiles: files);

  void _onFeedbackAddAttachmentEvent(FeedbackAddAttachmentEvent event, Emitter<FeedbackAddState> emit) async {
    try {
      var files = await _pickFiles();
      var filePaths = attachments.map((e) => p.basename(e.path));
      var newFilePaths = files.map((e) => p.basename(e.path));
      Console.of.log(filePaths);
      Console.of.warning(newFilePaths);
      var picked = files.where((element) => !filePaths.contains(p.basename(element.path)));
      if (picked.isNotEmpty) attachments.addAll(picked);
      emit(FeedbackAddCommonState());
    } catch (e) {
      emit(FeedbackAddErrorState(e));
    }
  }

  void _onFeedbackDeleteAttachmentEvent(FeedbackDeleteAttachmentEvent event, Emitter<FeedbackAddState> emit) {
    attachments.remove(event.model);
    emit(FeedbackAddCommonState());
  }

  void _onFeedbackSelectedPriorityEvent(FeedbackSelectedPriorityEvent event, Emitter<FeedbackAddState> emit) {
    selectedPriority = event.value;
    emit(FeedbackAddCommonState());
  }

  void _onFeedbackSubmitEvent(FeedbackSubmitEvent event, Emitter<FeedbackAddState> emit) async {
    try {
      var plainText = descriptionController.document.toPlainText();
      var mapData = <String, String>{
        "title" : titleController.text,
        "priority" : selectedPriority?.toLowerCase() ?? "",
      };
      if (plainText.trim().isNotNullOrEmpty) mapData["description"] = QuillDeltaToHtmlConverter(descriptionController.document.toDelta().toJson(), ConverterOptions.forEmail()).convert();
      // if (plainText.isNotNullOrEmpty) mapData["description"] = plainText;
      var files = attachments.map((e) => {
        (e.isImage ? "images" : "videos") : e.path,
      }).toList();
      Console.of.error(plainText);
      Console.of.debug(mapData);
      Console.of.warning(files);
      emit(FeedbackAddLoadingState());
      var res = await _addFeedback(mapData, files);
      _broadcast.stickyBroadcast("feedback_refresh", value: true);
      if (res != null) {
        emit(FeedbackAddCompletedState());
      } else {
        emit(FeedbackAddErrorState("Something went wrong"));
      }
    } catch (e) {
      Console.of.error(e);
      emit(FeedbackAddErrorState(e));
    }
  }

  void _onFeedbackViewAttachmentEvent(FeedbackViewAttachmentEvent event, Emitter<FeedbackAddState> emit) {
    emit(FeedbackAddViewAttachmentState(event.model, attachments));
  }
}