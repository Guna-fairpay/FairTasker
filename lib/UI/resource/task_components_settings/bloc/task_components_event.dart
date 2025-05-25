
import 'package:equatable/equatable.dart';

abstract class TaskComponentEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class TaskComponentInitialEvent extends TaskComponentEvent {}

class TaskComponentDropdownBaseEvent extends TaskComponentEvent {
  final Map<String, dynamic> value;
  TaskComponentDropdownBaseEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class TaskComponentResourceDropdownEvent extends TaskComponentEvent {
  final Map<String, dynamic> value;
  TaskComponentResourceDropdownEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class TaskComponentTabBarEvent extends TaskComponentEvent {
  final int tabIndex;
  TaskComponentTabBarEvent({required this.tabIndex});
  @override
  List<Object?> get props => [tabIndex];
}

class TaskComponentDeleteEvent extends TaskComponentEvent {
  final Map<String, dynamic> value;
  TaskComponentDeleteEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class TaskComponentEditEvent extends TaskComponentEvent {
  final Map<String, dynamic> value;
  TaskComponentEditEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class TaskComponentSaveEvent extends TaskComponentEvent {}

class TaskComponentUpdateEvent extends TaskComponentEvent {}

class TaskComponentClearAllFieldEvent extends TaskComponentEvent {}

