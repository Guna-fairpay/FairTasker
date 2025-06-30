part of 'leads_bloc.dart';

abstract class LeadsEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends LeadsEvent {
  final dynamic customerName;
  InitialEvent(this.customerName);
  @override
  List<Object?> get props => [customerName];
}

class ShowMoreEvent extends LeadsEvent {}

class ActiveStatesEvent extends LeadsEvent{
  final dynamic status;
  ActiveStatesEvent(this.status);
  @override
  List<Object?> get props => [status];
}

class SearchEvent extends LeadsEvent{
  final String query;
  SearchEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class SaveEvent extends LeadsEvent{}

class CloseEvent extends LeadsEvent{}

class DeleteEvent extends LeadsEvent{
  final dynamic data;
  DeleteEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class PaginationEvent extends LeadsEvent{
  final int page;
  PaginationEvent(this.page);
  @override
  List<Object?> get props => [page];
}

class DateRangeEvent extends LeadsEvent{
  final DateRange range;
  DateRangeEvent(this.range);
  @override
  List<Object?> get props => [range];
}

class EditEvent extends LeadsEvent{
  final dynamic data;
  EditEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class AppliedAtEvent extends LeadsEvent{
  final DateTime? data;
  AppliedAtEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class ExportEvent extends LeadsEvent{}

