part of 'vendor_type_bloc.dart';

abstract class VendorTypeState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends VendorTypeState{}

class CommonState extends VendorTypeState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends VendorTypeState{
  final dynamic error;
  ErrorState(this.error);
  @override
  List<Object?> get props => [error, Random().nextDouble()];
}

class SuccessState extends VendorTypeState{
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}