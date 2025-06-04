part of 'other_expense_details_bloc.dart';

abstract class OtherExpenseDetailsState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends OtherExpenseDetailsState{}

class ErrorState extends OtherExpenseDetailsState{
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends OtherExpenseDetailsState{
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class CommonState extends OtherExpenseDetailsState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class EditState extends OtherExpenseDetailsState {
  final dynamic id;
  EditState(this.id);
  @override
  List<Object?> get props => [id, Random().nextDouble()];
}