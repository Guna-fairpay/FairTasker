import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show TimeOfDay;

abstract class TMPDEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class TMPDInitialEvent extends TMPDEvents {
  final Map<String, dynamic>? model;
  final List<Map<String, dynamic>>? models;
  TMPDInitialEvent(this.model, this.models);
  @override
  List<Object?> get props => [model, models];
}

class TMPDSelectDateEvent extends TMPDEvents {
  final DateTime? selected;
  TMPDSelectDateEvent(this.selected);
  @override
  List<Object?> get props => [selected];
}

class TMPDSelectTimeEvent extends TMPDEvents {
  final TimeOfDay? selected;
  TMPDSelectTimeEvent(this.selected);
  @override
  List<Object?> get props => [selected];
}

class TMPDSelectVehicleEvent extends TMPDEvents {}
class TMPDSelectDayEvent extends TMPDEvents {}

class TMPDSelectTaskEvent extends TMPDEvents {
  final Map<String, dynamic>? model;
  final bool? selected;
  TMPDSelectTaskEvent(this.model, this.selected);
  @override
  List<Object?> get props => [model, selected];
}

class TMPDSelectAllTaskEvent extends TMPDEvents {
  final bool? selected;
  TMPDSelectAllTaskEvent({this.selected});
  @override
  List<Object?> get props => [selected];
}