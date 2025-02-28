
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fairpytasker/Response/task_response.dart';
import 'package:fairpytasker/Response/todo_list_response.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Repository/todo_list_repository.dart';
import '../../../../Response/assigned_to_response.dart';
import '../../../../Response/location_response.dart';
import '../../../../Response/parts_response.dart';
import '../../../../Response/supplies_response.dart';
import '../../../../Response/user_group_response.dart';
import '../../../../Response/vehicle_list_response.dart';
import '../../../../Response/vendor_response.dart';
import '../../../../Utilities/Str.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/prefs.dart';
import '../../add_todo/add_todo_const.dart';
import '../event/edit_todo_event.dart';
import '../state/edit_todo_state.dart';

class EditToDoBloc extends Bloc<EditToDoEvent, EditTodoState> {
  final TodoListRepo todoListRepo = TodoListRepo();
  dynamic todoId='';
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController vPersonController = TextEditingController();
  final TextEditingController vLocationController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController customLinkController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController odometerController = TextEditingController();

  String? get currentUserId => Session.of.getString(Str.userIdPrefText);

  int? get branchId => Session.of.getInt(Str.branchIdPrefText);

  String? departmentId; // LoggedIn User department ID
  List<String>selectedIds=[];

  EditToDoBloc()
      : super(EditTodoState(
      //showAppBar: true,
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
      selectedVendor: const {},
      selectedParts: const [],
      selectedSupplies: const [],
      attachments: const [],
      selectedTask: const[],
      linkOptions: AddToDoConfig.customOptions,
      bottomTapData:const [],
      selectedBottomTap: AddToDoConfig.editTodoBottomTaps.first,
      isSelectedPlatformCheck: false,
      showPlatformCheck: false,
      isMoreEnable: false,
      isPartServiceEnable: false,
      isSuppliesEnable: false,
      selectedLinkOption: AddToDoConfig.customOptions.first,
      selectedDate: DateTime.now(),
      selectedTime: TimeOfDay.now(),
      apiResponse: const{},
      todoStatus: false,
      selectedResource: const [],
      userGroup: const [],
      selectedTaskIdentifier: const {},
      resourceName: const [],

  )) {
    var tabs = List.from(AddToDoConfig.editTodoBottomTaps);
    on<GetEditTodoInitialEvent>((event, emit) async {
      emit(state.copyWith());
      todoId=event.todoId;
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
          _getUserGroup(),
        ]);
        TodoListResponse? todoResponse = await _editTodoData(todoId);
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
        UserGroupResponse? userGroupResponse = ((response[7] is UserGroupResponse)
            ? response[7]
            : null) as UserGroupResponse?;
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
        notesController.text = todoResponse!.editTodos?['notes'] ?? '';
        departmentId = selectedUser.firstOrNull?['department'].toString();
        if (todoResponse!.editTodos?['user_id'] != null) {
          selectedIds=((todoResponse.editTodos?['user_id']).toString()).split(',');
        }
        if (todoResponse.editTodos?['user_group_id'] != null) {
          for (var group in userGroupResponse?.data ?? []) {
            if (group['id'] == todoResponse.editTodos?['user_group_id']) {
              var decodedList = json.decode(group['userId'] ?? '[]');
              if (decodedList is List) {
                selectedIds = decodedList.map((e) => e.toString()).toList();
              } else {
                selectedIds = [];
              }
            }
          }
        }

        var list=(assignedToResponse?.resource ?? []).where((element) => selectedIds.contains(element['id'].toString())).map((e) => [e['first_name'].toString(), e['last_name'].toString()].toInitial).toList();

        emit(state.copyWith(
            isLoading: false,
            bottomTapData: tabs,
            resourceName: list,
            apiResponse: todoResponse.editTodos,
            todoStatus: todoResponse.editTodos?['status'] == 'In Progress'?false:true,
            // selectedBottomTap: tabs.firstWhere((element) => element['id'] == 4),
            tasks: taskResponse?.data ?? [],
            vehicles: vehicleResponse?.data ?? [],
            persons: resources,
            locations: locationResponse?.data ?? [],
            vendors: vendorResponse?.data ?? [],
            partServices: partsResponse?.data ?? [],
            supplies: suppliesResponse?.data ?? [],
            selectedTaskPersons: selectedUser,
            resources: resources,
            selectedLinkOption: AddToDoConfig.customOptions.first,
            selectedResource:selectedIds,
        )
        );

      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });

    on<EditToDoShowMoreEvent>((event, emit) {
      var currentStatus = state.isMoreEnable;
      emit(state.copyWith(isMoreEnable: !currentStatus));
    });

    on<EditToDoVPersonEvent>((event, emit) {
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

    on<EditToDoShowPartsEvent>((event, emit) {
      var currentStatus = state.isPartServiceEnable;
      emit(state.copyWith(isPartServiceEnable: !currentStatus));
    });

    on<EditToDoShowSuppliesEvent>((event, emit) {
      var currentStatus = state.isSuppliesEnable;
      emit(state.copyWith(isSuppliesEnable: !currentStatus));
    });

    on<TaskStatusChangeEvent>((event, emit) {
      emit(state.copyWith(todoStatus: !state.todoStatus));

    });

    on<EditToDoPersonTapEvent>((event, emit) {
      var existing = List.from(state.selectedTaskPersons);
      log("${event.isSelected} ${event.person}", name: "EditToDoBloc-Person");
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

    on<EditToDoPartSelectionEvent>((event, emit) {
      var existing = List.from(state.selectedParts);
      if (event.isChecked) {
        if (!existing.contains(event.part)) existing.add(event.part);
      } else {
        if (existing.contains(event.part)) existing.remove(event.part);
      }
      emit(state.copyWith(selectedParts: existing));
    });

    on<EditToDoSupplySelectionEvent>((event, emit) {
      var existing = List.from(state.selectedSupplies);
      if (event.isChecked) {
        if (!existing.contains(event.data)) existing.add(event.data);
      } else {
        if (existing.contains(event.data)) existing.remove(event.data);
      }
      emit(state.copyWith(selectedSupplies: existing));
    });

    on<EditToDoRecurringTypeEvent>((event, emit) =>
        emit(state.copyWith(selectedRecurring: event.recurringType)));

    on<EditToDoDateChangeEvent>((event, emit) =>
        emit(state.copyWith(selectedDate: event.selectedDate)));

    on<EditToDoTimeChangeEvent>((event, emit) =>
        emit(state.copyWith(selectedTime: event.selectedTime)));

    on<EditToDoTimeSensitiveEvent>((event, emit) =>
        emit(state.copyWith(isTimeSensitive: !state.isTimeSensitive)));

    on<EditToDoEditAttachmentEvent>((event, emit) async {
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

    on<EditToDoSelectLinkOptionEvent>((event, emit) =>
        emit(state.copyWith(selectedLinkOption: event.linkOption)));



    on<EditToDoRecurringMonthOccurrenceEvent>((event, emit) => emit(
        state.copyWith(
            isRecurringMonthOccurrence: event.isRecurringMonthOccurrence)));
    on<EditToDoRecurringEndDateEvent>((event, emit) =>
        emit(state.copyWith(isRecurringEndDate: event.isRecurringEndDate)));
    on<EditToDoRecurringYearlySelectedMonthEvent>((event, emit) => emit(
        state.copyWith(recurringYearlySelectedMonth: event.selectedMonth)));
    on<EditToDoRecurringEndDateSelectionEvent>((event, emit) =>
        emit(state.copyWith(selectedRecurringEndDate: event.dateTime)));

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
          .map((e) => [e['first_name'].toString(), e['last_name'].toString()].toInitial)
          .toList();
      emit(state.copyWith(selectedResource: existing,resourceName: list));

    });

    on<SelectedUsersNameEvent>((event, emit) {
      var existing = List<String>.from(state.resourceName);

      emit(state.copyWith(resourceName: existing));
    });

  }



  // PICK MULTI IMAGES / FILES
  Future<List<File>?> _pickFiles() async {
    var result = await ImagePicker().pickMultiImage();
    return result.map((e) => File(e.path)).toList();
  }

  Future<TodoListResponse?> _editTodoData(dynamic todoId) async =>
      await todoListRepo.editTodoData(id: todoId);
  /// API CALL: TASKS
  Future<TaskExpenseResponse?> _getTasks() async => await todoListRepo.getTaskExpense();

  /// API CALL: VENDORS
  Future<VendorResponse?> _getVendors() async => await todoListRepo.getVendor();

  /// API CALL: LOCATIONS
  Future<LocationResponse?> _getLocations() async =>
      await todoListRepo.getLocation();

  /// API CALL: ACTIVE-VEHICLES
  Future<VehicleListResponse?> _getVehicles() async =>
      await todoListRepo.fetchVehicleList();

  /// API CALL: GET-RESOURCES
  Future<AssignedToResponse?> _getResources() async =>
      await todoListRepo.getAssignedTo();

  /// API CALL: GET-PARTS
  Future<PartsResponse?> _getParts() async => await todoListRepo.getParts();

  /// API CALL: GET-SUPPLIES
  Future<SuppliesResponse?> _getSupplies() async =>
      await todoListRepo.getSupplies();

  /// API CALL: GET-USER-GROUP
  Future<UserGroupResponse?> _getUserGroup() async =>
      await todoListRepo.fetchUserGroupingList();

}


class EditToDoInitialEvent {
}