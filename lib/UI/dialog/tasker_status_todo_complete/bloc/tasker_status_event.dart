import 'package:equatable/equatable.dart';

abstract class TaskerStatusEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskerStatusInitialEvent extends TaskerStatusEvent {
  final dynamic model;
  TaskerStatusInitialEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class TaskerStatusSelectTaskEvent extends TaskerStatusEvent {
  final dynamic model;
  TaskerStatusSelectTaskEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class TaskerStatusSelectResourceEvent extends TaskerStatusEvent {
  final dynamic model;
  TaskerStatusSelectResourceEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class TaskerStatusVendorLocationEvent extends TaskerStatusEvent {
  final dynamic model;
  TaskerStatusVendorLocationEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class TaskerStatusAddressEvent extends TaskerStatusEvent {
  final dynamic model;
  TaskerStatusAddressEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class TaskerStatusDateEvent extends TaskerStatusEvent {
  final dynamic model;
  TaskerStatusDateEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class TaskerStatusTimeEvent extends TaskerStatusEvent {
  final dynamic model;
  TaskerStatusTimeEvent(this.model);
  @override
  List<Object?> get props => [model];
}