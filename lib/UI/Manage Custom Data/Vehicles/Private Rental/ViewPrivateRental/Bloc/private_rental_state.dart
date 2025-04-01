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
  final dynamic rentalData;
  AddPrivateRentalState({this.rentalData});
  @override
  List<Object?> get props => [rentalData, Random().nextDouble()];
}

class EditPrivateRentalState extends PrivateRentalState {
  final dynamic rentalData;
  EditPrivateRentalState({required this.rentalData});
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class PrivateRentalCompleteState extends PrivateRentalState {}


