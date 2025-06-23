import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class TaskerMaintenanceCompleteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskerMaintenanceLoadingState extends TaskerMaintenanceCompleteState {}
class TaskerMaintenanceCommonState extends TaskerMaintenanceCompleteState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TaskerMaintenanceErrorState extends TaskerMaintenanceCompleteState {
  final dynamic message;
  TaskerMaintenanceErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class TaskerMaintenanceSuccessState extends TaskerMaintenanceCompleteState {
  final dynamic message;
  TaskerMaintenanceSuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class TaskerMaintenanceCompletedState extends TaskerMaintenanceCompleteState {}