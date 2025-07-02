
import 'package:equatable/equatable.dart';

abstract class CumulativeExpenseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CumulativeExpenseInitialEvent extends CumulativeExpenseEvent {
  final dynamic data;
  CumulativeExpenseInitialEvent({this.data});
  @override
  List<Object?> get props => [data];
}

class CumulativeExpensePaginationEvent extends CumulativeExpenseEvent {
  final int page;
  CumulativeExpensePaginationEvent({required this.page});
  @override
  List<Object?> get props => [page];
}

class CumulativeExpenseDeleteEvent extends CumulativeExpenseEvent {
  final dynamic data;
  CumulativeExpenseDeleteEvent({required this.data});
  @override
  List<Object?> get props => [data];
}


