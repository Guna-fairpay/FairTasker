import 'dart:async';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/helper.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'detailed_report_event.dart';
part 'detailed_report_state.dart';

class DetailedBloc extends Bloc<DetailedReportEvent, DetailedState> {
  int selectedPageIndex = 0;
  Map<String, dynamic>? _model;
  Map<String, dynamic>? _employeeTaskHistory;
  List<dynamic>? selectedCohorts = [];
  Map<String, dynamic>? selectedModel;
  List<Map<String, dynamic>>? tasks = [];
  List<Map<String, dynamic>>? taskByDay = [];
  List<Map<String, dynamic>>? _taskCategoryGroup;
  final APiRepository _aPiRepository = APiRepository();

  DateTime? selectedDate;

  List<dynamic> get _requiredCateIds => [1,4,2,3,58];
  List<int> get _customOrder => [1, 4, -1, 2, 3, 58, -2]; // Define your custom order

  List<Map<String, dynamic>> get _coHorts => [...getIt<CommonService>().cohortsList];
  List<Map<String, dynamic>> get _vehicles => [...getIt<CommonService>().activeVehicleList];

  List<Map<String, dynamic>> get _mainCategories {
    List<Map<String, dynamic>> taskCategory = [...(_taskCategoryGroup ?? [])];
    var mainCategories = taskCategory.where((element) => element['parent_id'].toString().isNullOrEmpty).toList();
    var subCategories = taskCategory.where((element) => !element['parent_id'].toString().isNullOrEmpty).toList();
    for (var element in mainCategories) {
      var sub = subCategories.where((e) => e['parent_id'].toString() == element['id'].toString()).toList();
      var subList = List<Map<String, dynamic>>.from(element['subcategories'] ?? []);
      subList.addAll(sub ?? []);
      element['subcategories'] = subList;
    }
    mainCategories.removeWhere((element) => !_requiredCateIds.contains(element['id']));
    return mainCategories;
  }
  DetailedBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
    on<ViewByEvent>(_onViewByEvent);
    on<ViewFilterEvent>(_onViewFilterEvent);
    on<FilterCohortEvent>(_onFilterCohortEvent);
    on<ViewURLEvent>(_onViewURLEvent);
  }

  Future<List<Map<String, dynamic>>?> _getCohorts() async => await getIt<CommonService>().getCohorts();
  Future<List<Map<String, dynamic>>?> _getActiveVehicles() async => await getIt<CommonService>().getActiveVehicles();
  Future<List<Map<String, dynamic>>?> _getTaskCategoryGroup() async => List<Map<String, dynamic>>.from((await _aPiRepository.getTaskCategoryGroup())?['data'] ?? []);
  Future<Map<String, dynamic>?> _getEmployeeHistoryByTask() async => await _aPiRepository.getEmployeeHistoryByTask(userId: _model?['user_id'], dateTimeString: selectedModel?['date'], cohorts: selectedCohorts);

  Future<void> _processData() async {
    try {

      var employeeTaskHistory = await _getEmployeeHistoryByTask();

      _employeeTaskHistory = (employeeTaskHistory?['history'] is Map) ? (employeeTaskHistory?['history']) : null;
      var activeHour = ((employeeTaskHistory?['activeHour'] is Map) ? (employeeTaskHistory?['activeHour']) : null)?['active_hours'];
      selectedModel?['activeHour'] = activeHour;

      var history = _employeeTaskHistory?.values.expand((element) => element).toList();
      tasks = _mainCategories;
      if (taskByDay?.isEmpty ?? false) taskByDay = List.from(history ?? []);
      taskByDay?.sort((a, b) => (a['todo_time'].compareTo(b['todo_time'])));
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
      // tasks?.removeWhere((element) => List.from(element['tasks'] ?? []).isEmpty);
      tasks?.sort((a, b) => a['id'].compareTo(b['id']));
      if (tasks?.isNotEmpty ?? false) {
        tasks?.add({"id": -1, "name": "Parts", "tasks": partsTasks});
        tasks?.add({"id": -2, "name": "Other", "tasks": history});
      }
      tasks?.sort((a, b) {
        int indexA = _customOrder.indexOf(a["id"] ?? 0);
        int indexB = _customOrder.indexOf(b["id"] ?? 0);
        return indexA.compareTo(indexB);
      });
    } catch(e) {
      rethrow;
    }
  }

  void _onInitialEvent(InitialEvent event, Emitter<DetailedState> emit) async {
    try {
      await CommonHelper.instance.waitForPostFrameCallback();
      _model = event.model;
      selectedModel = _model?['selectedList'];
      selectedDate = selectedModel?['date'].toString().toDateTime();
      Console.of.log(_model, name: "DetailedReportBloc");
      emit(LoadingState());
      await _getCohorts();
      await _getActiveVehicles();
      _taskCategoryGroup = await _getTaskCategoryGroup();
      selectedCohorts = [..._coHorts.map((e) => e['id']).toList(), ...[null]];
      await _processData();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  void _error(e, Emitter<DetailedState> emit) {
    Console.of.error("Error", error: e);
    emit(ErrorState(e));
  }

  void _onViewByEvent(ViewByEvent event, Emitter<DetailedState> emit) {
    selectedPageIndex = event.index;
    emit(CommonState());
  }

  void _onViewFilterEvent(ViewFilterEvent event, Emitter<DetailedState> emit) {
    emit(ViewFilterState(model: selectedCohorts));
  }

  void _onFilterCohortEvent(FilterCohortEvent event, Emitter<DetailedState> emit) async {
    try {
      selectedCohorts = event.model;
      emit(LoadingState());
      await _processData();
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  void _onViewURLEvent(ViewURLEvent event, Emitter<DetailedState> emit) {
    if (event.model.isNotNullOrEmpty) return emit(ViewURLState(url: event.model));
  }
}