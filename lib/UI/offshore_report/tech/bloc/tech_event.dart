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

class PaginationEvent extends TechEvent {
  final int page;
  PaginationEvent({required this.page});
  @override
  List<Object?> get props => [page];
}

class ProjectFilterEvent extends TechEvent {}

class ProjectBasedFilterEvent extends TechEvent {
  final List<dynamic> projects;
  ProjectBasedFilterEvent(this.projects);
  @override
  List<Object?> get props => [projects];
}