import 'package:equatable/equatable.dart';

abstract class TaskerMaintenanceCompleteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskerMaintenanceInitialEvent extends TaskerMaintenanceCompleteEvent {
  final dynamic model;
  TaskerMaintenanceInitialEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class TaskerMaintenanceSelectEvent extends TaskerMaintenanceCompleteEvent {
  final dynamic model;
  TaskerMaintenanceSelectEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class TaskerMaintenanceUpdateEvent extends TaskerMaintenanceCompleteEvent {}