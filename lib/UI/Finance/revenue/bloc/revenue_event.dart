part of 'revenue_bloc.dart';

abstract class RevenueEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialEvent extends RevenueEvent{}

class DateRangeEvent extends RevenueEvent{
  final DateRange selectedDateRange;
  DateRangeEvent({required this.selectedDateRange});
  @override
  List<Object?> get props => [selectedDateRange];
}

class SearchEvent extends RevenueEvent{
  final String query;
  SearchEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class DropDownPopupEvent extends RevenueEvent{
  final dynamic value;
  DropDownPopupEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class CohortEvent extends RevenueEvent{
  final dynamic cohort;
  CohortEvent(this.cohort);
  @override
  List<Object?> get props => [cohort];

}