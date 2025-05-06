import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class TaskerStatusState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskerStatusLoadingState extends TaskerStatusState {}

class TaskerStatusCommonState extends TaskerStatusState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TaskerStatusErrorState extends TaskerStatusState {
  final dynamic message;
  TaskerStatusErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class TaskerStatusSuccessState extends TaskerStatusState {
  final dynamic message;
  TaskerStatusSuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}