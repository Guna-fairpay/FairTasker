part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingState extends SplashState {}
class CommonState extends SplashState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}
class NavigateLoginState extends SplashState {}
class NavigateHomeState extends SplashState {}