import 'dart:async';
import 'dart:io';

import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/log/bloc/log_event.dart';
import 'package:fairpytasker/UI/log/bloc/log_state.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class LogBloc extends Bloc<LogEvent, LogState> {
  List<dynamic> attachments = [];
  int currentPage = 1;
  int _totalCount = 0;
  int itemsPerPage = 10;
  List<Map<String, dynamic>> _logResponse = [];
  List<Map<String, dynamic>> filteredResponse = [];
  int get totalPage => (_totalCount / itemsPerPage).ceil();
  final APiRepository _aPiRepository = APiRepository();
  final TextEditingController titleController = TextEditingController();
  LogBloc() : super(LogLoadingState()) {
    on<LogInitialEvent>(_onInitialEvent);
    on<LogRefreshEvent>(_onRefreshEvent);
    on<LogAddAttachmentEvent>(_onAddAttachmentEvent);
    on<LogAddRecordingEvent>(_onAddRecordingEvent);
    on<LogAddVideoEvent>(_onAddVideoEvent);
    on<LogAddViewAttachmentEvent>(_onAddViewAttachmentEvent);
    on<LogAddSubmitEvent>(_onAddSubmitEvent);
    on<LogPaginationEvent>(_onPaginationEvent);
    on<LogEditEvent>(_onEditEvent);
    on<LogDeleteEvent>(_onDeleteEvent);
    on<LogDeletePermissionEvent>(_onDeletePermissionEvent);
    on<LogViewAttachmentEvent>(_onViewAttachmentEvent);
    on<LogInsertAttachmentEvent>(_onInsertAttachmentEvent);
  }

  Future<Map<String, dynamic>?> _fetchLogs() async => await _aPiRepository.getLogs();
  Future<Map<String, dynamic>?> _deleteLog(dynamic logId) async => await _aPiRepository.deleteLog(logId: logId);
  Future<Map<String, dynamic>?> _uploadLog({required Map<String, dynamic> data, List<dynamic>? infusedFiles}) async => await _aPiRepository.uploadLog(body: data, infusedFiles: infusedFiles);

  Future<File?> _pickVideo() async {
    var result = await ImagePicker().pickVideo(source: ImageSource.camera);
    return (result != null) ? File(result.path) : null;
  }

  Future<List<File>> _pickFiles() async {
    var result = await FilePicker.platform.pickFiles(allowMultiple: true,
        type: FileType.any,
    );
    return result?.paths.where((element) => (element?.isNotEmpty ?? false)).map((e) => File(e!)).toList() ?? [];
  }

  Future<void> _fetching() async {
    try {
      var response = await _fetchLogs();
      _logResponse = List<Map<String, dynamic>>.from(response?['data'] ?? []);
      _totalCount = _logResponse.length;
      currentPage = 1;
      filteredResponse = paginateList(data: _logResponse, currentPage: currentPage, itemsPerPage: itemsPerPage);
    } catch (e) {
      rethrow;
    }
  }

  void _clearControllers() {
    titleController.clear();
    attachments.clear();
  }

  void _onInitialEvent(LogInitialEvent event, Emitter<LogState> emit) async {
    try {
      emit(LogLoadingState());
      await _fetching();
      emit(LogCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(LogErrorState(e));
    }
  }

  void _onRefreshEvent(LogRefreshEvent event, Emitter<LogState> emit) async {
    try {
      emit(LogLoadingState());
      await _fetching();
      emit(LogCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(LogErrorState(e));
    }
  }

  void _onAddAttachmentEvent(LogAddAttachmentEvent event, Emitter<LogState> emit) async {
    try {
      var files = await _pickFiles();
      if (files.isNotEmpty) attachments.addAll(files);
      emit(LogCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(LogErrorState(e));
    }
  }

  void _onAddRecordingEvent(LogAddRecordingEvent event, Emitter<LogState> emit) {
    emit(LogAddRecordingState());
  }

  void _onAddVideoEvent(LogAddVideoEvent event, Emitter<LogState> emit) async {
    try {
      var file = await _pickVideo();
      if (file != null) attachments.add(file);
      emit(LogCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(LogErrorState(e));
    }
  }

  void _onAddViewAttachmentEvent(LogAddViewAttachmentEvent event, Emitter<LogState> emit) {
    emit(LogAddViewAttachmentState(attachments));
  }

  void _onAddSubmitEvent(LogAddSubmitEvent event, Emitter<LogState> emit) async {
    try {
      if (titleController.text.isNullOrEmpty) return emit(LogErrorState("Title is required!"));
      emit(LogLoadingState());
      Map<String, dynamic> body = { "title" : titleController.text };
      List<dynamic> files = attachments.whereType<File>().map((e) => {"attachments" : e.path}).toList();
      var response = await _uploadLog(data: body, infusedFiles: files);
      if ((response != null) && (response['status'] == true)) {
        _clearControllers();
        _logResponse.add(response['data']);
        _totalCount = _logResponse.length;
        currentPage = 1;
        filteredResponse = paginateList(data: _logResponse, currentPage: currentPage, itemsPerPage: itemsPerPage);
        emit(LogCommonState());
      } else {
        emit(LogErrorState(response?['message'] ?? (response?['error'] ?? "Something went wrong")));
      }
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(LogErrorState(e));
    }
  }

  void _onPaginationEvent(LogPaginationEvent event, Emitter<LogState> emit) {
    currentPage = event.page;
    filteredResponse = paginateList(data: _logResponse, currentPage: currentPage, itemsPerPage: itemsPerPage);
    emit(LogCommonState());
  }

  void _onEditEvent(LogEditEvent event, Emitter<LogState> emit) {
    emit(LogEditState(event.model));
  }

  void _onDeleteEvent(LogDeleteEvent event, Emitter<LogState> emit) async {
    try {
      emit(LogLoadingState());
      var response = await _deleteLog(event.model?['id']);
      if (response?['status'] == true) {
        _logResponse.removeWhere((element) => element['id'] == event.model?['id']);
        _totalCount = _logResponse.length;
        filteredResponse = paginateList(data: _logResponse, currentPage: currentPage, itemsPerPage: itemsPerPage);
        emit(LogCommonState());
      } else {
        emit(LogErrorState(response?['message'] ?? (response?['error'] ?? "Something went wrong")));
      }
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(LogErrorState(e));
    }
  }

  void _onDeletePermissionEvent(LogDeletePermissionEvent event, Emitter<LogState> emit) {
    emit(LogDeletePermissionState(event.model));
  }

  void _onViewAttachmentEvent(LogViewAttachmentEvent event, Emitter<LogState> emit) {
    emit(LogViewAttachmentState(event.model?['attachments']));
  }

  void _onInsertAttachmentEvent(LogInsertAttachmentEvent event, Emitter<LogState> emit) {
    try {
      attachments.add(event.model);
      emit(LogCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(LogErrorState(e));
    }
  }
}