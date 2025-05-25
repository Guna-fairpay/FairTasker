import 'dart:math';

import 'package:equatable/equatable.dart';
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
      hourSummeryData = event.hourSummeryData;
      total = event.hourSummeryData?.map((e) => e['total']).reduce((value, element) => value + element);
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
