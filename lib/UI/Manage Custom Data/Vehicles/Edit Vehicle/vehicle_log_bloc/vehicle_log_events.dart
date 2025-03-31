import 'package:equatable/equatable.dart';

abstract class VehicleLogEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class VehicleLogInitialEvent extends VehicleLogEvent {
  final dynamic vin;
  VehicleLogInitialEvent(this.vin);
  @override
  List<Object?> get props => [vin];
}

class AddVehicleLogEvent extends VehicleLogEvent {}

class VehicleLogSearchEvent extends VehicleLogEvent {
  final String searchQuery;
  VehicleLogSearchEvent(this.searchQuery);
  @override
  List<Object?> get props => [searchQuery];
}

class VehicleLogViewAttachmentEvent extends VehicleLogEvent {
  final Map<String, dynamic>? model;
  VehicleLogViewAttachmentEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class VehicleLogDeleteEvent extends VehicleLogEvent {
  final Map<String, dynamic>? model;
  VehicleLogDeleteEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class VehicleLogDeleteTapEvent extends VehicleLogEvent {
  final Map<String, dynamic>? model;
  VehicleLogDeleteTapEvent(this.model);
  @override
  List<Object?> get props => [model];
}

