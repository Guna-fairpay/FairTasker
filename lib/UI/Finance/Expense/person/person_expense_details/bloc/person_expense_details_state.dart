part of 'person_expense_details_bloc.dart';

abstract class PersonExpenseDetailsState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends PersonExpenseDetailsState{}

class ErrorState extends PersonExpenseDetailsState{
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends PersonExpenseDetailsState{
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class CommonState extends PersonExpenseDetailsState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class EditState extends PersonExpenseDetailsState {
  final dynamic model;
  EditState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}