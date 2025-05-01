import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class TaskerBouncieState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskerBouncieLoadingState extends TaskerBouncieState {}
class TaskerBouncieCommonState extends TaskerBouncieState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TaskerBouncieErrorState extends TaskerBouncieState {
  final dynamic message;
  TaskerBouncieErrorState(this.message);
  @override
  List<Object?> get props => [message];
}