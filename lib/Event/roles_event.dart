
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

class AddRoleData extends RolesEvent {

  final String name;
  final String permissions;
  final int? id;

  const AddRoleData({
    required this.name,required this.id,required this.permissions
  });
  @override
  List<Object?> get props => [name,permissions,id];
}

class DeleteDepartment extends RolesEvent {
  final String id;

  const DeleteDepartment({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}