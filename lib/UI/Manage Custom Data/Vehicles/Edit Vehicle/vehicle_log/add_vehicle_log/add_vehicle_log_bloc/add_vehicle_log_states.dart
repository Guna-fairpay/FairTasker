import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class AddVehicleLogState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddVehicleLogLoadingState extends AddVehicleLogState {}
class AddVehicleLogCommonState extends AddVehicleLogState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class AddVehicleLogErrorState extends AddVehicleLogState {
  final dynamic message;
  AddVehicleLogErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class AddVehicleLogSuccessState extends AddVehicleLogState {
  final dynamic message;
  AddVehicleLogSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}

class AddVehicleLogCompletedState extends AddVehicleLogState {}

class AddVehicleLogRecorderAudioState extends AddVehicleLogState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class AddVehicleLogDeleteAttachmentState extends AddVehicleLogState {
  final dynamic type;
  AddVehicleLogDeleteAttachmentState(this.type);
  @override
  List<Object?> get props => [Random().nextDouble(), type];
}