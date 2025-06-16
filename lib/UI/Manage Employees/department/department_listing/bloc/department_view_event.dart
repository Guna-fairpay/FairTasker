part of 'department_view_bloc.dart';

abstract class DepartmentViewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialEvent extends DepartmentViewEvent {}

class AddEditEvent extends DepartmentViewEvent{
  final dynamic model;
  AddEditEvent({this.model});
  @override
  List<Object?> get props => [model];
}

class DeleteEvent extends DepartmentViewEvent{
  final dynamic model;
  DeleteEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class PaginationEvent extends DepartmentViewEvent{
  final int page;
  PaginationEvent(this.page);
  @override
  List<Object?> get props => [page];
}

class  SearchEvent extends DepartmentViewEvent{
  final dynamic query;
  SearchEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class RefreshEvent extends DepartmentViewEvent {}