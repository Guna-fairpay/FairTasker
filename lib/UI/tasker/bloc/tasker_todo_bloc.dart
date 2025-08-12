import 'dart:async';
import 'dart:convert' show jsonEncode;
import 'dart:io' show File;
import 'dart:math';
import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:date_time/date_time.dart' show DateTimeExtensions, Time;
import 'package:fairpytasker/Response/general_response.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/config/todo_config.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/timeday_extension.dart';
import 'package:fairpytasker/core/app/helper/debouncer.dart';
import 'package:fairpytasker/core/app/helper/dummy_data_provider.dart';
import 'package:fairpytasker/core/app/helper/tasker_hours_processor.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/app/helper/work_manager_helper.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart' show Durations, FocusNode, TextEditingController, TimeOfDay, ScrollController, GlobalObjectKey;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/core/app/helper/helper.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/core/app/enums/task_enum.dart';
import 'package:flutter/gestures.dart' show TapDownDetails;

part 'tasker_todo_events.dart';
part 'tasker_todo_states.dart';
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
  // final ToDoProcessor _toDoProcessor = ToDoProcessor();
  final TaskerHoursProcessor _taskerHoursProcessor = TaskerHoursProcessor();

  bool get isAdmin => getIt<CommonService>().isAdmin;
  Map<String, dynamic>? get currentUser => getIt<CommonService>().user;
  String? get _selectedUserIds => selectedUsers?.map((e) => e['id'].toString()).join(",");

  List<String> get _checkInOutTask => ["Check Out", "Check In"];

  final FocusNode searchFocusNode = FocusNode();

  bool isTimeSensitive = false, isMeetingFilter = false;

  final Map<dynamic, GlobalObjectKey> _todoKeyMaps = {};
  final debounce = Debouncer(duration: Durations.extralong1);

  get todoKeys => _todoKeyMaps;

  final ScrollController scrollController = ScrollController();

  int get _userId => getIt<CommonService>().userId;
  int? get _hrmId => getIt<CommonService>().hrmId;
  int? get _branchId => getIt<CommonService>().branchId;

  List<Map<String, dynamic>> get taskerResult {
    if (toDos.isEmpty) return List.generate(10, (index) => DummyData.tasker);
    return toDos;
  }

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
    on<ToDoTaskerMeetingFilterEvent>(_onMeetingFilterEvent);
    on<ToDoTaskerViewBouncieEvent>(_onViewBouncieEvent);
    on<ToDoTaskerRemoveVehiclePersonEvent>(_onRemoveVehiclePersonEvent);
    on<ToDoTaskerYesterdayEvent>(_onYesterdayEvent);
    on<MeetingViewEvent>(_onMeetingViewEvent);
    on<FollowupTaskEvent>(_onFollowupTaskEvent);
    on<TaskerLeadTapEvent>(_onTaskerLeadTapEvent);
    on<TaskerLeadUpdateEvent>(_onTaskerLeadUpdateEvent);
    on<MeetingTapEvent>(_onMeetingTapEvent);
    on<MeetingUpdateEvent>(_onMeetingUpdateEvent);
    on<BookingInfoEvent>(_onBookingInfoEvent);
    on<LeadInfoEvent>(_onLeadInfoEvent);
  }

  bool _isCheckInOutTask(Map<String, dynamic>? model) => _checkInOutTask.contains(model?['title']);

  void _listenBroadCast() {
    _fBroadcast.register("todo_view", (value, callback) {
      if (value is Map) add(ToDoTaskerRefreshEvent(showLoading: (value?['showLoading'] ?? false), refresh: (value?['refresh'] ?? false)));
      else add(ToDoTaskerRefreshEvent(showLoading: (value ?? false)));
    });
    _fBroadcast.register("show_completed_popup", (value, callback) => add(ToDoTaskerCompleteEvent(value)));
    getIt<CommonService>().branchUpdate(callback: _reFetchToDos);
  }

  void _generateKeys() {
    if (toDos.isEmpty) _todoKeyMaps.clear();
    for (var e in toDos) {
      _todoKeyMaps.putIfAbsent(e['id'], () => GlobalObjectKey(e['id'].toString()));
    }
  }

  /* BEGIN: API CALLS */
  // Future<List<Map<String, dynamic>>?> _fetchToDoList() async => await _toDoProcessor.getToDoList(selectedDate, isCompleted, resourceId: _selectedUserIds);
  Future<Map<String, dynamic>?> _fetchToDoList({bool showOther = false}) async => await _aPiRepository.getToDoModList(selectedDate: selectedDate.toFormat(), status: isCompleted, resourceId: _selectedUserIds, showOther: getIt<CommonService>().activeVehicleList.isEmpty ? showOther : false);
  Future<Map<String, dynamic>?> _changeToMorrow({required List<String> todoIds, dynamic groupId, required String groupName, DateTime? date, TimeOfDay? time}) async => await _aPiRepository.changeToDoByGroup(todoList: todoIds, groupId: groupId, groupName: groupName, date: date, time: time);
  Future<Map<String, dynamic>?> _updateToDo({required Map<String, dynamic> body, required dynamic todoId}) async => await _aPiRepository.updateToDo(body: body, toDoId: todoId);
  Future<Map<String, dynamic>?> _swapToDo({required dynamic fromId, required dynamic toId}) async => await _aPiRepository.swapToDo(fromId: fromId, toId: toId);
  Future<GeneralResponse?> _deleteVehicle({required String? id}) async => await _aPiRepository.deleteTodoVehicle(id : id);
  Future<Map<String, dynamic>?> get _getLastKnownLocation async => await getIt<CommonService>().getCurrentLocation();
  Future<Map<String, dynamic>?> _addToDoOdometer({required dynamic toDoId, required dynamic currentOdometer, required dynamic nextOdometer, required dynamic nextMilesCheck}) async => await _aPiRepository.addToDoOdometer(toDoId: toDoId, currentOdometer: currentOdometer, nextOdometer: nextOdometer, nextMilesCheck: nextMilesCheck);
  Future<Map<String, dynamic>?> _addToDo({required Map<String, dynamic> body}) async => await _aPiRepository.addToDo(body: body);
  Future<Map<String, dynamic>?> _completeToDo({required Map<String, dynamic> body, required dynamic todoId}) async => await _aPiRepository.completeTodo(todoId: todoId, body: body);
  Future<Map<String, dynamic>?> _saveRecording({required File? file}) async => await _aPiRepository.saveAudio(audio: file);
  Future<Map<String, dynamic>?> _saveWorkingHour({required Map<String, dynamic> body}) async => await _aPiRepository.saveWorkingHour(body: body);
  Future<Map<String, dynamic>?> _updateWorkingHour({required Map<String, dynamic> body}) async => await _aPiRepository.updateWorkingHour(body: body);

  /* END: API CALLS */

  void _setOtherValues(Map<String, dynamic>? model) {
    if (model?.containsKey("vehicles") == false) return;
    List<Map<String, dynamic>>? users = List.from(model?['users'] ?? []);
    List<Map<String, dynamic>>? userGroup = List.from(model?['userGroup'] ?? []);
    List<Map<String, dynamic>>? taskExpenseData = List.from(model?['taskExpenseData'] ?? []);
    List<Map<String, dynamic>>? locations = List.from(model?['locations'] ?? []);
    List<Map<String, dynamic>>? vendors = List.from(model?['vendors'] ?? []);
    List<Map<String, dynamic>>? vehicleStatusCategories = List.from(model?['vehicleStatusCategories'] ?? []);
    List<Map<String, dynamic>>? vehicles = List.from(model?['vehicles'] ?? []);
    List<Map<String, dynamic>>? vehicleGroups = List.from(model?['vehicleGroups'] ?? []);
    List<Map<String, dynamic>>? resources = List.from(model?['resources'] ?? []);
    List<Map<String, dynamic>>? parts = List.from(model?['parts'] ?? []);
    List<Map<String, dynamic>>? supplies = List.from(model?['supplies'] ?? []);
    List<Map<String, dynamic>>? leads = List.from(model?['leads'] ?? []);
    List<Map<String, dynamic>>? channels = List.from(model?['channels'] ?? []);
    getIt<CommonService>().updateValues(userList: users, groupPersonList: userGroup, taskExpenseDataList: taskExpenseData, locationsList: locations, vendorsList: vendors, groupVehicleList: vehicleGroups, activeVehicleList: vehicles, resourcesList: resources, partsList: parts, suppliesList: supplies, vehicleCategories: vehicleStatusCategories, leads: leads, channels: channels);
  }

  // INITIAL EVENT PROCESSOR
  /// FETCH TO-DO LISTING API
  void _onInitialEvent(ToDoTaskerInitialEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
      toDos.clear();
      await CommonHelper.instance.waitForPostFrameCallback(withDelay: true);
      emit(ToDoTaskerLoadingState());
      // getIt<CommonService>().getCurrentLocation();
      if (!isAdmin) {
        if ((currentUser != null) && (currentUser?.isNotEmpty ?? false)) selectedUsers?.add(currentUser ?? {});
      }
      var response = await _fetchToDoList(showOther: true);
      if (response != null) _setOtherValues(response);
      unfiltered = _processTodo(List.from(response?['todos'] ?? []));
      toDos = unfiltered;
      // _generateKeys();
      isUserSelected = (selectedUsers?.isNotEmpty ?? false);
      Console.of.log("TASKER_ALL_API_LOADED", name: "TASKER_TODO_BLOC");
      //emit(ToDoTaskerCommonState());
      await _taskerHoursProcessor.initialize();
      processedWorkingHours = _taskerHoursProcessor.processWorkingHours();
      emit(ToDoTaskerCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ErrorState("Server failure, Try again!"));
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
    emit(DatePickerState());
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

  List<Map<String, dynamic>> _processTodo(List<dynamic>? todo) {
    var data = List<Map<String, dynamic>>.from(todo ?? []);
    var checkIO = ["Check In", "Check Out"];
    var checkInOut = data
        .where((element) => checkIO.contains(element['title']))
        .where((element) => element['user_id'].toString().toNumeric == _userId)
        .toList();
    data.removeWhere((element) => checkIO.contains(element['title']));
    data.addAll(checkInOut);
    data.sort((a, b) =>
    a['todo_time']
        .toString()
        .toDateTime(inputFormat: "HH:mm:ss")
        ?.compareTo(
        b['todo_time'].toString().toDateTime(inputFormat: "HH:mm:ss") ??
            DateTime.now()) ??
        0);
    return data;
  }

  void _reFetchToDos({bool showLoading = true, bool refresh = false}) async {
    try {
      toDos.clear();
      if ( (!showLoading) &&  (!isClosed)) emit(ToDoTaskerCommonState());
      Console.of.debug("SHOW_LOADING $showLoading");
      if ( showLoading && (!isClosed)) emit(ToDoTaskerLoadingState());
      if (refresh) triggerPreRequests; // TRIGGER WORK MANAGER TO FETCH ALL THE VALUES BACKGROUND
      var response = await _fetchToDoList();
      // if ((response != null) && (refresh)) _setOtherValues(response); // COMMENTED DUE TO HANDLED IN WM (Work Manager)
      unfiltered = _processTodo(List.from(response?['todos'] ?? []));
      toDos = unfiltered;
      _searchTasks();
      Console.of.debug("CHECK ${toDos.length}");
      //if (!isClosed) emit(ToDoTaskerCommonState());
      processedWorkingHours = await _taskerHoursProcessor.refresh();
      if (!isClosed) emit(ToDoTaskerCommonState());
    } catch (e) {
      Console.of.error("REFRESH_TODOS", error: e);
      if (!isClosed) emit(ErrorState("Server Error, Try again!"));
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

  void _onAddToDoEvent(ToDoTaskerOnAddToDoEvent event, Emitter<ToDoTaskerState> emit) {
    if (event.taskType != null) return emit(AddToDoState(selectedDate, taskType: event.taskType));
    if (event.offset != null) return emit(TaskerTypeState(event.offset!));
  }

  void _onMicEvent(ToDoTaskerOnMicEvent event, Emitter<ToDoTaskerState> emit) {
    emit(MicState());
  }

  void _onEditEvent(ToDoTaskerEditEvent event, Emitter<ToDoTaskerState> emit) {
    emit(EditState(event.toDoId, model: event.model));
  }

  void _onTapUserFilterEvent(
      ToDoTaskerTapUserFilterEvent event, Emitter<ToDoTaskerState> emit) {
    emit(UserFilterState(event.details));
  }

  void _onTapVehicleFilterEvent(
      ToDoTaskerTapVehicleFilterEvent event, Emitter<ToDoTaskerState> emit) {
    emit(VehicleFilterState(event.details));
  }

  void _onVendorInfoEvent(
      ToDoTaskerVendorInfoEvent event, Emitter<ToDoTaskerState> emit) {
    emit(VendorInfoState(event.model));
  }

  void _onViewNotesEvent(
      ToDoTaskerViewNotesEvent event, Emitter<ToDoTaskerState> emit) {
    emit(NotesTapState(event.model));
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
        _generateKeys();
        // TODO: CALL API TO UPDATE
        Map<String, dynamic> body = {
          "notes": event.notes,
        };
        emit(ToDoTaskerLoadingState());
        var response = await _updateToDo(body: body, todoId: model?['id']);
        if (response != null) _reFetchToDos();
        else emit(ToDoTaskerCommonState());
      }
    } catch (e) {
      emit(ErrorState(e));
    }
  }

  void _onVehiclePersonTapEvent(
      ToDoTaskerVehiclePersonTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(VehiclePersonTapState(event.model));
  }

  void _onResourceTapEvent(
      ToDoTaskerResourceTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ResourceTapState(event.model));
  }

  void _onAddressTapEvent(
      ToDoTaskerAddressTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(AddressTapState(event.model));
  }

  void _onPartsTapEvent(
      ToDoTaskerPartsTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(PartsTapState(event.model));
  }

  void _onSuppliesTapEvent(
      ToDoTaskerSuppliesTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(SuppliesTapState(event.model));
  }

  void _onPreviousEvent(
      ToDoTaskerPreviousEvent event, Emitter<ToDoTaskerState> emit) {
    emit(MoveTomorrowState(event.model, toDos));
  }

  void  _onCompleteEvent(
      ToDoTaskerCompleteEvent event, Emitter<ToDoTaskerState> emit) async {
    var model = event.model;
    var identifierId = model?['identifier_id'];
    var taskTitle = model?['title'];
    var taskDate = model?['todo_date'].toString().toDateTime();
    var maintenanceTaskId = model?['maintenance_task_id'].toString();
    var currentDate = DateTime.now().toFormat().toDateTime();
    var mileage = (num.tryParse("${model?['mileage'] ?? ""}") ?? 0);
    var mandatory = model?['mandatory'];
    var hasMileage = (mileage > 0);
    var hasMandatory = ( mandatory == 0);
    var isAbleMaintenanceComplete = (hasMileage && hasMandatory);
    var hasLead = (model?['lead_id'].toString().isNotNullOrEmpty ?? false);
    var hasPrecheckImages = (List.from(model?['precheck_images'] ?? []).isNotEmpty);
    Console.of.log("TASK COMPLETE ${identifierId} $taskTitle MILEAGE $hasMileage ($mileage) MANDATORY $hasMandatory ($mandatory) ${hasMileage && hasMandatory}");
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
      } else {
        if (maintenanceTaskId.isNotNullOrEmpty) {
          emit(MaintenanceCheckTasksCompleteState(model));
        } else {
          _callCompleteApi(model, showLoading: !(["Check Out", "Check In"].contains(taskTitle)));
        }
      }
      switch(taskTitle) {
        case "Check Out": emit(CompleteCheckOutState(event.model)); break;
        case "Check In": emit(CompleteCheckInState(event.model)); break;
      }
    } else {
      if(model?['todo_user_type'] == 5) return emit(MeetingCompleteState(model));
      var autoCompleteIds = [27];
      if (autoCompleteIds.contains(identifierId)) _callCompleteApi(model);
      switch(identifierId) {
        case 35: // OIL CHANGE STATE
        case 126: emit(CompleteOilChangeState(event.model)); break;
        case 408:
        case 257: {
          if (isAbleMaintenanceComplete) {
            _insertMaintenanceCheckTask(model, incrementDays: 30);
            _callCompleteApi(model); } else {
            if(!hasMandatory){
            emit(ErrorState("Is all maintenance check done is mandatory"));
            }if(!hasMileage && hasMandatory){
              emit(ErrorState("Odometer is mandatory"));
            }
            emit(CompleteMaintenanceCheckState(event.model));
          }
        } break;
        case 212: emit(CompleteRentalCheckOutState(event.model)); break;
        case 28:
        case 210: emit(CompleteRentalPickupState(event.model)); break;
        case 27: emit(CompleteDropCarState(event.model)); break;
        case 324: {
          if (hasMileage) _callCompleteApi(model);
          else {
            emit(ErrorState("Odometer is mandatory"));
            await Future.delayed(Durations.short1);
            emit(CompleteMaintenanceCheckState(event.model));
          }
        } break;
        case 403: {
          if(hasPrecheckImages){
            _callCompleteApi(model);
          }else{
            emit(ErrorState("Upload internal,external,etc., pictures to complete"));
            emit(CompletePreCheckState(event.model));
          }
        } break;
        default: _callCompleteApi(model); break; // CALL API TO COMPLETE TASK
      }
    }
    if (hasLead) return emit(FollowupTaskState(model));
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
          "${getIt<CommonService>().userId}_${dateTime.year}_${dateTime.month}_${dateTime.day}_${time.hour.toString().padLeft(2, '0')}_${time.minute.toString().padLeft(2, '0')}_00";
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
      emit(ErrorState(e));
    }
  }

  void _onDateChangeTapEvent(
      ToDoTaskerDateChangeTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(DateChangeTapState(event.model));
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
      emit(ErrorState(e));
    }
  }

  void _onCompletedTimeTapEvent(
      ToDoTaskerCompletedTimeTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(CompletedTimeTapState(event.model));
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
      emit(ErrorState(e));
    }
  }

  void _onTimePickerTapEvent(
      ToDoTaskerTimePickerTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(TimePickerTapState(event.model));
  }

  void _onTimeChangeEvent(
      ToDoTaskerTimeChangeEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
      var model = event.model;
      var time = event.selectedTime;
      var identifierId = model?['identifier_id'];
      var isPlatformRequired = Str.platFormCheckIds.contains(identifierId) && ((getIt<CommonService>().departmentId) == 7) && (model?['platform_check'] == 0);
      if (isPlatformRequired) return emit(ErrorState("Platform check is required"));
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
            emit(ShowDropCheckInPopupState(model, time, "drop"));
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
            emit(ShowDropCheckInPopupState(model, time, "pickup"));
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
      Console.of.error("ON_TIME_CHANGE_ERROR", error: e);
      emit(ErrorState(e));
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
      emit(ErrorState(e));
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
      emit(ErrorState(e));
    }
  }

  void _onVendorLocationTapEvent(
      ToDoTaskerVendorLocationTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(VendorLocationTapState(event.model));
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
      emit(ErrorState(e));
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
      emit(ErrorState(e));
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
      emit(ErrorState(e));
    }
  }

  void _onSaveResourcesEvent(ToDoTaskerSaveResourcesEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
      var model = event.model;
      var selected = event.selected;
      var identifierId = model?['identifier_id'];
      var isPlatformRequired = Str.platFormCheckIds.contains(identifierId) && ((getIt<CommonService>().departmentId) == 7) && (model?['platform_check'] == 0);
      if (isPlatformRequired) return emit(ErrorState("Platform check is required"));
      var mapData = {"user_group_data" : "${selected?.map((e) => e['id']).toList()}"};
      emit(ToDoTaskerLoadingState());
      var response = await _updateToDo(body: mapData, todoId: model?['id']);
      if (response != null) _reFetchToDos();
      triggerPreRequests;
    } catch (e) {
      emit(ErrorState(e));
    }
  }

  Future<Map<String, dynamic>?> _insertMaintenanceCheckTask(Map<String, dynamic>? model, {int incrementDays = 0}) async {
    try {
      var date = model?['todo_date'].toString().toDateTime();
      if (incrementDays > 0) {
        date = date?.add(Duration(days: incrementDays));
      }
      var addToDoMap = {
        "address" : model?['address'],
        "branch_id" : model?['branch_id'],
        "cohort_id" : model?['cohort_id'],
        "identifier_id" : 257,
        "location" : model?['location'],
        "location_id" : model?['location_id'],
        "notes" : model?['notes'],
        "start_at" : date.toFormat(),
        "time_sensitive" : model?['time_sensitive'],
        "title" : "Maintenance Check",
        "todo_time" : model?['todo_time'],
        "user_group_id" : model?['user_group_id'],
        "vehicle_name" : model?['vehicle_name'],
        "vehicles" : "${List.from(model?['vehicles'] ?? []).map((e) => jsonEncode(e)).toList()}",
        "vendor_id" : model?['vendor_id'],
        "vendor_name" : model?['vendor_name'],
        "vin" : model?['vin'],
        "user_id": model?['user_id']
      };
      return await _addToDo(body: addToDoMap);
    } catch (e) {
      rethrow;
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
        "vehicles" : "${List.from(model?['vehicles'] ?? []).map((e) => jsonEncode(e)).toList()}",
        "vendor_id" : model?['vendor_id'],
        "vendor_name" : model?['vendor_name'],
        "vin" : model?['vin'],
        "user_id": model?['user_id']
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
      emit(ErrorState(e));
    }
  }

  void _onCompleteDropCarEvent(ToDoTaskerCompleteDropCarEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
      var model = event.model;
      var date = event.date;
      var time = event.time;
      var notes = event.notes;
      var mapData = {
        // "user_id": _toDoProcessor.userId,
        "title" : "Pickup Car",
        "location" : null,
        "location_id" : null,
        "vehicles" : "${List.from(model?['vehicles'] ?? []).map((e) => jsonEncode(e)).toList()}",
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
        "assigned_to" : [_userId],
        "todo_time" : time.toHMS(),
        "platform_check" : null,
        "identifier_id" : 28,
        "todo_user_type" : null,
        "time_sensitive" : false,
        "comments" : null,
        "branch_id" : _branchId,
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
      emit(ErrorState(e));
    }
  }

  Future<Map<String, dynamic>?> _onCompleteToDo(Map<String, dynamic>? model) async {
    Console.of.log("MODEL: $model");
    Map<String, dynamic> body = {};
    body["complete_time_approved"] = model?['complete_time_approved'];
    body["complete_time_taken"] = (model?['display']?['completed_time'] ?? model?['complete_time_taken']);
    if((model?['title'].toString().toLowerCase() == "check in") || (model?['title'].toString().toLowerCase() == "check out")){
      var lastLocation = await _getLastKnownLocation;
      body['address'] = lastLocation?['address'];
      if(model?['title'].toString().toLowerCase() == "check in"){
        body['start_time_device_type'] = "Mobile";
      } else{
        body['end_time_device_type'] = "Mobile";
      }
      body['start_time_device_type'] = "Mobile";
      body['start_time_latitude'] = lastLocation?['latitude'];
      body['start_time_longitude'] = lastLocation?['longitude'];
    }
    body['status'] = true;
    return await _completeToDo(body : body, todoId: model?['id']);
  }

  Future<Map<String, dynamic>?> _vehicleUpdateStatus(
      Map<String, dynamic> body, dynamic vin) async =>
      await _aPiRepository.vehicleStatusUpdateApi(body: body, vin: vin);

  Map<String, dynamic> _statusUpdateBody(Map<String, dynamic>? model) => {
    "config_id": [(model?['vehicle_status_id'] ?? 0)],
    "category_id": (model?['vehicle_status_category'] ?? 0),
    "vin": model?['vin'] ?? "",
    "checklist_id": [(model?['vehicle_status_checklist'] ?? 0)],
    "checkbox_value": 1
  };

  void _callCompleteApi(Map<String, dynamic>? model, {bool showLoading = true}) async {
    try {
      if (showLoading) emit(ToDoTaskerLoadingState());
      var response = await _onCompleteToDo(model);
      if (response != null) {
        Map<String, dynamic> statusToDo = Map.from(response['statusTodo'] ?? {});
        Console.of.log("HAS STATUSTODO: ${statusToDo.isNotEmpty}");
        // if ((statusToDo.isNotEmpty) && (model?['todo_date'] == DateTime.now().toFormat())) emit(ToDoTaskerCompleteTransportCarState(model?..putIfAbsent("statusTodo", () => statusToDo)));
        if ((statusToDo.isNotEmpty)) {
          await _vehicleUpdateStatus(_statusUpdateBody(model), model?['vin']);
          emit(CompleteTransportCarState(model?..putIfAbsent("statusTodo", () => statusToDo)));
        }
        emit(TaskCompletedState(model)); _reFetchToDos();
      } else {
        emit(ToDoTaskerCommonState());
      }
    } catch (e) {
      emit(ErrorState(e));
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
        "user_id" : _hrmId,
      };
      var response = await _saveWorkingHour(body : body);
      if (response?['status'] == false) Toaster.showError(response?['message'] ?? "Sorry! Try again");
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
      if (response?['status'] == false) Toaster.showError(response?['message'] ?? "Sorry! Try again");
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
      emit(ErrorState(e));
    }
  }

  void _onVehicleHistoryTapEvent(ToDoTaskerVehicleHistoryTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(VehicleHistoryTapState(event.model));
  }

  void _onRefreshEvent(ToDoTaskerRefreshEvent event, Emitter<ToDoTaskerState> emit) {
    _reFetchToDos(showLoading: event.showLoading, refresh: event.refresh);
  }

  void _onViewVehicleEvent(ToDoTaskerViewVehicleEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ViewVehicleState(event.model));
  }

  void _onVehicleGroupTapEvent(ToDoTaskerVehicleGroupTapEvent event, Emitter<ToDoTaskerState> emit) {
    emit(VehicleGroupTapState(event.model));
  }

  void _onUserFilterEvent(ToDoTaskerUserFilterEvent event, Emitter<ToDoTaskerState> emit) {
    selectedUsers = event.users;
    isUserSelected = selectedUsers?.isNotEmpty ?? false;
    _reFetchToDos();
  }

  void _onFilterTaskEvent(ToDoTaskerFilterTaskEvent event, Emitter<ToDoTaskerState> emit) {
    emit(FilterTaskState(isTimeSensitive));
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
    if (isMeetingFilter) {
      results = results.where((element) => element['todo_user_type'] == 5).toList();
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
    _generateKeys();
  }

  void _onTaskFilterEvent(ToDoTaskerTaskFilterEvent event, Emitter<ToDoTaskerState> emit) {
    selectedTasks = event.tasks ?? [];
    isFilterSelected = (selectedTasks.isNotEmpty);
    _searchTasks();
    emit(ToDoTaskerCommonState());
  }

  void _onViewAttachmentEvent(ToDoTaskerViewAttachmentEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ViewAttachmentState(event.model));
  }


  void _onViewCustomLinkEvent(ToDoTaskerViewCustomLinkEvent event, Emitter<ToDoTaskerState> emit) {
    var link = event.model?['custom_link'];
    final hasFaiRental = ((event.model?['custom_link_id'] == 3) && (event.model?['rental_booking_id'] != null));
    final faiRentalBookingId = event.model?['rental_booking_id'];
    if (event.model?['display']?['customLinkText'].toString().isNotNullOrEmpty ?? false) {
      link = switch(event.model?['display']?['customLinkText']) {
        "G" => event.model?['reference_id'].toString().toGetAroundReserveUrl,
        _ => event.model?['reference_id'].toString().toTuroReserveUrl
      };
    }
    if (hasFaiRental) link = faiRentalBookingId.toString().toFaiRentalReserveUrl;
    emit(ViewCustomLinkState(event.model, link));
  }

  void _onViewReasonAttachmentEvent(ToDoTaskerViewReasonAttachmentEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ViewReasonAttachmentState(event.model));
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
      emit(ErrorState(e));
    }
  }

  void _onTimeSensitiveEvent(ToDoTaskerTimeSensitiveEvent event, Emitter<ToDoTaskerState> emit) {
    isTimeSensitive = event.isTimeSensitive;
    _searchTasks();
    emit(ToDoTaskerCommonState());
  }

  void _onMeetingFilterEvent(ToDoTaskerMeetingFilterEvent event, Emitter<ToDoTaskerState> emit) {
    isMeetingFilter = event.isMeetingFilter;
    _searchTasks();
    emit(ToDoTaskerCommonState());
  }

  void _onViewBouncieEvent(ToDoTaskerViewBouncieEvent event, Emitter<ToDoTaskerState> emit) {
    emit(ViewBouncieState(event.model));
  }

  void _onRemoveVehiclePersonEvent(ToDoTaskerRemoveVehiclePersonEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
      emit(ToDoTaskerLoadingState());
      var response = await _deleteVehicle(id: event.model?['id'].toString());
      if (response != null) _reFetchToDos();
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ErrorState(e));
    }
  }

  void _onYesterdayEvent(ToDoTaskerYesterdayEvent event, Emitter<ToDoTaskerState> emit) {
    selectedDate = event.selectedDate;
    isCompleted = false;
    _reFetchToDos();
  }

  void _onMeetingViewEvent(MeetingViewEvent event, Emitter<ToDoTaskerState> emit) {
    final model = event.model;
    final hasMeeting = ((model?['meeting_mode'] == "online") && (model?['meeting_link'].toString().isNotNullOrEmpty ?? false));
    final meetingLink = model?['meeting_link'].toString();
    if (hasMeeting) return emit(ViewCustomLinkState(model, meetingLink));
  }

  void _onFollowupTaskEvent(FollowupTaskEvent event, Emitter<ToDoTaskerState> emit) {
    emit(AddToDoState(selectedDate,leadId: event.model?['lead_id'], taskType: TaskType.lead));
  }

  void _onTaskerLeadTapEvent(TaskerLeadTapEvent event, Emitter<ToDoTaskerState> emit) {
    if ((event.model?['lead_id'].toString().isNotNullOrEmpty ?? false) || (event.model?['channel_id'].toString().isNotNullOrEmpty ?? false)) return emit(LeadChangeState(event.model));
  }

  void _onTaskerLeadUpdateEvent(TaskerLeadUpdateEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
      var model = event.model;
      var lead = event.selectedModel;
      if (lead != null) {
        var mapData = { (lead['type'] == "lead" ? "lead_id" : "channel_id"): lead['id']};
        emit(ToDoTaskerLoadingState());
        var response = await _updateToDo(body: mapData, todoId: model?['id']);
        if (response != null) _reFetchToDos();
      }
    } catch (e) {
      emit(ErrorState(e));
    }
  }

  void _onMeetingTapEvent(MeetingTapEvent event, Emitter<ToDoTaskerState> emit) {
    if (event.model?['meeting_mode'].toString().isNotNullOrEmpty ?? false) return emit(MeetingChangeState(event.model));
  }

  void _onMeetingUpdateEvent(MeetingUpdateEvent event, Emitter<ToDoTaskerState> emit) async {
    try {
      var model = event.model;
      var meetingMode = event.selectedModel;
      if (meetingMode != null) {
        var mapData = {"meeting_mode": meetingMode['name'].toString().toLowerCase()};
        emit(ToDoTaskerLoadingState());
        var response = await _updateToDo(body: mapData, todoId: model?['id']);
        if (response != null) _reFetchToDos();
      }
    } catch (e) {
      emit(ErrorState(e));
    }
  }

  void _onBookingInfoEvent(BookingInfoEvent event, Emitter<ToDoTaskerState> emit) {
    try{
      emit(BookingInfoState(event.model));
    }catch (e){
      emit(ErrorState(e));
    }
  }

  void _onLeadInfoEvent(LeadInfoEvent event, Emitter<ToDoTaskerState> emit) {
    try {
      emit(LeadInfoState(event.model));
    } catch (e) {
      emit(ErrorState(e));
    }
  }

}
