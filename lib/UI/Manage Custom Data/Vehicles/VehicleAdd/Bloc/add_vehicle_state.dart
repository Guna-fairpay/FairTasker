import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class AddVehicleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddVehicleLoadingState extends AddVehicleState {}

class AddVehicleLoadedState extends AddVehicleState {}

class AddVehicleCommonState extends AddVehicleState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class AddCompletedState extends AddVehicleState {}

class AddVehicleErrorState extends AddVehicleState {
  final dynamic message;
  AddVehicleErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class AddVehicleSuccessState extends AddVehicleState {
  final dynamic message;
  AddVehicleSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}


