
part of 'task_hour_summery_bloc.dart';

abstract class TaskHourSummeryState extends Equatable {
 @override
  List<Object?> get props => [];
}

class TaskHourSummeryLoadingState extends TaskHourSummeryState {}

class TaskHourSummeryCommonState extends TaskHourSummeryState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}