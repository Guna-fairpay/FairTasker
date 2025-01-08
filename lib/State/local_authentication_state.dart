import 'package:equatable/equatable.dart';

abstract class LocalAuthenticationState extends Equatable {
  const LocalAuthenticationState();
}

class LocalAuthenticationInitial extends LocalAuthenticationState {
  @override
  List<Object> get props => [];
}
