part of 'other_expense_details_bloc.dart';

abstract class OtherExpenseDetailsEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends OtherExpenseDetailsEvent{
  final dynamic model;
  InitialEvent({required this.model});
  @override
  List<Object?> get props => [model];
}

class PaginationEvent extends OtherExpenseDetailsEvent{
  final int page;
  PaginationEvent({required this.page});
  @override
  List<Object?> get props => [page];
}

class EditEvent extends OtherExpenseDetailsEvent{
  final dynamic id;
  EditEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class RefreshEvent extends OtherExpenseDetailsEvent{}