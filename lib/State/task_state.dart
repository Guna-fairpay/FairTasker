
import 'package:equatable/equatable.dart';
///Task
abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {
  @override
  List<Object> get props => [];
}

class TaskLoading extends TaskState {}

class TaskListLoaded extends TaskState {
  final List<Map<String, dynamic>>? data;
  const TaskListLoaded(
      {required this.data});
  @override
  List<Object?> get props => [data];
}

class TaskLoaded extends TaskState {
  final String message;
  const TaskLoaded(
      {required this.message});
  @override
  List<Object> get props => [message];
}

class TaskExpenseLoaded extends TaskState {
  final List<Map<String, dynamic>>? data;
  const TaskExpenseLoaded(
      {required this.data});
  @override
  List<Object?> get props => [data];
}


class TaskError extends TaskState {
  final String message;
  const TaskError(this.message);
  @override
  List<Object> get props => [message];
}

