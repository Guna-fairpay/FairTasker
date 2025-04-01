
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/Response/task_response.dart';
import 'package:fairpytasker/Response/todo_list_response.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/timeday_extension.dart';
import 'package:fairpytasker/core/app/helper/custom_search_data_converter.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
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
import '../../../../core/app/helper/toaster.dart';
import '../../add_todo/add_todo_const.dart';
import '../event/edit_todo_event.dart';
import '../state/edit_todo_state.dart';

class EditToDoBloc extends Bloc<EditToDoEvent, EditTodoState> {
  final TodoListRepo todoListRepo = TodoListRepo();
  final APiRepository apiRepository = APiRepository();
  dynamic todoId = '';
  final TextEditingController taskNameController = TextEditingController();
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
  String? get currentUserId => Session.of.getString(Str.userIdPrefText);
  int? get branchId => Session.of.getInt(Str.branchIdPrefText);
  String? departmentId; // LoggedIn User department ID
  List<String> selectedIds = [];
  List<Map<String, dynamic>> vehicleList = [];
  List<Map<String, dynamic>> partList = [];
  List<Map<String, dynamic>> suppliesList = [];
  List<dynamic> vinList = [];
  List<dynamic> linkSelection = [];
  List<dynamic> images = [];
  List<dynamic> todoImages = [];
  Map<String,dynamic> selectionTaps={};
  final FBroadcast _broadcast = FBroadcast.instance();
  dynamic selectedSentiments = {};
  List<dynamic>vehicleData=[];

  EditToDoBloc()
      : super(EditTodoState(
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
          selectedVehicle: const{},
          groupVehicles: const [],
          sentiments: AddToDoConfig.sentiments,
          selectedSentiment: const {},
          popUpdatePage: false,
      )) {

    on<GetEditTodoInitialEvent>((event, emit) async {
      emit(state.copyWith());
      todoId = event.todoId;
      // PROCEED API CALL
      try {
        emit(state.copyWith(isLoading: true));
        var response = await Future.wait([
          _editTodoData(todoId),
          // _getTasks(),
          // _getVehicles(),
          // _getVendors(),
          // _getLocations(),
          // _getParts(),
          // _getSupplies(),
          // _getResources(),
          // _getUserGroup(),
        ]);

        var partsResponse = await getIt<CommonService>().getPartsList();
        var suppliesResponse = await getIt<CommonService>().getSuppliesList();
        var vehicleResponse = await getIt<CommonService>().getActiveVehicles();
        var vendorResponse = await getIt<CommonService>().getVendorsList();
        var locationResponse = await getIt<CommonService>().getLocationsList();
        var taskResponse = await getIt<CommonService>().getTaskExpenseData();
        var userGroupResponse = await getIt<CommonService>().getGroupPersons();
        var assignedToResponse = await getIt<CommonService>().getResources();
        TodoListResponse? todoResponse = ((response[0] is TodoListResponse)
            ? response[0]
            : null);
        // TaskExpenseResponse? taskResponse =
        //     ((response[1] is TaskExpenseResponse) ? response[1] : null)
        //         as TaskExpenseResponse?;
        // VehicleListResponse? vehicleResponse =
        //     ((response[2] is VehicleListResponse) ? response[2] : null)
        //         as VehicleListResponse?;
        // VendorResponse? vendorResponse = ((response[3] is VendorResponse)
        //     ? response[3]
        //     : null) as VendorResponse?;
        // LocationResponse? locationResponse = ((response[4] is LocationResponse)
        //     ? response[4]
        //     : null) as LocationResponse?;
        // PartsResponse? partsResponse = ((response[5] is PartsResponse)
        //     ? response[5]
        //     : null) as PartsResponse?;
        // SuppliesResponse? suppliesResponse = ((response[6] is SuppliesResponse)
        //     ? response[6]
        //     : null) as SuppliesResponse?;
        // AssignedToResponse? assignedToResponse =
        //     ((response[7] is AssignedToResponse) ? response[7] : null)
        //         as AssignedToResponse?;
        // UserGroupResponse? userGroupResponse =
        //     ((response[8] is UserGroupResponse) ? response[8] : null)
        //         as UserGroupResponse?;
        var groupVehiclesResponse = await _getGroupVehicles();
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
        taskNameController.text = todoResponse?.editTodos?['title'] ?? '';
        timeController.text = todoResponse?.editTodos?['todo_time'] ?? '';
        dateController.text = todoResponse?.editTodos?['todo_date'] ?? '';
        notesController.text = todoResponse?.editTodos?['notes'] ?? '';
        departmentId = selectedUser.firstOrNull?['department'].toString();
        customLinkController.text =
            todoResponse?.editTodos?['reference_id'] ?? '';
        tripDrivenController.text=todoResponse?.editTodos?['trip_driven'] ?? '';
        resolutionNotesController.text=todoResponse?.editTodos?['resolution_notes'] ?? '';
        commentsController.text=todoResponse?.editTodos?['comments'] ?? '';

        if (todoResponse?.editTodos?['trip_review'] != null) {
          selectedSentiments= AddToDoConfig.sentiments.firstWhereOrNull(
                  (element) => element['name']==todoResponse?.editTodos?['trip_review'])??{};
        }
        log(selectedSentiments.toString(),name: "Selected_Sentiments");
        linkSelection = AddToDoConfig.customOptions
            .where((element) =>
        element['id']?.toString() == todoResponse?.editTodos?['custom_link_id']?.toString())
            .toList();

        if (linkSelection.isEmpty) {
          linkSelection = [AddToDoConfig.customOptions[1]];
        }

        if (todoResponse?.editTodos?['vin'] != null) {
          vinList = [todoResponse?.editTodos?['vin']];
        } else {
          List<dynamic>? vehicles = todoResponse?.editTodos?['vehicles'];
          if (vehicles is List && vehicles.isNotEmpty) {
            vinList = vehicles
                .map((v) => v['vin'])
                .where((vin) => vin != null)
                .toList();
          }
        }
        if (vinList.isNotEmpty) {
          vehicleList = vehicleResponse
              .where((element) => vinList.contains(element['vin'].toString()))
              .toList();
        }
        // log(vehicleList.toString(), name: "Vehicle List");
        List<dynamic> vendors = [];
        List<dynamic> locations = [];
        if (todoResponse?.editTodos?['location_id'] != null) {
          locations = locationResponse
              .where((element) =>
                  element['id'].toString() ==
                  todoResponse?.editTodos?['location_id'])
              .toList();
        }
        if (todoResponse?.editTodos?['vendor_id'] != null) {
          vendors = vendorResponse
              .where((element) =>
                  element['id'].toString() ==
                  todoResponse?.editTodos?['vendor_id'])
              .toList();
        }

        if (todoResponse?.editTodos?['user_id'] != null) {
          selectedIds =
              ((todoResponse?.editTodos?['user_id']).toString()).split(',');
        }
        if (todoResponse?.editTodos?['user_group_id'] != null) {
          for (var group in userGroupResponse) {
            if (group['id'] == todoResponse?.editTodos?['user_group_id']) {
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
        if ((todoResponse?.editTodos?['parts'] as List).isNotEmpty) {
          partsId = todoResponse?.editTodos?['parts']
              .map((e) => e['parts_id'])
              .where((element) => element != null)
              .toList();
        }

        if (partsId.isNotEmpty) {
          partList = partsResponse
              .where((element) => partsId.contains(element['id'].toString()))
              .toList();
        }
       // log(partList.toString(), name: "Parts List");


        List<dynamic> suppliesId = [];
        if ((todoResponse?.editTodos?['supplies'] as List).isNotEmpty) {
          suppliesId = todoResponse?.editTodos?['supplies']
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

        showPlatformCheck = Str.platFormCheckIds.contains(todoResponse?.editTodos?['identifier_id']);

        images=todoResponse?.editTodos?['todoimages'];

        todoImages=images.map((e) => e['path'].toString().toAttachmentURL).toList();

        final title = todoResponse?.editTodos?['title'];
        final vehicleExists = todoResponse?.editTodos?['vehicle_name'] != null ||
            todoResponse?.editTodos?['vin'] != null ||
            (todoResponse?.editTodos?['vehicles']?.isNotEmpty ?? false);

        final List<Map<String, dynamic>> tabs = [
          if (!['Check In', 'Check Out'].contains(title)) {"id": 1, "title": "Expense"},
          {"id": 2, "title": "Next Task"},
          if (title == 'Pre Checks') {"id": 3, "title": "Check List"},
          if (title == 'Maintenance Check') {"id": 4, "title": "Maintenance"},
          if (!['Check In', 'Check Out'].contains(title) && vehicleExists)
            {"id": 5, "title": "Set Vehicle"},
          if(title == 'Private Rental Check') {"id": 6, "title": "Private Rental Check"}, //Add by RDB
        ];

        selectionTaps = tabs.firstWhere(
              (e) => (title == "Pre Checks" && e['title'] == "Check List") ||
              (title == "Maintenance Check" && e['title'] == "Maintenance"),
          orElse: () => tabs.isNotEmpty ? tabs[0] : {},
        );

        log("$vinList",name: "vinLIST");
        log("$selectedIds",name: "selectedIds");

        var selectedPerson = resources.where((element) => element['id'].toString() == todoResponse?.editTodos?['person_id'].toString()).toList();
        var selectedGroupVehicles = groupVehiclesResponse.where((element) => element['id'].toString() == todoResponse?.editTodos?['vehicle_group_id'].toString()).toList();

        var selectedTask = taskResponse.firstWhereOrNull((element) => element['id']==todoResponse?.editTodos?['identifier_id']);
        vehicleData=todoResponse?.editTodos?['vehicles']??[];
        emit(state.copyWith(
          isLoading: false,
          bottomTapData: tabs,
          resourceName: list,
          apiResponse: todoResponse?.editTodos,
          todoStatus: todoResponse?.editTodos?['status'] == 'In Progress'
              ? false
              : true,
          selectedBottomTap: selectionTaps,
          tasks: taskResponse,
          selectedTask: selectedTask,
          selectedVPerson:
              CustomSearchDataConverter.convertVPerson(vehicles: vehicleList,persons: selectedPerson, groupVehicles: selectedGroupVehicles),
          selectedVLocations: CustomSearchDataConverter.convertVLocation(
              vendors: vendors, locations: locations)
              .firstOrNull ?? {},
          selectedDate: todoResponse?.editTodos?['todo_date']
              .toString()
              .toDateTime(inputFormat: 'yyyy-MM-dd'),
          selectedTime: todoResponse?.editTodos?['todo_time']
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
          selectedLinkOption:linkSelection.first,
          selectedResource: selectedIds,
          isPartServiceEnable:
              (todoResponse?.editTodos?['parts'] as List).isNotEmpty,
          isSuppliesEnable:
              (todoResponse?.editTodos?['supplies'] as List).isNotEmpty,
          selectedParts: partList,
          selectedSupplies: suppliesList,
          title: todoResponse?.editTodos?['title'] ?? '',
          selectedVehicle: vehicleList.firstOrNull,
          taskHistory: vehicleList,
          showPlatformCheck: showPlatformCheck,
          isSelectedPlatformCheck:todoResponse?.editTodos?['platform_check'] == 1?true:false,
          isTimeSensitive: todoResponse?.editTodos?['time_sensitive'] == 1?true:false,
          todoAttachments: todoImages,
          groupVehicles: groupVehiclesResponse,
          selectedSentiment: selectedSentiments,

        ));
        await Future.delayed(Durations.extralong4, () => partsBroadcastEvent(partList));
        await Future.delayed(Durations.extralong4, () => suppliesBroadcastEvent(suppliesList));
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
        emit(state.copyWith(selectedTask: event.selectedTask));
    });

    // on<EditToDoVPersonEvent>((event, emit) {
    //   var existingVPersons =
    //   List<Map<String, dynamic>>.from(state.selectedVPerson);
    //   if (( ['person', 'g_vehicles'].contains(event.vPerson.first['type']))) {
    //     existingVPersons.clear();
    //   }
    //   if (existingVPersons
    //       .where((element) => element['type'] == 'person')
    //       .isNotEmpty &&
    //       event.vPerson.first['type'] == 'person') {
    //     existingVPersons.clear();
    //   }
    //   existingVPersons.addAll(event.vPerson);
    //   existingVPersons = existingVPersons.unique((element) => element['id']);
    //   existingVPersons.removeWhere((element) =>
    //   element['type'] ==
    //       (( ['person', 'g_vehicles'].contains(event.vPerson.first['type'])) ? 'vehicles' : 'person'));
    //   emit(state.copyWith(
    //       selectedVPerson: existingVPersons,));
    // });

    on<EditToDoVPersonEvent>((event, emit) {
      var existingVPersons =
      List<Map<String, dynamic>>.from(state.selectedVPerson);
      String? type = existingVPersons.isNotEmpty ? existingVPersons.first['type'] : null;
      String newType = event.vPerson.first['type'];
      if (['person', 'g_vehicles'].contains(newType)) {
        existingVPersons.clear();
      }
      if (type != null && type != newType) {
        existingVPersons.clear();
      }
      existingVPersons.addAll(event.vPerson);
      existingVPersons = existingVPersons.unique((element) => element['id']);
      log(existingVPersons.toString(),name: "existingVPersons");
      emit(state.copyWith(
        selectedVPerson: existingVPersons,));
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
      bool? status =  event.todoStatus;
      log(status.toString(),name: 'STATUS');
      emit(state.copyWith(isLoading: true));
      try {
        emit(state.copyWith(isLoading: true));
        await apiRepository.completeToDo(todoId, status: status! );

      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(),name: 'ERROR');
        emit(state.copyWith(isLoading: false));
      }
      emit(state.copyWith(todoStatus: !state.todoStatus,isLoading: false));
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

    on<EditToDoPartSelectionEvent>((event, emit) {
      var existing = List.from(state.selectedParts);
      if (event.isChecked) {
        if (!existing.contains(event.part)) existing.add(event.part);
      } else {
        if (existing.contains(event.part)) existing.remove(event.part);
      }
      partsBroadcastEvent(existing);
      // FBroadcast.instance().broadcast("Parts",value: existing, persistence: true);
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
      suppliesBroadcastEvent(existing);
     // FBroadcast.instance().broadcast("Supplies",value:existing);

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
        if (!existing.contains(event.data)) existing.add(event.data);
      } else {
        if (existing.contains(event.data)) existing.remove(event.data);
      }
      emit(state.copyWith(addresses: existing));
    });

    on<EditToDoSelectTaskHistoryEvent>((event, emit) =>
        emit(state.copyWith(selectedVehicle: event.selectTaskHistory)));

    on<EditToDoDeleteVehicleEvent>((event, emit) async {
      try {
        emit(state.copyWith(isLoading: true));
        var id = vehicleData.firstWhereOrNull((element) => element['vin'] == event.vehicleId)?['id'];
        vinList.removeWhere((element) => event.vehicleId.contains(element),);
        await apiRepository.deleteTodoVehicle(id:"$id");
        _broadcast.stickyBroadcast("todo_view", value:true);
        emit(state.copyWith(isLoading: false));
      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(),name: 'ERROR');
       // emit(state.copyWith(isLoading: false));
    }
    });

    on<DeleteTodoEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        await apiRepository.deleteTodo(id: event.todoId,reason: event.reason);
      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(),name: 'ERROR');
      }
      emit(state.copyWith(isLoading: false));
    });

    on<RemoveImageEvent>((event, emit) async {
      if (event.data == null) return;
      if (event.data is File) {
        // LOCAL SELECTION REMOVE
        state.todoAttachments.remove(event.data);
        todoImages = state.todoAttachments;
      } else if (event.data is String) {
        // REMOTE SELECTION REMOVE
        var data = todoImages.firstWhereOrNull(
                (element) => element == event.data.toString());

        var attachmentId = images
            .where((element) => element['path'] == data.toString().removeStorageUrl)
            .map((e) => e['id'])
            .firstOrNull;
        emit(state.copyWith(isLoading: true));
        await apiRepository.deleteTodoImage(attachmentId);
        emit(state.copyWith(isLoading: false));
        // once success remove from attachments
        todoImages.remove(event.data);
      }
      emit(state.copyWith(todoAttachments: todoImages));
    });

    on<EditToDoSaveEvent>((event, emit) async {
      // VALIDATIONS MANDATORY
      // IF DEPARTMENT IS 7 THEN PLATFORM CHECK
      // TASK NAME
      // TASK MANAGER
      if (taskNameController.text.isEmpty) {
        Toaster.showError("Task name is required");
        return;
      }

      var isPlatformRequired = Str.platFormCheckIds.contains(state.selectedTask['id']) && departmentId == '7' && !state.isSelectedPlatformCheck;
      if (isPlatformRequired) {
        Toaster.showError("Platform check is required");
        return;
      }
      // API CALL
      try {
        emit(state.copyWith(isLoading: true));
        var response = await apiRepository.updateToDoApi(todoId: "${state.apiResponse['id']}",
            images: state.todoAttachments.whereType<File>().toList(), body: _editTodoBody());
        if (response?.isNotEmpty ?? false) Toaster.showSuccess(response?['message'] ?? "Success");
        _broadcast.stickyBroadcast("todo_view", value:true);
        emit(state.copyWith(isLoading: false));
        if (response?['status'] == 200) emit(state.copyWith(redirect: true));
      } catch (e) {
        Toaster.showError("$e");
        log(e.toString(),name: 'ERROR');
        emit(state.copyWith(isLoading: false));
      }
    });

  }

  Map<String, String> _editTodoBody() {

    state.selectedVPerson.removeWhere((element) => vinList.contains(element['value']['vin']));

    Map<String, String> baseBody = {};

    baseBody['title'] = taskNameController.text;
    baseBody['identifier_id'] = "${state.apiResponse['identifier_id']}";
    baseBody['todo_time'] = state.selectedTime.toHMS().toString();
    baseBody['todo_date'] = dateController.text;
    baseBody['reminder'] = state.apiResponse['reminder']==true?'true':'false';
    baseBody['notes'] = notesController.text;
    baseBody['comments'] = commentsController.text;
    baseBody['resolution_notes'] = resolutionNotesController.text;
    baseBody['platform_check'] = state.isSelectedPlatformCheck ? "1" : "0";
    baseBody['time_sensitive'] = state.isTimeSensitive ? '1' : '0';
    baseBody['odometer'] = odometerController.text;
    baseBody['todo_user_type'] = "0";
    baseBody['comments'] = "";
    baseBody['mileage'] = "";
    baseBody['resolution_notes'] = "";
    baseBody['custom_link_id'] = "${state.selectedLinkOption?['id'] ?? ""}";
    baseBody['trip_review'] = "${state.selectedSentiment?['name'] ?? ""}";
    baseBody['trip_driven'] = tripDrivenController.text;
    baseBody['custom_link'] = (state.selectedLinkOption?['id'] == 1)
        ? customLinkController.text
        : "";
    baseBody['reference_id'] = (state.selectedLinkOption?['id'] != 1)
        ? customLinkController.text
        : "";
    if(state.selectedResource.isNotEmpty){
      if (state.selectedResource.length == 1) {
        baseBody['user_id'] = state.selectedResource.first.toString();
        baseBody['assigned_to'] = state.selectedResource.first;
      }
      else if (state.selectedResource.length > 1) {
        baseBody['user_group_data'] = "${state.selectedResource}";
        baseBody['assigned_to'] = "${state.selectedResource}";
      }
    }

      baseBody['parts']= "${state.selectedParts.isEmpty
          ? null
          : state.selectedParts.map((e)=>jsonEncode({
        "parts_id": "${e['id']}",
        "parts_name": "${e['name']}",
      }) ).toList()}";

    baseBody['supplies'] = "${state.selectedSupplies.isEmpty
          ? null
          : state.selectedSupplies.map((e)=>jsonEncode({
      "supplies_id": "${e['id']}",
      "supplies_name": "${e['name']}",
    }) ).toList()}";

    if(state.selectedVLocations.isNotEmpty) {
      if (state.selectedVLocations['type'] == "location") {
        baseBody['location'] = "${state.selectedVLocations['name'] ?? ''}";
        baseBody['location_id'] = "${state.selectedVLocations['id'] ?? ''}";
      }
      if (state.selectedVLocations['type'] == "vendor") {
        baseBody['vendor'] = "${state.selectedVLocations['name'] ?? ''}";
        baseBody['vendor_id'] = "${state.selectedVLocations['id'] ?? ''}";
      }
    }
    baseBody['vehicles']= "${state.selectedVPerson
          .where((element) => element['type'] == "vehicles")
          .map((e) => e['value'])
          .map((e) => jsonEncode({
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

    var groupVehicleList = state.selectedVPerson
        .where((element) => element['type'] == "g_vehicles")
        .toList();

    var groupVehicleId = groupVehicleList.isNotEmpty ? groupVehicleList.first : null;

    baseBody['vehicle_group_id'] = groupVehicleId?['id']?.toString() ?? "";


    log(jsonEncode(baseBody), name: "EDIT_TODO_BODY");
    return baseBody;
  }

  void partsBroadcastEvent( dynamic value, ) {
   // log(value.toString(), name: "Parts Broadcast");
    FBroadcast.instance().broadcast("Parts", value: value, persistence: true);
  }

  void suppliesBroadcastEvent( dynamic value, ) {
    FBroadcast.instance().broadcast("Supplies", value: value, persistence: true);
  }

  void vendorBroadcastEvent( dynamic value,) {
    log(value.toString(), name: "Parts Broadcast");
    FBroadcast.instance().broadcast("Vendor", value: value, persistence: true);
  }



  // PICK MULTI IMAGES / FILES
  Future<List<File>?> _pickFiles() async {
    var result = await ImagePicker().pickMultiImage();
    return result.map((e) => File(e.path)).toList();
  }

  ///API CALL: EDIT TODO DATA
  Future<TodoListResponse?> _editTodoData(dynamic todoId) async =>
      await todoListRepo.editTodoData(id: todoId);

  /// API CALL: TASKS
  Future<TaskExpenseResponse?> _getTasks() async =>
      await todoListRepo.getTaskExpense();

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

  /// API CALL: GET-USER-GROUP
  Future<List<Map<String,dynamic>>> _getGroupVehicles() async =>
      await getIt<CommonService>().groupVehicles();

  var tabs = List.from(AddToDoConfig.editTodoBottomTaps);

}

class EditToDoInitialEvent {}
