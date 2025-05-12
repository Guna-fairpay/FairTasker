import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Response/authentication_response.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthenticationLoading extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationLoaded extends AuthenticationState {
  final User? authenticationData;
  final List<String>? userPermissions;
  AuthenticationLoaded({required this.authenticationData, required this.userPermissions});
  @override
  List<Object?> get props => [authenticationData, userPermissions];
}

class AuthenticationError extends AuthenticationState {
  final dynamic message;
  AuthenticationError(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class AuthenticationNavigateState extends AuthenticationState {}
