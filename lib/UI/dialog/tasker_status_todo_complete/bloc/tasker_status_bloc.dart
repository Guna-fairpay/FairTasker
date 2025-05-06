import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fairpytasker/UI/dialog/tasker_status_todo_complete/bloc/tasker_status_event.dart';
import 'package:fairpytasker/UI/dialog/tasker_status_todo_complete/bloc/tasker_status_state.dart';
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
  final FocusNode customFocusNode = FocusNode();
  List<Map<String, dynamic>>? _resources, _vendors, _locations;
  final TextEditingController taskController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  Map<String, dynamic>? _model, selectedResource, selectedVendorLocation, selectedAddress;
  final TextEditingController addressController = TextEditingController();
  final TextEditingController vendorLocationController = TextEditingController();
  final MultiSelectController<Map<String,dynamic>> controller = MultiSelectController<Map<String,dynamic>>();

  TaskerStatusBloc() : super(TaskerStatusLoadingState()) {
    on<TaskerStatusInitialEvent>(_onInitialEvent);
    on<TaskerStatusDateEvent>(_onDateEvent);
    on<TaskerStatusTimeEvent>(_onTimeEvent);
    on<TaskerStatusSelectTaskEvent>(_onSelectTaskEvent);
    on<TaskerStatusSelectResourceEvent>(_onSelectResourceEvent);
    on<TaskerStatusVendorLocationEvent>(_onSelectVendorLocationEvent);
    on<TaskerStatusAddressEvent>(_onSelectAddressEvent);
  }

  Future<List<Map<String, dynamic>>> _fetchResources() async => await getIt<CommonService>().getResources();
  Future<List<Map<String, dynamic>>> _fetchVendors() async => await getIt<CommonService>().getVendorsList();
  Future<List<Map<String, dynamic>>> _fetchLocations() async => await getIt<CommonService>().getLocationsList();
  List<Map<String, dynamic>> get resourcesList => _resources?.where((element) => element['branch_id'] == getIt<CommonService>().branchId).toList() ?? [];
  List<Map<String, dynamic>> get vendorsList => _vendors ?? [];
  List<Map<String, dynamic>> get locationsList => _locations ?? [];
  List<Map<String, dynamic>> get addressList => List.from(selectedVendorLocation?['value']['addresses'] ?? []);

  void _onInitialEvent(TaskerStatusInitialEvent event, Emitter<TaskerStatusState> emit) async {
    try {
      _model = event.model;
      _checkLists = List.from(event.model?['statusTodo']?['checklist']);
      selectedCategory = _checkLists?.firstWhereOrNull((element) => [(_model?['vehicle_status_category'])].contains(element['id']));
      tasks = List.from(selectedCategory?['checklists']);
      controller.addItems(tasks?.map((e) => DropdownItem<Map<String, dynamic>>(value: e, label: (e['checklist_name'] ?? ""))).toList() ?? []);
      _resources = await _fetchResources();
      _vendors = await _fetchVendors();
      _locations = await _fetchLocations();
      Console.of.log(tasks);
      emit(TaskerStatusCommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(TaskerStatusErrorState(e));
    }
  }

  void _onDateEvent(TaskerStatusDateEvent event, Emitter<TaskerStatusState> emit) {
    selectedDate = event.model;
    emit(TaskerStatusCommonState());
  }

  void _onTimeEvent(TaskerStatusTimeEvent event, Emitter<TaskerStatusState> emit) {
    selectedTime = event.model;
    emit(TaskerStatusCommonState());
  }

  void _onSelectTaskEvent(TaskerStatusSelectTaskEvent event, Emitter<TaskerStatusState> emit) {
    selectedTasks = event.model;
    taskFocusNode.unfocus();
    controller.items.removeWhere((element) => !(selectedTasks?.contains(element.value) ?? false));
    emit(TaskerStatusCommonState());
  }

  void _onSelectResourceEvent(TaskerStatusSelectResourceEvent event, Emitter<TaskerStatusState> emit) {
    selectedResource = event.model;
    emit(TaskerStatusCommonState());
  }

  void _onSelectVendorLocationEvent(TaskerStatusVendorLocationEvent event, Emitter<TaskerStatusState> emit) {
    selectedVendorLocation = event.model;
    emit(TaskerStatusCommonState());
  }

  void _onSelectAddressEvent(TaskerStatusAddressEvent event, Emitter<TaskerStatusState> emit) {
    selectedAddress = event.model;
    emit(TaskerStatusCommonState());
  }
}