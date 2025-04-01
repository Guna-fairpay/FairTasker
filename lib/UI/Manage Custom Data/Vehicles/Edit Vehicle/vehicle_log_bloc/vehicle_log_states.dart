import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class VehicleLogState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VehicleLogLoadingState extends VehicleLogState {}

class VehicleLogCommonState extends VehicleLogState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class VehicleLogErrorState extends VehicleLogState {
  final dynamic message;
  VehicleLogErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class VehicleLogSuccessState extends VehicleLogState {
  final dynamic message;
  VehicleLogSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}

class VehicleLogAddState extends VehicleLogState {
  final dynamic vin;
  VehicleLogAddState(this.vin);
  @override
  List<Object?> get props => [vin, Random().nextDouble()];
}

class VehicleLogDeleteTapState extends VehicleLogState {
  final Map<String, dynamic>? model;
  VehicleLogDeleteTapState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}

class VehicleLogViewAttachmentState extends VehicleLogState {
  final Map<String, dynamic>? model;
  VehicleLogViewAttachmentState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}