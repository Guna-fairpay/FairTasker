import 'package:equatable/equatable.dart';

abstract class RolesState extends Equatable {
  const RolesState();

  @override
  List<Object?> get props => [];
}

class RolesInitial extends RolesState {
  @override
  List<Object> get props => [];
}

class RolesLoading extends RolesState {}

class RolesListLoaded extends RolesState {
  final List<Map<String, dynamic>>? data;
  const RolesListLoaded(
      {required this.data});
  @override
  List<Object?> get props => [data];
}

class EditRolesLoaded extends RolesState {
  final List<int>? rolePermission;

  const EditRolesLoaded({
        required this.rolePermission,
      });
  @override
  List<Object?> get props => [rolePermission];
}

class PermissionDataForRoleLoaded extends RolesState {
  final List<Map<String, dynamic>>? data;

  const PermissionDataForRoleLoaded(
      {required this.data});

  @override
  List<Object?> get props => [data];
}

class RolesLoaded extends RolesState {
  final String message;
  const RolesLoaded(
      {required this.message});

  @override
  List<Object> get props => [message];
}

class RolesError extends RolesState {
  final String message;

  const RolesError(this.message);

  @override
  List<Object> get props => [message];
}

