import 'dart:async';
import 'dart:io' show File;
import 'package:collection/collection.dart';
import 'package:date_time/date_time.dart' show DateTimeExtensions, Time;
import 'package:fairpytasker/UI/dialog/transport_car_dialog/UI/transportcar_pop.dart';
import 'package:fairpytasker/Response/general_response.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/config/todo_config.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/timeday_extension.dart';
import 'package:fairpytasker/core/app/helper/tasker_hours_processor.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
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
  List<dynamic> selectedTasks = []; // USING FOR FILTERING TASKS
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>>? selectedUsers = [];
  final APiRepository _aPiRepository = APiRepository();
  final TextEditingController searchController = TextEditingController();
  final FBroadcast _fBroadcast = FBroadcast.instance();

  List<Map<String, dynamic>> toDos = [], unfiltered = [];
  Map<String, dynamic> processedWorkingHours = {};
  final ToDoProcessor _toDoProcessor = ToDoProcessor();
  final TaskerHoursProcessor _taskerHoursProcessor = TaskerHoursProcessor();

  bool get isAdmin => getIt<CommonService>().isAdmin;
  Map<String, dynamic>? get currentUser => getIt<CommonService>().user;
  String? get _selectedUserIds => selectedUsers?.map((e) => e['id'].toString()).join(",");

  List<String> get _checkInOutTask => ["Check Out", "Check In"];

  bool isTimeSensitive = false;

  ToDoTaskerBloc() : super(ToDoTaskerLoadingState()) {
    _listenBroadCast();
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
    on<ToDoTaskerSwapTaskEvent>(_onSwapTaskEvent);
    on<ToDoTaskerVendorLocationTapEvent>(_onVendorLocationTapEvent);
    on<ToDoTaskerVendorLocationUpdateEvent>(_onVendorLocationUpdateEvent);
    on<ToDoTaskerSaveVehiclesPersonsEvent>(_onSaveVehiclesPersonsEvent);
    on<ToDoTaskerSaveAddressEvent>(_onSaveAddressEvent);
    on<ToDoTaskerSaveResourcesEvent>(_onSaveResourcesEvent);
    on<ToDoTaskerCompleteOdometerEvent>(_onCompleteOdometerEvent);
    on<ToDoTaskerCompleteDropCarEvent>(_onCompleteDropCarEvent);
    on<ToDoTaskerUndoCompleteEvent>(_onUndoCompleteEvent);
    on<ToDoTaskerVehicleHistoryTapEvent>(_onVehicleHistoryTapEvent);
    on<ToDoTaskerRefreshEvent>(_onRefreshEvent);
    on<ToDoTaskerViewVehicleEvent>(_onViewVehicleEvent);
    on<ToDoTaskerVehicleGroupTapEvent>(_onVehicleGroupTapEvent);
    on<ToDoTaskerUserFilterEvent>(_onUserFilterEvent);
    on<ToDoTaskerFilterTaskEvent>(_onFilterTaskEvent);
    on<ToDoTaskerTaskFilterEvent>(_onTaskFilterEvent);
    on<ToDoTaskerViewAttachmentEvent>(_onViewAttachmentEvent);
    on<ToDoTaskerViewCustomLinkEvent>(_onViewCustomLinkEvent);
    on<ToDoTaskerViewReasonAttachmentEvent>(_onViewReasonAttachmentEvent);
    on<ToDoTaskerSaveRecordEvent>(_onSaveRecordEvent);
    on<ToDoTaskerTimeSensitiveEvent>(_onTimeSensitiveEvent);
    on<ToDoTaskerViewBouncieEvent>(_onViewBouncieEvent);
    on<ToDoTaskerRemoveVehiclePersonEvent>(_onRemoveVehiclePersonEvent);
  }

  bool _isCheckInOutTask(Map<String, dynamic>? model) => _checkInOutTask.contains(model?['title']);

  void _listenBroadCast() {
    _fBroadcast.register("todo_view", (value, callback) => add(ToDoTaskerRefreshEvent(showLoading: false)));
    _fBroadcast.register("show_completed_popup", (value, callback) => add(ToDoTaskerCompleteEvent(value)));
    getIt<CommonService>().branchUpdate(callback: _reFetchToDos);
  }

  /* BEGIN: API CALLS */
  Future<List<Map<String, dynamic>>?> _fetchToDoList() async =>
      await _toDoProcessor.getToDoList(selectedDate, isCompleted,
          resourceId: _selectedUserIds);

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

  Future<Map<String, dynamic>?> _swapToDo(
          {required dynamic fromId, required dynamic toId}) async =>
      await _aPiRepository.swapToDo(fromId: fromId, toId: toId);

  Future<GeneralResponse?> _deleteVehicle(
      {required String? id}) async =>
      await _aPiRepository.deleteTodoVehicle(id : id);

  Future<Map<String, dynamic>?> get _getLastKnownLocation async => await getIt<CommonService>().getCurrentLocation();

  Future<Map<String, dynamic>?> _addToDoOdometer({required dynamic toDoId, required dynamic currentOdometer, required dynamic nextOdometer, required dynamic nextMilesCheck}) async => await _aPiRepository.addToDoOdometer(toDoId: toDoId, currentOdometer: currentOdometer, nextOdometer: nextOdometer, nextMilesCheck: nextMilesCheck);

  Future<Map<String, dynamic>?> _addToDo({required Map<String, dynamic> body}) async => await _aPiRepository.addToDo(body: body);

  Future<Map<String, dynamic>?> _completeToDo({required Map<String, dynamic> body, required dynamic todoId}) async => await _aPiRepository.completeTodo(todoId: todoId, body: body);

  Future<Map<String, dynamic>?> _saveRecording({required File? file}) async => await _aPiRepository.saveAudio(audio: file);

  Future<Map<String, dynamic>?> _saveWorkingHour({required Map<String, dynamic> body}) async => await _aPiRepository.saveWorkingHour(body: body);

  Future<Map<String, dynamic>?> _updateWorkingHour({required Map<String, dynamic> body}) async => await _aPiRepository.updateWorkingHour(body: body);

  /* END: API CALLS */

  // INITIAL EVENT PROCESSOR
  /// FETCH TO-DO LISTING API
  void _onInitialEvent(
      ToDoTaskerInitialEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
      toDos.clear();
      emit(ToDoTaskerLoadingState());
      await CommonHelper.instance.waitForPostFrameCallback();
      await getIt<CommonService>().getCurrentLocation();
      if (!isAdmin) {
        if ((currentUser != null) && (currentUser?.isNotEmpty ?? false)) selectedUsers?.add(currentUser ?? {});
      }
      await Future.microtask(() async => await Future.wait([
        _toDoProcessor.initialize(),
        _taskerHoursProcessor.initialize()
      ]));
      // await _toDoProcessor.initialize();
      // await _taskerHoursProcessor.initialize();
      var response = await _fetchToDoList();
      processedWorkingHours = _taskerHoursProcessor.processWorkingHours();
      unfiltered = response ?? [];
      toDos = unfiltered;
      isUserSelected = (selectedUsers?.isNotEmpty ?? false);
      Console.of.log("TASKER_ALL_API_LOADED", name: "TASKER_TODO_BLOC");
      emit(ToDoTaskerCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ToDoTaskerErrorState("Server failure, Try again!"));
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

  void _reFetchToDos({bool showLoading = true}) async {
    try {
      toDos.clear();
      if ((!isClosed)) emit(ToDoTaskerCommonState());
      Console.of.debug("SHOW LOADING $showLoading");
      if ( showLoading && (!isClosed)) emit(ToDoTaskerLoadingState());
      var response = await _fetchToDoList();
      unfiltered = response ?? [];
      toDos = unfiltered;
      _searchTasks();
      Console.of.debug("CHECK ${toDos.length}");
      if (!isClosed) emit(ToDoTaskerCommonState());
    } catch (e) {
      Console.of.error("REFRESH_TODOS", error: e);
      if (!isClosed) emit(ToDoTaskerErrorState("Server Error, Try again!"));
    }
  }

  void _onSearchEvent(
      ToDoTaskerSearchEvent event, Emitter<ToDoTaskerState> emit) {
    var searchQuery = event.search;
    List<Map<String, dynamic>> results = [];
    if (isTimeSensitive) {
      results = unfiltered.where((element) => element['time_sensitive'] == 1).toList();
    } else {
      results = unfiltered;
    }
    if (searchQuery.isNotNullOrEmpty) {
      toDos = results
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
      toDos = results;
      emit(ToDoTaskerCommonState());
    }
  }

  void _onAddToDoEvent(
      ToDoTaskerOnAddToDoEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerAddToDoState(selectedDate));
  }

  void _onMicEvent(ToDoTaskerOnMicEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerMicState());
  }

  void _onEditEvent(ToDoTaskerEditEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerEditState(event.toDoId));
  }

  void _onTapUserFilterEvent(
      ToDoTaskerTapUserFilterEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerTapUserFilterState(event.details));
  }

  void _onTapVehicleFilterEvent(
      ToDoTaskerTapVehicleFilterEvent event, Emitter<ToDoTaskerState> emit) {
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
    emit(ToDoTaskerMoveTomorrowState(event.model, toDos));
  }

  void  _onCompleteEvent(
      ToDoTaskerCompleteEvent event, Emitter<ToDoTaskerState> emit) {
    var model = event.model;
    var identifierId = model?['identifier_id'];
    var taskTitle = model?['title'];
    var taskDate = model?['todo_date'].toString().toDateTime();
    var currentDate = DateTime.now().toFormat().toDateTime();
    Console.of.log("TASK COMPLETE ${identifierId} $taskTitle");
    if (identifierId.toString().isNullOrEmpty) {
      /// CUSTOM TASK
      Console.of.log("CUSTOM TASK COMPLETE");
      /// CALL COMPLETE API
      /// IF CHECK IN / CHECK OUT THEN CHECK TODO DATE AND CURRENT DATE ARE SAME OR NOT
      /// IF BOTH DATE AS SAME THEN COMPLETE THE TASK OTHERWISE NO NEED TO CALL THE API
      if ((["Check Out", "Check In",].contains(taskTitle))) {
        if ((taskDate == currentDate)) {
          // CALL COMPLETE API
          _callCompleteApi(model, showLoading: false);
          (taskTitle == "Check In") ? _callSaveWorkingHour(model) : _callUpdateWorkingHour(model);
        }
      }else if((["Transport Car-Buy"].contains(taskTitle))){
        emit(ToDoTaskerCompleteTransportCarState(event.model));
      } else {
        _callCompleteApi(model, showLoading: !(["Check Out", "Check In"].contains(taskTitle)));
      }
      switch(taskTitle) {
        case "Check Out": emit(ToDoTaskerCompleteCheckOutState(event.model)); break;
        case "Check In": emit(ToDoTaskerCompleteCheckInState(event.model)); break;
      }
    } else {
      var autoCompleteIds = [27];
      if (autoCompleteIds.contains(identifierId)) _callCompleteApi(model);
      switch(identifierId) {
        case 35: // OIL CHANGE STATE
        case 126: emit(ToDoTaskerCompleteOilChangeState(event.model)); break;
        case 257: emit(ToDoTaskerCompleteMaintenanceCheckState(event.model)); break;
        case 212: emit(ToDoTaskerCompleteRentalCheckOutState(event.model)); break;
        case 28:
        case 210: emit(ToDoTaskerCompleteRentalPickupState(event.model)); break;
        case 27: emit(ToDoTaskerCompleteDropCarState(event.model)); break;
        default: _callCompleteApi(model); break; // CALL API TO COMPLETE TASK
      }
    }
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
      var identifierId = model?['identifier_id'];
      var taskDate = model?['todo_date'].toString().toDateTime();
      var currentDate = DateTime.now().toFormat().toDateTime();
      var reason = event.reason;
      if ((taskDate == currentDate) && (reason.toString().isNullOrEmpty && event.type.toString().isNullOrEmpty)) {
        var selectedTime = Time.fromStr(time.toHMS());
        if (ToDoConfig.dropCheckInCarRental.contains(identifierId) && ((model?['notes'].toString().isNotNullOrEmpty ?? false) && !(model?['notes'].toString().contains("/") ?? false))) {
          var currentTime = model?['notes'].toString().toDateTime(inputFormat: "hh:mm a")?.time;
          var isBefore = selectedTime?.isBefore(currentTime ?? Time.fromMinutes(0));
          var isAfter = selectedTime?.isAfter(currentTime ?? Time.fromMinutes(0));
          if (isAfter ?? false) {
            emit(ToDoTaskerShowDropCheckInPopupState(model, time, "drop"));
            return;
          }
          Console.of.log("IS_AFTER:\t$isAfter $selectedTime $currentTime IS_BEFORE:\t$isBefore");
        } else {
          Console.of.log("ELSE PART");
        }
        if (ToDoConfig.pickCheckOutCarRental.contains(identifierId) && ((model?['notes'].toString().isNotNullOrEmpty ?? false) && !(model?['notes'].toString().contains("/") ?? false))) {
          var currentTime = model?['notes'].toString().toDateTime(inputFormat: "hh:mm a")?.time;
          var isBefore = selectedTime?.isBefore(currentTime ?? Time.fromMinutes(0));
          var isAfter = selectedTime?.isAfter(currentTime ?? Time.fromMinutes(0));
          if (isBefore ?? false) {
            emit(ToDoTaskerShowDropCheckInPopupState(model, time, "pickup"));
            return;
          }
          Console.of.log("IS_AFTER:\t$isAfter $selectedTime $currentTime IS_BEFORE:\t$isBefore");
        } else {
          Console.of.log("ELSE PART");
        }
      }
      var mapData = {
        "todo_time": time.toHMS(),
      };
      if (reason?.trim().isNotNullOrEmpty ?? false) mapData['time_change_reason'] = reason;
      emit(ToDoTaskerLoadingState());
      var response = await _updateToDo(body: mapData, todoId: model?['id']);
      if (response != null) {
        _reFetchToDos();
      }
    } catch (e) {
      emit(ToDoTaskerErrorState(e));
    }
  }

  void _onSavePartsSuppliesEvent(
      ToDoTaskerSavePartsSuppliesEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
      var model = event.model;
      var parts = event.parts;
      var supplies = event.supplies;
      var modelPartIds = List<Map<String, dynamic>>.from(model?['parts'] ?? [])
          .map((e) => e['parts_id'])
          .toList();
      var modelSupplyIds =
          List<Map<String, dynamic>>.from(model?['supplies'] ?? [])
              .map((e) => e['supplies_id'])
              .toList();
      var uploadParts = parts
          ?.where((element) => !modelPartIds.contains(element['id'].toString()))
          .toList();
      var uploadSupplies = supplies
          ?.where((element) => !modelSupplyIds.contains(element['id'].toString()))
          .toList();
      if (((uploadParts?.isNotEmpty ?? false) ||
          (uploadSupplies?.isNotEmpty ?? false))) {
        Map<String, dynamic> body = {};
        if (uploadParts != null && (uploadParts.isNotEmpty ?? false)) {
          body["parts"] = uploadParts
              .map((e) => {"parts_id": e['id'], "parts_name": e['name']}).toList();
        }

        if (uploadSupplies != null && (uploadSupplies.isNotEmpty ?? false)) {
          body["supplies"] = uploadSupplies
              .map((e) => {"supplies_id": e['id'], "supplies_name": e['name']}).toList();
        }
        emit(ToDoTaskerLoadingState());
        var response = await _updateToDo(body: body, todoId: model?['id']);
        if (response != null) _reFetchToDos();
      }
    } catch (e) {
      emit(ToDoTaskerErrorState(e));
    }
  }

  void _onSwapTaskEvent(
      ToDoTaskerSwapTaskEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
      emit(ToDoTaskerLoadingState());
      var response = await _swapToDo(fromId: event.fromId, toId: event.toId);
      if (response != null) {
        _reFetchToDos();
      }
    } catch (e) {
      emit(ToDoTaskerErrorState(e));
    }
  }

  void _onVendorLocationTapEvent(
      ToDoTaskerVendorLocationTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerVendorLocationTapState(event.model));
  }

  void _onVendorLocationUpdateEvent(ToDoTaskerVendorLocationUpdateEvent event,
      Emitter<ToDoTaskerState> emit) async {
    try {
      var model = event.model;
      var selectedModel = event.selectedModel;
      var type = selectedModel?['type'];
      var isLocation = type == 'location';
      var mapData = {
        "vendor_name": (!isLocation) ? (selectedModel?['name']) : "",
        "vendor_id": (!isLocation) ? (selectedModel?['id']) : "",
        "location": (isLocation) ? (selectedModel?['name']) : "",
        "location_id": (isLocation) ? (selectedModel?['id']) : "",
        "address": ""
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

  void _onSaveVehiclesPersonsEvent(ToDoTaskerSaveVehiclesPersonsEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
      var model = unfiltered.firstWhereOrNull((element) => element['id'] == event.model?['id']);
      var selected = event.selected;
      var isVehicles = selected?.map((e) => e['type']).contains('vehicles') ?? false;
      Map<String, dynamic> bodyData = {};
      if (isVehicles) {
        // VEHICLE
        var selectedVins = selected?.map((e) => e['value']?['vin']) ?? [];
        Console.of.log("Existing Vin: ${List.from(model?['vehicles'] ?? []).map((e) => e['vin'])}");
        Console.of.log("Selected Vin: $selectedVins");
        var modelVehiclesIds = List.from(model?['vehicles'] ?? []).where((element) => !selectedVins.contains(element['vin'])).map((e) => e['id'].toString());
        if (modelVehiclesIds.isNotEmpty) await Future.wait(modelVehiclesIds.map((e) => _deleteVehicle(id: e)));
        var modelVehicles = List.from(model?['vehicles'] ?? []).where((element) => !modelVehiclesIds.contains(element['id'])).map((e) => e['vin']);
        var selectedVehicles = selected?.where((element) => !modelVehicles.contains(element['value']?['vin']));
        // var selectedVehicles = selected;
        bodyData = {
          "vehicles": selectedVehicles?.map((e) => {
            "cohort_id" : e['value']['cohort']?['id'] ?? "",
            "cohort_name" : e['value']['cohort']?['cohort'] ?? "",
            "vehicle_image" : List<Map<String, dynamic>>.from(e['value']?['images'] ?? []).firstWhereOrNull((element) => element['vehicle_image_type'] == 1)?['path'] ?? "",
            "vehicle_name" : e['value']?['vehicle_name'],
            "vehicle_number" : e['value']?['vehicle_number'],
            "vin" : e['value']?['vin']
          }).toList()
        };
      } else {
        // PERSON
        var lastData = selected?.lastOrNull;
        var isPerson = lastData?['type'] == 'person';
        bodyData = {
          "person" : isPerson ? (lastData?['name']) : "",
          "person_id" : isPerson ? (lastData?['id']) : "",
          "vehicle_group_id" : isPerson ? "" : (lastData?['id'])
        };
      }
      emit(ToDoTaskerLoadingState());
      var response = await _updateToDo(body: bodyData, todoId: model?['id']);
      if (response != null) _reFetchToDos();
    } catch (e) {
      emit(ToDoTaskerErrorState(e));
    }
  }

  void _onSaveAddressEvent(ToDoTaskerSaveAddressEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
      var model = event.model;
      var selected = event.selected;
      var mapData = {
        "address" : (selected?.isNotEmpty ?? false) ? "${[selected?['id']]}" : "",
      };
      emit(ToDoTaskerLoadingState());
      var response = await _updateToDo(body: mapData, todoId: model?['id']);
      if (response != null) _reFetchToDos();
    } catch (e) {
      emit(ToDoTaskerErrorState(e));
    }
  }

  void _onSaveResourcesEvent(ToDoTaskerSaveResourcesEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
      var model = event.model;
      var selected = event.selected;
      var mapData = {"user_group_data" : "${selected?.map((e) => e['id']).toList()}"};
      emit(ToDoTaskerLoadingState());
      var response = await _updateToDo(body: mapData, todoId: model?['id']);
      if (response != null) _reFetchToDos();
    } catch (e) {
      emit(ToDoTaskerErrorState(e));
    }
  }

  void _onCompleteOdometerEvent(ToDoTaskerCompleteOdometerEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
      var model = event.model;
      var currentOdometer = event.currentOdometer;
      var nextMilesCheck = event.nextMilesCheck;
      var nextOdometer = event.nextOdometer;
      // addTodoOdometer
      var addToDoMap = {
        "address" : model?['address'],
        "branch_id" : model?['branch_id'],
        "cohort_id" : model?['cohort_id'],
        "identifier_id" : 257,
        "location" : model?['location'],
        "location_id" : model?['location_id'],
        "notes" : model?['notes'],
        "start_at" : model?['todo_date'],
        "time_sensitive" : model?['time_sensitive'],
        "title" : "Maintenance Check",
        "todo_time" : model?['todo_time'],
        "user_group_id" : model?['user_group_id'],
        "vehicle_name" : model?['vehicle_name'],
        "vehicles" : model?['vehicles'],
        "vendor_id" : model?['vendor_id'],
        "vendor_name" : model?['vendor_name'],
        "vin" : model?['vin'],
      };
      var completeTodoMap = {
        "complete_time_approved" : model?['complete_time_approved'],
        "complete_time_taken" : model?['complete_time_taken'],
        "status" : true
      };
      emit(ToDoTaskerLoadingState());
      var response = await Future.wait([
        _addToDoOdometer(toDoId: model?['id'], currentOdometer: currentOdometer, nextOdometer: nextOdometer, nextMilesCheck: nextMilesCheck),
        _addToDo(body: addToDoMap),
        _completeToDo(body: completeTodoMap, todoId: model?['id'])
      ]);
      if (response.isNotEmpty && response.length == 3) _reFetchToDos();
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ToDoTaskerErrorState(e));
    }
  }

  void _onCompleteDropCarEvent(ToDoTaskerCompleteDropCarEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
      var model = event.model;
      var date = event.date;
      var time = event.time;
      var notes = event.notes;
      var mapData = {
        "title" : "Pickup Car",
        "location" : null,
        "location_id" : null,
        "vehicles" : model?['vehicles'],
        "repeatPeriod" : null,
        "repeatDay" : null,
        "repeatWeek" : null,
        "weekDay" : null,
        "recur_monthly_type" : true,
        "repeatDateMonth" : null,
        "repeatMonth" : null,
        "repeatDayMonth" : null,
        "repeatDateYear" : null,
        "repeatMonthYear" : "January",
        "end_type" : true,
        "end_after" : null,
        "start_at" : date.toFormat(),
        "end_at" : null,
        "person" : null,
        "person_id" : null,
        "vendor_id" : null,
        "vendor_name" : null,
        "notes" : notes,
        "parts" : [],
        "supplies" : [],
        "vehicle_group_id" : null,
        "assigned_to" : [_toDoProcessor.userId],
        "todo_time" : time.toHMS(),
        "platform_check" : null,
        "identifier_id" : 28,
        "todo_user_type" : null,
        "time_sensitive" : false,
        "comments" : null,
        "branch_id" : _toDoProcessor.branchId,
        "mileage" : null,
        "resolution_notes" : null,
        "custom_link_id" : null,
        "reference_id" : null,
        "custom_link" : null
      };
      emit(ToDoTaskerLoadingState());
      var response = await _addToDo(body: mapData);
      if (response != null) _reFetchToDos();
    } catch (e) {
      emit(ToDoTaskerErrorState(e));
    }
  }

  void _callCompleteApi(Map<String, dynamic>? model, {bool showLoading = true}) async {
    try {
      if (showLoading) emit(ToDoTaskerLoadingState());
      Map<String, dynamic> body = {
        "complete_time_approved" : model?['complete_time_approved'],
        "complete_time_taken" : model?['complete_time_taken'],
        "status" : true
      };
      var response = await _completeToDo(body : body, todoId: model?['id']);
      if (response != null) _reFetchToDos();
      emit(ToDoTaskerTaskCompletedState(model));
    } catch (e) {
      emit(ToDoTaskerErrorState(e));
    }
  }

  void _callSaveWorkingHour(Map<String, dynamic>? model) async {
    try {
      // TODO: GET LAST KNOWN LOCATION
      var lastLocation = await _getLastKnownLocation;
      Map<String, dynamic> body = {
        "address" : lastLocation?['address'],
        "is_break" : 0,
        "location" : lastLocation?['address'],
        "start_date" : model?['todo_date'],
        "start_time" : getIt<CommonService>().timeNow,
        "start_time_device_type" : "Mobile",
        "start_time_latitude" : lastLocation?['latitude'],
        "start_time_longitude" : lastLocation?['longitude'],
        "title" : "Todo",
        "user_id" : _toDoProcessor.hrmId,
      };
      var response = await _saveWorkingHour(body : body);
      _fBroadcast.broadcast(Str.userPunchListRefresh);
      Console.of.log(response, name: "SAVE_WORKING_HOUR");
    } catch (e) {
      Console.of.log(e, name: "SAVE_WORKING_HOUR");
    }
  }

  void _callUpdateWorkingHour(Map<String, dynamic>? model) async {
    try {
      // TODO: GET LAST KNOWN LOCATION
      var lastLocation = await _getLastKnownLocation;
      Map<String, dynamic> body = {
        "is_break" : 0,
        "location" : lastLocation?['address'],
        "end_date" : model?['todo_date'],
        "end_time" : getIt<CommonService>().timeNow,
        "end_time_device_type" : "Mobile",
        "end_time_latitude" : lastLocation?['latitude'],
        "end_time_longitude" : lastLocation?['longitude'],
      };
      var response = await _updateWorkingHour(body : body);
      _fBroadcast.broadcast(Str.userPunchListRefresh);
      Console.of.log(response, name: "UPDATE_WORKING_HOUR");
    } catch (e) {
      Console.of.log(e, name: "SAVE_WORKING_HOUR");
    }
  }

  // TODO: NEED_MODIFICATION
  void _onUndoCompleteEvent(ToDoTaskerUndoCompleteEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
      var model = event.model;
      var taskDate = model?['todo_date'].toString().toDateTime();
      var currentDate = DateTime.now().toFormat().toDateTime();
      if (_isCheckInOutTask(model) && (taskDate != currentDate)) return;
      emit(ToDoTaskerLoadingState());
      Map<String, dynamic> body = {
        "complete_time_approved" : model?['complete_time_approved'],
        "complete_time_taken" : model?['complete_time_taken'],
        "status" : false
      };
      var response = await _completeToDo(body : body, todoId: model?['id']);
      if (_isCheckInOutTask(model) && (taskDate == currentDate)) _callUpdateWorkingHour(model);
      if (response != null) _reFetchToDos();
      if (response == null) emit(ToDoTaskerCommonState());
    } catch (e) {
      emit(ToDoTaskerErrorState(e));
    }
  }

  void _onVehicleHistoryTapEvent(ToDoTaskerVehicleHistoryTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerVehicleHistoryTapState(event.model));
  }

  void _onRefreshEvent(ToDoTaskerRefreshEvent event, Emitter<ToDoTaskerState> emit) {
    _reFetchToDos(showLoading: event.showLoading);
  }

  void _onViewVehicleEvent(ToDoTaskerViewVehicleEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerViewVehicleState(event.model));
  }

  void _onVehicleGroupTapEvent(ToDoTaskerVehicleGroupTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerVehicleGroupTapState(event.model));
  }

  void _onUserFilterEvent(ToDoTaskerUserFilterEvent event, Emitter<ToDoTaskerState> emit) {
    selectedUsers = event.users;
    isUserSelected = selectedUsers?.isNotEmpty ?? false;
    _reFetchToDos();
  }

  void _onFilterTaskEvent(ToDoTaskerFilterTaskEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerFilterTaskState());
  }

  void _filterTimeSensitiveTasks() {
    if (isTimeSensitive) {
      unfiltered = unfiltered.where((element) => (element['time_sensitive'] == ((isTimeSensitive ?? false) ? 1 : 0))).toList();
    } else {
      unfiltered = unfiltered;
    }
  }

  void _searchTasks() {
    var searchQuery = searchController.text;
    var tasks = selectedTasks.map((e) => e.toString().toLowerCase()).toList();
    List<Map<String, dynamic>> results = [];
    if (isTimeSensitive) {
      results = unfiltered.where((element) => element['time_sensitive'] == 1).toList();
    } else {
      results = unfiltered;
    }
    toDos = (tasks.isNotEmpty) ? results.where((element) => tasks.contains(element['title'].toString().toLowerCase())).toList() : results;
    toDos = toDos
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
  }

  void _onTaskFilterEvent(ToDoTaskerTaskFilterEvent event, Emitter<ToDoTaskerState> emit) {
    selectedTasks = event.tasks ?? [];
    isFilterSelected = (selectedTasks.isNotEmpty);
    _searchTasks();
    emit(ToDoTaskerCommonState());
  }

  void _onViewAttachmentEvent(ToDoTaskerViewAttachmentEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDOTaskerViewAttachmentState(event.model));
  }


  void _onViewCustomLinkEvent(ToDoTaskerViewCustomLinkEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerViewCustomLinkState(event.model));
  }

  void _onViewReasonAttachmentEvent(ToDoTaskerViewReasonAttachmentEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerViewReasonAttachmentState(event.model));
  }

  void _onSaveRecordEvent(ToDoTaskerSaveRecordEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
      emit(ToDoTaskerLoadingState());
      var file = event.audio;
      if (file != null) {
        var response = await _saveRecording(file: file);
        if ((response != null) && (response.isNotEmpty)) {
          var searchData = response['data'] ?? "";
          searchController.text = searchData;
          _searchTasks();
        }
      }
      emit(ToDoTaskerCommonState());
    } catch (e) {
      Console.of.error(e);
      emit(ToDoTaskerErrorState(e));
    }
  }

  void _onTimeSensitiveEvent(ToDoTaskerTimeSensitiveEvent event, Emitter<ToDoTaskerState> emit) {
    isTimeSensitive = event.isTimeSensitive;
    _searchTasks();
    emit(ToDoTaskerCommonState());
  }

  void _onViewBouncieEvent(ToDoTaskerViewBouncieEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ToDoTaskerViewBouncieState(event.model));
  }

  void _onRemoveVehiclePersonEvent(ToDoTaskerRemoveVehiclePersonEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
      emit(ToDoTaskerLoadingState());
      var response = await _deleteVehicle(id: event.model?['id'].toString());
      if (response != null) _reFetchToDos();
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ToDoTaskerErrorState(e));
    }
  }
}
