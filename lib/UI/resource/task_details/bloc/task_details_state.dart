part of 'task_details_bloc.dart';

abstract class TaskDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingState extends TaskDetailsState {}
class CommonState extends TaskDetailsState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends TaskDetailsState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends TaskDetailsState {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class ViewAmountSummaryState extends TaskDetailsState {
  final dynamic model;
  final dynamic name;
  ViewAmountSummaryState(this.name,this.model);
  @override
  List<Object?> get props => [name, model, Random().nextDouble()];
}

class ViewCohortState extends TaskDetailsState {
  final dynamic model;
  ViewCohortState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ViewFilterState extends TaskDetailsState {
  final dynamic model;
  ViewFilterState({this.model});
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}