import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart' show TapDownDetails;

abstract class ToDoTaskerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ToDoTaskerLoadingState extends ToDoTaskerState {}
class ToDoTaskerLoadedState extends ToDoTaskerState {}
class ToDoTaskerCommonState extends ToDoTaskerState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ToDoTaskerErrorState extends ToDoTaskerState {
  final dynamic message;
  ToDoTaskerErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class ToDoTaskerSuccessState extends ToDoTaskerState {
  final dynamic message;
  ToDoTaskerSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}

class ToDoTaskerDatePickerState extends ToDoTaskerState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ToDoTaskerAddToDoState extends ToDoTaskerState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}
class ToDoTaskerMicState extends ToDoTaskerState {}

class ToDoTaskerEditState extends ToDoTaskerState {
  final dynamic toDoId;
  ToDoTaskerEditState(this.toDoId);
  @override
  List<Object?> get props => [toDoId, Random().nextDouble()];
}

class ToDoTaskerTapUserFilterState extends ToDoTaskerState {
  final TapDownDetails? details;
  ToDoTaskerTapUserFilterState(this.details);
  @override
  List<Object?> get props => [details];
}

class ToDoTaskerTapVehicleFilterState extends ToDoTaskerState {
  final TapDownDetails? details;

  ToDoTaskerTapVehicleFilterState(this.details);

  @override
  List<Object?> get props => [details];
}

class ToDoTaskerVendorInfoState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerVendorInfoState(this.model);
  @override
  List<Object?> get props => [model];
}

class ToDoTaskerNotesTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerNotesTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ToDoTaskerVehiclePersonTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerVehiclePersonTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ToDoTaskerResourceTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerResourceTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ToDoTaskerAddressTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerAddressTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ToDoTaskerPartsTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerPartsTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ToDoTaskerSuppliesTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerSuppliesTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ToDoTaskerTaskCompletedState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerTaskCompletedState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ToDoTaskerPreviousState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  final List<Map<String, dynamic>>? models;
  ToDoTaskerPreviousState(this.model, this.models);
  @override
  List<Object?> get props => [model, models, Random().nextDouble()];
}

class ToDoTaskerDateChangeTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerDateChangeTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ToDoTaskerCompletedTimeTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerCompletedTimeTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ToDoTaskerTimePickerTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerTimePickerTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ToDoTaskerVendorLocationTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerVendorLocationTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ToDoTaskerVehicleGroupTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerVehicleGroupTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ToDoTaskerCompleteOilChangeState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerCompleteOilChangeState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ToDoTaskerCompleteCheckInState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerCompleteCheckInState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ToDoTaskerCompleteCheckOutState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerCompleteCheckOutState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ToDoTaskerCompleteMaintenanceCheckState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerCompleteMaintenanceCheckState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ToDoTaskerCompleteRentalCheckOutState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerCompleteRentalCheckOutState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ToDoTaskerCompleteRentalPickupState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerCompleteRentalPickupState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ToDoTaskerCompleteDropCarState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerCompleteDropCarState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ToDoTaskerVehicleHistoryTapState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerVehicleHistoryTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ToDoTaskerViewVehicleState extends ToDoTaskerState {
  final Map<String, dynamic>? model;
  ToDoTaskerViewVehicleState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class ToDoTaskerFilterTaskState extends ToDoTaskerState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}