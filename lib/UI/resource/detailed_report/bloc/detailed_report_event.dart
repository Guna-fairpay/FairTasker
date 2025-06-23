part of 'detailed_report_bloc.dart';

abstract class DetailedReportEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialEvent extends DetailedReportEvent {
  final dynamic model;
  InitialEvent({required this.model});
  @override
  List<Object?> get props => [model];
}

class ViewByEvent extends DetailedReportEvent {
  final dynamic index;
  ViewByEvent(this.index);
  @override
  List<Object?> get props => [index];
}

class ViewFilterEvent extends DetailedReportEvent {}

class FilterCohortEvent extends DetailedReportEvent {
  final dynamic model;
  FilterCohortEvent({this.model});
  @override
  List<Object?> get props => [model];
}

class ViewURLEvent extends DetailedReportEvent {
  final String? model;
  ViewURLEvent({this.model});
  @override
  List<Object?> get props => [model];
}