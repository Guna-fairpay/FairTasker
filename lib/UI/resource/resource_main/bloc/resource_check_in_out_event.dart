part of 'resource_check_in_out_bloc.dart';

abstract class ResourceCheckInOutEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialEvent extends ResourceCheckInOutEvent {}
class ResourceSelectEvent extends ResourceCheckInOutEvent {
  final dynamic model;
  ResourceSelectEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class DateRangeChangedEvent extends ResourceCheckInOutEvent {
  final dynamic model;
  DateRangeChangedEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ViewHoursDetailsEvent extends ResourceCheckInOutEvent {
  final dynamic model;
  ViewHoursDetailsEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class TaskComponentEvent extends ResourceCheckInOutEvent {}

class ViewTaskDetailsEvent extends ResourceCheckInOutEvent {
  final dynamic model;
  ViewTaskDetailsEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ViewTaskCountEvent extends ResourceCheckInOutEvent {
  final dynamic model;
  ViewTaskCountEvent(this.model);
  @override
  List<Object?> get props => [model];
}