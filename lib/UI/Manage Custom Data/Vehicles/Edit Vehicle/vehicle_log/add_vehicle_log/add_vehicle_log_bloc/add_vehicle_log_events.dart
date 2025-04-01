import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class AddVehicleLogEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddVehicleLogInitialEvent extends AddVehicleLogEvent {
  final dynamic vin;
  AddVehicleLogInitialEvent(this.vin);
  @override
  List<Object?> get props => [vin];
}

class AddVehicleLogRecordVideoEvent extends AddVehicleLogEvent {}

class AddVehicleLogRecordAudioEvent extends AddVehicleLogEvent {}

class AddVehicleLogUploadImageEvent extends AddVehicleLogEvent {}

class AddVehicleLogSubmitEvent extends AddVehicleLogEvent {}

class AddVehicleLogAudioInsertEvent extends AddVehicleLogEvent {
  final File? file;
  AddVehicleLogAudioInsertEvent(this.file);
  @override
  List<Object?> get props => [file];
}