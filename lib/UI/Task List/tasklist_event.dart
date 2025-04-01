


import 'package:equatable/equatable.dart';

abstract class TaskListEvent extends Equatable {
  const TaskListEvent();
  @override
  List<Object> get props => [];
}

class TaskListInitial extends TaskListEvent {
  const TaskListInitial();
  @override
  List<Object> get props => [];
}

class GetTaskListDataEvent extends TaskListEvent {
  final String startDate;
  final String endDate;
  const GetTaskListDataEvent(
      this.startDate,
      this.endDate,
      );
}