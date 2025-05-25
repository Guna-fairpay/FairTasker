part of 'task_hour_summery_bloc.dart';

abstract class TaskHourSummeryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskHourSummeryInitialEvent extends TaskHourSummeryEvent {
  final List<dynamic>? hourSummeryData;
  TaskHourSummeryInitialEvent({this.hourSummeryData});
  @override
  List<Object?> get props => [hourSummeryData];

}