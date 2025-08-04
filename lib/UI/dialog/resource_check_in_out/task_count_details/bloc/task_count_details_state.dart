part of 'task_count_details_bloc.dart';

abstract class TaskCountDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingState extends TaskCountDetailsState {}
class CommonState extends TaskCountDetailsState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends TaskCountDetailsState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends TaskCountDetailsState {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class ViewNotesCommentsState extends TaskCountDetailsState {
  final dynamic model;
  ViewNotesCommentsState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}