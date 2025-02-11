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

  String? get currentUserId => Session.of.getString(Str.userIdPrefText);

  AddToDoBloc()
      : super(AddToDoState(
            showAppBar: true,
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
        ]);
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
                as AssignedToResponse?;
        var resources = assignedToResponse?.resource ?? [];
        resources.removeWhere((resource) => resource['id'] == 2);
        resources.removeWhere((resource) =>
            ((!Str.reqTaskManagerIds.contains(resource['id'])) &&
                (resource['branch_id'] !=
                    Session.of.getInt(Str.branchIdPrefText))) ||
            (resource['deleted_at'] != null));
        var selectedUser = resources
            .where((element) => element['id'].toString() == currentUserId)
            .toList();
        emit(state.copyWith(
            isLoading: false,
            tasks: taskResponse?.data ?? [],
            vehicles: vehicleResponse?.data ?? [],
            persons: resources,
            locations: locationResponse?.data ?? [],
            vendors: vendorResponse?.data ?? [],
            partServices: partsResponse?.data ?? [],
            supplies: suppliesResponse?.data ?? [],
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
      existing.addAll(event.selectedTaskIdentifier);
      taskNameController.text = existing[1]['name'] ?? "";
      var existingVPersons =
          List<Map<String, dynamic>>.from(state.selectedVPerson);
      if (existing[2] != null) {
        if (existing[2]?['type'] == 'persons') vPersonController.text = existing[2]?['name'] ?? "";
        existingVPersons.removeWhere((element) =>
            element['type'] !=
            ((existing[2]?['type'] == 'persons') ? 'vehicles' : 'persons'));
        existingVPersons.add(existing[2]);
      }
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
      if ((event.vPerson as List).isEmpty) {
        var oldIdentifier = state.selectedTaskIdentifier;
        oldIdentifier.remove(2);
        emit(state.copyWith(
            selectedVPerson: [], selectedTaskIdentifier: oldIdentifier));
        return;
      }
      var oldIdentifier = state.selectedTaskIdentifier;
      var existingVPersons = state.selectedVPerson;
      log("$existingVPersons", name: "AddToDoBloc-Person-before");
      existingVPersons.addAll(event.vPerson);
      oldIdentifier.update(
          2, (value) => (event.vPerson[0] as Map<String, dynamic>));
      existingVPersons.removeWhere((element) =>
          element['type'] ==
          ((event.vPerson.first['type'] == 'persons')
              ? 'vehicles'
              : 'persons'));
      emit(state.copyWith(
          selectedVPerson: existingVPersons,
          selectedTaskIdentifier: oldIdentifier));
      log("$existingVPersons", name: "AddToDoBloc-Person");
    });

    on<AddToDoVLocationEvent>((event, emit) {
      var existing = Map<int, dynamic>.from(state.selectedTaskIdentifier);
      existing[3] = event.vLocation;
      emit(state.copyWith(selectedTaskIdentifier: existing));
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

    on<AddToDoRecurringMonthOccurrenceEvent>((event, emit) => emit(state.copyWith(isRecurringMonthOccurrence: event.isRecurringMonthOccurrence)));
    on<AddToDoRecurringEndDateEvent>((event, emit) => emit(state.copyWith(isRecurringEndDate: event.isRecurringEndDate)));
    on<AddToDoRecurringYearlySelectedMonthEvent>((event, emit) => emit(state.copyWith(recurringYearlySelectedMonth: event.selectedMonth)));
    on<AddToDoRecurringEndDateSelectionEvent>((event, emit) => emit(state.copyWith(selectedRecurringEndDate: event.dateTime)));
  }

  // PICK MULTI IMAGES / FILES
  Future<List<File>?> _pickFiles() async {
    var result = await ImagePicker().pickMultiImage();
    return result.map((e) => File(e.path)).toList();
  }

  // API CALL: TASKS
  Future<TaskExpenseResponse?> _getTasks() async =>
      await todoListRepo.getTaskExpense();

  // API CALL: VENDORS
  Future<VendorResponse?> _getVendors() async => await todoListRepo.getVendor();

  // API CALL: LOCATIONS
  Future<LocationResponse?> _getLocations() async =>
      await todoListRepo.getLocation();

  // API CALL: ACTIVE-VEHICLES
  Future<VehicleListResponse?> _getVehicles() async =>
      await todoListRepo.fetchVehicleList();

  // API CALL: GET-RESOURCES
  Future<AssignedToResponse?> _getResources() async =>
      await todoListRepo.getAssignedTo();

  // API CALL: GET-PARTS
  Future<PartsResponse?> _getParts() async => await todoListRepo.getParts();

  // API CALL: GET-PARTS
  Future<SuppliesResponse?> _getSupplies() async =>
      await todoListRepo.getSupplies();
}
