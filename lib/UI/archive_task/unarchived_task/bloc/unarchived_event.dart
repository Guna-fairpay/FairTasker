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