import 'dart:math';

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

class RolesLoading extends RolesState {
  @override
  // TODO: implement props
  List<Object?> get props => [Random().nextDouble()];
}

class RolesListLoaded extends RolesState {
  final List<Map<String, dynamic>>? data;
  const RolesListLoaded(
      {required this.data});
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class EditRolesLoaded extends RolesState {
  final List<int>? rolePermission;
  final List<Map<String, dynamic>>? data;
  const EditRolesLoaded({
    required this.rolePermission,
    required this.data,
      });
  @override
  List<Object?> get props => [rolePermission,data];
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

