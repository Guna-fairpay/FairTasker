import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class MaintenanceCheckState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MaintenanceCheckLoadingState extends MaintenanceCheckState {}
class MaintenanceCheckCommonState extends MaintenanceCheckState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}
class MaintenanceCheckErrorState extends MaintenanceCheckState {
  final dynamic message;
  MaintenanceCheckErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class MaintenanceCheckSuccessState extends MaintenanceCheckState {
  final dynamic message;
  MaintenanceCheckSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}

class MaintenanceCheckCompleteState extends MaintenanceCheckState {}

class MaintenanceTaskExistDialogState extends MaintenanceCheckState {
  final dynamic model;
  MaintenanceTaskExistDialogState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class MaintenanceTaskDeleteDialogState extends MaintenanceCheckState {
  final dynamic model;
  MaintenanceTaskDeleteDialogState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}