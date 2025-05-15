
import 'package:equatable/equatable.dart';

abstract class EmployeesViewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmployeesInitialEvent extends EmployeesViewEvent {
  final String? title;
  EmployeesInitialEvent({this.title});
  @override
  List<Object?> get props => [title];
}


class EmployeesPaginationEvent extends EmployeesViewEvent {
  final int page;
  EmployeesPaginationEvent({required this.page});
  @override
  List<Object?> get props => [page];
}

class SearchEmployeesEvent extends EmployeesViewEvent {
  final String query;
  SearchEmployeesEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class DeleteEmployeesEvent extends EmployeesViewEvent {
  final dynamic data;
  DeleteEmployeesEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class AddOrEditEvent extends EmployeesViewEvent {
  final dynamic data;
  AddOrEditEvent({this.data});
  @override
  List<Object?> get props => [data];
}


