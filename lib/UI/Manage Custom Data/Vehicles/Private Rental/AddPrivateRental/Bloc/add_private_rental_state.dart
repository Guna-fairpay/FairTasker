import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class AddPrivateRentalState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddPrivateRentalLoadingState extends AddPrivateRentalState {}

class AddPrivateRentalLoadedState extends AddPrivateRentalState {}

class AddCustomerState extends AddPrivateRentalState {}

class AddPrivateRentalCompleteState extends AddPrivateRentalState {}

class AddPrivateRentalCommonState extends AddPrivateRentalState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class AddPrivateRentalErrorState extends AddPrivateRentalState {
  final dynamic message;
  AddPrivateRentalErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class AddPrivateRentalSuccessState extends AddPrivateRentalState {
  final dynamic message;
  AddPrivateRentalSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}


