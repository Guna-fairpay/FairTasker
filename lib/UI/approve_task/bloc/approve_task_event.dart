part of 'approve_task_bloc.dart';

abstract class ApproveTaskEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends ApproveTaskEvent{}

class HideSupportEvent extends ApproveTaskEvent{}

class ExtraHoursEvent extends ApproveTaskEvent{}

class DateRangeEvent extends ApproveTaskEvent{
  final DateRange dateRange;
  DateRangeEvent(this.dateRange);
  @override
  List<Object?> get props => [dateRange];
}

class ListCheckEvent extends ApproveTaskEvent{}

class TaskInCompletedEvent extends ApproveTaskEvent{}

class OffShorTeamEvent extends ApproveTaskEvent{}