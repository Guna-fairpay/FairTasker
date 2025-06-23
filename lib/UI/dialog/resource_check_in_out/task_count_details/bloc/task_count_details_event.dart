part of 'task_count_details_bloc.dart';

abstract class TaskCountDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialEvent extends TaskCountDetailsEvent {
  final dynamic model;
  final DateRange? dateRange;
  InitialEvent({required this.model, this.dateRange});
  @override
  List<Object?> get props => [model, dateRange];
}

class ViewNotesCommentsEvent extends TaskCountDetailsEvent {
  final dynamic model;
  ViewNotesCommentsEvent(this.model);
  @override
  List<Object?> get props => [model];
}