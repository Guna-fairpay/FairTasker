part of 'expense_tab_bloc.dart';

abstract class ExpenseTabState extends Equatable{
  @override
  List<Object?> get props => [];
}

class CommonState extends ExpenseTabState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends ExpenseTabState{
  final dynamic error;
  ErrorState(this.error);
  @override
  List<Object?> get props => [error, Random().nextDouble()];
}