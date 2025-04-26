
import 'package:equatable/equatable.dart';

abstract class EmployeeAddEditEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmployeesInitialEvent extends EmployeeAddEditEvent {
  final String? title;
  EmployeesInitialEvent({this.title});
  @override
  List<Object?> get props => [title];
}


class EmployeesPaginationEvent extends EmployeeAddEditEvent {
  final int page;
  EmployeesPaginationEvent({required this.page});
  @override
  List<Object?> get props => [page];
}

class SearchEmployeesEvent extends EmployeeAddEditEvent {
  final String query;
  SearchEmployeesEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class DeleteEmployeesEvent extends EmployeeAddEditEvent {
  final dynamic data;
  DeleteEmployeesEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class AddOrEditEvent extends EmployeeAddEditEvent {}


