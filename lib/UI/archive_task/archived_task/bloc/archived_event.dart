part of 'archived_bloc.dart';

abstract class ArchivedEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitEvent extends ArchivedEvent{}

class DateRangePickerEvent extends ArchivedEvent{
  final dynamic selectedDateRange;
  DateRangePickerEvent(this.selectedDateRange);
  @override
  List<Object?> get props => [selectedDateRange];
}

class SelectAllEvent extends ArchivedEvent{}

class UnArchiveEvent extends ArchivedEvent{}

class ArchiveStatusEvent extends ArchivedEvent{
  final dynamic model;
  ArchiveStatusEvent(this.model);
  @override
  List<Object?> get props => [model];
}