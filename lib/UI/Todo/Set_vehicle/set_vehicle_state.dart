
import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class setVehicleState extends Equatable {
  const setVehicleState();
}

class setVehicleInitialState extends setVehicleState {
  const setVehicleInitialState();
  @override
  List<Object?> get props => [];
}

class setVehicleLoading extends setVehicleState {
  const setVehicleLoading();
  @override
  List<Object?> get props => [];
}

class setVehicleLoaded extends setVehicleState {
  const setVehicleLoaded();
  @override
  List<Object?> get props => [];
}

class setVehicleCommonState extends setVehicleState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}