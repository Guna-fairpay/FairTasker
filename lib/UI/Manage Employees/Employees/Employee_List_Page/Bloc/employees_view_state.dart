import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class EmployeesViewState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmployeesLoadingState extends EmployeesViewState {}

class EmployeesCommonState extends EmployeesViewState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class EmployeesErrorState extends EmployeesViewState {
  final dynamic message;
  EmployeesErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class EmployeesSuccessState extends EmployeesViewState {
  final dynamic message;
  EmployeesSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}



