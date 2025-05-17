import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:date_time/date_time.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/tasker/helper/tasker_helper.dart';
import 'package:fairpytasker/core/app/config/todo_config.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/timeday_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/custom_search_data_converter.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../Utilities/str.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/prefs.dart';
import '../../../../core/app/helper/toaster.dart';
import '../../add_todo/add_todo_const.dart';
import 'edit_todo_event.dart';
import 'edit_todo_state.dart';

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

  Map<String, dynamic> selectionTaps = {};

  dynamic selectedSentiments = {};
  dynamic previousOdometer = {};
  dynamic selectedDate;

  Map<String, dynamic>? todoResponse = {};

  bool showCleanCar = false;
  bool cleanCarIsActive = false;

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  DateTime? recurringStartDate;

  @override
  Future<void> close() {
    _broadcast.unregister(Str.editToDoRefresh);
    return super.close();
  }

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
    isRecurring: false,
    isTimeChange: false,
    notesImages: const [],
    mileageImages: const [],
  )) {
    _broadcast.register(Str.addToDoRefresh, (value, callback) => add(EditToDoRefreshEvent()));
    on<EditToDoRefreshEvent>(_onRefreshEvent);

    on<GetEditTodoInitialEvent>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        todoResponse = await apiRepository.editToDo(event.todoId);
        var partsResponse = await getIt<CommonService>().getPartsList();
        var suppliesResponse = await getIt<CommonService>().getSuppliesList();
        var vehicleResponse = await getIt<CommonService>().getActiveVehicles();
        var vendorResponse = await getIt<CommonService>().getVendorsList();
        var locationResponse = await getIt<CommonService>().getLocationsList();
        var taskResponse = await getIt<CommonService>().getTaskExpenseData();
        var userGroupResponse = await getIt<CommonService>().getGroupPersons();
        var assignedToResponse = await getIt<CommonService>().getResources();
        var groupVehiclesResponse = await getIt<CommonService>().groupVehicles();
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
              var decodedList = json.decode(group['userId'] ?? '[]');
              if (decodedList is List) {
                selectedIds = decodedList.map((e) => e.toString()).toList();
              } else {
                selectedIds = [];
              }
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
          if (todoResponse?['identifier_id'] == 219) {"id": 3, "title": "Check List"},
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
              (todoResponse?['identifier_id'] == 219 && e['title'] == "Check List") ||
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
          previousOdometer = await _getPreviousOdometer(
              date: todoResponse?['todo_date'],
              vin: List.from(vinList).firstOrNull ?? '',
              identifierId: todoResponse?['identifier_id']);
        }
        showCleanCar = Str.cleanCarCheckIds.contains(todoResponse?['identifier_id']);
        RegExp dateRegExp = RegExp(r'\d{2}-\d{2}-\d{4}');
        if(todoResponse?['recurring'] != null && todoResponse?['recurring_last_date'] != null){
          final matches = dateRegExp.allMatches(todoResponse?['recurring']??[]).toList();
          if (matches.isNotEmpty) {
            String startDate = matches[0].group(0)!;
            DateTime parsedStart = DateFormat('MM-dd-yyyy').parse(startDate);
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

        emit(state.copyWith(
          isLoading: false,
          showCleanCar: showCleanCar,
          bottomTapData: tabs,
          resourceName: list,
          apiResponse: todoResponse,
          previousOdometer: "${previousOdometer?['data'] ?? ''}",
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
    });

    on<EditToDoVLocationEvent>((event, emit) {
      var existing = event.vLocation;
      emit(state.copyWith(selectedVLocations: existing));
      vendorBroadcastEvent(existing);
      // FBroadcast.instance().broadcast("Vendor",value:existing);
    });

    on<EditToDoShowMoreEvent>((event, emit) {
      var currentStatus = state.isMoreEnable;
      emit(state.copyWith(isMoreEnable: !currentStatus));
    });

    on<EditToDoTaskEvent>((event, emit) {
      showCleanCar = Str.cleanCarCheckIds.contains(event.selectedTask['id']);
      emit(state.copyWith(
          selectedTask: event.selectedTask, showCleanCar: showCleanCar));
    });

    on<EditToDoVPersonEvent>((event, emit) {
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
    });

    on<EditToDoShowPartsEvent>((event, emit) {
      var currentStatus = state.isPartServiceEnable;
      emit(state.copyWith(isPartServiceEnable: !currentStatus));
    });

    on<EditToDoShowSuppliesEvent>((event, emit) {
      var currentStatus = state.isSuppliesEnable;
      emit(state.copyWith(isSuppliesEnable: !currentStatus));
    });

    on<TaskStatusChangeEvent>((event, emit) async {
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
    });

    on<EditToDoPersonTapEvent>((event, emit) {
      var existing = List.from(state.selectedTaskPersons);
      if (event.isSelected) {
        existing.add(event.person);
      } else {
        existing.remove(event.person);
      }
      emit(state.copyWith(selectedTaskPersons: existing));
    });

    on<EditToDoCleanCarDuration>((event, emit) =>
        emit(state.copyWith(selectedClearDuration: event.cleanCarDuration)));

    on<EditToDoPlatformCheckEvent>((event, emit) => emit(state.copyWith(
        isSelectedPlatformCheck: !state.isSelectedPlatformCheck)));

    on<EditToDoPartSelectionEvent>((event, emit) async {
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
          // _broadcast.stickyBroadcast("todo_view", value: false);
          TaskerHelper.instance.withoutLoadingRefresh();
        }
      }
      partsBroadcastEvent(existing);
      // FBroadcast.instance().broadcast("Parts",value: existing, persistence: true);
      emit(state.copyWith(selectedParts: existing));
    });

    on<EditToDoSupplySelectionEvent>((event, emit) async {
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
          // _broadcast.stickyBroadcast("todo_view", value: false);
          TaskerHelper.instance.withoutLoadingRefresh();
        }
      }
      emit(state.copyWith(selectedSupplies: existing));
      suppliesBroadcastEvent(existing);
      // FBroadcast.instance().broadcast("Supplies",value:existing);
    });

    on<EditToDoRecurringTypeEvent>((event, emit) =>
        emit(state.copyWith(selectedRecurring: event.recurringType)));

    on<EditToDoDateChangeEvent>((event, emit) =>
        emit(state.copyWith(selectedDate: event.selectedDate)));

    on<EditToDoStartDateChangeEvent>((event, emit) =>
        emit(state.copyWith(selectedStartDate: event.selectedDate)));

    on<EditToDoEndDateChangeEvent>((event, emit) =>
        emit(state.copyWith(selectedEndDate: event.selectedDate)));

    on<EditToDoTimeChangeEvent>((event, emit) async {
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
    });

    on<EditTodoTimeChangeReasonEvent>((event, emit) {
      reason = event.reason;
      emit(state.copyWith(selectedDate: selectedDate));
    });

    on<EditToDoTimeSensitiveEvent>((event, emit) =>
        emit(state.copyWith(isTimeSensitive: !state.isTimeSensitive)));

    on<EditToDoEditAttachmentEvent>((event, emit) async {
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
    });

    on<EditToDoSelectLinkOptionEvent>((event, emit) =>
        emit(state.copyWith(selectedLinkOption: event.linkOption)));

    on<EditToDoSelectSentimentsEvent>((event, emit) =>
        emit(state.copyWith(selectedSentiment: event.selectedSentiments)));

    on<EditToDoOpenCustomLinkEvent>((event, emit) {
      var url = (state.selectedLinkOption?['label'].toString().isCustomLink ??
              false)
          ? customLinkController.text
          : (state.selectedLinkOption?['label'].toString().isTuroReservation ??
                  false)
              ? customLinkController.text.toTuroReserveUrl
              : customLinkController.text.toGetAroundReserveUrl;
      Utils.openURL(url);
    });

    on<EditToDoBottomTapEvent>((event, emit) {
      emit(state.copyWith(selectedBottomTap: event.selectedBottomTap));
    });

    on<UserSelectionEvent>((event, emit) {
      var existing = List<String>.from(state.selectedResource);
      existing = event.selectedResource ?? [];
      var existingName = List.from(state.resources);
      var list = existingName
          .where((element) => existing.contains(element['id'].toString()))
          .map((e) =>
              [e['first_name'].toString(), e['last_name'].toString()].toInitial)
          .toList();
      emit(state.copyWith(selectedResource: existing, resourceName: list));
    });

    on<SelectedUsersNameEvent>((event, emit) {
      var existing = List<String>.from(state.resourceName);

      emit(state.copyWith(resourceName: existing));
    });

    on<EditToDoAddressSelectionEvent>((event, emit) {
      List<Map<String, dynamic>>? existing = List.from(state.addresses);
      if (event.isChecked) {
        Console.of.log(event.data);
        if (!existing.contains(event.data)) existing.add(event.data);
      } else {
        if (existing.contains(event.data)) existing.remove(event.data);
      }
      emit(state.copyWith(addresses: existing));
    });

    on<EditToDoSelectTaskHistoryEvent>((event, emit) {
      _broadcast.broadcast("set_vehicle_refresh", value: event.selectTaskHistory);
      emit(state.copyWith(selectedVehicle: event.selectTaskHistory));
    });

    on<EditToDoDeleteVehicleEvent>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: false));
        var id = vehicleData.firstWhereOrNull(
            (element) => element['vin'] == event.vehicleId)?['id'];
        vinList.removeWhere(
          (element) => event.vehicleId.contains(element),
        );
        await apiRepository.deleteTodoVehicle(id: "$id");
        // await getIt<CommonService>().getActiveVehicles(reset: true);
        // _broadcast.stickyBroadcast("todo_view", value: false);
        TaskerHelper.instance.withoutLoadingRefresh();
        emit(state.copyWith(isLoading: false));
      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(), name: 'ERROR');
        // emit(state.copyWith(isLoading: false));
      }
    });

    on<DeleteTodoEvent>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        if (event.isExpenseDelete) {
          await apiRepository.deleteVehicleExpense(event.data['expense_id']);
          var response = await apiRepository.deleteTodo(
              id: event.todoId, reason: event.reason);
          _broadcast.stickyBroadcast("todo_view", value: true);
          if (response?['status'] == 200) {
            Toaster.showSuccess(response?['message']);
          }
        } else if (event.isRecurring) {
          await apiRepository.deleteRecurringTodo(
            id: event.data['recurring_id'],
            reason: state.selectedEndDate.toFormat(),
            from: event.reason,
            to: state.selectedStartDate.toFormat(),
          );
          _broadcast.stickyBroadcast("todo_view", value: true);
        } else {
          await apiRepository.deleteTodo(id: event.todoId, reason: event.reason);
          _broadcast.stickyBroadcast("todo_view", value: true);
        }
        emit(state.copyWith(isLoading: false, isPop: true));
      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(), name: 'ERROR');
        emit(state.copyWith(isLoading: false));
      }
    });

    on<RemoveImageEvent>((event, emit) async {
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

    });

    on<RemoveNotesImageEvent>((event, emit) async {
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
    });

    on<RemoveMileageImageEvent>((event, emit) async {
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
    });

    on<EditToDoSaveEvent>((event, emit) async {
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
      if (state.selectedTask['id'] == 257) {
        final inputValue = num.tryParse(odometerController.text) ?? 0;
        final minMileage = num.tryParse(state.previousOdometer) ?? 0;
        if (odometerController.text.isNotEmpty && inputValue < minMileage) {
          Toaster.showError(
              "Can't enter lower than previous oil change odometer");
          return;
        }
      }
      // API CALL
      try {
        emit(state.copyWith(isLoading: true, isRecurring: event.isRecurring));
        var response = await apiRepository.updateToDoApi(
            todoId: "${state.apiResponse['id']}",
            images: state.todoAttachments.whereType<File>().toList(),
            body: _editTodoBody());
        if (response?.isNotEmpty ?? false) {
          Toaster.showSuccess(response?['message']);
          _broadcast.stickyBroadcast("todo_view", value: true);
          emit(state.copyWith(isPop: true, isRecurring: false));
        } else {
          emit(state.copyWith(isLoading: false));
        }
      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(), name: 'ERROR');
        emit(state.copyWith(isLoading: false));
      }
    });

    on<EditToDoCleanCarEvent>((event, emit) async {
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
    });
  }

  Map<String, String> _editTodoBody() {
    Console.of.log(state.isRecurring);
    state.selectedVPerson
        .removeWhere((element) => vinList.contains(element['value']['vin']));
    var title = state.selectedTask['task'] == taskNameController.text
        ? state.selectedTask['task']
        : taskNameController.text;
    var identifierId = state.selectedTask['task'] == taskNameController.text
        ? state.selectedTask['id']
        :'';
    Map<String, String> baseBody = {};
    baseBody['title'] = title;
    baseBody['identifier_id'] = "$identifierId";
    if (state.isRecurring == false) {
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
    baseBody['type'] = "inline";

    var groupVehicleList = state.selectedVPerson
        .where((element) => element['type'] == "g_vehicles")
        .toList();

    var groupVehicleId =
        groupVehicleList.isNotEmpty ? groupVehicleList.first : null;

    baseBody['vehicle_group_id'] = groupVehicleId?['id']?.toString() ?? "";
    if ((state.isRecurring == true) &&
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

  void partsBroadcastEvent(
    dynamic value,
  ) {
    // log(value.toString(), name: "Parts Broadcast");
    FBroadcast.instance().broadcast("Parts", value: value, persistence: true);
  }

  void suppliesBroadcastEvent(
    dynamic value,
  ) {
    FBroadcast.instance()
        .broadcast("Supplies", value: value, persistence: true);
  }

  void vendorBroadcastEvent(
    dynamic value,
  ) {
    log(value.toString(), name: "Parts Broadcast");
    FBroadcast.instance().broadcast("Vendor", value: value, persistence: true);
  }

  // PICK MULTI IMAGES / FILES
  Future<List<File>?> _pickFiles() async {
    var result = await ImagePicker().pickMultiImage();
    return result.map((e) => File(e.path)).toList();
  }

  Future<Map<String, dynamic>?> _getPreviousOdometer(
          {required String date,
          required String vin,
          required dynamic identifierId}) async =>
      await apiRepository.getPreviousOdometer(
          date: date, vin: vin, identifierId: identifierId);

  var tabs = List.from(AddToDoConfig.editTodoBottomTaps);

  void _onRefreshEvent(EditToDoRefreshEvent event, Emitter<EditTodoState> emit) async {
    Console.of.log("REFRESH_EVENT_TRIGGERED", name: "ADD_TODO_BLOC");
    // PROCEED API CALL
    try {
      emit(state.copyWith(isLoading: true));

      var partsResponse = await getIt<CommonService>().getPartsList();
      var suppliesResponse = await getIt<CommonService>().getSuppliesList();
      var vehicleResponse = await getIt<CommonService>().getActiveVehicles();
      var vendorResponse = await getIt<CommonService>().getVendorsList();
      var locationResponse = await getIt<CommonService>().getLocationsList();
      var taskResponse = await getIt<CommonService>().getTaskExpenseData();
      var userGroupResponse = await getIt<CommonService>().getGroupPersons();
      var assignedToResponse = await getIt<CommonService>().getResources();
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

  List<Map<String, dynamic>> get location => getIt<CommonService>().locationsList;
  List<Map<String, dynamic>> get tasks => getIt<CommonService>().taskExpenseDataList;
  List<Map<String, dynamic>> get vehicles => getIt<CommonService>().activeVehicleList.where((element) => element['branch_code'] == branchId).toList();
  List<Map<String, dynamic>> get vendor => getIt<CommonService>().vendorsList;
  List<Map<String, dynamic>> get groupVehicleList => getIt<CommonService>().groupVehicleList;

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

}


