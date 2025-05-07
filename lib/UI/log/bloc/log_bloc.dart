import 'dart:async';

import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/log/bloc/log_event.dart';
import 'package:fairpytasker/UI/log/bloc/log_state.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  }

  Future<Map<String, dynamic>?> _fetchLogs() async => await _aPiRepository.getLogs();
  Future<Map<String, dynamic>?> _deleteLog(dynamic logId) async => await _aPiRepository.deleteLog(logId: logId);
  Future<Map<String, dynamic>?> _uploadLog({required Map<String, dynamic> data, List<dynamic>? infusedFiles}) async => await _aPiRepository.uploadLog(body: data, infusedFiles: infusedFiles);

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

  void _onAddAttachmentEvent(LogAddAttachmentEvent event, Emitter<LogState> emit) {
  }

  void _onAddRecordingEvent(LogAddRecordingEvent event, Emitter<LogState> emit) {
  }

  void _onAddVideoEvent(LogAddVideoEvent event, Emitter<LogState> emit) {
  }

  void _onAddViewAttachmentEvent(LogAddViewAttachmentEvent event, Emitter<LogState> emit) {
  }

  void _onAddSubmitEvent(LogAddSubmitEvent event, Emitter<LogState> emit) {
  }

  void _onPaginationEvent(LogPaginationEvent event, Emitter<LogState> emit) {
  }

  void _onEditEvent(LogEditEvent event, Emitter<LogState> emit) {
  }

  void _onDeleteEvent(LogDeleteEvent event, Emitter<LogState> emit) {
  }

  void _onDeletePermissionEvent(LogDeletePermissionEvent event, Emitter<LogState> emit) {
  }

  void _onViewAttachmentEvent(LogViewAttachmentEvent event, Emitter<LogState> emit) {
  }
}