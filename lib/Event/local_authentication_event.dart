import 'package:equatable/equatable.dart';

abstract class LocalAuthenticationEvent extends Equatable {
  const LocalAuthenticationEvent();
}

class LocalAuthenticationInitialEvent extends LocalAuthenticationEvent {
  @override
  List<Object?> get props => [];
}
