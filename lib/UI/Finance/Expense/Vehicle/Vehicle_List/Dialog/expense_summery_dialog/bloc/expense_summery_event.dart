part of 'expense_summery_bloc.dart';

abstract class ExpenseSummeryEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends ExpenseSummeryEvent{
  final List<dynamic>? model;
  InitialEvent(this.model);
  @override
  List<Object?> get props => [model];
}

