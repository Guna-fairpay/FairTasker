
import 'dart:math';
import 'package:equatable/equatable.dart';

abstract  class  VehicleStatusConfigState extends Equatable{
  @override
  List<Object?> get props => [];
}

class VehicleStatusConfigLoadingState extends VehicleStatusConfigState{}

class VehicleStatusConfigLoadedState extends VehicleStatusConfigState{}

class VehicleStatusConfigCommonState extends VehicleStatusConfigState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ShowSwapDialogState extends VehicleStatusConfigState{

  @override
  List<Object?> get props => [Random().nextDouble()];
}

class VehicleStatusConfigErrorState extends VehicleStatusConfigState {
  final dynamic message;
  VehicleStatusConfigErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

