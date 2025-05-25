part of 'task_details_bloc.dart';

abstract class TaskDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialEvent extends TaskDetailsEvent {
  final Map<String, dynamic>? model;
  final DateRange? dateRange;
  InitialEvent({this.model, this.dateRange});
  @override
  List<Object?> get props => [model, dateRange];
}

class ViewAmountSummaryEvent extends TaskDetailsEvent {
  final Map<String, dynamic>? model;
  ViewAmountSummaryEvent({this.model});
  @override
  List<Object?> get props => [model];
}

class ViewCohortEvent extends TaskDetailsEvent {
  final dynamic model;
  ViewCohortEvent({this.model});
  @override
  List<Object?> get props => [model];
}