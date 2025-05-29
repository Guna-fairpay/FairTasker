import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_const.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_events.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_state.dart';
import 'package:fairpytasker/UI/dialog/oil_change_exist_dialog.dart';
import 'package:fairpytasker/UI/tasker/helper/tasker_helper.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/timeday_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/custom_search_data_converter.dart';
import 'package:fairpytasker/core/app/helper/helper.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fairpytasker/core/initializer/todo_supporter.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddToDoBloc extends Bloc<AddToDoEvent, AddToDoState> {
  final APiRepository _apiRepository = APiRepository();

  final TextEditingController taskIdentifierController = TextEditingController();
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController vPersonController = TextEditingController();
  final TextEditingController vLocationController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController customLinkController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController recurringEveryDayWeekController = TextEditingController();
  final TextEditingController recurringMonthDateController = TextEditingController();
  final TextEditingController recurringMonthMonthController = TextEditingController();
  final TextEditingController recurringYearDateController = TextEditingController();
  final TextEditingController recurringNoOccurrenceController = TextEditingController();
  final TextEditingController recurringEndDateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController partsController = TextEditingController();
  final TextEditingController suppliesController = TextEditingController();

  final FBroadcast _broadcast = FBroadcast.instance();

  String? get currentUserId => Session.of.getString(Str.userIdPrefText);

  int? get branchId => Session.of.getInt(Str.branchIdPrefText);

  String? departmentId; // LoggedIn User department ID

  List<Map<String, dynamic>> vendorLocations = [];

  Map<String, dynamic>? selectedVLocation;

  List<Map<String, dynamic>> _locations = [];
  List<Map<String, dynamic>> _persons = [];
  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, dynamic>> _vehicles = [];

  /// SELECTED AND STORING VARIABLES
  List<dynamic> attachments = [];

  late DateTime addToDoDate;
  dynamic existingRefId;

  bool isNextTask = false;

  String? get taskName {
    var selectedTask = state.selectedTaskIdentifier[1];
    if ( (selectedTask != null) && ((selectedTask as Map?)?.isNotEmpty ?? false)) {
      return selectedTask?['name'];
    } else {
      return null;
    }
  }

  List<Map<String, dynamic>> get locations => getIt<CommonService>().locationsList;
  List<Map<String, dynamic>> get persons {
    List<Map<String, dynamic>> resources = List.from(getIt<CommonService>().resourcesList);
    resources.removeWhere((resource) =>
    ((!Str.reqTaskManagerIds.contains(resource['id'])) &&
        (resource['branch_id'] !=
            Session.of.getInt(Str.branchIdPrefText))) ||
        (resource['deleted_at'] != null));
    return resources;
  }
  List<Map<String, dynamic>> get tasks => getIt<CommonService>().taskExpenseDataList;
  List<Map<String, dynamic>> get vehicles => getIt<CommonService>().activeVehicleList.where((element) => element['branch_code'] == branchId).toList();
  List<Map<String, dynamic>> get vendors => getIt<CommonService>().vendorsList;
  List<Map<String, dynamic>> get groupVehicleList => getIt<CommonService>().groupVehicleList;
  List<Map<String, dynamic>> get partsList => getIt<CommonService>().partsList;
  List<Map<String, dynamic>> get suppliesList => getIt<CommonService>().suppliesList;
  Color reservationColor = AppC.appColor;

  @override
  Future<void> close() {
    _broadcast.unregister(Str.addToDoRefresh);
    return super.close();
  }
  AddToDoBloc() : super(AddToDoState(
            showAppBar: true,
            isLoading: false,
            redirect: false,
            isTimeSensitive: false,
            tasks: const [],
            vehicles: const [],
            persons: const [],
            vendors: const [],
            locations: const [],
            partServices: const [],
            supplies: const [],
            resources: const [],
            groupVehicles: const [],
            selectedTaskPersons: const [],
            selectedVPerson: const [],
            selectedParts: const [],
            selectedSupplies: const [],
            attachments: const [],
            addresses: const [],
            selectedRecurringDays: const [],
            selectedTaskIdentifier: const {},
            recurringTypes: AddToDoConfig.recurringOptions,
            clearDurations: AddToDoConfig.cleanCarDurations,
            linkOptions: AddToDoConfig.customOptions,
            isSelectedPlatformCheck: false,
            showPlatformCheck: false,
            isMoreEnable: false,
            isPartServiceEnable: false,
            isSuppliesEnable: false,
            showCleanCar: false,
            isRecurringEndDate: true,
            isRecurringMonthOccurrence: true,
            showCleanTaskReassign: false,
            recleanModel: const {},
            isSaveEvent: false,
            recurringYearlySelectedMonth: AddToDoConfig.months.first,
            selectedLinkOption: AddToDoConfig.customOptions.first,
            selectedClearDuration: AddToDoConfig.cleanCarDurations.first,
            selectedRecurring: AddToDoConfig.recurringOptions.first,
            selectedDate: DateTime.now(),
            selectedTime: TimeOfDay.now())) {
    _broadcast.register(Str.addToDoRefresh, (value, callback) => add(AddToDoRefreshEvent()));
    on<AddToDoSaveEvent>(_onSaveEvent);
    on<AddToDoCleanCarEvent>(_onCleanEvent);
    on<AddToDoVPersonEvent>(_onVPersonEvent);
    on<AddToDoRefreshEvent>(_onRefreshEvent);
    on<AddToDoInitialEvent>(_onInitialEvent);
    on<AddToDoReassignEvent>(_onReassignEvent);
    on<AddToDoShowMoreEvent>(_onShowMoreEvent);
    on<AddToDoShowPartsEvent>(_onShowPartsEvent);
    on<AddToDoVLocationEvent>(_onVLocationEvent);
    on<AddToDoPersonTapEvent>(_onPersonTapEvent);
    on<AddToDoDateChangeEvent>(_onDateChangeEvent);
    on<AddToDoTimeChangeEvent>(_onTimeChangeEvent);
    on<AddToDoCleanCarDuration>(_onCleanCarDuration);
    on<AddToDoShowSuppliesEvent>(_onShowSuppliesEvent);
    on<AddToDoPlatformCheckEvent>(_onPlatformCheckEvent);
    on<AddToDoPartSelectionEvent>(_onPartSelectionEvent);
    on<AddToDoTimeSensitiveEvent>(_onTimeSensitiveEvent);
    on<AddToDoAddAttachmentEvent>(_onAddAttachmentEvent);
    on<AddToDoDeleteAttachment>(_onDeleteAttachmentEvent);
    on<AddToDoRecurringTypeEvent>(_onDoRecurringTypeEvent);
    on<AddToDoOpenCustomLinkEvent>(_onOpenCustomLinkEvent);
    on<AddToDoSupplySelectionEvent>(_onSupplySelectionEvent);
    on<AddToDoSelectLinkOptionEvent>(_onSelectLinkOptionEvent);
    on<AddToDoAddressSelectionEvent>(_onAddressSelectionEvent);
    on<AddToDoRecurringEndDateEvent>(_onRecurringEndDateEvent);
    on<AddToDoRecurringWeekDaysEvent>(_onRecurringWeekDaysEvent);
    on<AddToDoSelectedTaskIdentifierEvent>(_onSelectedTaskIdentifier);
    on<AddToDoRecurringMonthOccurrenceEvent>(_onMonthOccurrenceEvent);
    on<AddToDoRecurringEndDateSelectionEvent>(_onRecurringEndDateSelectionEvent);
    on<AddToDoRecurringYearlySelectedMonthEvent>(_onRecurringYearlySelectedMonthEvent);
  }

  Future<void> _findOilChangeTaskExist({required dynamic vin}) async {
    try {
      emit(state.copyWith(isLoading: true));
      var response = await _getOilChangeTask(vin: vin);
      emit(state.copyWith(isLoading: false));
      var context = CommonHelper.instance.navigatorKey.currentContext;
      if (context != null) {
        var result = await OilChangeTaskExistDialog.show(context, model: response);
        Utils.dismissKeyboard(context);
        if (result == true) {
          emit(state.copyWith(isLoading: true));
          var deleteResponse = await _deleteToDo(todoId: response?['id']);
          emit(state.copyWith(isLoading: false));
          if (deleteResponse?['status'] == 200) return add(AddToDoSaveEvent(oilChangeOverride: true));
        }
      }
    } catch (e) {
      Console.of.error("Error", error: e);
      rethrow;
    }
  }

  Future<void> _findReservationColor(String? vin) async {
    if (vin == null) return;
    var response = await getIt<CommonService>().findVehicleReservation(vin: vin);
    Console.of.log("${response?['identifier_id']}", name: "AddToDoBloc");
    existingRefId = response?['reference_id'] ?? "";
    Console.of.debug("ReferenceId: $existingRefId");
    if (existingRefId.toString().isNotNullOrEmpty) customLinkController.text = "${existingRefId ?? ""}";
    reservationColor = Str.red.contains(response?['identifier_id'])
        ?AppC.redAccent
        :Str.green.contains(response?['identifier_id'])
        ?AppC.green
        :AppC.appColor;
    }

  Map<String, String> _addTodoBody() {
    var baseBody = _cleanCarBody();
    baseBody['title'] = taskNameController.text;
    baseBody['identifier_id'] = ((taskNameController.text.isNotEmpty) &&
            (state.selectedTaskIdentifier[1]?['name'] ==
                taskNameController.text))
        ? "${state.selectedTaskIdentifier[1]?['id'] ?? ""}"
        : "";
    baseBody['repeatPeriod'] =
        ((state.selectedRecurring?['label'].toString().isDoesNotRepeat == false)
                ? (state.selectedRecurring?['label'].toString().toLowerCase())
                : "") ??
            '';
    baseBody['repeatDay'] =
        (state.selectedRecurring?['label'].toString().isDaily ?? false)
            ? recurringEveryDayWeekController.text
            : "";
    baseBody['repeatWeek'] =
        (state.selectedRecurring?['label'].toString().isWeekly ?? false)
            ? recurringEveryDayWeekController.text
            : "";
    baseBody['weekDay'] =
        (state.selectedRecurring?['label'].toString().isWeekly ?? false)
            ? "${state.selectedRecurringDays.map((e) => jsonEncode(e.toString().toLowerCase())).toList()}"
            : "";
    baseBody['recur_monthly_type'] = "${state.isRecurringMonthOccurrence}";
    baseBody['repeatDateMonth'] = state.isRecurringMonthOccurrence
        ? recurringMonthDateController.text
        : "";
    baseBody['repeatMonth'] = !state.isRecurringMonthOccurrence
        ? recurringMonthDateController.text
        : "";
    baseBody['repeatDayMonth'] = !state.isRecurringMonthOccurrence
        ? recurringMonthMonthController.text
        : "";
    baseBody['repeatDateYear'] =
        (state.selectedRecurring?['label'].toString().isYearly ?? false)
            ? recurringYearDateController.text
            : "";
    baseBody['repeatMonthYear'] =
        state.recurringYearlySelectedMonth?['month'].toString() ?? "";
    baseBody['end_type'] = "${state.isRecurringEndDate}";
    baseBody['end_after'] = (!state.isRecurringEndDate)
        ? (recurringNoOccurrenceController.text)
        : "";
    baseBody['end_at'] = state.selectedRecurringEndDate.toFormat() ?? "";
    baseBody['todo_time'] = state.selectedTime.toHMS().toString();
    baseBody['platform_check'] = "${state.isSelectedPlatformCheck ? 1 : 0}";
    baseBody['todo_user_type'] = "0";
    baseBody['comments'] = "";
    baseBody['mileage'] = "";
    baseBody['resolution_notes'] = "";
    baseBody['custom_link_id'] = "${state.selectedLinkOption?['id'] ?? ""}";
    baseBody['custom_link'] =
        (state.selectedLinkOption?['id'] == 1) ? customLinkController.text : "";
    baseBody['reference_id'] =
        (state.selectedLinkOption?['id'] != 1) ? customLinkController.text : "";
    log(jsonEncode(baseBody), name: "ADD_TODO_BODY");
    return baseBody;
  }

  Map<String, String> _cleanCarBody() {
    var location = (state.selectedTaskIdentifier[3]?['type'] == "location")
        ? state.selectedTaskIdentifier[3]
        : null;
    var vendor = (state.selectedTaskIdentifier[3]?['type'] == "vendor")
        ? state.selectedTaskIdentifier[3]
        : null;
    var person = (state.selectedTaskIdentifier[2]?['type'] == "person")
        ? state.selectedTaskIdentifier[2]
        : null;
    var vehicleGroup =
        (state.selectedTaskIdentifier[2]?['type'] == "g_vehicles")
            ? state.selectedTaskIdentifier[2]
            : null;
    var isAdd = state.selectedTaskIdentifier[1]?['id'] == 210;
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
    Map<String, String> jsonBody = {
      "title": "Clean Car",
      "identifier_id": "30",
      "location": location?['name'] ?? "",
      "location_id": "${location?['id'] ?? ""}",
      "cohort_id": "",
      "cohort_name": "",
      "vin": "",
      "vehicle_name": "",
      "vehicle_image": "",
      "vehicles":
          "${state.selectedVPerson.where((element) => element['type'] == "vehicles").map((e) => e['value']).map((e) => jsonEncode({
                    "cohort_id": "${e['cohort']?['id'] ?? ""}",
                    "cohort_name": "${e['cohort']?['cohort'] ?? ""}",
                    "vin": e['vin'],
                    "vehicle_name": e['vehicle_name'],
                    "vehicle_image":
                        (e['images'] as List?)?.firstOrNull?['path'],
                    "vehicle_number": e['vehicle_number']
                  })).toList()}",
      "start_at": "${date.toFormat(format: "yyyy-MM-dd")}",
      "person": "${person?['name'] ?? ""}",
      "person_id": "${person?['id'] ?? ""}",
      "vendor_id": "${vendor?['id'] ?? " "}",
      "vendor_name": "${vendor?['name'] ?? ""}",
      "notes":
          notesController.text.trim().isNullOrEmpty ? "" : notesController.text,
      "parts":
          "${state.selectedParts.isEmpty ? null : state.selectedParts.map((e) => jsonEncode({
                    "parts_id": e['id'],
                    "parts_name": e['name'],
                  })).toList()}",
      "supplies":
          "${state.selectedSupplies.isEmpty ? null : state.selectedSupplies.map((e) => jsonEncode({
                    "supplies_id": e['id'],
                    "supplies_name": e['name'],
                  })).toList()}",
      "vehicle_group_id": "${vehicleGroup?['id'] ?? ""}",
      "address": "${state.addresses.map((e) => e['id']).toList()}",
      "assigned_to":
          "${state.selectedTaskPersons.map((e) => e['id']).toList()}",
      "todo_time": "${timeDay.toHMS()}",
      "reason": reasonController.text,
      "time_sensitive": "${state.isTimeSensitive}",
      "branch_id": "$branchId",
    };
    log("${jsonEncode(jsonBody)}", name: "CLEAN_CAR_JSON_BODY");
    return jsonBody;
  }

  // PICK MULTI IMAGES / FILES
  Future<List<File>?> _pickFiles() async {
    var result = await ImagePicker().pickMultiImage();
    return result.map((e) => File(e.path)).toList();
  }

  Future<List<Map<String, dynamic>>?> _getTasks() async => await getIt<CommonService>().getTaskExpenseData(); // API CALL: TASKS
  Future<List<Map<String, dynamic>>?> _getVendors() async => await getIt<CommonService>().getVendorsList(); // API CALL: VENDORS
  Future<List<Map<String, dynamic>>?> _getLocations() async => await getIt<CommonService>().getLocationsList(); // API CALL: LOCATIONS
  Future<List<Map<String, dynamic>>?> _getVehicles() async => await getIt<CommonService>().getActiveVehicles(); // API CALL: ACTIVE-VEHICLES
  Future<List<Map<String, dynamic>>?> _getResources() async => await getIt<CommonService>().getResources(); // API CALL: GET-RESOURCES
  Future<List<Map<String, dynamic>>?> _getParts() async => await getIt<CommonService>().getPartsList(); // API CALL: GET-PARTS
  Future<List<Map<String, dynamic>>?> _getSupplies() async => await getIt<CommonService>().getSuppliesList(); // API CALL: GET-PARTS
  Future<List<Map<String, dynamic>>> _getGroupVehicles() async => await getIt<CommonService>().groupVehicles(); // API CALL: GET-GROUP-VEHICLES
  Future<List<Map<String, dynamic>>> _getCurrentToDos() async => await getIt<CommonService>().getToDos(); // API CALL: GET-TODOS
  Future<Map<String, dynamic>?> _getOilChangeTask({required dynamic vin}) async => await getIt<CommonService>().getLatestOilChangeTask(vin: vin, dateTime: state.selectedDate ?? DateTime.now());
  Future<Map<String, dynamic>?> _deleteToDo({dynamic todoId}) async => await _apiRepository.deleteTodo(id: todoId, reason: "");

  void _checkValidation() {
    // VALIDATIONS MANDATORY
    // IF DEPARTMENT IS 7 THEN PLATFORM CHECK
    // TASK NAME
    // TASK MANAGER
    if (taskNameController.text.isEmpty) {
      Toaster.showError("Task name is required");
      return;
    }
    var isPlatformRequired = state.selectedTaskIdentifier.containsKey(1) &&
        Str.platFormCheckIds
            .contains(state.selectedTaskIdentifier[1]?['id']) &&
        departmentId == '7' &&
        !state.isSelectedPlatformCheck;
    if (isPlatformRequired) {
      Toaster.showError("Platform check is required");
      return;
    }
    if (state.selectedTaskPersons.isEmpty) {
      Toaster.showError("Task manager is required");
      return;
    }

    if (state.selectedRecurring?['label'].toString().isDoesNotRepeat == false) {
      if (state.isRecurringEndDate) {
        if (state.selectedRecurringEndDate == null) {
          Toaster.showError("End date is required");
          return;
        }
      }
      if ((!state.isRecurringEndDate) &&
          (recurringNoOccurrenceController.text.isEmpty)) {
        Toaster.showError("No of occurrences is required");
        return;
      }
      if ((state.selectedRecurring?['label'].toString().isDailyOrWeekly ??
          false)) {
        if (recurringEveryDayWeekController.text.isEmpty) {
          Toaster.showError("Occurring count is required");
          return;
        }
      }
      if (state.selectedRecurring?['label'].toString().isWeekly ?? false) {
        if (state.selectedRecurringDays.isEmpty) {
          Toaster.showError("Please choose at least one day to recur");
          return;
        }
      }
      if (state.selectedRecurring?['label'].toString().isMonthly ?? false) {
        if (recurringMonthDateController.text.isEmpty) {
          Toaster.showError("Occurrence Date is required");
          return;
        }
        if (!state.isRecurringMonthOccurrence &&
            recurringMonthMonthController.text.isEmpty) {
          Toaster.showError("Occurrence Month is required");
          return;
        }
      }
      if (state.selectedRecurring?['label'].toString().isYearly ?? false) {
        if (recurringYearDateController.text.isEmpty) {
          Toaster.showError("Occurrence Date is required");
          return;
        }
        if (state.recurringYearlySelectedMonth == null) {
          Toaster.showError("Occurrence Month is required");
          return;
        }
      }
    }
  }

  void _onReassignEvent(AddToDoReassignEvent event, Emitter<AddToDoState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      if (event.isSaveEvent ?? false) {
        var body = _addTodoBody();
        body['reason'] = event.reasonMessage ?? "";
        var images =
            state.attachments.whereType<File>().map((e) => {"images": e.path});
        var reasonImages = event.reasonFiles
            ?.whereType<File>()
            .map((e) => {"reason_images": e.path})
            .toList();
        var attachments = [...images, ...(reasonImages ?? [])];
        var response =
            await _apiRepository.addToDo(body: body, infusedFiles: attachments);
        _broadcast.stickyBroadcast("todo_view", value: true);
        if (response?.isNotEmpty ?? false) {
          Toaster.showSuccess(response?['message'] ?? "Success");
        }
        emit(state.copyWith(isLoading: false));
        if (response?['status'] == 200) emit(state.copyWith(redirect: true));
      } else {
        var body = _cleanCarBody();
        body['reason'] = event.reasonMessage ?? "";
        var reasonImages = event.reasonFiles
            ?.whereType<File>()
            .map((e) => {"reason_images": e.path})
            .toList();
        var attachments = [...(reasonImages ?? [])];
        var response =
            await _apiRepository.addToDo(body: body, infusedFiles: attachments);
        _broadcast.stickyBroadcast("todo_view", value: true);
        if (response != null) {
          Toaster.showSuccess(response['message'] ?? "Success");
        }
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      Toaster.showError("$e");
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onRefreshEvent(AddToDoRefreshEvent event, Emitter<AddToDoState> emit) async {
    Console.of.log("REFRESH_EVENT_TRIGGERED", name: "ADD_TODO_BLOC");
    // PROCEED API CALL
    try {
      emit(state.copyWith(isLoading: true));
      var response = await Future.wait([
        _getTasks(), // 0
        _getVehicles(), // 1
        _getVendors(), // 2
        _getLocations(), // 3
        _getParts(), // 4
        _getSupplies(), // 5
        _getResources(), // 6
        _getGroupVehicles(), // 7
        _getCurrentToDos(), // 8
      ]);
      var resources = response[6] ?? [];
      resources.removeWhere((resource) => resource['id'] == 2);
      resources.removeWhere((resource) =>
      ((!Str.reqTaskManagerIds.contains(resource['id'])) &&
          (resource['branch_id'] !=
              Session.of.getInt(Str.branchIdPrefText))) ||
          (resource['deleted_at'] != null));
      Console.of.log(response.map((e) => e?.length).join(", "));
      vendorLocations = CustomSearchDataConverter.convertVLocation(
          vendors: response[2], locations: response[3]);
      _tasks = response[0] ?? [];
      _vehicles = response[1] ?? [];
      _persons = resources;
      _locations = response[3] ?? [];
      emit(state.copyWith(
          isLoading: false,
          tasks: response[0] ?? [],
          vehicles: response[1] ?? [],
          persons: resources,
          locations: response[3] ?? [],
          vendors: response[2] ?? [],
          partServices: response[4] ?? [],
          supplies: response[5] ?? [],
          groupVehicles: response[7] ?? [],
          resources: resources));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onSaveEvent(AddToDoSaveEvent event, Emitter<AddToDoState> emit) async {
    _checkValidation();
    // API CALL
    try {
      if (state.selectedDate?.toFormat() == DateTime.now().toFormat()) {
        if (state.selectedVPerson.isNotEmpty) {
          var lastVin = state.selectedVPerson.where((element) => element['type'] == 'vehicles').map((e) => e['value']['vin']).lastOrNull;
          if ((lastVin != null) && (state.selectedTaskIdentifier[1]?['id'] == 30)) {
            if (getIt<ToDoSupport>().isClearCarTaskExist(vin: lastVin)) {
              var lastBody = getIt<ToDoSupport>().lastCleanCarTask(vin: lastVin);
              emit(state.copyWith(showCleanTaskReassign: true, isSaveEvent: true, recleanModel: lastBody));
              await Future.delayed(Durations.short2);
              emit(state.copyWith(showCleanTaskReassign: false, isSaveEvent: false, recleanModel: {}));
              return;
            }
          }
        }
      }

      if (state.selectedTaskIdentifier.containsKey(1) && (Str.oilChangeCheckIds.contains(state.selectedTaskIdentifier[1]?['id'])) && !event.oilChangeOverride) {
        // TRIGGER OIL CHANGE
        var lastVin = state.selectedVPerson.where((element) => element['type'] == 'vehicles').map((e) => e['value']['vin']).lastOrNull;
        if (lastVin.toString().isNotNullOrEmpty) return await _findOilChangeTaskExist(vin: lastVin);
      }

      emit(state.copyWith(isLoading: true));
      var files = state.attachments.whereType<File>().map((e) => {"images" : e.path}).toList();
      var response = await _apiRepository.addToDo(body: _addTodoBody(), infusedFiles: files);
      if ((response?.isNotEmpty ?? false) && (response?['status'] == 200)) Toaster.showSuccess(response?['message'] ?? "Success");
      if ((response?.isNotEmpty ?? false) && (response?['status'] != 200)) Toaster.showError(response?['message'] ?? "Error occurred!");
      if ((response?.isNotEmpty ?? false) && (response?['status'] == 200)) _broadcast.stickyBroadcast("todo_view", value: true);
      if (response?['status'] == 200) { emit(state.copyWith(redirect: true)); } else { emit(state.copyWith(isLoading: false)); }
    } catch (e) {
      Console.of.error("Error", error: e);
      Toaster.showError("$e");
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onCleanEvent(AddToDoCleanCarEvent event, Emitter<AddToDoState> emit) async {
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
      if (state.selectedDate?.toFormat() == DateTime.now().toFormat()) {
        var lastVin = state.selectedVPerson
            .where((element) => element['type'] == 'vehicles')
            .map((e) => e['value']['vin'])
            .lastOrNull;
        if (lastVin != null) {
          if (getIt<ToDoSupport>().isClearCarTaskExist(vin: lastVin)) {
            var lastBody = getIt<ToDoSupport>().lastCleanCarTask(
                vin: lastVin);
            emit(state.copyWith(
                showCleanTaskReassign: true,
                isSaveEvent: false,
                recleanModel: lastBody));
            await Future.delayed(Durations.short2);
            emit(state.copyWith(
                showCleanTaskReassign: false,
                isSaveEvent: false,
                recleanModel: {}));
            return;
          }
        }
      }
      emit(state.copyWith(isLoading: true));
      var response = await _apiRepository.cleanCar(body: _cleanCarBody());
      if (response?['status'] == 200) { TaskerHelper.instance.refresh(); Toaster.showSuccess(response?['message'] ?? "Success"); } else { Toaster.showError(response?['message'] ?? "Error occurred!"); }
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      Toaster.showError("$e");
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onInitialEvent(AddToDoInitialEvent event, Emitter<AddToDoState> emit) async {
    // PROCEED API CALL
    try {
      await CommonHelper.instance.waitForPostFrameCallback();
      isNextTask = event.isNextTask;
      addToDoDate = event.selectedDate ?? DateTime.now();
      emit(state.copyWith(showAppBar: event.showAppBar, selectedDate: addToDoDate));
      emit(state.copyWith(isLoading: true));
      var response = await Future.wait([
        _getTasks(), // 0
        _getVehicles(), // 1
        _getVendors(), // 2
        _getLocations(), // 3
        _getParts(), // 4
        _getSupplies(), // 5
        _getResources(), // 6
        _getGroupVehicles(), // 7
        _getCurrentToDos(), // 8
      ]);
      var resources = response[6] ?? [];
      resources.removeWhere((resource) => resource['id'] == 2);
      resources.removeWhere((resource) =>
      ((!Str.reqTaskManagerIds.contains(resource['id'])) &&
          (resource['branch_id'] !=
              Session.of.getInt(Str.branchIdPrefText))) ||
          (resource['deleted_at'] != null));
      var selectedUser = resources
          .where((element) => element['id'].toString() == currentUserId)
          .toList();
      departmentId = selectedUser.firstOrNull?['department'].toString();
      Console.of.log(response.map((e) => e?.length).join(", "));
      vendorLocations = CustomSearchDataConverter.convertVLocation(
          vendors: response[2], locations: response[3]);
      _tasks = response[0] ?? [];
      _vehicles = response[1] ?? [];
      _persons = resources;
      _locations = response[3] ?? [];
      if (event.selectedVPerson?.length == 1) await _findReservationColor(event.selectedVPerson?.firstOrNull?['value']?['vin']);
      var selectedOption = getIt<CommonService>().isAdmin ? AddToDoConfig.customOptions.first : AddToDoConfig.customOptions[1];
      if (existingRefId.toString().isNotNullOrEmpty) selectedOption = AddToDoConfig.customOptions[1];
      Console.of.debug("EXISTING_ID: $existingRefId ADMIN: ${getIt<CommonService>().isAdmin} ID: ${selectedOption['id']}", name: "ADD_TODO_BLOC");
      emit(state.copyWith(
          isLoading: false,
          tasks: response[0] ?? [],
          vehicles: response[1] ?? [],
          persons: resources,
          locations: response[3] ?? [],
          vendors: response[2] ?? [],
          partServices: response[4] ?? [],
          supplies: response[5] ?? [],
          groupVehicles: response[7] ?? [],
          selectedTaskPersons: selectedUser,
          selectedVPerson: event.selectedVPerson ?? [],
          resources: resources,
          selectedDate: addToDoDate,
          selectedLinkOption: selectedOption));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onShowMoreEvent(AddToDoShowMoreEvent event, Emitter<AddToDoState> emit) {
    var currentStatus = state.isMoreEnable;
    emit(state.copyWith(isMoreEnable: !currentStatus));
  }

  void _onShowPartsEvent(AddToDoShowPartsEvent event, Emitter<AddToDoState> emit) {
    var currentStatus = state.isPartServiceEnable;
    emit(state.copyWith(isPartServiceEnable: !currentStatus));
  }

  void _onShowSuppliesEvent(AddToDoShowSuppliesEvent event, Emitter<AddToDoState> emit) {
    var currentStatus = state.isSuppliesEnable;
    emit(state.copyWith(isSuppliesEnable: !currentStatus));
  }

  void _onVPersonEvent(AddToDoVPersonEvent event, Emitter<AddToDoState> emit) async {
    List<Map<String, dynamic>> input = List.from(event.vPerson);
    var existingVPersons =
    List<Map<String, dynamic>>.from(state.selectedVPerson);
    var oldIdentifier = Map<int, dynamic>.from(state.selectedTaskIdentifier);
    if (input.isEmpty) {
      oldIdentifier[2] = {};
      if (existingRefId.toString().isNotNullOrEmpty) {
        customLinkController.clear();
      }
      existingRefId = null;
      emit(state.copyWith(
          selectedVPerson: [], selectedTaskIdentifier: oldIdentifier));
      return;
    }
    existingVPersons = input;
    oldIdentifier[2] = input.last;
    var vehicleVin = existingVPersons
        .where((element) => element['type'] == 'vehicles')
        .map((e) => e['value']['vin'])
        .firstOrNull;

    existingVPersons = existingVPersons.distinct((element) => element['id']);
    emit(state.copyWith(
        selectedVPerson: existingVPersons,
        selectedTaskIdentifier: oldIdentifier));
    if (existingVPersons.length == 1) {
      await _findReservationColor(vehicleVin);
      if (existingRefId.toString().isNotNullOrEmpty) {
        emit(state.copyWith(selectedLinkOption: AddToDoConfig.customOptions[1]));
      }
    }
    else {
      existingRefId = null;
      customLinkController.clear();
    }
  }

  void _onVLocationEvent(AddToDoVLocationEvent event, Emitter<AddToDoState> emit) {
    var existing = Map<int, dynamic>.from(state.selectedTaskIdentifier);
    if ((event.vLocation == existing[3]) || (event.vLocation == null)) {
      existing[3] = {};
    } else {
      existing[3] = event.vLocation;
    }
    Console.of.warning(
        "${event.vLocation?['name']} ${existing.containsKey(3)} ${existing[3]}",
        name: "AddToDoBloc-Location");
    if (existing.containsKey(3) &&
        (existing[3] != null) &&
        (Map.from(existing[3]).isNotEmpty)) {
      if ((selectedVLocation != existing[3])) {
        selectedVLocation = Map<String, dynamic>.from(existing[3]);
      }
      if ((existing[3]?['name'] ?? "") != vLocationController.text) {
        vLocationController.text = existing[3]?['name'] ?? "";
      }
    } else {
      selectedVLocation?.clear();
      vLocationController.clear();
    }
    emit(state.copyWith(
      selectedTaskIdentifier: existing,
    ));
  }

  void _onPersonTapEvent(AddToDoPersonTapEvent event, Emitter<AddToDoState> emit) {
    var existing = List.from(state.selectedTaskPersons);
    if (event.isSelected) {
      existing.add(event.person);
    } else {
      existing.remove(event.person);
    }
    emit(state.copyWith(selectedTaskPersons: existing));
  }

  void _onCleanCarDuration(AddToDoCleanCarDuration event, Emitter<AddToDoState> emit) {
    emit(state.copyWith(selectedClearDuration: event.cleanCarDuration));
  }

  void _onPlatformCheckEvent(AddToDoPlatformCheckEvent event, Emitter<AddToDoState> emit) {
    emit(state.copyWith(isSelectedPlatformCheck: !state.isSelectedPlatformCheck));
  }

  void _onPartSelectionEvent(AddToDoPartSelectionEvent event, Emitter<AddToDoState> emit) {
    var existing = List.from(state.selectedParts);
    if (event.isChecked) {
      if (!existing.contains(event.part)) existing.add(event.part);
    } else {
      if (existing.contains(event.part)) existing.remove(event.part);
    }
    emit(state.copyWith(selectedParts: existing));
  }

  void _onSupplySelectionEvent(AddToDoSupplySelectionEvent event, Emitter<AddToDoState> emit) {
    var existing = List.from(state.selectedSupplies);
    if (event.isChecked) {
      if (!existing.contains(event.data)) existing.add(event.data);
    } else {
      if (existing.contains(event.data)) existing.remove(event.data);
    }
    emit(state.copyWith(selectedSupplies: existing));
  }

  void _onAddAttachmentEvent(AddToDoAddAttachmentEvent event, Emitter<AddToDoState> emit) async {
    try {
      var result = await _pickFiles();
      if (result != null) {
        var existing = List.from(state.attachments);
        var existingPaths = List.from(state.attachments)
            .whereType<File>()
            .map((e) => (e.path))
            .toList();
        for (var element in result) {
          if (!existingPaths.contains(element.path)) existing.add(element);
        }
        attachments = existing;
        emit(state.copyWith(attachments: existing));
      }
    } catch (e) {
      Console.of.error("Error", error: e);
    }
  }

  void _onDoRecurringTypeEvent(AddToDoRecurringTypeEvent event, Emitter<AddToDoState> emit) {
    emit(state.copyWith(selectedRecurring: event.recurringType));
  }

  void _onDeleteAttachmentEvent(AddToDoDeleteAttachment event, Emitter<AddToDoState> emit) {
    try {
      var existing = List.from(state.attachments);
      existing.remove(event.attachment);
      attachments = existing;
      emit(state.copyWith(attachments: existing));
    } catch (e) {
      Console.of.error("Error", error: e);
    }
  }

  void _onAddressSelectionEvent(AddToDoAddressSelectionEvent event, Emitter<AddToDoState> emit) {
    try {
      var existing = List.from(state.addresses);
      if (event.isChecked) {
        if (!existing.contains(event.data)) existing.add(event.data);
      } else {
        if (existing.contains(event.data)) existing.remove(event.data);
      }
      emit(state.copyWith(addresses: existing));
    } catch (e) {
      Console.of.error("Error", error: e);
    }
  }

  void _onRecurringWeekDaysEvent(AddToDoRecurringWeekDaysEvent event, Emitter<AddToDoState> emit) {
    try {
      var existing = List.from(state.selectedRecurringDays);
      if (event.selectedRecurringDay != null) {
        if (!existing.contains(event.selectedRecurringDay)) {
          existing.add(event.selectedRecurringDay);
        } else {
          existing.remove(event.selectedRecurringDay);
        }
      }
      emit(state.copyWith(selectedRecurringDays: existing));
    } catch (e) {
      Console.of.error("Error", error: e);
    }
  }

  void _onOpenCustomLinkEvent(AddToDoOpenCustomLinkEvent event, Emitter<AddToDoState> emit) {
    try {
      var url = (state.selectedLinkOption?['label'].toString().isCustomLink ??
          false)
          ? customLinkController.text
          : (state.selectedLinkOption?['label'].toString().isTuroReservation ??
          false)
          ? customLinkController.text.toTuroReserveUrl
          : customLinkController.text.toGetAroundReserveUrl;
      Utils.openURL(url);
    } catch (e) {
      Console.of.error("Error", error: e);
    }
  }

  void _onDateChangeEvent(AddToDoDateChangeEvent event, Emitter<AddToDoState> emit) {
    emit(state.copyWith(selectedDate: event.selectedDate));
  }

  void _onTimeChangeEvent(AddToDoTimeChangeEvent event, Emitter<AddToDoState> emit) {
    emit(state.copyWith(selectedTime: event.selectedTime));
  }

  void _onTimeSensitiveEvent(AddToDoTimeSensitiveEvent event, Emitter<AddToDoState> emit) {
    emit(state.copyWith(isTimeSensitive: !state.isTimeSensitive));
  }

  void _onSelectLinkOptionEvent(AddToDoSelectLinkOptionEvent event, Emitter<AddToDoState> emit) {
    emit(state.copyWith(selectedLinkOption: event.linkOption));
  }

  void _onMonthOccurrenceEvent(AddToDoRecurringMonthOccurrenceEvent event, Emitter<AddToDoState> emit) {
    emit(state.copyWith(isRecurringMonthOccurrence: event.isRecurringMonthOccurrence));
  }

  void _onRecurringEndDateEvent(AddToDoRecurringEndDateEvent event, Emitter<AddToDoState> emit) {
    emit(state.copyWith(isRecurringEndDate: event.isRecurringEndDate));
  }

  void _onSelectedTaskIdentifier(AddToDoSelectedTaskIdentifierEvent event, Emitter<AddToDoState> emit) async {
    try {
      var existing = Map<int, dynamic>.from(state.selectedTaskIdentifier);
      if (existing.isEmpty && event.selectedTaskIdentifier.isEmpty) return;
      existing.removeWhere(
              (key, value) => !event.selectedTaskIdentifier.keys.contains(key));
      if (event.selectedTaskIdentifier.isEmpty) existing.clear();
      if (event.selectedTaskIdentifier.isNotEmpty) {
        existing.addAll(event.selectedTaskIdentifier);
      }
      if (existing.containsKey(1)) {
        if (((existing[1] as Map).isEmpty) && (taskNameController.text.isNullOrEmpty)) {
          taskNameController.clear();
        } else {
          taskNameController.text = existing[1]?['name'] ?? "";
        }
      }
      var existingVPersons =
      List<Map<String, dynamic>>.from(state.selectedVPerson);
      if (existing[2] != null) {
        if ((existing[2]?['type'] != 'vehicles') || ((existing[2]?['type'] == 'vehicles') && !(existingVPersons.map((e) => e['type']).contains("vehicles")))) {
          existingVPersons.clear();
          existingVPersons.add(existing[2]);
        }
        if (!existingVPersons.contains(existing[2])) existingVPersons.add(existing[2]);
      }
      existingVPersons = existingVPersons.distinct((element) => element['id']);
      vLocationController.text = existing[3]?['name'] ?? "";
      var showCleanCar = false;
      var showPlatformCheck = false;
      var taskId = existing[1]?['id'] ?? 0;
      showCleanCar = Str.cleanCarCheckIds.contains(taskId);
      showPlatformCheck = Str.platFormCheckIds.contains(taskId);
      // var selectedLink = Str.getAroundIds.contains(taskId);
      emit(state.copyWith(
        selectedTaskIdentifier: existing,
        selectedVPerson: existingVPersons,
        showCleanCar: showCleanCar,
        showPlatformCheck: showPlatformCheck,
      ));
      if (existingVPersons.length == 1) await _findReservationColor(existingVPersons.firstOrNull?['value']?['vin']);
    } catch (e) {
      Console.of.error("Error", error: e);
      Toaster.showError("$e");
    }
  }

  void _onRecurringYearlySelectedMonthEvent(AddToDoRecurringYearlySelectedMonthEvent event, Emitter<AddToDoState> emit) {
    emit(state.copyWith(recurringYearlySelectedMonth: event.selectedMonth));
  }

  void _onRecurringEndDateSelectionEvent(AddToDoRecurringEndDateSelectionEvent event, Emitter<AddToDoState> emit) {
    emit(state.copyWith(selectedRecurringEndDate: event.dateTime));
  }
}
