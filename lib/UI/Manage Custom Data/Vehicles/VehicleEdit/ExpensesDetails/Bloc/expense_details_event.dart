
import 'package:equatable/equatable.dart';

abstract class ExpenseDetailsEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class ExpenseDetailsInitialEvent extends ExpenseDetailsEvent{
  final String vin;
  ExpenseDetailsInitialEvent({required this.vin});
  @override
  List<Object?> get props => [vin];
}

class SearchExpenseEvent extends ExpenseDetailsEvent {
  final String query;
  SearchExpenseEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class SearchRmExpenseEvent extends ExpenseDetailsEvent {
  final String query;
  SearchRmExpenseEvent(this.query);
  @override
  List<Object?> get props => [query];
}