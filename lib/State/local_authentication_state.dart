part of '../Bloc/local_authentication_bloc.dart';

abstract class LocalAuthenticationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingState extends LocalAuthenticationState {}
class SuccessState extends LocalAuthenticationState {}
class FailureState extends LocalAuthenticationState {
  final dynamic message;
  FailureState({this.message});
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}
class CommonState extends LocalAuthenticationState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}


