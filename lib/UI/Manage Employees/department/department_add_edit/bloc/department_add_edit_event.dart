part of'department_add_edit_bloc.dart';

abstract class DepartmentAddEditEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends DepartmentAddEditEvent{
  final dynamic model;
  InitialEvent({this.model});
  @override
  List<Object?> get props => [model];
}

class SaveEvent extends DepartmentAddEditEvent{}

class HeadSelectionEvent extends DepartmentAddEditEvent{
  final dynamic value;
  HeadSelectionEvent({required this.value});
  @override
  List<Object?> get props => [value];
}