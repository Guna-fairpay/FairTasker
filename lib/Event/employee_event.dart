import 'package:equatable/equatable.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();
}

class EmployeeInitialEvent extends EmployeeEvent {
  @override
  List<Object?> get props => [];
}

class GetEmployeeData extends EmployeeEvent {
  const GetEmployeeData();
  @override
  List<Object> get props => [];
}

class GetEmployeeDepartmentData extends EmployeeEvent {
  const GetEmployeeDepartmentData();
  @override
  List<Object> get props => [];
}

class GetEmployeeRoleData extends EmployeeEvent {
  const GetEmployeeRoleData();
  @override
  List<Object> get props => [];
}

class GetEditEmployeeData extends EmployeeEvent {
  final int? id;
  const GetEditEmployeeData({required this.id});
  @override
  List<Object?> get props => [id];
}

class AddEmployeeData extends EmployeeEvent {
  final String firstname;
  final String lastname;
  final String email;
  final String phone;
  final String department;
  final String? password;
  final String role;
  final int? id;

  const AddEmployeeData({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.department,
    required this.password,
    required this.role,
    required this.id,
  });
  @override
  List<Object?> get props =>
      [firstname, lastname, email, password, phone, department, role, id];
}

class EditEmployeeData extends EmployeeEvent {
  final String firstname;
  final String lastname;
  final String email;
  final String phone;
  final String department;
  final int role;
  final int? id;

  const EditEmployeeData({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.department,
    required this.role,
    required this.id,
  });
  @override
  List<Object?> get props =>
      [firstname, lastname, email, phone, department, role, id];
}

class DeleteEmployeeData extends EmployeeEvent {
  final String id;

  const DeleteEmployeeData({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
