
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
  final String message; // Define DashboardData as a list

  const UsersLoaded(
      {required this.message}); // Define named parameter in constructor

  @override
  List<Object?> get props => [message];
}

class UsersListLoaded extends UsersState {
  final List<Map<String, dynamic>>? data; // Define DashboardData as a list

  const UsersListLoaded(
      {required this.data}); // Define named parameter in constructor

  @override
  List<Object?> get props => [data];
}

class UsersError extends UsersState {
  final String message;

  const UsersError(this.message);

  @override
  List<Object> get props => [message];
}

