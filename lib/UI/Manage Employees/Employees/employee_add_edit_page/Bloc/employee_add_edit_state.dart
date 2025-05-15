import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class EmployeeAddEditState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmployeeAddEditLoadingState extends EmployeeAddEditState {}

class EmployeeAddEditCommonState extends EmployeeAddEditState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class EmployeeAddEditErrorState extends EmployeeAddEditState {
  final dynamic message;
  EmployeeAddEditErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class EmployeeAddEditSuccessState extends EmployeeAddEditState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}



