import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'task_filter_dialog_event.dart';
part 'task_filter_dialog_state.dart';

class TaskFilterDialogBloc extends Bloc<TaskFilterDialogEvent, TaskFilterDialogState> {

  bool isAll = false;

  List<dynamic> taskFilterList = [];

  List<dynamic> taskName = [];

  TaskFilterDialogBloc() : super(CommonState()){
    on<InitialEvent>(_onInitialEvent);
    on<AllCheckEvent>(_onAllCheckEvent);
    on<TitleCheckEvent>(_onTitleCheckEvent);
    on<TaskCheckEvent>(_onTaskCheckEvent);
  }

  void _onInitialEvent(InitialEvent event, Emitter<TaskFilterDialogState> emit){
    try {
      taskFilterList = event.taskFilterList;
      isAll = event.isAll ?? false;
      emit(CommonState());
    } catch (e) {
      _error(e.toString(), emit);
    }
  }

  void _onAllCheckEvent(AllCheckEvent event, Emitter<TaskFilterDialogState> emit){
    try {
      isAll = !isAll;
      for (var element in taskFilterList) {
        element['isChecked'] = isAll == true ? 1 : 0;
        element?['tasks'].forEach((task) {
          task['isChecked'] = isAll == true ? 1 : 0;
        });
      }
      emit(EmitValueState(value: taskFilterList));
    } catch (e) {
      _error(e.toString(), emit);
    }
  }

  void _onTitleCheckEvent(TitleCheckEvent event, Emitter<TaskFilterDialogState> emit){
    try {
      for (var element in taskFilterList) {
        if(element['id'] == event.value['id']){
          element['isChecked'] = event.value['isChecked'] == 1 ? 0 : 1;
          for (var task in List.of(element['tasks'] ?? [])) {
            task['isChecked'] = element['isChecked'];
          }
        }
      }
      isAll = taskFilterList.every((element) => element['isChecked'] == 1);
      emit(EmitValueState(value: taskFilterList));
    } catch (e) {
      _error(e.toString(), emit);
    }
  }

  void _onTaskCheckEvent(TaskCheckEvent event, Emitter<TaskFilterDialogState> emit){
    try {
      for (var group in taskFilterList) {
        var tasks = List.of(group['tasks'] ?? []);
        for (var task in tasks) {
          if (task['task_name'] == event.value['task_name']) {
            task['isChecked'] = event.value['isChecked'] == 1 ? 0 : 1;
          }
        }
        group['isChecked'] = tasks.every((task) => task['isChecked'] == 1) ? 1 : 0;
      }
      isAll = taskFilterList.every((element) => element['isChecked'] == 1);
      emit(EmitValueState(value: taskFilterList));
    } catch (e) {
      _error(e.toString(), emit);
    }
  }

  void _error(String message, Emitter<TaskFilterDialogState> emit){
    Console.of.error(message);
    emit(ErrorState(message: message));
  }



}