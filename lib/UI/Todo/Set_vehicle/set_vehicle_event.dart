

import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class setVehicleEvent extends Equatable {
  const setVehicleEvent();
  @override
  List<Object?> get props => [];
}



class setVehicleInitialEvents extends setVehicleEvent {
  final dynamic vehicle;
  final dynamic todoItems;
  const setVehicleInitialEvents({this.vehicle,this.todoItems});
  @override
  List<Object?> get props => [vehicle, todoItems];
}


class setVehicleBouncieEvent extends setVehicleEvent {
  final bool value;
  const setVehicleBouncieEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class setVehicleAirTagEvent extends setVehicleEvent {
  final bool value;
  const setVehicleAirTagEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class setVehicleSpareTireEvent extends setVehicleEvent {
  final bool value;
  const setVehicleSpareTireEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class setVehicleTollTagsEvent extends setVehicleEvent {
  final bool value;
  const setVehicleTollTagsEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class setVehicleSpareKeyEvent extends setVehicleEvent {
  final bool value;
  const setVehicleSpareKeyEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class setVehiclePermanentPlateEvent extends setVehicleEvent {
  final bool value;
  const setVehiclePermanentPlateEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class setVehicleFLicensePlateEvent extends setVehicleEvent {
  final bool value;
  const setVehicleFLicensePlateEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class setVehicleDatePickerEvent extends setVehicleEvent {
  final dynamic value;
  const setVehicleDatePickerEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class setVehicleSaveEvent extends setVehicleEvent { }

class createSparekeyTask extends setVehicleEvent { }

class setVehicleAddAttachmentEvent extends setVehicleEvent {
  final dynamic imageType;
  const setVehicleAddAttachmentEvent({required this.imageType});
  @override
  List<Object?> get props => [imageType, Random().nextDouble()];
}

class setVehicleRemoveAttachmentEvent extends setVehicleEvent {
  final dynamic attachment;
  final List<dynamic> attachments;
  final dynamic imageType;
  const setVehicleRemoveAttachmentEvent(this.attachment, this.attachments, this.imageType);
  @override
  List<Object?> get props => [attachment, attachments, imageType, Random().nextDouble()];
}
