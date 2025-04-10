import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskLoadingState extends TaskState {}

class TaskCommonState extends TaskState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TaskErrorState extends TaskState {
  final dynamic message;
  TaskErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class TaskSuccessState extends TaskState {
  final dynamic message;
  TaskSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}



