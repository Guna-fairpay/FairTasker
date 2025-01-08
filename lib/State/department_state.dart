
import 'package:equatable/equatable.dart';

abstract class DepartmentState extends Equatable {
  const DepartmentState();

  @override
  List<Object?> get props => [];
}

class DepartmentInitial extends DepartmentState {
  @override
  List<Object> get props => [];
}

class DepartmentLoading extends DepartmentState {}

class DepartmentListLoaded extends DepartmentState {
  final List<Map<String, dynamic>>? data;

  const DepartmentListLoaded(
      {required this.data});

  @override
  List<Object?> get props => [data];
}

class DepartmentLoaded extends DepartmentState {
  final String? message;
  const DepartmentLoaded({required this.message,});
  @override
  List<Object?> get props => [message];
}


class DepartmentError extends DepartmentState {
  final String message;

  const DepartmentError(this.message);

  @override
  List<Object> get props => [message];
}

