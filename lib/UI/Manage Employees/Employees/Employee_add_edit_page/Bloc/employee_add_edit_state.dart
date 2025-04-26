import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class EmployeeAddEditState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmployeesLoadingState extends EmployeeAddEditState {}

class EmployeesCommonState extends EmployeeAddEditState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class EmployeesErrorState extends EmployeeAddEditState {
  final dynamic message;
  EmployeesErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class EmployeesSuccessState extends EmployeeAddEditState {
  final dynamic message;
  EmployeesSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}



