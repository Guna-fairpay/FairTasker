import 'dart:async';
import 'package:collection/collection.dart';
import 'package:date_time/date_time.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

import 'package:equatable/equatable.dart';

part 'tasker_check_in_out_dialog_events.dart';
part 'tasker_check_in_out_dialog_states.dart';

class TCIODBloc extends Bloc<TCIODEvents, TCIODStates>{
  bool isCheckOut = false;
  Map<String, dynamic>? model;
  Time idleTime = Time.fromMinutes(0);
  Time activeHours = Time.fromMinutes(0);
  Map<String, dynamic>? _apiResponse;
  List<Map<String, dynamic>>? _workingHours;
  List<Map<String, dynamic>> toDoList = [];
  final APiRepository _apiRepository = APiRepository();
  Time checkInTime = Time.fromMinutes(0);
  Time checkOutTime = Time.fromMinutes(0);
  String? get userId => Session.of.getString(Str.userIdPrefText);
  bool showPendingCounts = false;
  int previousTaskCounts = 0;
  TCIODBloc() : super(TCIODLoadingState()) {
    on<TCIODInitialEvent>(_onInitialEvent);
    on<NavigateYesterdayEvent>(_onNavigateYesterdayEvent);
  }

  /// API CALLS BEGIN HERE
  Future<Map<String, dynamic>?> _fetchToDos({required DateTime date, bool? status}) async => await _apiRepository.getToDoList(selectedDate: date.toFormat(), status: status, resourceId: userId);
  Future<List<Map<String, dynamic>>?> _fetchWorkingHours() async => await _apiRepository.getWorkingHoursByUser();
  /// API CALLS ENDS HERE

  void _onInitialEvent(TCIODInitialEvent event, Emitter<TCIODStates> emit) async {
    isCheckOut = event.isCheckout;
    model = event.model;
    var dateTime = (model?['todo_date'].toString().toDateTime() ?? DateTime.now());
    var currentDate = (isCheckOut) ? dateTime : dateTime.subtract(const Duration(days: 1));
    Console.of.log("DATE: $currentDate");
    emit(TCIODLoadingState());
    _apiResponse = await _fetchToDos(date: currentDate, status: true);
    if (!isCheckOut) {
      var previousRecords = await _fetchToDos(date: dateTime.subDays(1), status: false);
      var tasks = List<Map<String, dynamic>>.from(previousRecords?['todos'] ?? []);
      previousTaskCounts = tasks.length;
      showPendingCounts = previousTaskCounts > 0;
    }
    toDoList = List<Map<String, dynamic>>.from(_apiResponse?['todos'] ?? []);
    activeHours = Time.fromMinutes((toDoList.map((e) => Time.fromStr(e['complete_time_taken'])?.inMins ?? 0).sum));
    idleTime = Time.fromMinutes(0);
    if (isCheckOut) {
      _workingHours = await _fetchWorkingHours();
      checkInTime = Time.fromStr(_workingHours?.lastOrNull?['start_time']) ?? Time.fromMinutes(0);
    }
    emit(TCIODCommonState());
  }

  void _onNavigateYesterdayEvent(NavigateYesterdayEvent event, Emitter<TCIODStates> emit) {
    var dateTime = (model?['todo_date'].toString().toDateTime() ?? DateTime.now());
    Console.of.log(dateTime);
    emit(NavigateYesterdayState(dateTime.subDays(1)));
  }
}