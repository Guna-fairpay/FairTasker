import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/int_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fbroadcast/fbroadcast.dart';

class TaskerHoursProcessor {
  List<Map<String, dynamic>> workingHours = [];
  List<Map<String, dynamic>> _completedHours = [];
  final APiRepository _aPiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();

  Future<List<Map<String, dynamic>>?> _fetchWorkingByHours() async => await _aPiRepository.getWorkingHoursByUser();
  Future<List<Map<String, dynamic>>?> _fetchCompletedTasks() async => await _aPiRepository.getCompletedTodo();

  Future<void> initialize() async {
    _listenBroadcast();
    _getWorkingHours();
    return;
  }

  Future<Map<String, dynamic>> refresh() async {
    await _getWorkingHours();
    return processWorkingHours();
  }

  void _listenBroadcast() {
    _broadcast.register("header_timer", (value, callback) => _getWorkingHours());
  }

  Future<void> _getWorkingHours() async {
    var response = await Future.wait([_fetchWorkingByHours(), _fetchCompletedTasks()]);
    workingHours = (response[0] ?? []);
    _completedHours = (response[1] ?? []);
  }

  int get _totalHours {
    try {
      var workinghours = workingHours.firstOrNull?['total_hours'].toString().parseDurationToMinutes;
      var completedHours = _completedHours.map((e) => e['complete_time_taken'].toString().parseDurationToMinutes).sum;
      // return ((workinghours ?? 0) - (completedHours ?? 0)).abs();
      return (completedHours ?? 0);
    } catch (e) {
      return 0;
    }
  }

  Map<String, dynamic> processWorkingHours() {
    return {
      "checkIn" : workingHours.firstOrNull?['start_time'],
      "totalHours" : _totalHours.minutesToHourMinute,
      "checkOut" : workingHours.firstOrNull?['end_time'],
    };
  }
}