import 'package:equatable/equatable.dart';

abstract class MaintenanceCheckEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MaintenanceCheckInitialEvent extends MaintenanceCheckEvent {
  final Map<String, dynamic>? todoItem;
  MaintenanceCheckInitialEvent(this.todoItem);
  @override
  List<Object?> get props => [todoItem];
}

class MaintenanceCheckAllCheckEvent extends MaintenanceCheckEvent {
  final bool? value;
  MaintenanceCheckAllCheckEvent(this.value);
  @override
  List<Object?> get props => [value];
}

class MaintenanceCheckItemCheckEvent extends MaintenanceCheckEvent {
  final dynamic model;
  final bool value;
  MaintenanceCheckItemCheckEvent(this.model, this.value);
  @override
  List<Object?> get props => [model, value];
}

class MaintenanceChangeStatusEvent extends MaintenanceCheckEvent {
  final dynamic model;
  final dynamic value;
  MaintenanceChangeStatusEvent(this.model, this.value);
  @override
  List<Object?> get props => [model, value];
}

class MaintenanceCreateTaskEvent extends MaintenanceCheckEvent {
  final dynamic model;
  MaintenanceCreateTaskEvent(this.model);
  @override
  List<Object?> get props => [model];
}