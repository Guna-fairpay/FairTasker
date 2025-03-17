import 'dart:async';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/tasker_hours_processor.dart';
import 'package:flutter/material.dart' show TextEditingController;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/core/app/helper/helper.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_events.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_states.dart';
import 'package:fairpytasker/core/app/helper/tasker_todo_data_processor.dart';

class ToDoTaskerBloc extends Bloc<ToDoTaskerEvent, ToDoTaskerState> {
  bool isFilterSelected = false;
  bool isUserSelected = false;
  bool isCompleted = false;
  DateTime selectedDate = DateTime.now();
  final APiRepository _aPiRepository = APiRepository();
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> toDos = [], unfiltered = [];
  Map<String, dynamic> processedWorkingHours = {};
  final ToDoProcessor _toDoProcessor = ToDoProcessor();
  final TaskerHoursProcessor _taskerHoursProcessor = TaskerHoursProcessor();

  ToDoTaskerBloc() : super(ToDoTaskerLoadingState()) {
    on<ToDoTaskerInitialEvent>(_onInitialEvent);
    on<ToDoTaskerPreviousDateEvent>(_onPreviousDateEvent);
    on<ToDoTaskerNextDateEvent>(_onNextDateEvent);
    on<ToDoTaskerTapDateEvent>(_onTapDateEvent);
    on<ToDoTaskerDateFilterEvent>(_onDateFilterEvent);
    on<ToDoTaskerShowCompleteEvent>(_onShowCompleteEvent);
    on<ToDoTaskerSearchEvent>(_onSearchEvent);
    on<ToDoTaskerOnAddToDoEvent>(_onAddToDoEvent);
    on<ToDoTaskerOnMicEvent>(_onMicEvent);
    on<ToDoTaskerEditEvent>(_onEditEvent);
    on<ToDoTaskerTapUserFilterEvent>(_onTapUserFilterEvent);
    on<ToDoTaskerTapVehicleFilterEvent>(_onTapVehicleFilterEvent);
    on<ToDoTaskerVendorInfoEvent>(_onVendorInfoEvent);
    on<ToDoTaskerViewNotesEvent>(_onViewNotesEvent);
    on<ToDoTaskerSaveNotesEvent>(_onSaveNotesEvent);
    on<ToDoTaskerVehiclePersonTapEvent>(_onVehiclePersonTapEvent);
  }

  /* BEGIN: API CALLS */
  Future<List<Map<String, dynamic>>?> _fetchToDoList(
          {String? resourceId}) async =>
      await _toDoProcessor.getToDoList(selectedDate, isCompleted,
          resourceId: resourceId);

  /* END: API CALLS */

  // INITIAL EVENT PROCESSOR
  /// FETCH TO-DO LISTING API
  void _onInitialEvent(
      ToDoTaskerInitialEvent event, Emitter<ToDoTaskerState> emit) async {
    await CommonHelper.instance.waitForPostFrameCallback();
    try {
      toDos.clear();
      emit(ToDoTaskerLoadingState());
      await _toDoProcessor.initialize();
      await _taskerHoursProcessor.initialize();
      var response = await _fetchToDoList();
      processedWorkingHours = _taskerHoursProcessor.processWorkingHours();
      unfiltered = response ?? [];
      toDos = unfiltered;
      emit(ToDoTaskerLoadedState());
    } catch (e) {
      Console.of.error(e);
      emit(ToDoTaskerErrorState(e));
    }
  }

  void _onPreviousDateEvent(
      ToDoTaskerPreviousDateEvent event, Emitter<ToDoTaskerState> emit) async {
    selectedDate = selectedDate.subtract(const Duration(days: 1));
    _reFetchToDos();
  }

  void _onNextDateEvent(
      ToDoTaskerNextDateEvent event, Emitter<ToDoTaskerState> emit) async {
    selectedDate = selectedDate.add(const Duration(days: 1));
    _reFetchToDos();
  }

  void _onTapDateEvent(
      ToDoTaskerTapDateEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerDatePickerState());
  }

  void _onDateFilterEvent(
      ToDoTaskerDateFilterEvent event, Emitter<ToDoTaskerState> emit) async {
    selectedDate = event.selectedDate ?? DateTime.now();
    _reFetchToDos();
  }

  void _onShowCompleteEvent(
      ToDoTaskerShowCompleteEvent event, Emitter<ToDoTaskerState> emit) async {
    isCompleted = event.showCompleted;
    _reFetchToDos();
  }

  void _reFetchToDos() async {
    try {
      toDos.clear();
      emit(ToDoTaskerLoadingState());
      var response = await _fetchToDoList();
      unfiltered = response ?? [];
      toDos = unfiltered;
      emit(ToDoTaskerLoadedState());
    } catch (e) {
      Console.of.error(e);
      emit(ToDoTaskerErrorState(e));
    }
  }

  void _onSearchEvent(
      ToDoTaskerSearchEvent event, Emitter<ToDoTaskerState> emit) {
    var searchQuery = event.search;
    if (searchQuery.isNotNullOrEmpty) {
      toDos = unfiltered
          .where((element) => ((element['display']?['task_title']
                      .toString()
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ??
                  false) ||
              (element['display']?['vehicle_name']
                      .toString()
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ??
                  false) ||
              (element['display']?['person_name']
                      .toString()
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ??
                  false) ||
              (element['display']?['vendor_location']
                      .toString()
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ??
                  false) ||
              (element['display']?['notes'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ??
                  false) ||
              (element['display']?['notes']
                      .toString()
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ??
                  false)))
          .toList();
      emit(ToDoTaskerCommonState());
    } else {
      toDos = unfiltered;
      emit(ToDoTaskerLoadedState());
    }
  }

  void _onAddToDoEvent(
      ToDoTaskerOnAddToDoEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerAddToDoState());
  }

  void _onMicEvent(ToDoTaskerOnMicEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerMicState());
  }

  void _onEditEvent(ToDoTaskerEditEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerEditState(event.toDoId));
  }

  void _onTapUserFilterEvent(ToDoTaskerTapUserFilterEvent event, Emitter<ToDoTaskerState> emit) {
    isUserSelected = !isUserSelected;
    emit(ToDoTaskerTapUserFilterState(event.details));
  }

  void _onTapVehicleFilterEvent(ToDoTaskerTapVehicleFilterEvent event, Emitter<ToDoTaskerState> emit) {
    isFilterSelected = !isFilterSelected;
    emit(ToDoTaskerTapVehicleFilterState(event.details));
  }

  void _onVendorInfoEvent(ToDoTaskerVendorInfoEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerVendorInfoState(event.model));
  }

  void _onViewNotesEvent(ToDoTaskerViewNotesEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerNotesTapState(event.model));
  }

  void _onSaveNotesEvent(ToDoTaskerSaveNotesEvent event, Emitter<ToDoTaskerState> emit) {
    var model = event.model;
    var existingNotes = model?['notes'];
    if (existingNotes != event.notes) {
      // NEW NOTES ARRIVED
      event.model
        ?..['notes'] = event.notes
        ..['display']?['notes'] = event.notes;
      unfiltered = unfiltered.map((e) {
        if (e['id'] == model?['id']) {
          return e
            ..['notes'] = event.notes
              ..['display']?['notes'] = event.notes;
        } else {
          return e;
        }
      }).toList();
      toDos = unfiltered;
      // TODO: CALL API TO UPDATE
      emit(ToDoTaskerCommonState());
    }
  }

  void _onVehiclePersonTapEvent(ToDoTaskerVehiclePersonTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerVehiclePersonTapState(event.model));
  }
}
