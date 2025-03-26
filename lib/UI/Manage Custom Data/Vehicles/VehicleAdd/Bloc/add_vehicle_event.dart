import 'dart:math';
import 'package:equatable/equatable.dart';

abstract class AddVehicleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddVehicleInitialEvent extends AddVehicleEvent {}

class MoveToPrivateRentalEvent extends AddVehicleEvent {
  final dynamic vehicleData;
  MoveToPrivateRentalEvent({required this.vehicleData});
  @override
  List<Object?> get props => [vehicleData];
}