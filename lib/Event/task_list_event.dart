
import 'package:equatable/equatable.dart';

abstract class TaskListEvent extends Equatable {
  const TaskListEvent();
}

class TaskListInitialEvent extends TaskListEvent {
  @override
  List<Object?> get props => [];
}

class GetTaskListData extends TaskListEvent {
  final String? startDate;
  final String? endDate;
  const GetTaskListData(
      this.startDate,
      this.endDate,
      );
  @override
  List<Object?> get props => [startDate,endDate];
}
