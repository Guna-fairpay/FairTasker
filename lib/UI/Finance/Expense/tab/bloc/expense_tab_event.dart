part of 'expense_tab_bloc.dart';

abstract class ExpenseTabEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends ExpenseTabEvent{}

class TabChangeEvent extends ExpenseTabEvent{
  final dynamic tab;
  TabChangeEvent(this.tab);
  @override
  List<Object?> get props => [tab];
}