part of 'person_view_bloc.dart';

abstract class PersonViewState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends PersonViewState{}

class CommonState extends PersonViewState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends PersonViewState{
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends PersonViewState {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class AddEditPageState extends PersonViewState {
  final dynamic model;
  AddEditPageState({this.model});
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class PersonExpenseDetailState extends PersonViewState {
  final dynamic model;
  PersonExpenseDetailState({this.model});
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

