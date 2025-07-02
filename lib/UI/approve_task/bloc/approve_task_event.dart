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

class ListCheckEvent extends ApproveTaskEvent{
  final dynamic data;
  final bool? isApproved;
  ListCheckEvent({this.data, this.isApproved});
  @override
  List<Object?> get props => [data, isApproved];
}

class TaskInCompletedEvent extends ApproveTaskEvent{}

class OffShorTeamEvent extends ApproveTaskEvent{}