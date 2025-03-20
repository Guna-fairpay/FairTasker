import 'dart:async';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/timeday_extension.dart';
import 'package:fairpytasker/core/app/helper/tasker_hours_processor.dart';
import 'package:flutter/material.dart' show TextEditingController, TimeOfDay;
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
    on<ToDoTaskerResourceTapEvent>(_onResourceTapEvent);
    on<ToDoTaskerAddressTapEvent>(_onAddressTapEvent);
    on<ToDoTaskerPartsTapEvent>(_onPartsTapEvent);
    on<ToDoTaskerSuppliesTapEvent>(_onSuppliesTapEvent);
    on<ToDoTaskerCompleteEvent>(_onCompleteEvent);
    on<ToDoTaskerPreviousEvent>(_onPreviousEvent);
    on<ToDoTaskerMoveTomorrowEvent>(_onMoveTomorrowEvent);
    on<ToDoTaskerDateChangeTapEvent>(_onDateChangeTapEvent);
    on<ToDoTaskerDateChangeEvent>(_onDateChangeEvent);
    on<ToDoTaskerCompletedTimeTapEvent>(_onCompletedTimeTapEvent);
    on<ToDoTaskerCompletedTimeChangeEvent>(_onCompletedTimeChangeEvent);
    on<ToDoTaskerTimePickerTapEvent>(_onTimePickerTapEvent);
    on<ToDoTaskerTimeChangeEvent>(_onTimeChangeEvent);
    on<ToDoTaskerSavePartsSuppliesEvent>(_onSavePartsSuppliesEvent);
  }

  /* BEGIN: API CALLS */
  Future<List<Map<String, dynamic>>?> _fetchToDoList(
          {String? resourceId}) async =>
      await _toDoProcessor.getToDoList(selectedDate, isCompleted,
          resourceId: resourceId);

  Future<Map<String, dynamic>?> _changeToMorrow({
    required List<String> todoIds,
    dynamic groupId,
    required String groupName,
    DateTime? date,
    TimeOfDay? time,
  }) async =>
      await _aPiRepository.changeToDoByGroup(
          todoList: todoIds,
          groupId: groupId,
          groupName: groupName,
          date: date,
          time: time);

  Future<Map<String, dynamic>?> _updateToDo(
          {required Map<String, dynamic> body,
          required dynamic todoId}) async =>
      await _aPiRepository.updateToDo(body: body, toDoId: todoId);

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
      Console.of.log("LENGTH ${response?.length ?? -1}");
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
      Console.of.debug("CHECK ${toDos.length}");
      emit(ToDoTaskerLoadedState());
    } catch (e) {
      Console.of.error("REFRESH_TODOS $e");
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

  void _onTapUserFilterEvent(
      ToDoTaskerTapUserFilterEvent event, Emitter<ToDoTaskerState> emit) {
    isUserSelected = !isUserSelected;
    emit(ToDoTaskerTapUserFilterState(event.details));
  }

  void _onTapVehicleFilterEvent(
      ToDoTaskerTapVehicleFilterEvent event, Emitter<ToDoTaskerState> emit) {
    isFilterSelected = !isFilterSelected;
    emit(ToDoTaskerTapVehicleFilterState(event.details));
  }

  void _onVendorInfoEvent(
      ToDoTaskerVendorInfoEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerVendorInfoState(event.model));
  }

  void _onViewNotesEvent(
      ToDoTaskerViewNotesEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerNotesTapState(event.model));
  }

  void _onSaveNotesEvent(
      ToDoTaskerSaveNotesEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
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
        Map<String, dynamic> body = {
          "notes": event.notes,
        };
        emit(ToDoTaskerLoadingState());
        var response = await _updateToDo(body: body, todoId: model?['id']);
        if (response != null) {
          _reFetchToDos();
        }
        emit(ToDoTaskerCommonState());
      }
    } catch (e) {
      emit(ToDoTaskerErrorState(e));
    }
  }

  void _onVehiclePersonTapEvent(
      ToDoTaskerVehiclePersonTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerVehiclePersonTapState(event.model));
  }

  void _onResourceTapEvent(
      ToDoTaskerResourceTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerResourceTapState(event.model));
  }

  void _onAddressTapEvent(
      ToDoTaskerAddressTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerAddressTapState(event.model));
  }

  void _onPartsTapEvent(
      ToDoTaskerPartsTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerPartsTapState(event.model));
  }

  void _onSuppliesTapEvent(
      ToDoTaskerSuppliesTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerSuppliesTapState(event.model));
  }

  void _onPreviousEvent(
      ToDoTaskerPreviousEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerPreviousState(event.model, toDos));
  }

  void _onCompleteEvent(
      ToDoTaskerCompleteEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerCompleteState(event.model));
  }

  void _onMoveTomorrowEvent(
      ToDoTaskerMoveTomorrowEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
      var dateTime = event.selectedDate;
      var time = event.selectedTime;
      var models = event.model?.map((e) => e['id'].toString()).toList() ?? [];
      var groupIds = event.model
          ?.where((element) => element['group_id'].toString().isNotNullOrEmpty)
          .map((e) => e['group_id'] ?? "")
          .toList();
      groupIds = groupIds.unique((element) => element);
      groupIds.removeWhere((element) => element.toString().isNullOrEmpty);
      var groupId = (groupIds.length > 1) ? null : groupIds.firstOrNull;
      var groupName =
          "${_toDoProcessor.userId}_${dateTime.year}_${dateTime.month}_${dateTime.day}_${time.hour.toString().padLeft(2, '0')}_${time.minute.toString().padLeft(2, '0')}_00";
      if (models.isNotEmpty) {
        emit(ToDoTaskerLoadingState());
        var response = await _changeToMorrow(
            todoIds: models,
            groupId: groupId,
            groupName: groupName,
            date: dateTime,
            time: time);
        if (response != null) {
          Console.of.log(
              "MOVE_TO_MORROW:\t$models $groupName $groupId $dateTime $time $response");
          _reFetchToDos();
        }
      }
    } catch (e) {
      emit(ToDoTaskerErrorState(e));
    }
  }

  void _onDateChangeTapEvent(
      ToDoTaskerDateChangeTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerDateChangeTapState(event.model));
  }

  void _onDateChangeEvent(
      ToDoTaskerDateChangeEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
      var model = event.model;
      var date = event.selectedDate;
      var mapData = {
        "todo_date": date.toFormat(),
      };
      emit(ToDoTaskerLoadingState());
      var response = await _updateToDo(body: mapData, todoId: model?['id']);
      if (response != null) {
        _reFetchToDos();
      }
    } catch (e) {
      emit(ToDoTaskerErrorState(e));
    }
  }

  void _onCompletedTimeTapEvent(
      ToDoTaskerCompletedTimeTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerCompletedTimeTapState(event.model));
  }

  void _onCompletedTimeChangeEvent(ToDoTaskerCompletedTimeChangeEvent event,
      Emitter<ToDoTaskerState> emit) async {
    try {
      var model = event.model;
      var timeTaken = event.timeTaken;
      var reason = event.reason;
      var mapData = {
        "complete_time_approved": 0,
        "complete_time_taken": timeTaken,
        "notes_complete": reason
      };
      var isDifferent = (model?['display']?['completed_time'] != timeTaken);
      if (isDifferent) {
        emit(ToDoTaskerLoadingState());
        var response = await _updateToDo(body: mapData, todoId: model?['id']);
        if (response != null) {
          _reFetchToDos();
        }
      }
    } catch (e) {
      emit(ToDoTaskerErrorState(e));
    }
  }

  void _onTimePickerTapEvent(
      ToDoTaskerTimePickerTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerTimePickerTapState(event.model));
  }

  void _onTimeChangeEvent(
      ToDoTaskerTimeChangeEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
      var model = event.model;
      var time = event.selectedTime;
      var mapData = {
        "todo_time": time.toHMS(),
      };
      emit(ToDoTaskerLoadingState());
      var response = await _updateToDo(body: mapData, todoId: model?['id']);
      if (response != null) {
        _reFetchToDos();
      }
    } catch (e) {
      emit(ToDoTaskerErrorState(e));
    }
  }

  void _onSavePartsSuppliesEvent(ToDoTaskerSavePartsSuppliesEvent event, Emitter<ToDoTaskerState> emit) {
    var model = event.model;
    var parts = event.parts;
    var supplies = event.supplies;
    var modelPartIds = List<Map<String, dynamic>>.from(model?['parts'] ?? [])
        .map((e) => e['parts_id'])
        .toList();
    var modelSupplyIds = List<Map<String, dynamic>>.from(
        model?['supplies'] ?? []).map((e) => e['supplies_id']).toList();
    var uploadParts = parts?.where((element) =>
    !modelPartIds.contains(element['id'].toString())).toList();
    var uploadSupplies = supplies?.where((element) =>
    !modelSupplyIds.contains(element['id'].toString())).toList();
    if (((uploadParts?.isNotEmpty ?? false) ||
        (uploadSupplies?.isNotEmpty ?? false))) {
      Map<String, dynamic> body = {};
      if (uploadParts != null && (uploadParts.isNotEmpty ?? false)) {
        var partMap = uploadParts.map((e) =>
        {
          "parts_id": e['id'],
          "parts_name": e['name']
        });
        partMap.forEach((element) => body.addAll(element));
      }

      if (uploadSupplies != null && (uploadSupplies.isNotEmpty ?? false)) {
        var supplyMap = uploadSupplies.map((e) =>
        {
          "supplies_id": e['id'],
          "supplies_name": e['name']
        });
        supplyMap.forEach((element) => body.addAll(element));
      }
    }
  }
}
