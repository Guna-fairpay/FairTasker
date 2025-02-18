
import 'package:equatable/equatable.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();
}

class UsersInitialEvent extends UsersEvent {
  @override
  List<Object?> get props => [];
}

class GetUsersData extends UsersEvent {
  const GetUsersData();
  @override
  List<Object> get props => [];
}

class GetPermissionForUsers extends UsersEvent {
  const GetPermissionForUsers();
  @override
  List<Object> get props => [];
}

class GetEditUsers extends UsersEvent {
  final int id;
  const GetEditUsers({required this.id});
  @override
  List<Object> get props => [id];
}

class AddUsersData extends UsersEvent {
  final int? user;
  final List<int>? permissions;
  const AddUsersData({
    required this.user,
    required this.permissions,
    });
  @override
  List<Object?> get props => [user,permissions];
}

class DeleteUsersData extends UsersEvent {
  final int id;
  const DeleteUsersData({
    required this.id,
  });
  @override
  List<Object> get props => [id];
}