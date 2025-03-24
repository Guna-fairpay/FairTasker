import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fairpytasker/Repository/todo_list_repository.dart';
import 'package:fairpytasker/Response/assigned_to_response.dart';
import 'package:fairpytasker/Response/location_response.dart';
import 'package:fairpytasker/Response/parts_response.dart';
import 'package:fairpytasker/Response/supplies_response.dart';
import 'package:fairpytasker/Response/task_response.dart';
import 'package:fairpytasker/Response/vehicle_list_response.dart';
import 'package:fairpytasker/Response/vendor_response.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_const.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_events.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_state.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/timeday_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddToDoBloc extends Bloc<AddToDoEvent, AddToDoState> {
  final TodoListRepo todoListRepo = TodoListRepo();
  final TextEditingController taskIdentifierController =
      TextEditingController();
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController vPersonController = TextEditingController();
  final TextEditingController vLocationController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController customLinkController = TextEditingController();

  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  final TextEditingController recurringEveryDayWeekController =
      TextEditingController();
  final TextEditingController recurringMonthDateController =
      TextEditingController();
  final TextEditingController recurringMonthMonthController =
      TextEditingController();
  final TextEditingController recurringYearDateController =
      TextEditingController();
  final TextEditingController recurringNoOccurrenceController =
      TextEditingController();
  final TextEditingController recurringEndDateController =
      TextEditingController();

  final TextEditingController reasonController = TextEditingController();

  final TextEditingController addressController = TextEditingController();
  final TextEditingController partsController = TextEditingController();
  final TextEditingController suppliesController = TextEditingController();

  final FBroadcast _broadcast = FBroadcast.instance();

  String? get currentUserId => Session.of.getString(Str.userIdPrefText);

  int? get branchId => Session.of.getInt(Str.branchIdPrefText);

  String? departmentId; // LoggedIn User department ID

  AddToDoBloc()
      : super(AddToDoState(
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
            recurringYearlySelectedMonth: AddToDoConfig.months.first,
            selectedLinkOption: AddToDoConfig.customOptions.first,
            selectedClearDuration: AddToDoConfig.cleanCarDurations.first,
            selectedRecurring: AddToDoConfig.recurringOptions.first,
            selectedDate: DateTime.now(),
            selectedTime: TimeOfDay.now())) {
    on<AddToDoInitialEvent>((event, emit) async {
      emit(state.copyWith(showAppBar: event.showAppBar));
      // PROCEED API CALL
      try {
        emit(state.copyWith(isLoading: true));
        var response = await Future.wait([
          _getTasks(),
          _getVehicles(),
          _getVendors(),
          _getLocations(),
          _getParts(),
          _getSupplies(),
          _getResources(),
          _getGroupVehicles()
        ]);
        // var groupVehicles = await _getGroupVehicles();
        /*var tasks = response[0];
        TaskExpenseResponse? taskResponse =
            ((response[0] is TaskExpenseResponse) ? response[0] : null)
                as TaskExpenseResponse?;
        VehicleListResponse? vehicleResponse =
            ((response[1] is VehicleListResponse) ? response[1] : null)
                as VehicleListResponse?;
        VendorResponse? vendorResponse = ((response[2] is VendorResponse)
            ? response[2]
            : null) as VendorResponse?;
        LocationResponse? locationResponse = ((response[3] is LocationResponse)
            ? response[3]
            : null) as LocationResponse?;
        PartsResponse? partsResponse = ((response[4] is PartsResponse)
            ? response[4]
            : null) as PartsResponse?;
        SuppliesResponse? suppliesResponse = ((response[5] is SuppliesResponse)
            ? response[5]
            : null) as SuppliesResponse?;
        AssignedToResponse? assignedToResponse =
            ((response[6] is AssignedToResponse) ? response[6] : null)
                as AssignedToResponse?;*/
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
            resources: resources,
            selectedLinkOption: AddToDoConfig.customOptions.first));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });

    on<AddToDoShowMoreEvent>((event, emit) {
      var currentStatus = state.isMoreEnable;
      emit(state.copyWith(isMoreEnable: !currentStatus));
    });

    on<AddToDoShowPartsEvent>((event, emit) {
      var currentStatus = state.isPartServiceEnable;
      emit(state.copyWith(isPartServiceEnable: !currentStatus));
    });

    on<AddToDoShowSuppliesEvent>((event, emit) {
      var currentStatus = state.isSuppliesEnable;
      emit(state.copyWith(isSuppliesEnable: !currentStatus));
    });

    on<AddToDoSelectedTaskIdentifierEvent>((event, emit) {
      var existing = Map<int, dynamic>.from(state.selectedTaskIdentifier);
      // if ((!event.selectedTaskIdentifier.containsKey(1)) &&
      //     existing.containsKey(1)) {
      //   existing.remove(1);
      // }
      // if ((!event.selectedTaskIdentifier.containsKey(2)) &&
      //     existing.containsKey(2)) {
      //   existing.remove(2);
      // }
      // if ((!event.selectedTaskIdentifier.containsKey(3)) &&
      //     existing.containsKey(3)) {
      //   existing.remove(3);
      // }
      log("${event.selectedTaskIdentifier.keys}", name: "AddToDoBloc-before");
      existing.removeWhere((key, value) => !event.selectedTaskIdentifier.keys.contains(key));
      if (event.selectedTaskIdentifier.isEmpty) existing.clear();
      if (event.selectedTaskIdentifier.isNotEmpty) {
        existing.addAll(event.selectedTaskIdentifier);
      }
      if (existing.containsKey(1)) {
        taskNameController.text = existing[1]?['name'] ?? "";
      }
      if (!existing.containsKey(1)) taskNameController.clear();

      var existingVPersons =
          List<Map<String, dynamic>>.from(state.selectedVPerson);
      if (existing[2] != null) {
        if (existing[2]?['type'] == 'person') {
          vPersonController.text = existing[2]?['name'] ?? "";
        }
        existingVPersons.removeWhere((element) =>
            element['type'] !=
            ((existing[2]?['type'] == 'person') ? 'vehicles' : 'person'));
        log("$existingVPersons", name: "AddToDoBloc-Person-before");
        if ((existing[2]?['type'] == 'person') && existingVPersons.where((element) => element['type'] == 'person').isNotEmpty) existingVPersons.clear();
        if ((existingVPersons.where((element) => element['type'] == 'person').isNotEmpty) && (existing[2]?['type'] == 'person')) {
          existingVPersons.clear();
        }
        existingVPersons.add(existing[2]);
      }
      if (!existing.containsKey(2)) existingVPersons.clear();

      log("${existing[3]}", name: "AddToDoBloc-VLocation");
      vLocationController.text = existing[3]?['name'] ?? "";
      var showCleanCar = false;
      var showPlatformCheck = false;
      var taskId = existing[1]?['id'] ?? 0;
      showCleanCar = Str.cleanCarCheckIds.contains(taskId);
      showPlatformCheck = Str.platFormCheckIds.contains(taskId);
      var selectedLink = Str.getAroundIds.contains(taskId);
      emit(state.copyWith(
          selectedTaskIdentifier: existing,
          selectedVPerson: existingVPersons,
          showCleanCar: showCleanCar,
          showPlatformCheck: showPlatformCheck,
          selectedLinkOption: selectedLink
              ? AddToDoConfig.customOptions.last
              : AddToDoConfig.customOptions[1]));
      log("$existing", name: "AddToDoBloc");
    });

    on<AddToDoVPersonEvent>((event, emit) {
      log("${event.vPerson}", name: "AddToDoBloc-Person-before-check");
      if ((event.vPerson as List).isEmpty) {
        var oldIdentifier = state.selectedTaskIdentifier;
        oldIdentifier.remove(2);
        emit(state.copyWith(
            selectedVPerson: [], selectedTaskIdentifier: oldIdentifier));
        return;
      }
      var oldIdentifier = Map<int, dynamic>.from(state.selectedTaskIdentifier);
      var existingVPersons = List<Map<String, dynamic>>.from(state.selectedVPerson);
      log("$existingVPersons", name: "AddToDoBloc-Person-before");
      log("${event.vPerson}", name: "AddToDoBloc-Person-before-Add");
      if (existingVPersons.where((element) => element['type'] == 'person').isNotEmpty && event.vPerson.first['type'] == 'person') {
        existingVPersons.clear();
      }
      existingVPersons.addAll(event.vPerson);
      // existingVPersons.removeWhere((element) => !(event.vPerson.map((e) => e['id']).contains(element['id'])));
      if (oldIdentifier.containsKey(2)) {
        oldIdentifier.update(
            2, (value) => (event.vPerson[0] as Map<String, dynamic>));
      }
      if (!oldIdentifier.containsKey(2)) {
        oldIdentifier.putIfAbsent(
            2, () => (event.vPerson[0] as Map<String, dynamic>));
      }
      existingVPersons = existingVPersons.unique((element) => element['id']);
      existingVPersons.removeWhere((element) =>
          element['type'] ==
          ((event.vPerson.first['type'] == 'person') ? 'vehicles' : 'person'));
      emit(state.copyWith(
          selectedVPerson: existingVPersons,
          selectedTaskIdentifier: oldIdentifier));
      log("$existingVPersons", name: "AddToDoBloc-Person");
    });

    on<AddToDoVLocationEvent>((event, emit) {
      var existing = Map<int, dynamic>.from(state.selectedTaskIdentifier);
      if (event.vLocation == existing[3]) {
        existing.remove(3);
      } else {
        existing[3] = event.vLocation;
      }
      log("${event.vLocation['name']}", name: "AddToDoBloc-Location");
      if (existing.containsKey(3)) {
        if ((existing[3]?['name'] ?? "") != vLocationController.text) vLocationController.text = existing[3]?['name'] ?? "";
      } else {
        vLocationController.clear();
      }
      emit(state.copyWith(selectedTaskIdentifier: existing, ));
    });

    on<AddToDoPersonTapEvent>((event, emit) {
      var existing = List.from(state.selectedTaskPersons);
      log("${event.isSelected} ${event.person}", name: "AddToDoBloc-Person");
      if (event.isSelected) {
        existing.add(event.person);
      } else {
        existing.remove(event.person);
      }
      emit(state.copyWith(selectedTaskPersons: existing));
    });

    on<AddToDoCleanCarDuration>((event, emit) =>
        emit(state.copyWith(selectedClearDuration: event.cleanCarDuration)));

    on<AddToDoPlatformCheckEvent>((event, emit) => emit(state.copyWith(
        isSelectedPlatformCheck: !state.isSelectedPlatformCheck)));

    on<AddToDoPartSelectionEvent>((event, emit) {
      var existing = List.from(state.selectedParts);
      if (event.isChecked) {
        if (!existing.contains(event.part)) existing.add(event.part);
      } else {
        if (existing.contains(event.part)) existing.remove(event.part);
      }
      emit(state.copyWith(selectedParts: existing));
    });

    on<AddToDoSupplySelectionEvent>((event, emit) {
      var existing = List.from(state.selectedSupplies);
      if (event.isChecked) {
        if (!existing.contains(event.data)) existing.add(event.data);
      } else {
        if (existing.contains(event.data)) existing.remove(event.data);
      }
      emit(state.copyWith(selectedSupplies: existing));
    });

    on<AddToDoRecurringTypeEvent>((event, emit) =>
        emit(state.copyWith(selectedRecurring: event.recurringType)));

    on<AddToDoDateChangeEvent>((event, emit) =>
        emit(state.copyWith(selectedDate: event.selectedDate)));

    on<AddToDoTimeChangeEvent>((event, emit) =>
        emit(state.copyWith(selectedTime: event.selectedTime)));

    on<AddToDoTimeSensitiveEvent>((event, emit) =>
        emit(state.copyWith(isTimeSensitive: !state.isTimeSensitive)));

    on<AddToDoAddAttachmentEvent>((event, emit) async {
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
        emit(state.copyWith(attachments: existing));
      }
    });

    on<AddToDoSelectLinkOptionEvent>((event, emit) =>
        emit(state.copyWith(selectedLinkOption: event.linkOption)));

    on<AddToDoAddressSelectionEvent>((event, emit) {
      var existing = List.from(state.addresses);
      if (event.isChecked) {
        if (!existing.contains(event.data)) existing.add(event.data);
      } else {
        if (existing.contains(event.data)) existing.remove(event.data);
      }
      emit(state.copyWith(addresses: existing));
    });

    on<AddToDoRecurringWeekDaysEvent>((event, emit) {
      var existing = List.from(state.selectedRecurringDays);
      if (event.selectedRecurringDay != null) {
        if (!existing.contains(event.selectedRecurringDay)) {
          existing.add(event.selectedRecurringDay);
        } else {
          existing.remove(event.selectedRecurringDay);
        }
      }
      emit(state.copyWith(selectedRecurringDays: existing));
    });

    on<AddToDoRecurringMonthOccurrenceEvent>((event, emit) => emit(
        state.copyWith(
            isRecurringMonthOccurrence: event.isRecurringMonthOccurrence)));
    on<AddToDoRecurringEndDateEvent>((event, emit) =>
        emit(state.copyWith(isRecurringEndDate: event.isRecurringEndDate)));
    on<AddToDoRecurringYearlySelectedMonthEvent>((event, emit) => emit(
        state.copyWith(recurringYearlySelectedMonth: event.selectedMonth)));
    on<AddToDoRecurringEndDateSelectionEvent>((event, emit) =>
        emit(state.copyWith(selectedRecurringEndDate: event.dateTime)));

    on<AddToDoOpenCustomLinkEvent>((event, emit) {
      var url = (state.selectedLinkOption?['label'].toString().isCustomLink ??
              false)
          ? customLinkController.text
          : (state.selectedLinkOption?['label'].toString().isTuroReservation ??
                  false)
              ? customLinkController.text.toTuroReserveUrl
              : customLinkController.text.toGetAroundReserveUrl;
      Utils.openURL(url);
    });

    on<AddToDoSaveEvent>((event, emit) async {
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
              .contains(state.selectedTaskIdentifier[1]['id']) &&
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
        if ((state.selectedRecurring?['label']
            .toString()
            .isDailyOrWeekly ?? false)) {
          if (recurringEveryDayWeekController.text.isEmpty) {
            Toaster.showError("Occurring count is required");
            return;
          }
        }
        if (state.selectedRecurring?['label']
            .toString()
            .isWeekly ?? false) {
          if (state.selectedRecurringDays.isEmpty) {
            Toaster.showError("Please choose at least one day to recur");
            return;
          }
        }
        if (state.selectedRecurring?['label']
            .toString()
            .isMonthly ?? false) {
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
        if (state.selectedRecurring?['label']
            .toString()
            .isYearly ?? false) {
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
      // API CALL
      try {
        emit(state.copyWith(isLoading: true));
        var response = await todoListRepo.addTodo(body: _addTodoBody(), images: state.attachments.whereType<File>().toList());
        if (response?.isNotEmpty ?? false) Toaster.showSuccess(response?['message'] ?? "Success");
        emit(state.copyWith(isLoading: false));
        _broadcast.stickyBroadcast("todo_view", value: true);
        if (response?['status'] == 200) emit(state.copyWith(redirect: true));
      } catch (e) {
        Toaster.showError("$e");
        emit(state.copyWith(isLoading: false));
      }
    });

    on<AddToDoCleanCarEvent>((event, emit) async {
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
              .where((element) => element['type'] == 'vehicles')
              .isEmpty)) {
        Toaster.showError("Vehicle is required");
        return;
      }
      try {
        emit(state.copyWith(isLoading: true));
        var response = await todoListRepo.cleanCar(body: _cleanCarBody());
        if (response != null) Toaster.showSuccess(response['message'] ?? "Success");
        emit(state.copyWith(isLoading: false));
      } catch(e) {
        Toaster.showError("$e");
        emit(state.copyWith(isLoading: false));
      }

    });
  }

  Map<String, String> _addTodoBody() {
    var baseBody = _cleanCarBody();
    baseBody['title'] = taskNameController.text;
    baseBody['identifier_id'] = ((taskNameController.text.isNotEmpty)
        && (state.selectedTaskIdentifier[1]?['name'] == taskNameController.text))
        ? "${state.selectedTaskIdentifier[1]?['id'] ?? ""}"
        : "";
    baseBody['repeatPeriod'] = ((state.selectedRecurring?['label'].toString().isDoesNotRepeat == false) ? (state.selectedRecurring?['label'].toString().toLowerCase()) : "")??'';
    baseBody['repeatDay'] = (state.selectedRecurring?['label'].toString().isDaily ?? false) ? recurringEveryDayWeekController.text : "";
    baseBody['repeatWeek'] = (state.selectedRecurring?['label'].toString().isWeekly ?? false) ? recurringEveryDayWeekController.text : "";
    baseBody['weekDay'] = (state.selectedRecurring?['label'].toString().isWeekly ?? false) ? (state.selectedRecurringDays).toString() : "";
    baseBody['recur_monthly_type'] = "${state.isRecurringMonthOccurrence}";
    baseBody['repeatDateMonth'] = state.isRecurringMonthOccurrence ? recurringMonthDateController.text : "";
    baseBody['repeatMonth'] = !state.isRecurringMonthOccurrence ? recurringMonthDateController.text : "";
    baseBody['repeatDayMonth'] = !state.isRecurringMonthOccurrence ? recurringMonthMonthController.text : "";
    baseBody['repeatDateYear'] = (state.selectedRecurring?['label'].toString().isYearly ?? false) ? recurringYearDateController.text : "";
    baseBody['repeatMonthYear'] = state.recurringYearlySelectedMonth?['month'].toString() ?? "";
    baseBody['end_type'] = "${state.isRecurringEndDate}";
    baseBody['end_after'] = (!state.isRecurringEndDate) ? (recurringEndDateController.text ?? "") : "";
    baseBody['end_at'] = state.selectedRecurringEndDate.toFormat() ?? "";
    baseBody['todo_time'] = state.selectedTime.toHMS().toString();
    baseBody['platform_check'] = "${state.isSelectedPlatformCheck ? 1 : 0}";
    baseBody['todo_user_type'] = "0";
    baseBody['comments'] = "";
    baseBody['mileage'] = "";
    baseBody['resolution_notes'] = "";
    baseBody['custom_link_id'] = "${state.selectedLinkOption?['id']}";
    baseBody['custom_link'] = (state.selectedLinkOption?['id'] == 1) ? customLinkController.text : "";
    baseBody['reference_id'] = (state.selectedLinkOption?['id'] != 1) ? customLinkController.text : "";
    log("${jsonEncode(baseBody)}", name: "ADD_TODO_BODY");
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
    var isAdd = state.selectedTaskIdentifier[1]?['id'] == 210;
    var date = state.selectedDate ?? DateTime.now();
    var timeAt = state.selectedTime.toDateTime;
    var timeDay = state.selectedTime;
    if (timeAt != null) {
      date = DateTime(date.year, date.month, date.day, timeAt.hour, timeAt.minute);
      if (isAdd) {
        timeAt = date.add(Duration(minutes: state.selectedClearDuration?['value']));
      } else {
        timeAt =
            date.subtract(Duration(minutes: state.selectedClearDuration?['value']));
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
      "vehicles": "${state.selectedVPerson
          .where((element) => element['type'] == "vehicles")
          .map((e) => e['value'])
          .map((e) => jsonEncode({
        "cohort_id": "${e['cohort']?['id'] ?? ""}",
        "cohort_name": "${e['cohort']?['cohort'] ?? ""}",
        "vin": e['vin'],
        "vehicle_name": e['vehicle_name'],
        "vehicle_image": (e['images'] as List?)?.firstOrNull?['path'],
        "vehicle_number": e['vehicle_number']
      }))
          .toList()}",
      "start_at": "${date.toFormat(format: "yyyy-MM-dd")}",
      "person": "${person?['name'] ?? ""}",
      "person_id": "${person?['id'] ?? ""}",
      "vendor_id": "${vendor?['id'] ?? " "}",
      "vendor_name": "${vendor?['name'] ?? ""}",
      "notes": notesController.text,
      "parts": "${state.selectedParts.isEmpty
          ? null
          : state.selectedParts
          .map((e) =>
      {
        "parts_id": e['id'],
        "parts_name": e['name'],
      })
          .toList()}",
      "supplies": "${
        state.selectedSupplies.isEmpty
            ? null
            : state.selectedSupplies
                .map((e) => {
                      "supplies_id": e['id'],
                      "supplies_name": e['name'],
                    })
                .toList()
      }",
      "vehicle_group_id": "",
      "address": "${state.addresses.map((e) => e['id']).toList()}",
      "assigned_to": "${state.selectedTaskPersons.map((e) => e['id']).toList()}",
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

  // API CALL: TASKS
  Future<List<Map<String, dynamic>>?> _getTasks() async =>
      await getIt<CommonService>().getTaskExpenseData();

  // API CALL: VENDORS
  Future<List<Map<String, dynamic>>?> _getVendors() async =>
      await getIt<CommonService>().getVendorsList();

  // API CALL: LOCATIONS
  Future<List<Map<String, dynamic>>?> _getLocations() async =>
      await getIt<CommonService>().getLocationsList();

  // API CALL: ACTIVE-VEHICLES
  Future<List<Map<String, dynamic>>?> _getVehicles() async =>
      await getIt<CommonService>().getActiveVehicles();

  // API CALL: GET-RESOURCES
  Future<List<Map<String, dynamic>>?> _getResources() async =>
      await getIt<CommonService>().getResources();

  // API CALL: GET-PARTS
  Future<List<Map<String, dynamic>>?> _getParts() async =>
      await getIt<CommonService>().getPartsList();

  // API CALL: GET-PARTS
  Future<List<Map<String, dynamic>>?> _getSupplies() async =>
      await getIt<CommonService>().getSuppliesList();

  Future<List<Map<String, dynamic>>> _getGroupVehicles() async =>
      await getIt<CommonService>().groupVehicles();
}
