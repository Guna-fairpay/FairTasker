part of 'checkout_bloc.dart';

abstract class CheckoutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingState extends CheckoutState {}

class CommonState extends CheckoutState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends CheckoutState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends CheckoutState {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class ApproveAndCloseState extends CheckoutState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}