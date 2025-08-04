part of 'task_components_bloc.dart';

abstract class TaskComponentEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends TaskComponentEvent {}

class DropdownBaseEvent extends TaskComponentEvent {
  final Map<String, dynamic> value;
  DropdownBaseEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class ResourceDropdownEvent extends TaskComponentEvent {
  final Map<String, dynamic> value;
  ResourceDropdownEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class TabBarEvent extends TaskComponentEvent {
  final int tabIndex;
  TabBarEvent({required this.tabIndex});
  @override
  List<Object?> get props => [tabIndex];
}

class DeleteEvent extends TaskComponentEvent {
  final Map<String, dynamic> value;
  DeleteEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class EditEvent extends TaskComponentEvent {
  final Map<String, dynamic> value;
  EditEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class SaveEvent extends TaskComponentEvent {}

class UpdateEvent extends TaskComponentEvent {}

class ClearAllFieldEvent extends TaskComponentEvent {}

