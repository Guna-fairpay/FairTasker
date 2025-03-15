import 'dart:math';

import 'package:equatable/equatable.dart';

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