part of 'add_todo_bloc.dart';

abstract class AddToDoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingState extends AddToDoState {}

class SuccessState extends AddToDoState {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class ErrorState extends AddToDoState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class CommonState extends AddToDoState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class NewPartState extends AddToDoState {
  final dynamic message;
  NewPartState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class NewSupplyState extends AddToDoState {
  final dynamic message;
  NewSupplyState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class OpenLinkState extends AddToDoState {
  final String link;
  OpenLinkState(this.link);
  @override
  List<Object?> get props => [link, Random().nextDouble()];
}

class CleanTaskReassignState extends AddToDoState {
  final dynamic model;
  CleanTaskReassignState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class OilChangeTaskExistState extends AddToDoState {
  final dynamic model;
  OilChangeTaskExistState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class CompletedState extends AddToDoState {}