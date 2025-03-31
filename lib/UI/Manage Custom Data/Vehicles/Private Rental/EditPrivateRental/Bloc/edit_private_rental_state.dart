import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class EditPrivateRentalState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditPrivateRentalLoadingState extends EditPrivateRentalState {}

class EditPrivateRentalLoadedState extends EditPrivateRentalState {}

class EditCustomerState extends EditPrivateRentalState {}

class EditPrivateRentalCommonState extends EditPrivateRentalState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class EditPrivateRentalErrorState extends EditPrivateRentalState {
  final dynamic message;
  EditPrivateRentalErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class EditPrivateRentalSuccessState extends EditPrivateRentalState {
  final dynamic message;
  EditPrivateRentalSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}


