
import 'package:equatable/equatable.dart';

abstract class EmployeeAddEditEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmployeesAddEditInitialEvent extends EmployeeAddEditEvent {
  final String? id;
  EmployeesAddEditInitialEvent({this.id});
  @override
  List<Object?> get props => [id];
}

class ShowPasswordEvent extends EmployeeAddEditEvent {}

class EmployeesAddEditRoleEvent extends EmployeeAddEditEvent {}

class EmployeesAddEditDepartmentEvent extends EmployeeAddEditEvent {}

class EmployeeSaveEvent extends EmployeeAddEditEvent {}


