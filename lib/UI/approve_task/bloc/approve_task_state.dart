part of 'approve_task_bloc.dart';

abstract class ApproveTaskState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends ApproveTaskState{}

class CommonState extends ApproveTaskState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends ApproveTaskState{
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends ApproveTaskState{
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}


