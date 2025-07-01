import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'task_hour_summery_state.dart';
part 'task_hour_summery_event.dart';

class TaskHourSummeryBloc extends Bloc<TaskHourSummeryEvent, TaskHourSummeryState> {

  List<dynamic>? hourSummeryData;
  dynamic total;

  TaskHourSummeryBloc() : super(TaskHourSummeryLoadingState()) {
    on<TaskHourSummeryInitialEvent>(_onTaskHourSummeryInitialEvent);
  }

  void _onTaskHourSummeryInitialEvent(TaskHourSummeryInitialEvent event, Emitter<TaskHourSummeryState> emit) {
    try {
      emit(TaskHourSummeryLoadingState());
      hourSummeryData = event.hourSummeryData ?? [];
      Console.of.log(hourSummeryData);
      total = event.hourSummeryData?.where((element) => !element['task_name'].toString().toLowerCase().contains("other")).map((e) => e['total'].toString().toNumeric).sum ?? 0;
      final otherAmount = event.hourSummeryData?.where((element) => element['task_name'].toString().toLowerCase().contains("other")).map((e) => e['hour_amount'].toString().toNumeric).sum ?? 0;
      total+=otherAmount;
      emit(TaskHourSummeryCommonState());
    }catch (e) {
      _error("TaskHourSummeryInitialEvent :( ${e.toString()}");
      emit(TaskHourSummeryCommonState());
    }
  }

  void _error(String message) {
    Toaster.showError(message);
    Console.of .error(message);
  }

}
