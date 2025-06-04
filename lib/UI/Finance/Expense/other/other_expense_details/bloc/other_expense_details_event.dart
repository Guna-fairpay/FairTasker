part of 'other_expense_details_bloc.dart';

abstract class OtherExpenseDetailsEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends OtherExpenseDetailsEvent{
  final dynamic id;
  InitialEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class PaginationEvent extends OtherExpenseDetailsEvent{}

class EditEvent extends OtherExpenseDetailsEvent{
  final dynamic id;
  EditEvent(this.id);
  @override
  List<Object?> get props => [id];
}