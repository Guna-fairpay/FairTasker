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
  final List<Map<String, dynamic>>? data; // Define DashboardData as a list
  const RolesListLoaded(
      {required this.data}); // Define named parameter in constructor
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

