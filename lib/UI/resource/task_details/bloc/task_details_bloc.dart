import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart' show DateRange;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:math';

part 'task_details_event.dart';
part 'task_details_state.dart';

class TaskDetailsBloc extends Bloc<TaskDetailsEvent, TaskDetailsState> {
  Map<String, dynamic>? _model;
  Map<String, dynamic>? _employeeTaskHistory;
  DateRange? dateRange;
  List<Map<String, dynamic>>? _taskCategoryGroup;
  List<Map<String, dynamic>>? tasks = [];
  List<dynamic>? selectedCohorts = [];
  List<Map<String, dynamic>>? configs = [];
  List<Map<String, dynamic>>? _configResponse = [];
  final APiRepository _apiRepository = APiRepository();
  TaskDetailsBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
    on<ViewFilterEvent>(_onViewFilterEvent);
    on<FilterCohortEvent>(_onFilterCohortEvent);
    on<ViewTaskDetailsEvent>(_onViewTaskDetailsEvent);
    on<ViewAmountSummaryEvent>(_onViewAmountSummaryEvent);
  }

  List<Map<String, dynamic>> get _configs => [...(_configResponse ?? [])];
  List<Map<String, dynamic>> get _coHorts => [...getIt<CommonService>().cohortsList];
  List<Map<String, dynamic>> get _vehicles => [...getIt<CommonService>().activeVehicleList];
  Future<List<Map<String, dynamic>>?> _getTaskCategoryGroup() async => List<Map<String, dynamic>>.from((await _apiRepository.getTaskCategoryGroup())?['data'] ?? []);
  Future<List<Map<String, dynamic>>?> _getCohorts() async => await getIt<CommonService>().getCohorts();
  Future<List<Map<String, dynamic>>?> _getActiveVehicles() async => await getIt<CommonService>().getActiveVehicles();
  Future<Map<String, dynamic>?> _getEmployeeTaskHistory() async => await _apiRepository.getEmployeeTaskHistory(userId: _model?['user_id'], from: dateRange?.start, to: dateRange?.end, cohorts: selectedCohorts);
  Future<Map<String, dynamic>?> _getConfiguration() async => await _apiRepository.getConfiguration();

  Future<void> _processData() async {
    try {
      List<Map<String, dynamic>> taskCategory = [...(_taskCategoryGroup ?? [])];
      var mainCategories = taskCategory.where((element) => element['parent_id'].toString().isNullOrEmpty).toList();
      var subCategories = taskCategory.where((element) => !element['parent_id'].toString().isNullOrEmpty).toList();
      for (var element in mainCategories) {
        var sub = subCategories.where((e) => e['parent_id'].toString() == element['id'].toString()).toList();
        var subList = List<Map<String, dynamic>>.from(element['subcategories'] ?? []);
        subList.addAll(sub ?? []);
        element['subcategories'] = subList;
      }
      var employeeTaskHistory = await _getEmployeeTaskHistory();

      _employeeTaskHistory = (employeeTaskHistory?['history'] is Map) ? (employeeTaskHistory?['history']) : null;

      /// TASK COUNT CALCULATIONS
      Map<String, dynamic>? taskCount = (employeeTaskHistory?['taskCount'] is Map) ? (employeeTaskHistory?['taskCount']) : null;
      var taskIds = taskCount?.keys.map((e) => e.toNumeric);
      var confs = _configs;
      confs.removeWhere((element) => !(taskIds?.contains(element['id']) ?? false));
      configs = confs.map((e) => e..['task_count'] = (taskCount?[e['id'].toString()] ?? 0)..['total'] = ((taskCount?[e['id'].toString()] ?? 0) * (e['amount'].toString().toNumeric))).toList();

      var history = _employeeTaskHistory?.values.expand((element) => element).toList();
      tasks = mainCategories;
      history?.forEach((element) {
        if (element['vin'].toString().isNotNullOrEmpty && element['vehicle_name'].toString().isNullOrEmpty) {
          element['vehicle_name'] = _vehicles.firstWhereOrNull((v) => v['vin'] == element['vin'])?['vehicle_name'] ?? "";
        }
      });

      var partsTasks = history?.where((element) => element['title'].toString().toLowerCase().contains("parts")).toList();
      history?.removeWhere((element) => partsTasks?.map((e) => e['id']).contains(element['id']) ?? false);
      tasks?.forEach((element) {
        var subCate = List<Map<String, dynamic>>.from(element['subcategories'] ?? []).map((e) => e['name'].toString().toLowerCase());
        var historyTasks = history?.where((element) => subCate.contains(element['title'].toString().toLowerCase())).toList();
        var partTasks = partsTasks?.where((element) => subCate.contains(element['title'].toString().toLowerCase())).toList();
        if (historyTasks?.isNotEmpty ?? false) history?.removeWhere((element) => historyTasks?.map((e) => e['id']).contains(element['id']) ?? false);
        if (partTasks?.isNotEmpty ?? false) partsTasks?.removeWhere((element) => partTasks?.map((e) => e['id']).contains(element['id']) ?? false);
        element['tasks'] = [...(historyTasks ?? []), ...(partTasks ?? [])];
      });
      tasks?.removeWhere((element) => List.from(element['tasks'] ?? []).isEmpty);
      tasks?.sort((a, b) => a['id'].compareTo(b['id']));
      if (tasks?.isNotEmpty ?? false) {
        tasks?.add({"id": 0, "name": "Parts", "tasks": partsTasks});
        tasks?.add({"id": -1, "name": "Other", "tasks": history});
      }
    } catch(e) {
      rethrow;
    }
  }

  void _onInitialEvent(InitialEvent event, Emitter<TaskDetailsState> emit) async {
    try {
      _model = event.model;
      dateRange = event.dateRange;
      emit(LoadingState());
      await _getCohorts();
      await _getActiveVehicles();
      _taskCategoryGroup = await _getTaskCategoryGroup();
      _configResponse = List.from((await _getConfiguration())?['data'] ?? []);
      selectedCohorts = [..._coHorts.map((e) => e['id']).toList(), ...[null]];
      await _processData();
      emit(CommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ErrorState(e));
    }
  }

  void _onViewFilterEvent(ViewFilterEvent event, Emitter<TaskDetailsState> emit) async {
    emit(ViewFilterState(model: selectedCohorts));
  }

  void _onViewAmountSummaryEvent(ViewAmountSummaryEvent event, Emitter<TaskDetailsState> emit) {
    emit(ViewAmountSummaryState(_model?['name'] ?? "", (tasks?.isEmpty ?? false) ? [] : configs));
  }

  void _onFilterCohortEvent(FilterCohortEvent event, Emitter<TaskDetailsState> emit) async {
    try {
      selectedCohorts = event.model;
      emit(LoadingState());
      await _processData();
      emit(CommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ErrorState(e));
    }
  }

  void _onViewTaskDetailsEvent(ViewTaskDetailsEvent event, Emitter<TaskDetailsState> emit) {
    emit(ViewTaskDetailsState(event.model));
  }
}