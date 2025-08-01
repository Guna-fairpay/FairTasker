part of 'unarchived_bloc.dart';

abstract class UnarchivedEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitEvent extends UnarchivedEvent{}

class DateRangePickerEvent extends UnarchivedEvent{
  final dynamic selectedDateRange;
  DateRangePickerEvent(this.selectedDateRange);
  @override
  List<Object?> get props => [selectedDateRange];
}

class SelectAllEvent extends UnarchivedEvent{}

class UnArchiveEvent extends UnarchivedEvent{}

class ArchiveStatusEvent extends UnarchivedEvent{
  final dynamic model;
  ArchiveStatusEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class SearchEvent extends UnarchivedEvent{
  final dynamic query;
  SearchEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class TaskFilterEvent extends UnarchivedEvent{
  final List<dynamic> data;
  TaskFilterEvent(this.data);
  @override
  List<Object?> get props => [data];
}