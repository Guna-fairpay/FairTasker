part of 'person_expense_details_bloc.dart';

abstract class PersonExpenseDetailsEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends PersonExpenseDetailsEvent{
  final dynamic model;
  InitialEvent({required this.model});
  @override
  List<Object?> get props => [model];
}

class PaginationEvent extends PersonExpenseDetailsEvent{
  final int page;
  PaginationEvent({required this.page});
  @override
  List<Object?> get props => [page];
}

class EditEvent extends PersonExpenseDetailsEvent{
  final dynamic model;
  EditEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class RefreshEvent extends PersonExpenseDetailsEvent{}