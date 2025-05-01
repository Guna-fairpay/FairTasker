
import 'package:equatable/equatable.dart';

abstract class EmployeeAddEditEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmployeesAddEditInitialEvent extends EmployeeAddEditEvent {
  final dynamic id;
  EmployeesAddEditInitialEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class ShowPasswordEvent extends EmployeeAddEditEvent {}

class EmployeesAddEditRoleEvent extends EmployeeAddEditEvent {}

class EmployeesAddEditDepartmentEvent extends EmployeeAddEditEvent {}

class EmployeeSaveEvent extends EmployeeAddEditEvent {}

class RoleSelectionEvent extends EmployeeAddEditEvent {
  final dynamic value;
  RoleSelectionEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class DepartmentSelectionEvent extends EmployeeAddEditEvent {
  final dynamic value;
  DepartmentSelectionEvent({required this.value});
  @override
  List<Object?> get props => [value];
}


