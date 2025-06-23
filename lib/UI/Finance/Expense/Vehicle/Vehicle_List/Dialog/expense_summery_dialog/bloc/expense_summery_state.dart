part of 'expense_summery_bloc.dart';

abstract class ExpenseSummeryState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends ExpenseSummeryState{}

class CommonState extends ExpenseSummeryState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends ExpenseSummeryState{
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends ExpenseSummeryState{
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}