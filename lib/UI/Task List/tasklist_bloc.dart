

import 'dart:developer';

import 'package:fairpytasker/UI/Task%20List/task_list_repository.dart';
import 'package:fairpytasker/UI/Task%20List/tasklist_event.dart';
import 'package:fairpytasker/UI/Task%20List/tasklist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  TaskListBloc() : super(const TaskListState(pop: false,
  )) {
    final TaskListRepository taskListRepo = TaskListRepository();
    on<GetTaskListDataEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        emit(state.copyWith(isLoading: false));
        final value = await taskListRepo.getTaskList(event.startDate, event.endDate);
        log("value---->${value?.data ?? []}");
      } catch (error) {
        emit(state.copyWith(isLoading: false));
        log(error.toString());
      }
    });
  }
}