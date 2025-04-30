import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Response/authentication_response.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationLoading extends AuthenticationState {
  const AuthenticationLoading();
  @override
  List<Object> get props => [];
}

class AuthenticationLoaded extends AuthenticationState {
  final User? authenticationData;
  final List<String>? userPermissions;
  const AuthenticationLoaded({required this.authenticationData, required this.userPermissions});
  @override
  List<Object?> get props => [authenticationData, userPermissions];
}

class AuthenticationError extends AuthenticationState {
  final dynamic message;
  const AuthenticationError({this.message});
  @override
  List<Object?> get props => [message];
}
