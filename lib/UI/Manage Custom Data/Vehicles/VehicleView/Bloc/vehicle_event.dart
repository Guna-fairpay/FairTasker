import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class VehicleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class VehicleInitialEvent extends VehicleEvent {
  final dynamic vin;
  VehicleInitialEvent({this.vin});
  @override
  List<Object?> get props => [vin];
}

class SearchVehicleEvent extends VehicleEvent {
  final String? query;
  SearchVehicleEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class SelectedVehicleEvent extends VehicleEvent {
  final int vehicleId;
  final bool isSelected;
  final dynamic vehicle;
  SelectedVehicleEvent({required this.vehicleId,required this.isSelected, this.vehicle});
  @override
  List<Object?> get props => [vehicleId,isSelected, vehicle];
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

class EditVehicleTabEvent extends VehicleEvent {
  final dynamic vehicleData;
  EditVehicleTabEvent({required this.vehicleData});
  @override
  List<Object?> get props => [vehicleData];
}

class VehiclePaginationEvent extends VehicleEvent {
  final int page;
  VehiclePaginationEvent({required this.page});
  @override
  List<Object?> get props => [page];
}

class VehicleResetEvent extends VehicleEvent {}

class VehicleTabChangeEvent extends VehicleEvent {
  final int tabIndex;
  VehicleTabChangeEvent({required this.tabIndex});
  @override
  List<Object?> get props => [tabIndex];
}

class VehicleClearEditEvent extends VehicleEvent {}

class VehicleGroupingTapEvent extends VehicleEvent {}