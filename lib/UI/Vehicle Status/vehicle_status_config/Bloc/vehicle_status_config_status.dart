
import 'dart:math';
import 'package:equatable/equatable.dart';

abstract  class VehicleStatusConfigStatus extends Equatable{
  @override
  List<Object?> get props => [];
}

class VehicleStatusConfigLoadingState extends VehicleStatusConfigStatus{}

class VehicleStatusConfigLoadedState extends VehicleStatusConfigStatus{}

class VehicleStatusConfigCommonState extends VehicleStatusConfigStatus{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class VehicleStatusConfigErrorState extends VehicleStatusConfigStatus {
  final dynamic message;
  VehicleStatusConfigErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

