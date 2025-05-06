import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/dialog/tasker_status_todo_complete/bloc/tasker_status_event.dart';
import 'package:fairpytasker/UI/dialog/tasker_status_todo_complete/bloc/tasker_status_state.dart';
import 'package:fairpytasker/UI/tasker/helper/tasker_helper.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/timeday_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class TaskerStatusBloc extends Bloc<TaskerStatusEvent, TaskerStatusState> {
  dynamic selectedCategory;
  List<Map<String, dynamic>>? tasks;
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>>? _checkLists;
  TimeOfDay selectedTime = TimeOfDay.now();
  List<Map<String, dynamic>>? selectedTasks;
  final FocusNode taskFocusNode = FocusNode();
  final FocusNode notesFocusNode = FocusNode();
  Map<String, dynamic>? _vehicleStatusResponse;
  final FocusNode customFocusNode = FocusNode();
  List<Map<String, dynamic>>? _resources, _vendors, _locations;
  final TextEditingController taskController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  Map<String, dynamic>? _model, selectedVendorLocation, selectedAddress;
  dynamic selectedResource;
  final TextEditingController addressController = TextEditingController();
  final TextEditingController vendorLocationController =
      TextEditingController();
  final MultiSelectController<Map<String, dynamic>> controller =
      MultiSelectController<Map<String, dynamic>>();

  int get _currentUserId => getIt<CommonService>().userId;
  final APiRepository _aPiRepository = APiRepository();

  TaskerStatusBloc() : super(TaskerStatusLoadingState()) {
    on<TaskerStatusInitialEvent>(_onInitialEvent);
    on<TaskerStatusDateEvent>(_onDateEvent);
    on<TaskerStatusTimeEvent>(_onTimeEvent);
    on<TaskerStatusSelectTaskEvent>(_onSelectTaskEvent);
    on<TaskerStatusSelectResourceEvent>(_onSelectResourceEvent);
    on<TaskerStatusVendorLocationEvent>(_onSelectVendorLocationEvent);
    on<TaskerStatusAddressEvent>(_onSelectAddressEvent);
    on<TaskerStatusSaveEvent>(_onSaveEvent);
    on<TaskerStatusIgnoreEvent>(_onIgnoreEvent);
  }

  Future<List<Map<String, dynamic>>> _fetchResources() async =>
      await getIt<CommonService>().getResources();

  Future<List<Map<String, dynamic>>> _fetchVendors() async =>
      await getIt<CommonService>().getVendorsList();

  Future<List<Map<String, dynamic>>> _fetchLocations() async =>
      await getIt<CommonService>().getLocationsList();

  Future<Map<String, dynamic>?> _addToDo(Map<String, dynamic> body) async =>
      await _aPiRepository.vehicleStatusCreateTask(body: body);

  Future<Map<String, dynamic>?> _vehicleUpdateStatus(
          Map<String, dynamic> body, dynamic vin) async =>
      await _aPiRepository.vehicleStatusUpdateApi(body: body, vin: vin);

  List<dynamic> get resourcesList =>
      _resources
          ?.where((element) =>
              element['branch_id'] == getIt<CommonService>().branchId)
          .toList() ??
      [];

  List<Map<String, dynamic>> get vendorsList => _vendors ?? [];

  List<Map<String, dynamic>> get locationsList => _locations ?? [];

  List<Map<String, dynamic>> get addressList =>
      List.from(selectedVendorLocation?['value']['addresses'] ?? []);

  String _checkListName(dynamic value, dynamic statusId) {
    String suffix = switch (statusId) {
      1 => "Buy",
      2 => "Recon",
      3 => "Rental",
      4 => "Repair",
      5 => "Presale",
      7 => "Sold",
      _ => "",
    };
    return "${value ?? ""} - $suffix";
  }

  Map<String, dynamic> get _statusUpdateBody => {
        "config_id": [ (_model?['vehicle_status_id'] ?? 0) ],
        "category_id": (_model?['vehicle_status_category'] ?? 0),
        "vin": _model?['vin'] ?? "",
        "checklist_id": [ (_model?['vehicle_status_checklist'] ?? 0) ],
        "checkbox_value": 1
      };

  Map<String, dynamic> _addToDoBody() {
    Map<String, dynamic>? cohort =
        List.from(_model?['display']?['vehicles']).firstOrNull?['cohort'];
    Map<String, dynamic>? vehicle =
        List.from(_model?['display']?['vehicles']).firstOrNull;
    Map<String, dynamic> body = {
      "cohort_id": cohort?['id'] ?? "",
      "cohort_name": cohort?['cohort'] ?? "",
      "custom_task": taskController.text,
      "notes": notesController.text,
      "start_at": selectedDate.toFormat() ?? "",
      "statusTask": controller.selectedItems
          .map((e) => e.value)
          .map((e) => {
                "title": _checkListName(
                    e['checklist_name'], (e['category_id'] ?? 0)),
                "vehicle_status_category": e['category_id'] ?? 0,
                "vehicle_status_checklist": e['checklist_id'] ?? 0,
                "vehicle_status_id": e['id'] ?? 0,
              })
          .toList(),
      "todo_time": selectedTime.toHMS() ?? "",
      "user_id": selectedResource?['id'] ?? "",
      "vehicle_name": vehicle?['vehicle_name'] ?? "",
      "vehicle_status_category": _model?['vehicle_status_category'],
      "vin": vehicle?['vin'] ?? "",
    };
    if (selectedVendorLocation != null) {
      if (selectedVendorLocation?['type'] == "location") {
        body["location"] = selectedVendorLocation?['name'] ?? "";
        body["location_id"] = selectedVendorLocation?['id'] ?? "";
      } else {
        body["vendor_name"] = selectedAddress?['name'] ?? "";
        body["vendor_id"] = selectedAddress?['id'] ?? "";
      }
    }
    if (selectedAddress != null) {
      // body["address"] = [selectedAddress?['id'] ?? ""];
    }
    return body;
  }

  void _onInitialEvent(
      TaskerStatusInitialEvent event, Emitter<TaskerStatusState> emit) async {
    try {
      emit(TaskerStatusLoadingState());
      _model = event.model;
      _checkLists = List.from(event.model?['statusTodo']?['checklist']);
      selectedCategory = _checkLists?.firstWhereOrNull((element) =>
          [(_model?['vehicle_status_category'])].contains(element['id']));
      tasks = List.from(selectedCategory?['checklists']);
      controller.addItems(tasks
              ?.map((e) => DropdownItem<Map<String, dynamic>>(
                  value: e, label: (e['checklist_name'] ?? "")))
              .toList() ??
          []);
      _resources = await _fetchResources();
      _vendors = await _fetchVendors();
      _locations = await _fetchLocations();
      selectedResource = _resources
          ?.firstWhereOrNull((element) => element['id'] == _currentUserId);
      _vehicleStatusResponse = await _vehicleUpdateStatus(_statusUpdateBody, _model?['vin']);
      Console.of.log(_vehicleStatusResponse, name: "RESPONSE");
      emit(TaskerStatusCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(TaskerStatusErrorState(e));
    }
  }

  void _onDateEvent(
      TaskerStatusDateEvent event, Emitter<TaskerStatusState> emit) {
    selectedDate = event.model;
    emit(TaskerStatusCommonState());
  }

  void _onTimeEvent(
      TaskerStatusTimeEvent event, Emitter<TaskerStatusState> emit) {
    selectedTime = event.model;
    emit(TaskerStatusCommonState());
  }

  void _onSelectTaskEvent(
      TaskerStatusSelectTaskEvent event, Emitter<TaskerStatusState> emit) {
    selectedTasks = event.model;
    taskFocusNode.unfocus();
    controller.items.removeWhere(
        (element) => !(selectedTasks?.contains(element.value) ?? false));
    emit(TaskerStatusCommonState());
  }

  void _onSelectResourceEvent(
      TaskerStatusSelectResourceEvent event, Emitter<TaskerStatusState> emit) {
    selectedResource = event.model;
    emit(TaskerStatusCommonState());
  }

  void _onSelectVendorLocationEvent(
      TaskerStatusVendorLocationEvent event, Emitter<TaskerStatusState> emit) {
    selectedVendorLocation = event.model;
    emit(TaskerStatusCommonState());
  }

  void _onSelectAddressEvent(
      TaskerStatusAddressEvent event, Emitter<TaskerStatusState> emit) {
    selectedAddress = event.model;
    emit(TaskerStatusCommonState());
  }

  void _onSaveEvent(
      TaskerStatusSaveEvent event, Emitter<TaskerStatusState> emit) async {
    try {
      Console.of.log(jsonEncode(_addToDoBody()));
      var response = await _addToDo(_addToDoBody());
      if (response != null) {
        TaskerHelper.instance.refresh();
        emit(TaskerStatusCompleteState());
      }
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(TaskerStatusErrorState(e));
    }
  }

  void _onIgnoreEvent(
      TaskerStatusIgnoreEvent event, Emitter<TaskerStatusState> emit) {}
}
