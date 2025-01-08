
import 'package:equatable/equatable.dart';

abstract class LeaveManagementState extends Equatable {
  const LeaveManagementState();

  @override
  List<Object?> get props => [];
}

class LeaveManagementInitial extends LeaveManagementState {
  @override
  List<Object> get props => [];
}

class LeaveManagementLoading extends LeaveManagementState {}

class LeaveManagementListLoaded extends LeaveManagementState {
  final List<Map<String, dynamic>>? data;

  const LeaveManagementListLoaded(
      {required this.data});

  @override
  List<Object?> get props => [data];
}

class LeaveManagementLoaded extends LeaveManagementState {
  final String? message;
  const LeaveManagementLoaded({required this.message,});
  @override
  List<Object?> get props => [message];
}


class LeaveManagementError extends LeaveManagementState {
  final String message;

  const LeaveManagementError(this.message);

  @override
  List<Object> get props => [message];
}

class LeaveManagementEmployeeListLoaded extends LeaveManagementState {
  final List<Map<String, dynamic>>? data;

  const LeaveManagementEmployeeListLoaded(
      {required this.data});

  @override
  List<Object?> get props => [data];
}

class LeaveTypeListLoaded extends LeaveManagementState {
  final List<Map<String, dynamic>>? data;

  const LeaveTypeListLoaded(
      {required this.data});

  @override
  List<Object?> get props => [data];
}
