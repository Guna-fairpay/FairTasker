part of 'task_components_bloc.dart';


abstract class TaskComponentState extends Equatable{
  @override
  List<Object?> get props => [];
}

class TaskComponentLoadingState extends TaskComponentState {}

class TaskComponentCommentState extends TaskComponentState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends TaskComponentState {
  final String message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}