part of 'vendor_bloc.dart';

abstract class VendorState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends VendorState {}

class ErrorState extends VendorState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class CommonState extends VendorState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class SuccessState extends VendorState {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}