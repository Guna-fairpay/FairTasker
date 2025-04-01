
import 'package:equatable/equatable.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {
  @override
  List<Object> get props => [];
}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final String message;
  const UsersLoaded({required this.message});
  @override
  List<Object?> get props => [message];
}

class UsersListLoaded extends UsersState {
  final List<Map<String, dynamic>>? data;
  const UsersListLoaded({required this.data});
  @override
  List<Object?> get props => [data];
}

class PermissionForUsersLoaded extends UsersState {
  final List<Map<String, dynamic>>? data;
  const PermissionForUsersLoaded({required this.data});
  @override
  List<Object?> get props => [data];
}

class EditUsersLoaded extends UsersState {
  final List<int>? data;
  final List<Map<String, dynamic>>? permission;
  const EditUsersLoaded({required this.data,required this.permission});
  @override
  List<Object?> get props => [data];
}

class UsersError extends UsersState {
  final String message;
  const UsersError(this.message);
  @override
  List<Object> get props => [message];
}

