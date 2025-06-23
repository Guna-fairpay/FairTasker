part of 'role_view_bloc.dart';

abstract class RoleViewEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends RoleViewEvent{}

class SearchEvent extends RoleViewEvent{
  final String query;
  SearchEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class DeleteEvent extends RoleViewEvent{
  final dynamic data;
  DeleteEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class PaginationEvent extends RoleViewEvent{
  final int page;
  PaginationEvent(this.page);
  @override
  List<Object?> get props => [page];
}

class TabEvent extends RoleViewEvent{
  final int index;
  TabEvent(this.index);
  @override
  List<Object?> get props => [index];
}

class AddEditEvent extends RoleViewEvent{
  final dynamic data;
  final bool isRoleEdit;
  final bool isUserEdit;
  AddEditEvent({this.data, required this.isRoleEdit, required this.isUserEdit});
  @override
  List<Object?> get props => [data, isRoleEdit, isUserEdit];
}

class RefreshEvent extends RoleViewEvent{}

