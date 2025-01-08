part of '../Bloc/upcoming_task_bloc.dart';

abstract class UpcomingTaskState extends Equatable {
  const UpcomingTaskState();
}

class UpcomingTaskInitial extends UpcomingTaskState {
  @override
  List<Object> get props => [];
}

class JobListLoading extends UpcomingTaskState {
  @override
  List<Object> get props => [];
}

class JobListLoaded extends UpcomingTaskState {
 final List<Map<String,dynamic>>? taskList;
 const JobListLoaded({required this.taskList});
  @override
  List<Object?> get props => [taskList];
}

class DeleteJobLoaded extends UpcomingTaskState {
 final bool? result;
 const DeleteJobLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class CreateJobLoaded extends UpcomingTaskState {
 final bool? result;
 const CreateJobLoaded({required this.result});
  @override
  List<Object?> get props => [result];
}

class AssignedToLoaded extends UpcomingTaskState {
 final List<Map<String,dynamic>>? resource;
 const AssignedToLoaded({required this.resource});
  @override
  List<Object?> get props => [resource];
}
