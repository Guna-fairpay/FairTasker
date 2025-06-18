part of 'role_add_edit_bloc.dart';

abstract class RoleAddEditEvent extends Equatable{
 @override
  List<Object?> get props => [];
}

class InitialEvent extends RoleAddEditEvent{
  final dynamic data;
  final bool isRoleEdit;
  final bool isUserEdit;
  InitialEvent({this.data, required this.isRoleEdit, required this.isUserEdit});
  @override
  List<Object?> get props => [data, isRoleEdit, isUserEdit];
}

class BaseOnEvent extends RoleAddEditEvent{
  final dynamic data;
  BaseOnEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class UserEvent extends RoleAddEditEvent{
  final dynamic data;
  UserEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class PermissionEvent extends RoleAddEditEvent{
  final dynamic data;
  PermissionEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class SaveEvent extends RoleAddEditEvent{}

