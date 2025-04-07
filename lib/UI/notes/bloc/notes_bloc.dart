import 'dart:async';

import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/notes/bloc/notes_events.dart';
import 'package:fairpytasker/UI/notes/bloc/notes_states.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesBloc extends Bloc<NotesEvents, NotesStates> {
  final TextEditingController searchController = TextEditingController();
  final APiRepository _apiRepository = APiRepository();
  List<Map<String, dynamic>>? apiResponse = [], unfilteredResponse = [];
  DateTime selectedDate = DateTime.now();
  bool showCompletedStates = false;
  NotesBloc() : super(NotesLoadingState()) {
    on<NotesInitialEvent>(_onInitialEvent);
    on<NotesNextDayEvent>(_onNextDayEvent);
    on<NotesPreviousDayEvent>(_onPreviousDayEvent);
    on<NotesDatePickerEvent>(_onDatePickerEvent);
    on<NotesAddNewEvent>(_onAddNewEvent);
    on<NotesEditEvent>(_onEditEvent);
    on<NotesFilterEvent>(_onFilterEvent);
    on<NotesSearchEvent>(_onSearchEvent);
    on<NotesDateEvent>(_onDateEvent);
    on<NotesSwipeTomorrowEvent>(_onSwipeTomorrowEvent);
    on<NotesSwipeCompleteEvent>(_onSwipeCompleteEvent);
    on<NotesDeletePermissionEvent>(_onDeletePermissionEvent);
    on<NotesDeleteEvent>(_onNotesDeleteEvent);
    on<NotesEditTaskTapEvent>(_onEditTaskTapEvent);
    on<NotesAddTaskTapEvent>(_onAddTaskTapEvent);
    on<NotesAddTaskEvent>(_onAddTaskEvent);
    on<NotesUpdateTaskEvent>(_onUpdateTaskEvent);
    on<NotesCheckTapEvent>(_onCheckTapEvent);
    on<NotesCheckEvent>(_onCheckSubmitEvent);
    // on<NotesAddCommentEvent>(_onAddCommentEvent);
    // on<NotesCheckTaskEvent>(_onCheckTaskEvent);
  }

  Future<Map<String, dynamic>?> _fetchNotes() async => await _apiRepository.getNotes(selectedDate: selectedDate, status: showCompletedStates);
  Future<Map<String, dynamic>?> _updateNotes({Map<String, dynamic>? body, dynamic id}) async => await _apiRepository.putNotes(id: id, body: body);
  Future<Map<String, dynamic>?> _updateNoteStatus({Map<String, dynamic>? body, dynamic id}) async => await _apiRepository.updateNoteStatus(id: id, body: body);
  Future<Map<String, dynamic>?> _deleteNotes({dynamic id}) async => await _apiRepository.deleteNotes(id: id);
  Future<Map<String, dynamic>?> _addNoteItem({dynamic id, Map<String, dynamic>? body}) async => await _apiRepository.addNoteItem(id: id, body: body);
  Future<Map<String, dynamic>?> _updateNoteItem({dynamic id, Map<String, dynamic>? body}) async => await _apiRepository.updateNoteItem(id: id, body: body);


  void _onInitialEvent(NotesInitialEvent event, Emitter<NotesStates> emit) => _refreshNotes();

  void _refreshNotes() async {
    try {
      unfilteredResponse = [];
      apiResponse = [];
      emit(NotesLoadingState());
      var response = await Future.microtask(_fetchNotes);
      if (response != null) {
        unfilteredResponse = List<Map<String, dynamic>>.from(response['data'] ?? []);
        apiResponse = (searchController.text.trim().isNotEmpty) ? unfilteredResponse?.where((element) => element.toString().toLowerCase().contains(searchController.text.toLowerCase())).toList() : unfilteredResponse;
        emit(NotesCommonState());
      } else {
        emit(NotesErrorState(response));
      }
    } catch (e) {
      Console.of.error(e);
      emit(NotesErrorState(e));
    }
  }

  void _onNextDayEvent(NotesNextDayEvent event, Emitter<NotesStates> emit) {
    selectedDate = selectedDate.add(const Duration(days: 1));
    _refreshNotes();
  }

  void _onPreviousDayEvent(NotesPreviousDayEvent event, Emitter<NotesStates> emit) {
    selectedDate = selectedDate.subtract(const Duration(days: 1));
    _refreshNotes();
  }

  void _onDatePickerEvent(NotesDatePickerEvent event, Emitter<NotesStates> emit) => emit(NotesDatePickerState(selectedDate));

  void _onAddNewEvent(NotesAddNewEvent event, Emitter<NotesStates> emit) => emit(NotesAddNewState());

  void _onEditEvent(NotesEditEvent event, Emitter<NotesStates> emit) => emit(NotesEditState(event.data));

  void _onFilterEvent(NotesFilterEvent event, Emitter<NotesStates> emit) {
    showCompletedStates = event.status ?? false;
    _refreshNotes();
  }

  void _onSearchEvent(NotesSearchEvent event, Emitter<NotesStates> emit) {
    if (searchController.text.trim().isNotEmpty) {
      apiResponse = unfilteredResponse?.where((element) => element.toString().toLowerCase().contains(searchController.text.toLowerCase())).toList();
    } else {
      apiResponse = unfilteredResponse;
    }
    emit(NotesCommonState());
  }

  void _onDateEvent(NotesDateEvent event, Emitter<NotesStates> emit) {
    selectedDate = event.date ?? DateTime.now();
    _refreshNotes();
  }

  void _onSwipeTomorrowEvent(NotesSwipeTomorrowEvent event, Emitter<NotesStates> emit) async {
    try {
      emit(NotesLoadingState());
      var body = {
        "date" : selectedDate.add(const Duration(days: 1)).toFormat(),
        "title" : event.data?['title'],
      };
      var response = await Future.microtask(() => _updateNotes(body: body, id: event.data?['id']));
      if (response != null) _refreshNotes();
    } catch (e) {
      Console.of.error(e);
      emit(NotesErrorState(e));
    }
  }

  void _onSwipeCompleteEvent(NotesSwipeCompleteEvent event, Emitter<NotesStates> emit) async {
    try {
      emit(NotesLoadingState());
      var body = {
        "all" : true,
        "complete_time_approved" : 1,
        "complete_time_taken" : "00:15",
        "status" : true
      };
      var response = await Future.microtask(() => _updateNoteStatus(body: body, id: event.data?['id']));
      if (response != null) _refreshNotes();
    } catch (e) {
      Console.of.error(e);
      emit(NotesErrorState(e));
    }
  }

  void _onDeletePermissionEvent(NotesDeletePermissionEvent event, Emitter<NotesStates> emit) => emit(NotesDeletePermissionState(event.data));

  void _onNotesDeleteEvent(NotesDeleteEvent event, Emitter<NotesStates> emit) async {
    try {
      emit(NotesLoadingState());
      var response = await Future.microtask(() => _deleteNotes(id: event.data?['id']));
      if (response != null) _refreshNotes();
    } catch (e) {
      Console.of.error(e);
      emit(NotesErrorState(e));
    }
  }

  void _onEditTaskTapEvent(NotesEditTaskTapEvent event, Emitter<NotesStates> emit) => emit(NotesEditTaskTapState(event.data));

  void _onAddTaskTapEvent(NotesAddTaskTapEvent event, Emitter<NotesStates> emit) => emit(NotesAddTaskTapState(event.data));

  void _onAddTaskEvent(NotesAddTaskEvent event, Emitter<NotesStates> emit) async {
    try {
      emit(NotesLoadingState());
      var body = {
        "complete_status" : 0,
        "description" : "",
        "title" : event.input,
      };
      var response = await Future.microtask(() => _addNoteItem(id: event.data?['id'], body: body));
      if (response != null) _refreshNotes();
    } catch (e) {
      Console.of.error(e);
      emit(NotesErrorState(e));
    }
  }

  void _onUpdateTaskEvent(NotesUpdateTaskEvent event, Emitter<NotesStates> emit) async {
    try {
      emit(NotesLoadingState());
      var body = {
        "complete_status" : 0,
        "title" : event.input,
      };
      var response = await Future.microtask(() => _updateNoteItem(id: event.data?['id'], body: body));
      if (response != null) _refreshNotes();
    } catch (e) {
      Console.of.error(e);
      emit(NotesErrorState(e));
    }
  }

  void _onCheckTapEvent(NotesCheckTapEvent event, Emitter<NotesStates> emit) => emit(NotesCheckTapState(event.data, isAll: event.isAll, status: event.status));

  void _onCheckSubmitEvent(NotesCheckEvent event, Emitter<NotesStates> emit) async {
    try {
      emit(NotesLoadingState());
      var body = {
        "all" : event.isAll,
        "complete_time_approved" : 1,
        "complete_time_taken" : "00:15",
        "status" : event.status
      };
      var response = await Future.microtask(() => _updateNoteStatus(body: body, id: event.data?['id']));
      if (response != null) _refreshNotes();
    } catch (e) {
      Console.of.error(e);
      emit(NotesErrorState(e));
    }
  }
}