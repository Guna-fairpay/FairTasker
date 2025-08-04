part of 'operation_bloc.dart';

abstract class OperationEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class OperationInitialEvent extends OperationEvent{}

class DateRangeSelectedEvent extends OperationEvent {
  final DateRange selectedDateRange;
  DateRangeSelectedEvent(this.selectedDateRange);
  @override
  List<Object?> get props => [selectedDateRange];
}

class SearchEvent extends OperationEvent{
  final String query;
  SearchEvent(this.query);
  @override
  List<Object?> get props => [query];
}