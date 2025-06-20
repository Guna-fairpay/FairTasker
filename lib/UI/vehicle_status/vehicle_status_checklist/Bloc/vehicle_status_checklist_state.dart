
import 'dart:math';
import 'package:equatable/equatable.dart';

abstract  class VehicleStatusChecklistState extends Equatable{
  @override
  List<Object?> get props => [];
}

class VehicleStatusChecklistLoadingState extends VehicleStatusChecklistState{}

class VehicleStatusChecklistLoadedState extends VehicleStatusChecklistState{}

class VehicleStatusChecklistCommonState extends VehicleStatusChecklistState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class VehicleStatusChecklistErrorState extends VehicleStatusChecklistState {
  final dynamic message;
  VehicleStatusChecklistErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

