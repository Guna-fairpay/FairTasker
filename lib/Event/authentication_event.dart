import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class AuthenticationInitialEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class DoLoginEvent extends AuthenticationEvent {
  final String email;
  final String password;
  // final String deviceId;

  const DoLoginEvent(
      {required this.email, required this.password/*, required this.deviceId*/});
  @override
  List<Object> get props => [email, password/*, deviceId*/];
}
