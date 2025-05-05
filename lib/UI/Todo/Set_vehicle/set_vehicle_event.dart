

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

class DeleteVehicleImage extends setVehicleEvent {
  final int? id;
  const DeleteVehicleImage({required this.id,});
  @override
  List<Object?> get props => [id,];
}

// class setVehicleUpdateEvents extends setVehicleEvent {
//   final dynamic vehicle;
//   final dynamic todoItems;
//   const setVehicleUpdateEvents({this.vehicle,this.todoItems});
//   @override
//   List<Object?> get props => [vehicle, todoItems];
// }

class setVehicleBouncieEvent extends setVehicleEvent {
  final bool value;
  setVehicleBouncieEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class setVehicleAirTagEvent extends setVehicleEvent {
  final bool value;
  setVehicleAirTagEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class setVehicleSpareTireEvent extends setVehicleEvent {
  final bool value;
  setVehicleSpareTireEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class setVehicleTollTagsEvent extends setVehicleEvent {
  final bool value;
  setVehicleTollTagsEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class setVehicleSpareKeyEvent extends setVehicleEvent {
  final bool value;
  setVehicleSpareKeyEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class setVehiclePermanentPlateEvent extends setVehicleEvent {
  final bool value;
  setVehiclePermanentPlateEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class setVehicleFLicensePlateEvent extends setVehicleEvent {
  final bool value;
  setVehicleFLicensePlateEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class setVehicleDatePickerEvent extends setVehicleEvent {
  final dynamic value;
  setVehicleDatePickerEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class setVehicleSaveEvent extends setVehicleEvent { }

class createSparekeyTask extends setVehicleEvent { }

class setVehicleAddAttachmentEvent extends setVehicleEvent {
  final dynamic imageType;
  setVehicleAddAttachmentEvent({required this.imageType});
  @override
  List<Object?> get props => [imageType, Random().nextDouble()];
}

class setVehicleViewAttachmentEvent extends setVehicleEvent {
  final dynamic attachment;
  final List<dynamic> attachments;
  setVehicleViewAttachmentEvent(this.attachment, this.attachments);
  @override
  List<Object?> get props => [attachment, attachments, Random().nextDouble()];
}

class setVehicleRemoveAttachmentEvent extends setVehicleEvent {
  final dynamic attachment;
  final List<dynamic> attachments;
  final dynamic imageType;
  setVehicleRemoveAttachmentEvent(this.attachment, this.attachments, this.imageType);
  @override
  List<Object?> get props => [attachment, attachments, imageType, Random().nextDouble()];
}

class ResetAllEvent extends setVehicleEvent {}