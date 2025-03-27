import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class VehicleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VehicleLoadingState extends VehicleState {}

class VehicleLoadedState extends VehicleState {}

class VehicleCommonState extends VehicleState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class VehicleErrorState extends VehicleState {
  final dynamic message;
  VehicleErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class VehicleSuccessState extends VehicleState {
  final dynamic message;
  VehicleSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}

class AddVehicleState extends VehicleState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}


