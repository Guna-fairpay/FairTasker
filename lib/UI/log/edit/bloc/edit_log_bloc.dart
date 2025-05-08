import 'dart:async';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/log/edit/bloc/edit_log_events.dart';
import 'package:fairpytasker/UI/log/edit/bloc/edit_log_states.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/helper.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditLogBloc extends Bloc<EditLogEvent, EditLogState> {
  final APiRepository _aPiRepository = APiRepository();
  final TextEditingController titleController = TextEditingController();
  List<dynamic> attachments = [];
  Map<String, dynamic>? _model;
  EditLogBloc() : super(EditLogLoadingState()) {
    on<EditLogInitialEvent>(_onInitialEvent);
    on<EditLogPickFilesEvent>(_onPickFilesEvent);
    on<EditLogTapRecordAudioEvent>(_onTapRecordAudioEvent);
    on<EditLogTapRecordVideoEvent>(_onTapRecordVideoEvent);
    on<EditLogSubmitEvent>(_onSubmitEvent);
    on<EditLogTapDeleteAttachmentEvent>(_onTapDeleteAttachmentEvent);
    on<EditLogDeleteAttachmentEvent>(_onDeleteAttachmentEvent);
    on<EditLogInsertAttachmentEvent>(_onInsertAttachmentEvent);
  }

  Future<Map<String, dynamic>?> _fetchLog(dynamic id) async => await _aPiRepository.getLog(id: id);
  Future<Map<String, dynamic>?> _deleteLogAttachment(dynamic id) async => await _aPiRepository.deleteLogAttachment(attachmentId: id);
  Future<Map<String, dynamic>?> _updateLog(Map<String, dynamic> body, dynamic id, {List<dynamic>? attachment}) async => await _aPiRepository.updateLog(logId: id, body: body, infusedFiles: attachment);

  void _onInitialEvent(EditLogInitialEvent event, Emitter<EditLogState> emit) async {
    try {
      emit(EditLogLoadingState());
      var model = event.model;
      var response = await _fetchLog(model['id']);
      if (response?['status'] == true) _model = response?['data'];
      titleController.text = (_model?['title'] ?? "");
      attachments.clear();
      var attachment = List.from(_model?['attachments']).map((e) => e['path'].toString().toTaskerStorageURL).toList();
      attachments.addAll(attachment);
      emit(EditLogCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(EditLogErrorState(e));
    }
  }

  void _onPickFilesEvent(EditLogPickFilesEvent event, Emitter<EditLogState> emit) async {
    try {
      var result = await CommonHelper.instance.pickFiles();
      if (result.isNotEmpty) attachments.addAll(result);
      emit(EditLogCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(EditLogErrorState(e));
    }
  }

  void _onTapRecordAudioEvent(EditLogTapRecordAudioEvent event, Emitter<EditLogState> emit) {
    emit(EditLogRecordState());
  }

  void _onTapRecordVideoEvent(EditLogTapRecordVideoEvent event, Emitter<EditLogState> emit) async {
    try {
      var result = await CommonHelper.instance.pickVideo();
      if (result != null) attachments.add(result);
      emit(EditLogCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(EditLogErrorState(e));
    }
  }

  void _onSubmitEvent(EditLogSubmitEvent event, Emitter<EditLogState> emit) async {
    try {
      var body = { "title" : titleController.text };
      var logId = _model?['id'];
      var bodyFiles = attachments.whereType<File>().map((e) => { "attachments" : e.path }).toList();
      emit(EditLogLoadingState());
      var response = await _updateLog(body, logId, attachment: bodyFiles);
      if (response?['status'] == true) {
        FBroadcast.instance().broadcast("log_refresh");
        emit(EditLogSuccessState("Log Updated Successfully"));
        await Future.delayed(Durations.short1);
        emit(EditLogCompleteState());
      } else {
        emit(EditLogErrorState(response?['message'] ?? (response?['error'] ?? "Unknown Error")));
      }
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(EditLogErrorState(e));
    }
  }

  void _onTapDeleteAttachmentEvent(EditLogTapDeleteAttachmentEvent event, Emitter<EditLogState> emit) {
    emit(EditLogDeletePermissionState(event.model));
  }

  void _onDeleteAttachmentEvent(EditLogDeleteAttachmentEvent event, Emitter<EditLogState> emit) async {
    try {
      var attachment = event.model;
      if (attachment is String) {
        // REMOVE FROM SERVER
        emit(EditLogLoadingState());
        var attachmentId = List.from(_model?['attachments']).firstWhereOrNull((e) => e['path'] == attachment.removeTaskerStorageUrl)?['id'];
        var response = await _deleteLogAttachment(attachmentId);
        if (response?['status'] == true) {
          FBroadcast.instance().broadcast("log_refresh");
          attachments.remove(attachment);
        } else {
          emit(EditLogErrorState(response?['message'] ?? (response?['error'] ?? "Unknown Error")));
        }
      } else if (attachment is File) {
        // REMOVE FROM LOCAL
        attachments.remove(attachment);
      }
      emit(EditLogCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(EditLogErrorState(e));
    }
  }

  void _onInsertAttachmentEvent(EditLogInsertAttachmentEvent event, Emitter<EditLogState> emit) {
    attachments.add(event.model);
    emit(EditLogCommonState());
  }
}