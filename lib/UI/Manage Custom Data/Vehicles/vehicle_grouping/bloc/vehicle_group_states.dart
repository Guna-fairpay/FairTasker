import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class VehicleGroupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VehicleGroupLoadingState extends VehicleGroupState {}

class VehicleGroupCommonState extends VehicleGroupState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class VehicleGroupSuccessState extends VehicleGroupState {
  final dynamic message;
  VehicleGroupSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}

class VehicleGroupErrorState extends VehicleGroupState {
  final dynamic message;
  VehicleGroupErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class VehicleGroupDeleteTapVehicleState extends VehicleGroupState {
  final Map<String, dynamic> selectedModel;
  VehicleGroupDeleteTapVehicleState(this.selectedModel);
  @override
  List<Object?> get props => [selectedModel, Random().nextDouble()];

}