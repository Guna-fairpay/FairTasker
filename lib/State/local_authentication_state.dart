import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class LocalAuthenticationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LocalAuthenticationLoadingState extends LocalAuthenticationState {}
class LocalAuthenticationSuccessState extends LocalAuthenticationState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}
class LocalAuthenticationFailureState extends LocalAuthenticationState {
  final dynamic message;
  LocalAuthenticationFailureState({this.message});
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}


