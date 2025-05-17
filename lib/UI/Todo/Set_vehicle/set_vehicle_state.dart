
import 'dart:math';

import 'package:equatable/equatable.dart';

abstract class setVehicleState extends Equatable {
  const setVehicleState();
}

class setVehicleInitialState extends setVehicleState {
  const setVehicleInitialState();
  @override
  List<Object?> get props => [];
}

class setVehicleLoading extends setVehicleState {
  const setVehicleLoading();
  @override
  List<Object?> get props => [];
}

class setVehicleLoaded extends setVehicleState {
  bool? pop = false;
  setVehicleLoaded( {this.pop});
  @override
  List<Object?> get props => [pop];
}

class setVehicleCommonState extends setVehicleState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class setVehicleViewAttachmentState extends setVehicleState {
  final dynamic attachment;
  final List<dynamic> attachments;
  const setVehicleViewAttachmentState(this.attachment, this.attachments);
  @override
  List<Object?> get props => [attachment, attachments, Random().nextDouble()];
}