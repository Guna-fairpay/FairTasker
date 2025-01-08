
import 'package:equatable/equatable.dart';

abstract class PermissionEvent extends Equatable {
  const PermissionEvent();
}

class PermissionInitialEvent extends PermissionEvent {
  @override
  List<Object?> get props => [];
}

class GetPermissionData extends PermissionEvent {
  const GetPermissionData();
  @override
  List<Object> get props => [];
}

class AddPermissionData extends PermissionEvent {

  final String name;
  final int? id;

  const AddPermissionData({
    required this.name,
    required this.id,
  });
  @override
  List<Object?> get props => [name,id];
}

class DeletePermissionData extends PermissionEvent {
  final String id;

  const DeletePermissionData({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
