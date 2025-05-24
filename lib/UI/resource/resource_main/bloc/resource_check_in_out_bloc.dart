import 'dart:async';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/int_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart' show DateRange;

part 'resource_check_in_out_event.dart';

part 'resource_check_in_out_state.dart';

class ResourceCheckInOutBloc extends Bloc<ResourceCheckInOutEvent, ResourceCheckInOutState> {
  final APiRepository _aPiRepository = APiRepository();
  DateRange? selectedDateRange = DateRange(DateTime.now().subtract(const Duration(days: 7)), DateTime.now());
  dynamic selectedResource;

  List<dynamic> get _currentBranchHrmIds => getIt<CommonService>().currentBranchHrmIds;

  List<Map<String, dynamic>> get resources {
    var list = [...getIt<CommonService>().resourcesList];
    list.removeWhere((element) =>
        (element['id'] == 2) ||
        (element['deleted_at'].toString().isNotNullOrEmpty) ||
        (element['branch_id'] != getIt<CommonService>().branchId));
    var dummy = {'id': -1, 'first_name': 'All', "last_name": ""};
    list.insert(0, dummy);
    return list;
  }

  List<Map<String, dynamic>>? workingHours = [];
  List<Map<String, dynamic>>? _employeeWorkHours = [];
  List<Map<String, dynamic>>? employeeWorkHours = [];
  List<Map<String, dynamic>>? _employeeActiveHours = [];
  List<Map<String, dynamic>>? _employeeHistoryCount = [];

  ResourceCheckInOutBloc() : super(LoadingState()) {
    on<InitialEvent>(_onInitialEvent);
    on<DateRangeChangedEvent>(_onDateRangeChangedEvent);
    on<ResourceSelectEvent>(_onResourceSelectEvent);
    on<ViewHoursDetailsEvent>(_onViewHoursDetailsEvent);
  }

  Future<List<Map<String, dynamic>>> _getResources() async => await getIt<CommonService>().getResources();
  Future<List<Map<String, dynamic>>?> _getWorkingHours() async => await _aPiRepository.getWorkingHours();
  Future<List<Map<String, dynamic>>?> _getEmployeeWorkHours() async => List<Map<String, dynamic>>.from((await _aPiRepository.employeeWorkHours(fromDate: selectedDateRange?.start, toDate: selectedDateRange?.end))?['data']?['data'] ?? []);
  Future<List<Map<String, dynamic>>?> _getEmployeeActiveHours() async => List<Map<String, dynamic>>.from((await _aPiRepository.employeeActiveHours(fromDate: selectedDateRange?.start, toDate: selectedDateRange?.end))?['data'] ?? []);
  Future<List<Map<String, dynamic>>?> _getEmployeeHistoryCount() async => List<Map<String, dynamic>>.from((await _aPiRepository.employeeHistoryCount(fromDate: selectedDateRange?.start, toDate: selectedDateRange?.end))?['history'] ?? []);

  void _processData() {
    _employeeHistoryCount = _employeeHistoryCount?.map((e) => e..['hrm_id'] = (e['users']?['hrm_id'])).toList();
    _employeeActiveHours?.removeWhere((element) => element['hrm_id'].toString().isNullOrEmpty);
    workingHours = workingHours?.map((e) => e..['active'] = (_employeeActiveHours?.where((element) => element['todo_date'] == (DateTime.now().toFormat())).where((element) => element['hrm_id'] == (e['employee']?['id'])).map((e1) => (e1['active_hours'].toString().parseDurationToMinutes)).sum.minutesToHourMinute)).toList();
    selectedResource = resources.firstOrNull ?? {'id': -1, 'first_name': 'All', "last_name": ""};
    employeeWorkHours?.forEach((e) {
      e['user_id'] = (resources.firstWhereOrNull((element) => element['hrm_id'] == e['id']))?['id'];
      e['active'] = (_employeeActiveHours?.where((element) => element['hrm_id'] == e['id']).map((e1) => (e1['active_hours'].toString().parseDurationToMinutes)).sum.minutesToHourMinute);
      e['totalCount'] = (_employeeHistoryCount?.firstWhereOrNull((element) => element['hrm_id'] == e['id'])?['task_count']);
      e['task_count'] = (List.from(e['list'] ?? [])).length;
    });
    employeeWorkHours?.removeWhere((element) => !_currentBranchHrmIds.contains(element['id']));
    _employeeWorkHours = employeeWorkHours;
  }

  void _onInitialEvent(InitialEvent event, Emitter<ResourceCheckInOutState> emit) async {
    try {
      emit(LoadingState());
      var response = await Future.wait([_getWorkingHours(), _getResources(), _getEmployeeWorkHours(), _getEmployeeActiveHours(), _getEmployeeHistoryCount()]);
      workingHours = response[0] ?? [];
      employeeWorkHours = (response[2]?.map((e) => e['user']).toList() ?? []).cast<Map<String, dynamic>>();
      _employeeActiveHours = response[3] ?? [];
      _employeeHistoryCount = response[4] ?? [];
      _processData();
      Console.of.log(employeeWorkHours);
      emit(CommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ErrorState(e));
    }
  }

  void _onDateRangeChangedEvent(DateRangeChangedEvent event, Emitter<ResourceCheckInOutState> emit) async {
    try {
      selectedDateRange = event.model;
      _employeeWorkHours = [];
      employeeWorkHours = [];
      emit(LoadingState());
      var response = await Future.wait([_getEmployeeWorkHours(), _getEmployeeActiveHours(), _getEmployeeHistoryCount()]);
      employeeWorkHours = (response[0]?.map((e) => e['user']).toList() ?? []).cast<Map<String, dynamic>>();
      _employeeActiveHours = response[1] ?? [];
      _employeeHistoryCount = response[2] ?? [];
      _processData();
      emit(CommonState());
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(ErrorState(e));
    }
  }

  void _onResourceSelectEvent(ResourceSelectEvent event, Emitter<ResourceCheckInOutState> emit) {
    selectedResource = event.model;
    if (selectedResource['id'] == -1) {
      employeeWorkHours = _employeeWorkHours;
    } else {
      employeeWorkHours = _employeeWorkHours?.where((element) => element['id'] == selectedResource['hrm_id']).toList();
    }
    emit(CommonState());
  }

  void _onViewHoursDetailsEvent(ViewHoursDetailsEvent event, Emitter<ResourceCheckInOutState> emit) {
    emit(ViewHoursDetailsState(event.model, selectedDateRange));
  }
}
