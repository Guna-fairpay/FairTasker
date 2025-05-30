part of 'tech_bloc.dart';

abstract class TechEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class TechInitialEvent extends TechEvent{}

class DateRangeSelectedEvent extends TechEvent {
  final DateRange selectedDateRange;
  DateRangeSelectedEvent(this.selectedDateRange);
  @override
  List<Object?> get props => [selectedDateRange];
}

class SearchEvent extends TechEvent{
  final String query;
  SearchEvent(this.query);
  @override
  List<Object?> get props => [query];
}