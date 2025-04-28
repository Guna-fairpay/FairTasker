import 'package:equatable/equatable.dart';

abstract class LocalAuthenticationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LocalAuthenticationInitialEvent extends LocalAuthenticationEvent {}
class LocalAuthenticationCheckEvent extends LocalAuthenticationEvent {}
