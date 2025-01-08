part of '../Bloc/upcoming_task_bloc.dart';

abstract class UpcomingTaskEvent extends Equatable {
  const UpcomingTaskEvent();
}

class DeleteJobEvent extends UpcomingTaskEvent {
  String? taskId;
  DeleteJobEvent({this.taskId});
  @override
  List<Object?> get props => [taskId];
}

class GetJobList extends UpcomingTaskEvent {
  final String? selectedDate;
  const GetJobList({required this.selectedDate});
  @override
  List<Object?> get props => [selectedDate];
}

class CreateTaskEvent extends UpcomingTaskEvent {
  final CreateJobParams? createJobParams;
  const CreateTaskEvent({required this.createJobParams});
  @override
  List<Object> get props => [CreateJobParams];
}

class GetAssignedToList extends UpcomingTaskEvent {
  const GetAssignedToList();
  @override
  List<Object> get props => [];
}
