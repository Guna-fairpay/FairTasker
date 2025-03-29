import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class PrivateRentalState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PrivateRentalLoadingState extends PrivateRentalState {}

class PrivateRentalLoadedState extends PrivateRentalState {}

class PrivateRentalCommonState extends PrivateRentalState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class PrivateRentalErrorState extends PrivateRentalState {
  final dynamic message;
  PrivateRentalErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class PrivateRentalSuccessState extends PrivateRentalState {
  final dynamic message;
  PrivateRentalSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}

class AddPrivateRentalState extends PrivateRentalState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class EditPrivateRentalState extends PrivateRentalState {
  final dynamic vehicleData;
  EditPrivateRentalState({required this.vehicleData});
  @override
  List<Object?> get props => [Random().nextDouble()];
}


