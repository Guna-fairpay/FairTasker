import 'package:equatable/equatable.dart';

abstract class PreCheckEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PreCheckInitialEvent extends PreCheckEvent {
  final dynamic model;
  final dynamic selectedVehicle;
  PreCheckInitialEvent(this.model, {this.selectedVehicle});
  @override
  List<Object?> get props => [model, selectedVehicle];
}

class PreCheckCheckEvent extends PreCheckEvent {
  final dynamic model;
  final bool? isChecked;
  PreCheckCheckEvent(this.model, this.isChecked);
  @override
  List<Object?> get props => [model, isChecked];
}

class PreCheckSubmitEvent extends PreCheckEvent {
  final dynamic model;
  final bool oilChangeOverride;
  final dynamic taskId;
  PreCheckSubmitEvent(this.model, {this.oilChangeOverride = false, this.taskId});
  @override
  List<Object?> get props => [model, oilChangeOverride, taskId];
}

class PreCheckCompleteEvent extends PreCheckEvent {
  final dynamic model;
  PreCheckCompleteEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class PreCheckDeleteEvent extends PreCheckEvent {
  final dynamic model;
  final String? reason;
  PreCheckDeleteEvent(this.model, {this.reason});
  @override
  List<Object?> get props => [model, reason];
}