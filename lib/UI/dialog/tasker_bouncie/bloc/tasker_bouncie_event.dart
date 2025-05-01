import 'package:equatable/equatable.dart';

abstract class TaskerBouncieEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskerBouncieInitialEvent extends TaskerBouncieEvent {
  final dynamic model;
  TaskerBouncieInitialEvent(this.model);
  @override
  List<Object?> get props => [model];
}