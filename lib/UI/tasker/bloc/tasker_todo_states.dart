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

class ToDoTaskerAddToDoState extends ToDoTaskerState {}
class ToDoTaskerMicState extends ToDoTaskerState {}

class ToDoTaskerEditState extends ToDoTaskerState {
  final dynamic toDoId;
  ToDoTaskerEditState(this.toDoId);
  @override
  List<Object?> get props => [toDoId];
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