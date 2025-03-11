import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/UI/Vehicle%20Status/vehicle_status_list/bloc/vehicle_status_config.dart';

abstract class VehicleStatusState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VehicleStatusLoadingState extends VehicleStatusState {}
class VehicleStatusLoadedState extends VehicleStatusState {}

class VehicleStatusErrorState extends VehicleStatusState {
  final dynamic errorMessage;
  VehicleStatusErrorState(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}

class VehicleStatusSuccessState extends VehicleStatusState {
  final dynamic successMessage;
  VehicleStatusSuccessState(this.successMessage);
  @override
  List<Object?> get props => [successMessage];
}

class VehicleStatusShowSearcherState extends VehicleStatusState {}
class VehicleStatusHideSearcherState extends VehicleStatusState {}

class VehicleStatusChangedState extends VehicleStatusState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class VehicleStatusOnPressedState extends VehicleStatusState {
  final Map<String, dynamic>? data;
  final VehicleStatusOnPressed? type;
  final int? tripCategory;
  VehicleStatusOnPressedState(this.data, this.type, this.tripCategory);
  @override
  List<Object?> get props => [data, type, tripCategory, Random().nextDouble()];
}