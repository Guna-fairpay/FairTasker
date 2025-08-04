


import 'package:equatable/equatable.dart';

abstract class OdometerEvent extends Equatable  {
  const OdometerEvent();
  @override
  List<Object?> get props => [];
}

class OdometerInitialEvent extends OdometerEvent{
  final Map<String, dynamic>? vehicle;
  final Map<String, dynamic>? todoItems;
  final dynamic selectedVehicle;

  const OdometerInitialEvent({
    required this.vehicle,
    required this.todoItems,
    required this.selectedVehicle,
  });
}

class OdometerSaveEvent extends OdometerEvent{
  final dynamic currentOdometer;
  final dynamic nextOdometer;
  final dynamic nextMilesCheck;
  final dynamic toDoId;
  const OdometerSaveEvent({
    required this.currentOdometer,
    required this.nextOdometer,
    required this.nextMilesCheck,
    required this.toDoId,});
}