part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingState extends SplashState {}
class NavigateLoginState extends SplashState {}
class NavigateHomeState extends SplashState {}