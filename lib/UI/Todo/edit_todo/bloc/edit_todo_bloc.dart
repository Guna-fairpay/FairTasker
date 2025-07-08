import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:fairpytasker/UI/dialog/oil_change_exist_dialog.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_delta_from_html/parser/html_to_delta.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

import 'edit_todo_event.dart';
import 'edit_todo_state.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:date_time/date_time.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:collection/collection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/helper/helper.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/config/todo_config.dart';
import 'package:fairpytasker/UI/tasker/helper/tasker_helper.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_const.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/timeday_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/helper/custom_search_data_converter.dart';

class EditToDoBloc extends Bloc<EditToDoEvent, EditTodoState> {

  final APiRepository apiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();

  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController partsController = TextEditingController();
  final TextEditingController suppliesController = TextEditingController();
  final TextEditingController vPersonController = TextEditingController();
  final TextEditingController vLocationController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController customLinkController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController odometerController = TextEditingController();
  final TextEditingController tripDrivenController = TextEditingController();
  final TextEditingController resolutionNotesController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();
  QuillController quillController = QuillController.basic();

  int? get branchId => Session.of.getInt(Str.branchIdPrefText);
  String? get currentUserId => Session.of.getString(Str.userIdPrefText);

  String? departmentId;
  String? reason;
  String? timeChangePopupType;
  String? todoId;
  String? name = Session.of.getString("name");

  List<String> selectedIds = [];
  List<Map<String, dynamic>> vehicleList = [];
  List<Map<String, dynamic>> partList = [];
  List<Map<String, dynamic>> suppliesList = [];
  List<Map<String,dynamic>> task = [];
  List<Map<String,dynamic>> vehiclePersonList=[];
  List<dynamic> vinList = [];
  List<dynamic> linkSelection = [];
  List<dynamic> images = [];
  List<dynamic> todoImages = [];
  List<dynamic> notesImages = [];
  List<dynamic> mileageImages = [];
  List<dynamic> vehicleData = [];
  List<dynamic> addressList = [];
  List<dynamic> vendors = [];
  List<dynamic> locations = [];
  List<dynamic> partsIdList = [];
  List<dynamic> suppliesIdList = [];
  List<dynamic> meetingType = [
    {'id': 1, 'name': 'Online'},
    {'id': 2, 'name': 'Person'},
  ];

  Map<String, dynamic> selectionTaps = {};

  dynamic selectedSentiments = {};
  dynamic previousOdometer = {};
  dynamic selectedDate;
  dynamic selectedMeetingType;

  Map<String, dynamic>? todoResponse = {};

  bool showCleanCar = false;
  bool cleanCarIsActive = false;
  bool showOdometer = false;
  bool isRecurring = false;

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  DateTime? recurringStartDate;

  @override
  Future<void> close() {
    _broadcast.unregister(Str.editToDoRefresh);
    return super.close();
  }

  Future<Map<String, dynamic>?> _editToDo({dynamic id}) async => await apiRepository.editToDo(id);
  Future<List<Map<String, dynamic>>> _getPartsList() async => await getIt<CommonService>().getPartsList();
  Future<List<Map<String, dynamic>>> _getSuppliesList() async => await getIt<CommonService>().getSuppliesList();
  Future<List<Map<String, dynamic>>> _getActiveVehicles() async => await getIt<CommonService>().getActiveVehicles();
  Future<List<Map<String, dynamic>>> _getVendorsList() async => await getIt<CommonService>().getVendorsList();
  Future<List<Map<String, dynamic>>> _getLocationsList() async => await getIt<CommonService>().getLocationsList();
  Future<List<Map<String, dynamic>>>_getTaskExpenseData() async => await getIt<CommonService>().getTaskExpenseData();
  Future<List<Map<String, dynamic>>>_getGroupPersons() async => await getIt<CommonService>().getGroupPersons();
  Future<List<Map<String, dynamic>>>_getResources() async => await getIt<CommonService>().getResources();
  Future<List<Map<String, dynamic>>>_groupVehicles() async => await getIt<CommonService>().groupVehicles();

  EditToDoBloc() : super(EditTodoState(
    isLoading: false,
    isTimeSensitive: false,
    tasks: const [],
    vehicles: const [],
    persons: const [],
    vendors: const [],
    locations: const [],
    partServices: const [],
    supplies: const [],
    resources: const [],
    selectedTaskPersons: const [],
    selectedVPerson: const [],
    selectedVLocations: const {},
    selectedParts: const [],
    selectedSupplies: const [],
    todoAttachments: const [],
    selectedTask: const {},
    linkOptions: AddToDoConfig.customOptions,
    bottomTapData: const [],
    selectedBottomTap: const {},
    isSelectedPlatformCheck: false,
    showPlatformCheck: false,
    isMoreEnable: false,
    isPartServiceEnable: false,
    isSuppliesEnable: false,
    selectedLinkOption: AddToDoConfig.customOptions[1],
    selectedDate: DateTime.now(),
    selectedTime: TimeOfDay.now(),
    apiResponse: const {},
    todoStatus: false,
    selectedResource: const [],
    userGroup: const [],
    resourceName: const [],
    addresses: const [],
    title: '',
    taskHistory: const [],
    selectedVehicle: const {},
    groupVehicles: const [],
    sentiments: AddToDoConfig.sentiments,
    selectedSentiment: const {},
    popUpdatePage: false,
    previousOdometer: '',
    selectedClearDuration: AddToDoConfig.cleanCarDurations.first,
    showCleanCar: false,
    isPop: false,
    clearDurations: AddToDoConfig.cleanCarDurations,
    selectedEndDate: null,
    selectedStartDate: null,
    isTimeChange: false,
    notesImages: const [],
    mileageImages: const [],
    showOdometer: false,
  )) {
    _broadcast.register(Str.addToDoRefresh, (value, callback) => add(EditToDoRefreshEvent()));
    on<EditToDoRefreshEvent>(_onRefreshEvent);
    on<GetEditTodoInitialEvent>(_onInitialEvent);
    on<EditToDoVLocationEvent>(_onVLocationEvent);
    on<EditToDoShowMoreEvent>(_onShowMoreEvent);
    on<EditToDoTaskEvent>(_onTaskEvent);
    on<EditToDoVPersonEvent>(_onVPersonEvent);
    on<EditToDoShowPartsEvent>(_onShowPartsEvent);
    on<EditToDoShowSuppliesEvent>(_onShowSuppliesEvent);
    on<TaskStatusChangeEvent>(_onTaskStatusChangeEvent);
    on<EditToDoPersonTapEvent>(_onPersonTapEvent);
    on<EditToDoCleanCarDuration>(_onCleanCarDurationEvent);
    on<EditToDoPlatformCheckEvent>(_onPlatformCheckEvent);
    on<EditToDoPartSelectionEvent>(_onPartSelectionEvent);
    on<EditToDoSupplySelectionEvent>(_onSupplySelectionEvent);
    on<EditToDoRecurringTypeEvent>(_onDoRecurringTypeEvent);
    on<EditToDoDateChangeEvent>(_onDateChangeEvent);
    on<EditToDoStartDateChangeEvent>(_onStartDateChangeEvent);
    on<EditToDoEndDateChangeEvent>(_onEndDateChangeEvent);
    on<EditToDoTimeChangeEvent>(_onTimeChangeEvent);
    on<EditTodoTimeChangeReasonEvent>(_onTimeChangeReasonEvent);
    on<EditToDoTimeSensitiveEvent>(_onTimeSensitiveEvent);
    on<EditToDoEditAttachmentEvent>(_onEditAttachmentEvent);
    on<EditToDoSelectLinkOptionEvent>(_onSelectLinkOptionEvent);
    on<EditToDoSelectSentimentsEvent>(_onSelectSentimentEvent);
    on<EditToDoOpenCustomLinkEvent>(_onOpenCustomLinkEvent);
    on<EditToDoBottomTapEvent>(_onBottomTapEvent);
    on<UserSelectionEvent>(_onUserSelectionEvent);
    on<SelectedUsersNameEvent>(_onSelectedUsersNameEvent);
    on<EditToDoAddressSelectionEvent>(_onAddressSelectionEvent);
    on<EditToDoSelectTaskHistoryEvent>(_onSelectTaskHistoryEvent);
    on<EditToDoDeleteVehicleEvent>(_onDeleteVehicleEvent);
    on<DeleteTodoEvent>(_onDeleteTodoEvent);
    on<RemoveImageEvent>(_onRemoveImageEvent);
    on<RemoveNotesImageEvent>(_onRemoveNotesImageEvent);
    on<RemoveMileageImageEvent>(_onRemoveMileageImageEvent);
    on<EditToDoSaveEvent>(_onSaveEvent);
    on<EditToDoCleanCarEvent>(_onCleanCarEvent);
    on<EditToDoMeetingTypeEvent>(_onMeetingTypeEvent);
  }

  Future<void>_onInitialEvent(GetEditTodoInitialEvent event, Emitter<EditTodoState> emit) async  {
  try {
    await CommonHelper.instance.waitForPostFrameCallback();
    emit(state.copyWith(isLoading: true));
    todoResponse = await _editToDo(id: event.todoId);
    var partsResponse = await _getPartsList();
    var suppliesResponse = await _getSuppliesList();
    var vehicleResponse = await _getActiveVehicles();
    var vendorResponse = await _getVendorsList();
    var locationResponse = await _getLocationsList();
    var taskResponse = await _getTaskExpenseData();
    var userGroupResponse = await _getGroupPersons();
    var assignedToResponse = await _getResources();
    var groupVehiclesResponse = await _groupVehicles();
    var resources = assignedToResponse;
    resources.removeWhere((resource) => resource['id'] == 2);
    resources.removeWhere((resource) =>
    ((!Str.reqTaskManagerIds.contains(resource['id'])) &&
        (resource['branch_id'] !=
            Session.of.getInt(Str.branchIdPrefText))) ||
        (resource['deleted_at'] != null));
    var selectedUser = resources
        .where((element) => element['id'].toString() == currentUserId)
        .toList();
    if(todoResponse?['identifier_id'] == 358) {
      quillController.document = Document.fromDelta(
          HtmlToDelta().convert(todoResponse?['rental_enquiry'] ?? ''));
    }
    timeController.text = todoResponse?['todo_time'] ?? '';
    dateController.text = todoResponse?['todo_date'] ?? '';
    notesController.text = todoResponse?['notes'] ?? '';
    departmentId = selectedUser.firstOrNull?['department'].toString();
    customLinkController.text = todoResponse?['reference_id'] ?? '';
    tripDrivenController.text = todoResponse?['trip_driven'] ?? '';
    resolutionNotesController.text =
        todoResponse?['resolution_notes'] ?? '';
    if((todoResponse?['comments']) != null) commentsController.text = todoResponse?['comments'] ?? '';
    odometerController.text = "${todoResponse?['mileage'] ?? ''}";
    if (todoResponse?['trip_review'] != null) {
      selectedSentiments = AddToDoConfig.sentiments.firstWhereOrNull(
              (element) =>
          element['name'] == todoResponse?['trip_review']) ??
          {};
    }
    linkSelection = AddToDoConfig.customOptions
        .where((element) =>
    element['id']?.toString() ==
        todoResponse?['custom_link_id']?.toString())
        .toList();
    if (linkSelection.isEmpty) {
      linkSelection = [AddToDoConfig.customOptions[1]];
    }
    if(todoResponse?['vehicle_group_id'] == null){
      vinList = [todoResponse?['vin']];
      var vVins = List.from(todoResponse?['vehicles']).map((e) => e['vin']);
      vinList.addAll(vVins);
      vinList.removeWhere((element) => element.toString().isNullOrEmpty);
      vinList = vinList.unique((element) => element);
      Console.of.log("Vins $vinList");
      if (vinList.isNotEmpty) {
        vehicleList = vehicleResponse
            .where((element) => vinList.contains(element['vin'].toString()))
            .toList();
      }
    }
    if (todoResponse?['location_id'] != null) {
      locations = locationResponse
          .where((element) =>
      element['id'].toString() == todoResponse?['location_id'])
          .toList();
    }
    if (todoResponse?['vendor_id'] != null) {
      vendors = vendorResponse
          .where((element) =>
      element['id'].toString() == todoResponse?['vendor_id'])
          .toList();
    }
    if (todoResponse?['user_id'] != null) {
      selectedIds = ((todoResponse?['user_id']).toString()).split(',');
    }
    if (todoResponse?['user_group_id'] != null) {
      for (var group in userGroupResponse) {
        if (group['id'] == todoResponse?['user_group_id']) {
          var decodedList = List.from(json.decode(group['userId'] ?? '') ?? []);
          selectedIds = decodedList.map((e) => e.toString()).toList();
        }
      }
    }
    var list = assignedToResponse
        .where((element) => selectedIds.contains(element['id'].toString()))
        .map((e) => [e['first_name'].toString(), e['last_name'].toString()]
        .toInitial)
        .toList();
    List<dynamic> partsId = [];
    if ((todoResponse?['parts'] as List).isNotEmpty) {
      partsId = todoResponse?['parts']
          .map((e) => e['parts_id'])
          .where((element) => element != null)
          .toList();
    }
    if (partsId.isNotEmpty) {
      partList = partsResponse
          .where((element) => partsId.contains(element['id'].toString()))
          .toList();
    }
    List<dynamic> suppliesId = [];
    if ((todoResponse?['supplies'] as List).isNotEmpty) {
      suppliesId = todoResponse?['supplies']
          .map((e) => e['supplies_id'])
          .where((element) => element != null)
          .toList();
    }
    if (suppliesId.isNotEmpty) {
      suppliesList = suppliesResponse
          .where((element) => suppliesId.contains(element['id'].toString()))
          .toList();
    }
    suppliesBroadcastEvent(suppliesList);
    var showPlatformCheck = false;
    showPlatformCheck =
        Str.platFormCheckIds.contains(todoResponse?['identifier_id']);
    images = todoResponse?['todoimages'];
    todoImages =
        images.map((e) => e['path'].toString().toAttachmentURL).toList();
    notesImages =
        List.from(todoResponse?['todo_note_attachments']).map((e) => e['path'].toString().toAttachmentURL).toList();
    mileageImages =
        List.from(todoResponse?['todo_mileage_attachments']).map((e) => e['path'].toString().toAttachmentURL).toList();
    final title = todoResponse?['title'];
    final vehicleExists = todoResponse?['vehicle_name'] != null ||
        todoResponse?['vin'] != null ||
        (todoResponse?['vehicles']?.isNotEmpty ?? false);
    final List<Map<String, dynamic>> tabs = [
      if (!['Check In', 'Check Out'].contains(title))
        {"id": 1, "title": "Expense"},
      {"id": 2, "title": "Next Task"},
      if ([268,219].contains(todoResponse?['identifier_id'])) {"id": 3, "title": "Check List"},
      if (todoResponse?['identifier_id'] == 257) {"id": 4, "title": "Maintenance"},
      if (['Oil change'.toLowerCase(), 'OilChange Check'.toLowerCase(), 'Oil Change Check'.toLowerCase()].contains(title.toString().toLowerCase()))
        {"id": 7, "title": "Odometer"}, //Add by RDB
      if (!['Check In', 'Check Out'].contains(title) && vehicleExists)
        {"id": 5, "title": "Set Vehicle"},
      if (todoResponse?['identifier_id'] == 324)
        {"id": 6, "title": "Private Rental Check"},
    ];
    selectionTaps = tabs.firstWhere(
          (e) =>
      ([268,219].contains(todoResponse?['identifier_id']) && e['title'] == "Check List") ||
          (todoResponse?['identifier_id'] == 257 && e['title'] == "Maintenance") ||
          (todoResponse?['identifier_id'] == 324 && e['title'] == "Private Rental Check") ||
          ((title == 'Oil change' || title == 'OilChange Check' || title == 'Oil Change Check') && e['title'] == "Odometer"),
      orElse: () => tabs.isNotEmpty ? tabs[0] : {},
    );
    var selectedPerson = resources
        .where((element) =>
    element['id'].toString() ==
        todoResponse?['person_id'].toString())
        .toList();
    var selectedGroupVehicles = groupVehiclesResponse
        .where((element) =>
    element['id'].toString() ==
        todoResponse?['vehicle_group_id'].toString())
        .toList();
    var selectedTask = taskResponse.firstWhereOrNull(
            (element) => element['id'] == todoResponse?['identifier_id']);
    vehicleData = todoResponse?['vehicles'] ?? [];
    final addressIds = (todoResponse?['address'] != null)
        ? List.from(jsonDecode(todoResponse!['address']))
        : [];
    addressList = List.from(locations.firstOrNull?['addresses'] ?? [])
        .where((e) => addressIds.contains(e['id']))
        .toList();
    if(vinList.isNotEmpty){
      previousOdometer = List.from(todoResponse?['previousOdometer']).firstOrNull;
      /*previousOdometer = await _getPreviousOdometer(
          date: todoResponse?['todo_date'],
          vin: List.from(vinList).firstOrNull ?? '',
          identifierId: todoResponse?['identifier_id']);*/
    }
    showCleanCar = Str.cleanCarCheckIds.contains(todoResponse?['identifier_id']);
    RegExp dateRegExp = RegExp(r'\d{2}-\d{2}-\d{4}');
    if(todoResponse?['recurring'] != null && todoResponse?['recurring_last_date'] != null){
      final matches = dateRegExp.allMatches(todoResponse?['recurring']??[]).toList();
      if (matches.isNotEmpty) {
        String startDate = matches[0].group(0)!;
        DateTime parsedStart = DateFormat('yyyy-MM-dd').parse(startDate);
        recurringStartDate = parsedStart;
        selectedStartDate = DateFormat('yyyy-MM-dd').parse(todoResponse?['todo_date']);
        selectedEndDate = DateFormat('yyyy-MM-dd').parse(todoResponse?['recurring_last_date']);
      }
    }
    todoId = todoResponse?['id'].toString()??'';
    partsIdList=List<Map<String, dynamic>>.from(todoResponse?['parts'] ?? []).map((e) => e['parts_id']).toList();
    suppliesIdList=List<Map<String, dynamic>>.from(todoResponse?['supplies'] ?? []).map((e) => e['supplies_id']).toList();
    Console.of.log(partsIdList.toString(), name: "partsIdList");
    task =List.from(taskResponse);
    vehiclePersonList=CustomSearchDataConverter.convertVPerson(
        vehicles: vehicleList,
        persons: selectedPerson,
        groupVehicles: selectedGroupVehicles);
    cleanCarIsActive=true;

    if((todoResponse?['identifier_id'] == null) || (selectedTask == null)
        || (selectedTask['task'] != (todoResponse?['title'] ?? '')) ){
      Console.of.debug(todoResponse?['title']);
      taskNameController.text = todoResponse?['title'] ?? '';
      selectedTask=null;
    }

    showOdometer = (Str.completedOdometer.contains(todoResponse?['identifier_id'])
        && todoResponse?['status']=="Completed")
        || (Str.unCompletedOdometer.contains(todoResponse?['identifier_id']));

    Console.of.log(showOdometer.toString(), name: "show");
    isRecurring = todoResponse?['recurring_id'] != null;

    selectedMeetingType = meetingType.firstWhereOrNull((element) => element['name'] == todoResponse?['meeting_type']);

    emit(state.copyWith(
      isLoading: false,
      showCleanCar: showCleanCar,
      bottomTapData: tabs,
      resourceName: list,
      apiResponse: todoResponse,
      previousOdometer: "${previousOdometer?['odometer'] ?? ''}",
      todoStatus: todoResponse?['status'] == 'In Progress' ? false : true,
      selectedBottomTap: selectionTaps,
      tasks: task,
      selectedTask: selectedTask,
      selectedVPerson: CustomSearchDataConverter.convertVPerson(
          vehicles: vehicleList,
          persons: selectedPerson,
          groupVehicles: selectedGroupVehicles),
      selectedVLocations: CustomSearchDataConverter.convertVLocation(
          vendors: vendors, locations: locations)
          .firstOrNull ??
          {},
      addresses: addressList,
      selectedDate: todoResponse?['todo_date']
          .toString()
          .toDateTime(inputFormat: 'yyyy-MM-dd'),
      selectedTime: todoResponse?['todo_time']
          .toString()
          .toTimeOfDay(inputFormat: 'HH:mm'),
      vehicles: vehicleResponse,
      persons: resources,
      locations: locationResponse,
      vendors: vendorResponse,
      partServices: partsResponse,
      supplies: suppliesResponse,
      selectedTaskPersons: selectedUser,
      resources: resources,
      selectedLinkOption: linkSelection.first,
      selectedResource: selectedIds,
      isPartServiceEnable: (todoResponse?['parts'] as List).isNotEmpty,
      isSuppliesEnable: (todoResponse?['supplies'] as List).isNotEmpty,
      selectedParts: partList,
      selectedSupplies: suppliesList,
      title: todoResponse?['title'] ?? '',
      selectedVehicle: vehicleList.firstOrNull,
      taskHistory: vehicleList,
      showPlatformCheck: showPlatformCheck,
      isSelectedPlatformCheck:
      todoResponse?['platform_check'] == 1 ? true : false,
      isTimeSensitive: todoResponse?['time_sensitive'] == 1 ? true : false,
      todoAttachments: todoImages,
      groupVehicles: groupVehiclesResponse,
      selectedSentiment: selectedSentiments,
      clearDurations: AddToDoConfig.cleanCarDurations,
      selectedEndDate: selectedEndDate,
      selectedStartDate: selectedStartDate,
      notesImages: notesImages,
      mileageImages: mileageImages,
      showOdometer: showOdometer,
      isPop: false,
    ));
    await Future.delayed(
        Durations.extralong4, () => partsBroadcastEvent(partList));
    await Future.delayed(
        Durations.extralong4, () => suppliesBroadcastEvent(suppliesList));
  } catch (e) {
    log("$e", name: "Error In Bloc Value");
    emit(state.copyWith(isLoading: false));
  }
}

  Future<void>_onVLocationEvent(EditToDoVLocationEvent event, Emitter<EditTodoState> emit) async {
  var existing = event.vLocation;
  emit(state.copyWith(selectedVLocations: existing));
  vendorBroadcastEvent(existing);
}

  Future<void>_onShowMoreEvent(EditToDoShowMoreEvent event, Emitter<EditTodoState> emit) async {
  var currentStatus = state.isMoreEnable;
  emit(state.copyWith(isMoreEnable: !currentStatus));
}

  Future<void> _onVPersonEvent(EditToDoVPersonEvent event, Emitter<EditTodoState> emit) async  {
  var existingVPersons =
  List<Map<String, dynamic>>.from(state.selectedVPerson);
  String? type =
  existingVPersons.isNotEmpty ? existingVPersons.first['type'] : null;
  String? newType = List.from(event.vPerson).firstOrNull?['type'];
  if (['person', 'g_vehicles'].contains(newType)) {
    existingVPersons.clear();
  }
  if (type != null && type != newType) {
    existingVPersons.clear();
  }
  existingVPersons.addAll(event.vPerson);
  existingVPersons = existingVPersons.unique((element) => element['id']);
  log(existingVPersons.toString(), name: "existingVPersons");
  emit(state.copyWith(
    selectedVPerson: existingVPersons,
  ));
}

  Future<void> _onTaskEvent(EditToDoTaskEvent event, Emitter<EditTodoState> emit) async  {
  showCleanCar = Str.cleanCarCheckIds.contains(event.selectedTask['id']);
  emit(state.copyWith(
      selectedTask: event.selectedTask, showCleanCar: showCleanCar));
}

  Future<void> _onShowPartsEvent(EditToDoShowPartsEvent event, Emitter<EditTodoState> emit) async   {
  var currentStatus = state.isPartServiceEnable;
  emit(state.copyWith(isPartServiceEnable: !currentStatus));
}

  Future<void> _onShowSuppliesEvent(EditToDoShowSuppliesEvent event, Emitter<EditTodoState> emit) async  {
  var currentStatus = state.isSuppliesEnable;
  emit(state.copyWith(isSuppliesEnable: !currentStatus));
}

  Future<void> _onTaskStatusChangeEvent(TaskStatusChangeEvent event, Emitter<EditTodoState> emit) async   {
    bool? status = event.todoStatus;
    log(status.toString(), name: 'STATUS');
    try {
      if(status==true){
        if ((state.apiResponse['identifier_id'] == 257)) {
          if (odometerController.text.isEmpty || state.apiResponse['mileage']==null) {
            return Toaster.showError("odometer is mandatory");
          } else if (state.apiResponse['mandatory'] == 1) {
            return Toaster.showError(
                "is all maintenance check done is mandatory");
          } else {
            emit(state.copyWith(isLoading: true));
            await apiRepository.completeToDo(todoId, status: status!);
            _insertMaintenanceCheckTask(todoResponse, incrementDays: 30);
            _broadcast.stickyBroadcast("todo_view", value: true);
            emit(state.copyWith(
                todoStatus: !state.todoStatus,
                isLoading: false,
                isPop: true));
          }
        } else {
          var model = state.apiResponse;
          model.putIfAbsent("display", () => {"vins": vinList});
          _broadcast.stickyBroadcast("show_completed_popup", value: model);
          emit(state.copyWith(todoStatus: !state.todoStatus, isPop: true));
        }
      }else{
        emit(state.copyWith(isLoading: true));
        await apiRepository.completeToDo(todoId, status: status!);
        _broadcast.stickyBroadcast("todo_view", value: true);
        emit(state.copyWith(
            todoStatus: !state.todoStatus,
            isLoading: false,
            isPop: true));
      }
    } catch (e) {
      Toaster.showError("$e");
      log(e.toString(), name: 'ERROR');
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onPersonTapEvent(EditToDoPersonTapEvent event, Emitter<EditTodoState> emit) async  {
    var existing = List.from(state.selectedTaskPersons);
    if (event.isSelected) {
      existing.add(event.person);
    } else {
      existing.remove(event.person);
    }
    emit(state.copyWith(selectedTaskPersons: existing));
  }

  Future<void> _onCleanCarDurationEvent(EditToDoCleanCarDuration event, Emitter<EditTodoState> emit) async  {
    emit(state.copyWith(selectedClearDuration: event.cleanCarDuration));}

  Future<void> _onPlatformCheckEvent(EditToDoPlatformCheckEvent event, Emitter<EditTodoState> emit) async   { emit(state.copyWith(
      isSelectedPlatformCheck: !state.isSelectedPlatformCheck));}

  Future<void> _onPartSelectionEvent(EditToDoPartSelectionEvent event, Emitter<EditTodoState> emit) async   {
    var existing = List.from(state.selectedParts);
    if (event.isChecked) {
      if (!existing.contains(event.part)) existing.add(event.part);
    } else {
      if (existing.contains(event.part)) existing.remove(event.part);
      bool isOld = partsIdList.contains(event.part['id'].toString());

      Console.of.log("IS_OLD:	${event.part['id']}");
      if (isOld) {
        var id=List.from(state.apiResponse['parts']).firstWhereOrNull(
                (element) => element['parts_id'].toString() == event.part['id'].toString())?['id'];
        await _deleteParts(id);
        _broadcast.stickyBroadcast("parts_id", value: id);
        TaskerHelper.instance.withoutLoadingRefresh();
      }
    }
    partsBroadcastEvent(existing);
    // FBroadcast.instance().broadcast("Parts",value: existing, persistence: true);
    emit(state.copyWith(selectedParts: existing));
  }

  Future<void> _onSupplySelectionEvent(EditToDoSupplySelectionEvent event, Emitter<EditTodoState> emit) async  {
    var existing = List.from(state.selectedSupplies);
    if (event.isChecked) {
      if (!existing.contains(event.data)) existing.add(event.data);
    } else {
      if (existing.contains(event.data)) existing.remove(event.data);
      bool isOld = suppliesIdList.contains(event.data['id'].toString());
      Console.of.log("IS_OLD:	${event.data['id']}");
      if (isOld) {
        var id = List.from(state.apiResponse['supplies']).firstWhereOrNull(
                (element) =>
            element['supplies_id'].toString() ==
                event.data['id'].toString())?['id'];
        await _deleteSupplies(id);
        _broadcast.stickyBroadcast("supplies_id", value: id);
        // _broadcast.stickyBroadcast("todo_view", value: false);
        TaskerHelper.instance.withoutLoadingRefresh();
      }
    }
    emit(state.copyWith(selectedSupplies: existing));
    suppliesBroadcastEvent(existing);
    // FBroadcast.instance().broadcast("Supplies",value:existing);
  }

  Future<void> _onDoRecurringTypeEvent(EditToDoRecurringTypeEvent event, Emitter<EditTodoState> emit) async {
    emit(state.copyWith(selectedRecurring: event.recurringType));
  }

  Future<void> _onDateChangeEvent(EditToDoDateChangeEvent event, Emitter<EditTodoState> emit) async {
    emit(state.copyWith(selectedDate: event.selectedDate));}

  Future<void> _onStartDateChangeEvent(EditToDoStartDateChangeEvent event, Emitter<EditTodoState> emit) async {
    emit(state.copyWith(selectedStartDate: event.selectedDate));}

  Future<void> _onEndDateChangeEvent(EditToDoEndDateChangeEvent event, Emitter<EditTodoState> emit) async {
    emit(state.copyWith(selectedEndDate: event.selectedDate));}

  Future<void> _onTimeChangeEvent(EditToDoTimeChangeEvent event, Emitter<EditTodoState> emit) async  {
    var time = event.selectedTime;
    var identifierId = state.selectedTask['id'];
    var taskDate = state.selectedDate;
    var notes = notesController.text;
    var currentDate = DateTime.now().toFormat().toDateTime();
    if ((taskDate == currentDate) &&
        (reason
            .toString()
            .isNullOrEmpty /* && event.type.toString().isNullOrEmpty*/)) {
      var selectedTime = Time.fromStr(time.toHMS());
      if (ToDoConfig.dropCheckInCarRental.contains(identifierId) &&
          ((notes.isNotNullOrEmpty) &&
              !(notes.contains("/")))) {
        var currentTime = notes.toDateTime(inputFormat: "hh:mm a")?.time;
        var isBefore =
        selectedTime?.isBefore(currentTime ?? Time.fromMinutes(0));
        var isAfter =
        selectedTime?.isAfter(currentTime ?? Time.fromMinutes(0));
        if (isAfter ?? false) {
          timeChangePopupType = 'drop';
          selectedDate = event.selectedTime;
          emit(state.copyWith(isTimeChange: true));
          await Future.delayed(Durations.short1,
                  () => emit(state.copyWith(isTimeChange: false)));
          return;
        }
        Console.of.log(
            "IS_AFTER:\t$isAfter $selectedTime $currentTime IS_BEFORE:\t$isBefore");
      } else {
        Console.of.log("ELSE PART");
      }
      if (ToDoConfig.pickCheckOutCarRental.contains(identifierId) &&
          ((notes.isNotNullOrEmpty) &&
              !(notes.contains("/")))) {
        var currentTime = notes.toDateTime(inputFormat: "hh:mm a")?.time;
        var isBefore =
        selectedTime?.isBefore(currentTime ?? Time.fromMinutes(0));
        var isAfter =
        selectedTime?.isAfter(currentTime ?? Time.fromMinutes(0));
        if (isBefore ?? false) {
          timeChangePopupType = 'pickup';
          emit(state.copyWith(isTimeChange: true));
          await Future.delayed(Durations.short1,
                  () => emit(state.copyWith(isTimeChange: false)));
          return;
        }
        Console.of.log(
            "IS_AFTER:\t$isAfter $selectedTime $currentTime IS_BEFORE:\t$isBefore");
      } else {
        Console.of.log("ELSE PART");
      }
    }
    emit(state.copyWith(selectedTime: event.selectedTime));
  }

  Future<void> _onTimeChangeReasonEvent(EditTodoTimeChangeReasonEvent event, Emitter<EditTodoState> emit) async  {
    reason = event.reason;
    emit(state.copyWith(selectedDate: selectedDate));
  }

  Future<void> _onTimeSensitiveEvent(EditToDoTimeSensitiveEvent event, Emitter<EditTodoState> emit) async  {
    emit(state.copyWith(isTimeSensitive: !state.isTimeSensitive));}

  Future<void> _onEditAttachmentEvent(EditToDoEditAttachmentEvent event, Emitter<EditTodoState> emit) async   {
    var result = await _pickFiles();
    if (result != null) {
      var existing = List.from(state.todoAttachments);
      var existingPaths = List.from(state.todoAttachments)
          .whereType<File>()
          .map((e) => (e.path))
          .toList();
      for (var element in result) {
        if (!existingPaths.contains(element.path)) existing.add(element);
      }
      emit(state.copyWith(todoAttachments: existing));
    }
  }

  Future<void> _onSelectLinkOptionEvent(EditToDoSelectLinkOptionEvent event, Emitter<EditTodoState> emit) async  {
    emit(state.copyWith(selectedLinkOption: event.linkOption));}

  Future<void> _onSelectSentimentEvent(EditToDoSelectSentimentsEvent event, Emitter<EditTodoState> emit) async  {
    emit(state.copyWith(selectedSentiment: event.selectedSentiments));}

  void _onOpenCustomLinkEvent(EditToDoOpenCustomLinkEvent event, Emitter<EditTodoState> emit)  {
    var url = (state.selectedLinkOption?['label'].toString().isCustomLink ??
        false)
        ? customLinkController.text
        : (state.selectedLinkOption?['label'].toString().isTuroReservation ??
        false)
        ? customLinkController.text.toTuroReserveUrl
        : customLinkController.text.toGetAroundReserveUrl;
    Utils.openURL(url);
  }

  void _onBottomTapEvent(EditToDoBottomTapEvent event, Emitter<EditTodoState> emit)  {
    emit(state.copyWith(selectedBottomTap: event.selectedBottomTap));
  }

  void _onUserSelectionEvent(UserSelectionEvent event, Emitter<EditTodoState> emit)  {
    var existing = List<String>.from(state.selectedResource);
    existing = event.selectedResource ?? [];
    var existingName = List.from(state.resources);
    var list = existingName
        .where((element) => existing.contains(element['id'].toString()))
        .map((e) =>
    [e['first_name'].toString(), e['last_name'].toString()].toInitial)
        .toList();
    emit(state.copyWith(selectedResource: existing, resourceName: list));
  }

  void _onSelectedUsersNameEvent(SelectedUsersNameEvent event, Emitter<EditTodoState> emit)  {
    var existing = List<String>.from(state.resourceName);

    emit(state.copyWith(resourceName: existing));
  }

  void _onAddressSelectionEvent(EditToDoAddressSelectionEvent event, Emitter<EditTodoState> emit) {
    List<Map<String, dynamic>>? existing = List.from(state.addresses);
    if (event.isChecked) {
      Console.of.log(event.data);
      if (!existing.contains(event.data)) existing.add(event.data);
    } else {
      if (existing.contains(event.data)) existing.remove(event.data);
    }
    emit(state.copyWith(addresses: existing));
  }

  void _onSelectTaskHistoryEvent(EditToDoSelectTaskHistoryEvent event, Emitter<EditTodoState> emit)  {
    _broadcast.broadcast("set_vehicle_refresh", value: event.selectTaskHistory);
    emit(state.copyWith(selectedVehicle: event.selectTaskHistory));
  }

  Future<void> _onDeleteVehicleEvent(EditToDoDeleteVehicleEvent event, Emitter<EditTodoState> emit) async {
    try {
      emit(state.copyWith(isLoading: false));

      if(event.data['type']=='vehicles'){
        Console.of.log(event.data, name: "event.data");
        var id = vehicleData.firstWhereOrNull(
                (element) => element['vin'] == event.data?['value']?['vin'])?['id'];
        vinList.removeWhere(
              (element) => event.data?['value']?['vin'].contains(element),
        );
        await apiRepository.deleteTodoVehicle(id: "$id");
      }
      state.selectedVPerson.removeWhere((element) => element['id'] == event.data['id']);
      // await getIt<CommonService>().getActiveVehicles(reset: true);
      // _broadcast.stickyBroadcast("todo_view", value: false);
      TaskerHelper.instance.withoutLoadingRefresh();
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      Toaster.showError("$e");
      log(e.toString(), name: 'ERROR');
      // emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onDeleteTodoEvent(DeleteTodoEvent event, Emitter<EditTodoState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      if (event.isExpenseDelete) {
        await apiRepository.deleteVehicleExpense(event.data['expense_id']);
        var response = await apiRepository.deleteTodo(
            id: event.todoId, reason: event.reason);
        _broadcast.stickyBroadcast("todo_view", value: true);
        if (response?['status'] == 200) Toaster.showSuccess(response?['message']);
      } else if (isRecurring) {
        await apiRepository.deleteRecurringTodo(
          id: "${event.data['recurring_id']}",
          reason: event.reason,
          from: "${state.selectedStartDate.toFormat()}",
          to: "${state.selectedEndDate.toFormat()}",
        );
        _broadcast.stickyBroadcast("todo_view", value: true);
      } else {
        await apiRepository.deleteTodo(id: event.todoId, reason: event.reason);
        _broadcast.stickyBroadcast("todo_view", value: true);
      }
      emit(state.copyWith(isPop: true));
    } catch (e) {
      Toaster.showError("$e");
      log(e.toString(), name: 'ERROR');
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onRemoveImageEvent(RemoveImageEvent event, Emitter<EditTodoState> emit) async  {
    if (event.data == null) return;
    if (event.data is File) {
      // LOCAL SELECTION REMOVE
      state.todoAttachments.remove(event.data);
      todoImages = state.todoAttachments;
      emit(state.copyWith(todoAttachments: todoImages));
      return;
    } else if (event.data is String) {
      try{
        var attachmentId = images
            .where((element) =>
        element['path'].toString().toAttachmentURL ==
            event.data.toString())
            .map((e) => e['id'])
            .firstOrNull;

        var response = await apiRepository.deleteTodoImage(attachmentId);
        if(response != null){
          todoImages.remove(event.data);
          _broadcast.stickyBroadcast("todo_view", value: true);
        }
        emit(state.copyWith(todoAttachments: todoImages));
        return;
      }catch(e){
        Toaster.showError("$e");
        log(e.toString(), name: 'ERROR');
        emit(state.copyWith(isLoading: false));
      }
    }

  }

  Future<void> _onRemoveNotesImageEvent(RemoveNotesImageEvent event, Emitter<EditTodoState> emit)  async {
    try{
      var attachmentId =
          List.from(todoResponse?['todo_note_attachments']).where((element) =>
          element['path'].toString().toAttachmentURL ==
              event.data.toString())
              .map((e) => e['id'])
              .firstOrNull;
      var response = await apiRepository.deleteTodoNoteAttachment(attachmentId);
      if(response != null){
        notesImages.remove(event.data);
        _broadcast.stickyBroadcast("todo_view", value: true);
      }
      emit(state.copyWith(notesImages: notesImages));
      return;
    }catch(e){
      Toaster.showError("$e");
      log(e.toString(), name: 'ERROR');
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onRemoveMileageImageEvent(RemoveMileageImageEvent event, Emitter<EditTodoState> emit)  async {
    try{
      var attachmentId =
          List.from(todoResponse?['todo_mileage_attachments']).where((element) =>
          element['path'].toString().toAttachmentURL ==
              event.data.toString())
              .map((e) => e['id'])
              .firstOrNull;
      var response = await apiRepository.deleteTodoMileageAttachment(attachmentId);
      if(response != null){
        mileageImages.remove(event.data);
        _broadcast.stickyBroadcast("todo_view", value: true);
      }
      emit(state.copyWith(mileageImages: mileageImages));
      return;
    }catch(e){
      Toaster.showError("$e");
      log(e.toString(), name: 'ERROR');
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onSaveEvent(EditToDoSaveEvent event, Emitter<EditTodoState> emit) async {
    if (taskNameController.text.isEmpty) {
      Toaster.showError("Task name is required");
      return;
    }
    var isPlatformRequired =
        Str.platFormCheckIds.contains(state.selectedTask['id']) &&
            departmentId == '7' &&
            !state.isSelectedPlatformCheck;
    if (isPlatformRequired) {
      Toaster.showError("Platform check is required");
      return;
    }

    // if (state.selectedTask['id'] == 257) {
    //   final inputValue = num.tryParse(odometerController.text) ?? 0;
    //   final minMileage = num.tryParse(state.previousOdometer) ?? 0;
    //   if (odometerController.text.isNotEmpty && inputValue < minMileage) {
    //     Toaster.showError(
    //         "Can't enter lower than previous oil change odometer");
    //     return;
    //   }
    // }

    if (Str.oilChangeCheckIds.contains(state.selectedTask['id']) && !event.overrideOilCheck) {
      // TRIGGER OIL CHANGE
      var lastVin = state.selectedVPerson.where((element) => element['type'] == 'vehicles').map((e) => e['value']['vin']).lastOrNull;
      if (lastVin.toString().isNotNullOrEmpty) return await _findOilChangeTaskExist(vin: lastVin);
    }
    // API CALL
    try {
      emit(state.copyWith(isLoading: true));
      var response = await apiRepository.updateToDoApi(
          todoId: "${state.apiResponse['id']}",
          images: state.todoAttachments.whereType<File>().toList(),
          body: _editTodoBody());
      if (response?.isNotEmpty ?? false) {
        Toaster.showSuccess(response?['message']);
        _broadcast.stickyBroadcast("todo_view", value: true);
        emit(state.copyWith(isPop: true));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      Toaster.showError("$e");
      log(e.toString(), name: 'ERROR');
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onCleanCarEvent(EditToDoCleanCarEvent event, Emitter<EditTodoState> emit)  async {
    if (taskNameController.text.isEmpty) {
      Toaster.showError("Task name is required");
      return;
    }
    if (state.selectedTaskPersons.isEmpty) {
      Toaster.showError("Task manager is required");
      return;
    }
    if (state.selectedVPerson.isEmpty ||
        (state.selectedVPerson
            .where((element) =>
            ['vehicles', 'g_vehicles'].contains(element['type']))
            .isEmpty)) {
      Toaster.showError("Vehicle is required");
      return;
    }
    try {
      emit(state.copyWith(isLoading: true));
      var response = await apiRepository.cleanCar(body: _cleanCarBody());
      cleanCarIsActive=false;
      _broadcast.stickyBroadcast("todo_view", value: true);
      if (response != null) {
        Toaster.showSuccess(response['message'] ?? "Success");
      }
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      Toaster.showError("$e");
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _findOilChangeTaskExist({required dynamic vin}) async {
    try {
      emit(state.copyWith(isLoading: true));
      var response = await _getOilChangeTask(vin: vin);
      emit(state.copyWith(isLoading: false));
      var context = CommonHelper.instance.navigatorKey.currentContext;
      if ((response == null) || (response.isEmpty)) return add(EditToDoSaveEvent(overrideOilCheck: true));
      if (context != null) {
        var result = await OilChangeTaskExistDialog.show(context, model: response, isAddNew: false);
        Utils.dismissKeyboard(context);
        if (result == true) {
          emit(state.copyWith(isLoading: true));
          var deleteResponse = await _deleteToDo(todoId: response['id']);
          emit(state.copyWith(isLoading: false));
          if (deleteResponse?['status'] == 200) return add(EditToDoSaveEvent(overrideOilCheck: true));
        }
      }
    } catch (e) {
      Console.of.error("Error", error: e);
      rethrow;
    }
  }

  void _onRefreshEvent(EditToDoRefreshEvent event, Emitter<EditTodoState> emit) async {
    Console.of.log("REFRESH_EVENT_TRIGGERED", name: "ADD_TODO_BLOC");
    // PROCEED API CALL
    try {
      emit(state.copyWith(isLoading: true));

      var partsResponse = await _getPartsList();
      var suppliesResponse = await _getSuppliesList();
      var vehicleResponse = await _getActiveVehicles();
      var vendorResponse = await _getVendorsList();
      var locationResponse = await _getLocationsList();
      var taskResponse = await _getTaskExpenseData();
      var userGroupResponse = await _getGroupPersons();
      var assignedToResponse = await _getResources();
      var resources = assignedToResponse;
      resources.removeWhere((resource) => resource['id'] == 2);
      resources.removeWhere((resource) =>
      ((!Str.reqTaskManagerIds.contains(resource['id'])) &&
          (resource['branch_id'] !=
              Session.of.getInt(Str.branchIdPrefText))) ||
          (resource['deleted_at'] != null));
      emit(state.copyWith(
          isLoading: false,
          tasks: taskResponse,
          vehicles: vehicleResponse,
          persons: resources,
          locations: locationResponse,
          vendors: vendorResponse,
          partServices: partsResponse,
          supplies: suppliesResponse,
          groupVehicles: userGroupResponse,
          resources: resources));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onMeetingTypeEvent(EditToDoMeetingTypeEvent event, Emitter<EditTodoState> emit) {
    try{
      selectedMeetingType = event.meetingType;
      emit(state.copyWith());
    }catch(e){
      Toaster.showError("$e");
    }
  }

  Map<String, String> _editTodoBody() {
    Console.of.log(isRecurring);
    state.selectedVPerson
        .removeWhere((element) => vinList.contains(element['value']['vin']));
    Set existingPartIds = state.apiResponse['parts'].map((e) => e['parts_id']).toSet();
    state.selectedParts.removeWhere((element) => existingPartIds.contains(element['id'].toString()));
    Set existingSuppliesIds = state.apiResponse['supplies'].map((e) => e['supplies_id']).toSet();
    state.selectedSupplies.removeWhere((element) => existingSuppliesIds.contains(element['id'].toString()));
    var title = state.selectedTask['task'] == taskNameController.text
        ? state.selectedTask['task']
        : taskNameController.text;
    var identifierId = state.selectedTask['task'] == taskNameController.text
        ? state.selectedTask['id']
        :'';
    Map<String, String> baseBody = {};
    baseBody['title'] = title;
    baseBody['identifier_id'] = "$identifierId";
    if (isRecurring == false) {
      baseBody['todo_time'] = state.selectedTime.toHMS().toString();
      if (todoResponse?['todo_date'] != dateController.text) {
        baseBody['todo_date'] = dateController.text;
      }
    }
    baseBody['reminder'] =
        state.apiResponse['reminder'] == true ? 'true' : 'false';
    baseBody['notes'] =
        notesController.text.trim().isNullOrEmpty ? "" : notesController.text;
    baseBody['comments'] = commentsController.text.trim().isNullOrEmpty ? "" :commentsController.text;
    baseBody['resolution_notes'] = resolutionNotesController.text;
    baseBody['platform_check'] = state.isSelectedPlatformCheck ? "1" : "0";
    baseBody['time_sensitive'] = state.isTimeSensitive ? '1' : '0';
    baseBody['todo_user_type'] = "0";
    baseBody['mileage'] = odometerController.text;
    baseBody['address'] = "${state.addresses.map((e) => e['id']).toList()}";
    baseBody['custom_link_id'] = "${state.selectedLinkOption?['id'] ?? ""}";
    baseBody['trip_review'] = "${state.selectedSentiment?['name'] ?? ""}";
    baseBody['trip_driven'] = tripDrivenController.text;
    baseBody['time_change_reason'] = reason ?? '';
    baseBody['custom_link'] =
        (state.selectedLinkOption?['id'] == 1) ? customLinkController.text : "";
    baseBody['reference_id'] =
        (state.selectedLinkOption?['id'] != 1) ? customLinkController.text : "";
    if (state.selectedResource.isNotEmpty) {
      if (state.selectedResource.length == 1) {
        baseBody['user_id'] = state.selectedResource.first.toString();
        baseBody['assigned_to'] = state.selectedResource.first;
      } else if (state.selectedResource.length > 1) {
        baseBody['user_group_data'] = "${state.selectedResource}";
        baseBody['assigned_to'] = "${state.selectedResource}";
      }
    }
    baseBody['parts'] =
        "${state.selectedParts.isEmpty ? null : state.selectedParts.map((e) => jsonEncode({
                  "parts_id": "${e['id']}",
                  "parts_name": "${e['name']}",
                })).toList()}";
    baseBody['supplies'] =
        "${state.selectedSupplies.isEmpty ? null : state.selectedSupplies.map((e) => jsonEncode({
                  "supplies_id": "${e['id']}",
                  "supplies_name": "${e['name']}",
                })).toList()}";
    if (state.selectedVLocations.isNotEmpty) {
      if (state.selectedVLocations['type'] == "location") {
        baseBody['location'] = "${state.selectedVLocations['name'] ?? ''}";
        baseBody['location_id'] = "${state.selectedVLocations['id'] ?? ''}";
        baseBody['vendor_name'] = "";
        baseBody['vendor_id'] = "";
      }
      if (state.selectedVLocations['type'] == "vendor") {
        baseBody['vendor_name'] = "${state.selectedVLocations['name'] ?? ''}";
        baseBody['vendor_id'] = "${state.selectedVLocations['id'] ?? ''}";
        baseBody['location'] = "";
        baseBody['location_id'] = "";
      }
    }
    baseBody['vehicles'] =
        "${state.selectedVPerson.where((element) => element['type'] == "vehicles").map((e) => e['value']).map((e) => jsonEncode({
                  "cohort_id": "${e['cohort']?['id'] ?? ""}",
                  "cohort_name": "${e['cohort']?['cohort'] ?? ""}",
                  "vin": e['vin'],
                  "vehicle_name": e['vehicle_name'],
                  "vehicle_image": (e['images'] as List?)?.firstOrNull?['path'],
                  "vehicle_number": e['vehicle_number']
                })).toList()}";
    var personList = state.selectedVPerson
        .where((element) => element['type'] == "person")
        .toList();

    var firstPerson = personList.isNotEmpty ? personList.first : null;

    baseBody['person'] = firstPerson?['name']?.toString() ?? "";
    baseBody['person_id'] = firstPerson?['id']?.toString() ?? "";
    baseBody['rental_enquiry'] = QuillDeltaToHtmlConverter(
      (quillController).document.toDelta().toJson(),
      ConverterOptions.forEmail(),).convert();
    baseBody['meeting_mode'] = selectedMeetingType?['name'] ?? '';
    baseBody['type'] = "inline";

    var groupVehicleList = state.selectedVPerson
        .where((element) => element['type'] == "g_vehicles")
        .toList();

    var groupVehicleId =
        groupVehicleList.isNotEmpty ? groupVehicleList.first : null;

    baseBody['vehicle_group_id'] = groupVehicleId?['id']?.toString() ?? "";
    if ((isRecurring == true) &&
        (state.selectedStartDate != null && state.selectedEndDate != null)) {
      baseBody['from_date'] = state.selectedStartDate.toFormat() ?? '';
      baseBody['to_date'] = state.selectedEndDate.toFormat() ?? '';
    }
    log(jsonEncode(baseBody), name: "EDIT_TODO_BODY");
    return baseBody;
  }

  Map<String, String> _cleanCarBody() {
    var isAdd = state.selectedTask['id'] == 210;
    var date = state.selectedDate ?? DateTime.now();
    var timeAt = state.selectedTime.toDateTime;
    var timeDay = state.selectedTime;
    if (timeAt != null) {
      date =
          DateTime(date.year, date.month, date.day, timeAt.hour, timeAt.minute);
      if (isAdd) {
        timeAt =
            date.add(Duration(minutes: state.selectedClearDuration?['value']));
      } else {
        timeAt = date
            .subtract(Duration(minutes: state.selectedClearDuration?['value']));
      }
      timeDay = TimeOfDay.fromDateTime(timeAt);
    }
    Map<String, String> baseBody = {};
    baseBody['title'] = "Clean Car";
    baseBody['identifier_id'] = "30";
    if (state.selectedVLocations.isNotEmpty) {
      if (state.selectedVLocations['type'] == "location") {
        baseBody['location'] = "${state.selectedVLocations['name'] ?? ''}";
        baseBody['location_id'] = "${state.selectedVLocations['id'] ?? ''}";
        baseBody['vendor_name'] = "";
        baseBody['vendor_id'] = "";
      }
      if (state.selectedVLocations['type'] == "vendor") {
        baseBody['vendor'] = "${state.selectedVLocations['name'] ?? ''}";
        baseBody['vendor_id'] = "${state.selectedVLocations['id'] ?? ''}";
        baseBody['location'] = "";
        baseBody['location_id'] = "";
      }
    }
    baseBody['cohort_id'] = "";
    baseBody['cohort_name'] = "";
    baseBody['vin'] = "";
    baseBody['vehicle_name'] = "";
    baseBody['vehicle_image'] = "";
    baseBody['vehicle_name'] = "";
    baseBody['vehicles'] =
        "${state.selectedVPerson.where((element) => element['type'] == "vehicles").map((e) => e['value']).map((e) => jsonEncode({
                  "cohort_id": "${e['cohort']?['id'] ?? ""}",
                  "cohort_name": "${e['cohort']?['cohort'] ?? ""}",
                  "vin": e['vin'],
                  "vehicle_name": e['vehicle_name'],
                  "vehicle_image": (e['images'] as List?)?.firstOrNull?['path'],
                  "vehicle_number": e['vehicle_number']
                })).toList()}";
    baseBody['parts'] =
        "${state.selectedParts.isEmpty ? null : state.selectedParts.map((e) => jsonEncode({
                  "parts_id": "${e['id']}",
                  "parts_name": "${e['name']}",
                })).toList()}";

    baseBody['supplies'] =
        "${state.selectedSupplies.isEmpty ? null : state.selectedSupplies.map((e) => jsonEncode({
                  "supplies_id": "${e['id']}",
                  "supplies_name": "${e['name']}",
                })).toList()}";

    baseBody['todo_time'] = "${timeDay.toHMS()}";
    baseBody['start_at'] = "${date.toFormat(format: "yyyy-MM-dd")}";
    baseBody['notes'] =
        notesController.text.trim().isNullOrEmpty ? "" : notesController.text;
    baseBody['time_sensitive'] = state.isTimeSensitive ? '1' : '0';
    baseBody['todo_user_type'] = "0";
    baseBody['mileage'] = odometerController.text;
    baseBody['resolution_notes'] = "";
    baseBody['address'] = "${state.addresses.map((e) => e['id']).toList()}";
    if (state.selectedResource.isNotEmpty) {
      if (state.selectedResource.length == 1) {
        baseBody['user_id'] = state.selectedResource.first.toString();
        baseBody['assigned_to'] = state.selectedResource.first;
      } else if (state.selectedResource.length > 1) {
        baseBody['user_group_data'] = "${state.selectedResource}";
        baseBody['assigned_to'] = "${state.selectedResource}";
      }
    }
    var groupVehicleList = state.selectedVPerson
        .where((element) => element['type'] == "g_vehicles")
        .toList();
    var groupVehicleId =
        groupVehicleList.isNotEmpty ? groupVehicleList.first : null;
    baseBody['vehicle_group_id'] = groupVehicleId?['id']?.toString() ?? "";
    baseBody['reason'] = '';
    baseBody['branch_id'] = "${branchId ?? ""}";
    log(jsonEncode(baseBody), name: "CLEAN_CAR_JSON_BODY");
    return baseBody;
  }

  void partsBroadcastEvent(dynamic value,) {
    // log(value.toString(), name: "Parts Broadcast");
    FBroadcast.instance().broadcast("Parts", value: value, persistence: true);
  }

  void suppliesBroadcastEvent(dynamic value,) {
    FBroadcast.instance()
        .broadcast("Supplies", value: value, persistence: true);
  }

  void vendorBroadcastEvent(dynamic value,) {
    log(value.toString(), name: "Parts Broadcast");
    FBroadcast.instance().broadcast("Vendor", value: value, persistence: true);
  }

  Future<List<File>?> _pickFiles() async {
    var result = await ImagePicker().pickMultiImage();
    return result.map((e) => File(e.path)).toList();
  }

  var tabs = List.from(AddToDoConfig.editTodoBottomTaps);

  List<Map<String, dynamic>> get location => getIt<CommonService>().locationsList;

  List<Map<String, dynamic>> get tasks => getIt<CommonService>().taskExpenseDataList;

  List<Map<String, dynamic>> get vehicles => getIt<CommonService>().activeVehicleList.where((element) => element['branch_code'] == branchId).toList();

  List<Map<String, dynamic>> get vendor => getIt<CommonService>().vendorsList;

  List<Map<String, dynamic>> get groupVehicleList => getIt<CommonService>().groupVehicleList;

  List<Map<String, dynamic>> get partsList => getIt<CommonService>().partsList;

  List<Map<String, dynamic>> get suppliesLists => getIt<CommonService>().suppliesList;

  List<Map<String, dynamic>> get persons {
    List<Map<String, dynamic>> resources = List.from(getIt<CommonService>().resourcesList);
    resources.removeWhere((resource) =>
    ((!Str.reqTaskManagerIds.contains(resource['id'])) &&
        (resource['branch_id'] !=
            Session.of.getInt(Str.branchIdPrefText))) ||
        (resource['deleted_at'] != null));
    Console.of.log("FETCHING_RESOURCE_FROM_GET");
    return resources;
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

  Future<Map<String, dynamic>?> _addToDo({required Map<String, dynamic> body}) async => await apiRepository.addToDo(body: body);

  Future<Map<String, dynamic>?> _deleteParts(dynamic id) async => await apiRepository.deleteVehicleParts(id: id);

  Future<Map<String, dynamic>?> _deleteSupplies(dynamic id) async => await apiRepository.deleteSupplies(id: id);

  Future<Map<String, dynamic>?> _getOilChangeTask({required dynamic vin}) async => await getIt<CommonService>().getLatestOilChangeTask(vin: vin, dateTime: state.selectedDate ?? DateTime.now(), id: state.apiResponse['id']);

  Future<Map<String, dynamic>?> _deleteToDo({dynamic todoId}) async => await apiRepository.deleteTodo(id: todoId, reason: "");

}


