import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class VehicleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class VehicleInitialEvent extends VehicleEvent {}

class SearchVehicleEvent extends VehicleEvent {
  final String? query;
  SearchVehicleEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class SelectedVehicleEvent extends VehicleEvent {
  final int vehicleId;
  final bool isSelected;
  SelectedVehicleEvent({required this.vehicleId,required this.isSelected});
  @override
  List<Object?> get props => [vehicleId,isSelected];
}

class VehicleDeleteEvent extends VehicleEvent {
  final String vehicleId;
  VehicleDeleteEvent({required this.vehicleId});
  @override
  List<Object?> get props => [vehicleId];
}

class MoveToPrivateRentalEvent extends VehicleEvent {
  final dynamic vehicleData;
  MoveToPrivateRentalEvent({required this.vehicleData});
  @override
  List<Object?> get props => [vehicleData];
}

class AddVehicleEvent extends VehicleEvent {}