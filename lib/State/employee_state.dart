import 'package:equatable/equatable.dart';
///Employee
abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object?> get props => [];
}

class EmployeeInitial extends EmployeeState {
  @override
  List<Object> get props => [];
}

class EmployeeLoading extends EmployeeState {}

class EmployeeListLoaded extends EmployeeState {
  final List<Map<String, dynamic>>? data;
  const EmployeeListLoaded({required this.data});
  @override
  List<Object?> get props => [data];
}

class EmployeeRoleLoaded extends EmployeeState {
  final List<Map<String, dynamic>>? data;
  const EmployeeRoleLoaded({required this.data});
  @override
  List<Object?> get props => [data];
}

class EmployeeDepartmentLoaded extends EmployeeState {
  final List<Map<String, dynamic>>? data;
  const EmployeeDepartmentLoaded({required this.data});
  @override
  List<Object?> get props => [data];
}

class EditEmployeeListLoaded extends EmployeeState {
  final List<Map<String, dynamic>>? role;
  final Map<String, dynamic>? user;
  final List<int>? userRole;

  const EditEmployeeListLoaded(
      {required this.role,
        required this.user,
      required this.userRole});

  @override
  List<Object?> get props => [role,user,userRole];
}

class EmployeeLoaded extends EmployeeState {
  final String message;

  const EmployeeLoaded(
      {required this.message});

  @override
  List<Object> get props => [message];
}


class EmployeeError extends EmployeeState {
  final String message;

  const EmployeeError(this.message);

  @override
  List<Object> get props => [message];
}

