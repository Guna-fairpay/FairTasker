
import 'package:equatable/equatable.dart';

abstract class RolesEvent extends Equatable {
  const RolesEvent();
}

class RolesInitialEvent extends RolesEvent {
  @override
  List<Object?> get props => [];
}

class GetRolesData extends RolesEvent {
  const GetRolesData();
  @override
  List<Object> get props => [];
}

class GetPermissionDataForRole extends RolesEvent {
  const GetPermissionDataForRole();
  @override
  List<Object> get props => [];

}

class GetEditRoleData extends RolesEvent {
  final int id;
  const GetEditRoleData({required this.id});
  @override
  List<Object> get props => [id];
}

class AddRoleData extends RolesEvent {
  final String name;
  final List<dynamic> permissions;
  final int? id;

  const AddRoleData({
    required this.name,required this.id,required this.permissions
  });
  @override
  List<Object?> get props => [name,permissions,id];
}

class DeleteRole extends RolesEvent {
  final int id;

  const DeleteRole({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}