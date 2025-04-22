import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:date_time/date_time.dart' as d;
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/attendance/bloc/attendance_events.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/attendance/bloc/attendance_states.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/int_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/timeday_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {

  final APiRepository _aPiRepository = APiRepository();
  DateTime? fromDate, toDate;
  String? get currentUserId => Session.of.getString(Str.userIdPrefText);
  int? get currentHrmId => Session.of.getInt(Str.hrmIdPrefText);
  int? get currentBranchId => Session.of.getInt(Str.branchIdPrefText);

  List<Map<String, dynamic>>? resources = [];
  List<Map<String, dynamic>>? _users = [];
  List<Map<String, dynamic>>? _groupPersons = [];
  List<Map<String, dynamic>>? _todos = [];
  List<Map<String, dynamic>>? _workingHourByUser = [];
  List<Map<String, dynamic>>? _empActiveHours = [];
  List<Map<String, dynamic>>? _empHistoryCount = [];
  List<Map<String, dynamic>>? _empWorkingHours = [];
  AttendanceBloc() : super(AttendanceLoadingState()) {
    on<AttendanceInitialEvent>(_onInitialEvent);
  }

  Future<List<Map<String, dynamic>>> _fetchResources() async => await getIt<CommonService>().getResources(reset: true);
  Future<List<Map<String, dynamic>>> _fetchGroupPersons() async => await getIt<CommonService>().getGroupPersons();
  Future<List<Map<String, dynamic>>> _fetchUsers() async => await getIt<CommonService>().getUsers(reset: true);
  Future<List<Map<String, dynamic>>?> _fetchWorkingHours() async => await getIt<CommonService>().getWorkingHourByUser();
  Future<Map<String, dynamic>?> _fetchToDoDataRange() async => await _aPiRepository.toDoDataRange(date: toDate, isCompleted: true);
  Future<Map<String, dynamic>?> _fetchEmployeeActiveHours() async => await _aPiRepository.employeeActiveHours(fromDate: fromDate, toDate: toDate);
  Future<Map<String, dynamic>?> _fetchEmployeeHistoryCount() async => await _aPiRepository.employeeHistoryCount(fromDate: fromDate, toDate: toDate);
  Future<Map<String, dynamic>?> _fetchEmployeeWorkHours() async => await _aPiRepository.employeeWorkHours(fromDate: fromDate, toDate: toDate);

  void _onInitialEvent(AttendanceInitialEvent event, Emitter<AttendanceState> emit) async {
    try {
      emit(AttendanceLoadingState());
      toDate = DateTime.now().toUtc();
      fromDate = toDate?.subtract(const Duration(days: 7));
      toDate = toDate?.subtract(const Duration(days: 1));
      var response = await Future.wait([
        _fetchResources(),
        _fetchUsers(),
        _fetchWorkingHours(),
        _fetchToDoDataRange(),
        _fetchEmployeeActiveHours(),
        _fetchEmployeeHistoryCount(),
        _fetchEmployeeWorkHours(),
        _fetchGroupPersons()
      ]);
      resources = response[0] as List<Map<String, dynamic>>;
      _users = response[1] as List<Map<String, dynamic>>;
      _workingHourByUser = response[2] as List<Map<String, dynamic>>;
      _todos = List<Map<String, dynamic>>.from((response[3] as Map<String, dynamic>?)?['todos']);
      _empActiveHours = List<Map<String, dynamic>>.from((response[4] as Map<String, dynamic>?)?['data']);
      _empHistoryCount = List<Map<String, dynamic>>.from((response[5] as Map<String, dynamic>?)?['history']);
      _empWorkingHours = List<Map<String, dynamic>>.from((response[6] as Map<String, dynamic>?)?['data']?['data']);
      _groupPersons = response[7] as List<Map<String, dynamic>>;
      _groupPersons = _groupPersons?.map((e) => e..['userId'] = List.from(jsonDecode(e["userId"]))).toList();
      resources?.removeWhere((element) => (element['deleted_at'].toString().isNotNullOrEmpty) || (element['hrm_id'].toString().isNullOrEmpty) || (element['branch_id'].toString().isNullOrEmpty) || (element['branch_id'] != currentBranchId) || ( [3,17,15,27].contains(element['id'])) || (["8"].contains(element["department"])));
      List<String>? departments = resources?.map((e) => e['department'].toString()).toList();
      departments?.sortBy((element) => element);
      resources?.sort((a, b) => (a['id'] ?? 0).compareTo(b['id'] ?? 0));
      resources = resources?.map((e) => _processData(e)).toList();
      emit(AttendanceCommonState());
    } catch (e) {
      emit(AttendanceErrorState(e.toString()));
    }
  }

  Map<String, dynamic> _processData(Map<String, dynamic> model) {
    var data = model;
    try {
      Console.of.debug("HRM ${data['hrm_id']} USER ${data['id']} ${data['first_name']}");
      var empActiveHours = _empActiveHours?.where((element) => element['user_id'] == data['id']);
      var empWorkHours = _empWorkingHours?.firstWhereOrNull((element) => element['user']?['id'] == data['hrm_id']);
      var groupIds = _groupPersons?.where((element) => element['userId']?.contains(data['id']) ?? false).map((e) => e['id']).toList();
      // Console.of.debug(groupIds, name: "GROUP_IDS");
      int? taskCount = _empHistoryCount?.firstWhereOrNull((element) => element['user_id'].toString() == data['id'].toString())?['task_count'];
      int? workingHours = empWorkHours?['user']?['total_working_hours'].toString().parseDurationToMinutes;
      int? activeHours = empActiveHours?.map((e) => d.Time.fromStr(e['active_hours'].toString())?.inMins ?? 0).sum ?? 0;

      ///
      var completeTasks = _todos?.where((element) => (element['status'].toString().toLowerCase() == "completed"));
      var unCompleteTasks = _todos?.where((element) => (element['status'].toString().toLowerCase() != "completed"));
      var completedTasks = completeTasks?.where((element) => (element['user_id'].toString() == data['id'].toString()) || (groupIds?.contains(data['id']) ?? false));
      var unCompleted = unCompleteTasks?.where((element) => (element['user_id'].toString() == data['id'].toString())  || (groupIds?.contains(data['id']) ?? false));
      int? completedTaskTime = completedTasks?.map((e) => d.Time.fromStr(e['complete_time_taken'])?.inMins ?? 0).sum;
      int? currentDayTaskCompleted = completedTasks?.where((element) => element['todo_date'] == toDate?.toFormat()).length;
      int? currentDayTaskCompletedTime = completedTasks?.where((element) => element['todo_date'] == toDate?.toFormat()).map((e) => d.Time.fromStr(e['complete_time_taken'] ?? "")?.inMins ?? 0).sum;
      int? currentDayTaskUnCompleted = unCompleted?.where((element) => element['todo_date'] == toDate?.toFormat()).length;
      ///

      ///
      int? currentDayWorkHours = List.from(empWorkHours?['user']?['list'] ?? []).firstWhereOrNull((element) => element["date"] == toDate.toFormat())?['total_hours'].toString().parseDurationToMinutes ?? 0;
      int? currentDayActiveHours = empActiveHours?.firstWhereOrNull((element) => (element['todo_date'] == toDate?.toFormat()))?['active_hours'].toString().parseDurationToMinutes ?? 0;
      int? currentDayIdleHours = ((currentDayWorkHours ?? 0) == 0) ? 0 : (currentDayActiveHours ?? 0) - (currentDayWorkHours ?? 0);
      ///

      Console.of.warning("WORK $workingHours, ACTIVE $activeHours");
      data['total_working_hours'] = workingHours;
      data['sum_of_hours'] = activeHours.minutesToHourMinute;
      data['weekly_hours'] = (((workingHours ?? 0) == 0) ? 0 : ((workingHours ?? 0) - (activeHours ?? 0)).abs()).minutesToHourMinute;
      data['taskCount'] = taskCount ?? 0;
      data['completedTaskCount'] = completedTasks?.length ?? 0;
      data['unCompletedTaskCount'] = unCompleted?.length ?? 0;
      data['completedTaskTime'] = completedTaskTime ?? 0;
      data['weekly'] = {
        "dateText" : "${fromDate?.formatDateWithOrdinal} - ${toDate?.formatDateWithOrdinal}",
        "totalHours" : workingHours?.minutesToHourMinute,
        "activeHours": data['sum_of_hours'],
        "idleHours" : data['weekly_hours'],
        "completedTaskCount" : currentDayTaskCompleted ?? 0,
      };
      data['daily'] = {
        "currentDay": toDate?.formatDateWithOrdinal,
        "totalHours" : currentDayWorkHours.minutesToHourMinute,
        "activeHours" : currentDayActiveHours.minutesToHourMinute,
        "idleHours" : currentDayIdleHours.minutesToHourMinute,
        "completedTaskCount" : currentDayTaskCompleted ?? 0,
        "totalTasks" : currentDayTaskUnCompleted ?? 0
      };
      Console.of.debug(data);
    } catch (e) {
      Console.of.error("Error", error: e);
    }
    return data;
  }

}