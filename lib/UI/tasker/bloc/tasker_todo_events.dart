import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart' show TapDownDetails;
import 'package:flutter/material.dart';

abstract class ToDoTaskerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ToDoTaskerInitialEvent extends ToDoTaskerEvent {}

class ToDoTaskerPreviousDateEvent extends ToDoTaskerEvent {}
class ToDoTaskerNextDateEvent extends ToDoTaskerEvent {}
class ToDoTaskerTapDateEvent extends ToDoTaskerEvent {}
class ToDoTaskerDateFilterEvent extends ToDoTaskerEvent {
  final DateTime? selectedDate;
  ToDoTaskerDateFilterEvent(this.selectedDate);
  @override
  List<Object?> get props => [selectedDate];
}
class ToDoTaskerShowCompleteEvent extends ToDoTaskerEvent {
  final bool showCompleted;
  ToDoTaskerShowCompleteEvent(this.showCompleted);
  @override
  List<Object?> get props => [showCompleted];
}

class ToDoTaskerOnAddToDoEvent extends ToDoTaskerEvent {}
class ToDoTaskerOnMicEvent extends ToDoTaskerEvent {}
class ToDoTaskerSearchEvent extends ToDoTaskerEvent {
  final String search;
  ToDoTaskerSearchEvent(this.search);
  @override
  List<Object?> get props => [search];
}

class ToDoTaskerEditEvent extends ToDoTaskerEvent {
  final dynamic toDoId;
  ToDoTaskerEditEvent(this.toDoId);
  @override
  List<Object?> get props => [toDoId];
}

class ToDoTaskerTapUserFilterEvent extends ToDoTaskerEvent {
  final TapDownDetails? details;
  ToDoTaskerTapUserFilterEvent(this.details);
  @override
  List<Object?> get props => [details];
}

class ToDoTaskerTapVehicleFilterEvent extends ToDoTaskerEvent {
  final TapDownDetails? details;
  ToDoTaskerTapVehicleFilterEvent(this.details);
  @override
  List<Object?> get props => [details];
}

class ToDoTaskerVendorInfoEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  ToDoTaskerVendorInfoEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ToDoTaskerViewNotesEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  ToDoTaskerViewNotesEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ToDoTaskerDateChangeTapEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  ToDoTaskerDateChangeTapEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ToDoTaskerCompletedTimeTapEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  ToDoTaskerCompletedTimeTapEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ToDoTaskerSaveNotesEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  final String? notes;
  ToDoTaskerSaveNotesEvent(this.model, this.notes);
  @override
  List<Object?> get props => [model, notes];
}

class ToDoTaskerVehiclePersonTapEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  ToDoTaskerVehiclePersonTapEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ToDoTaskerResourceTapEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  ToDoTaskerResourceTapEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ToDoTaskerAddressTapEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  ToDoTaskerAddressTapEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ToDoTaskerPartsTapEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  ToDoTaskerPartsTapEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ToDoTaskerSuppliesTapEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  ToDoTaskerSuppliesTapEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ToDoTaskerPreviousEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  ToDoTaskerPreviousEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ToDoTaskerCompleteEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  ToDoTaskerCompleteEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ToDoTaskerMoveTomorrowEvent extends ToDoTaskerEvent {
  final List<Map<String, dynamic>>? model;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  ToDoTaskerMoveTomorrowEvent(this.model, this.selectedDate, this.selectedTime);
  @override
  List<Object?> get props => [model, selectedDate, selectedTime];
}

class ToDoTaskerDateChangeEvent extends ToDoTaskerEvent {
  final DateTime selectedDate;
  final Map<String, dynamic>? model;
  ToDoTaskerDateChangeEvent(this.selectedDate, this.model);
  @override
  List<Object?> get props => [selectedDate, model];
}

class ToDoTaskerCompletedTimeChangeEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  final String timeTaken;
  final String? reason;
  ToDoTaskerCompletedTimeChangeEvent(this.model, this.timeTaken, this.reason);
  @override
  List<Object?> get props => [model, timeTaken, reason];
}

class ToDoTaskerTimePickerTapEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  ToDoTaskerTimePickerTapEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ToDoTaskerTimeChangeEvent extends ToDoTaskerEvent {
  final TimeOfDay selectedTime;
  final Map<String, dynamic>? model;
  ToDoTaskerTimeChangeEvent(this.selectedTime, this.model);
  @override
  List<Object?> get props => [selectedTime, model];
}

class ToDoTaskerSavePartsSuppliesEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  final List<Map<String, dynamic>>? parts;
  final List<Map<String, dynamic>>? supplies;
  ToDoTaskerSavePartsSuppliesEvent({required this.model, this.parts, this.supplies});
  @override
  List<Object?> get props => [model, parts, supplies];
}

class ToDoTaskerSwapTaskEvent extends ToDoTaskerEvent {
  final dynamic fromId;
  final dynamic toId;
  ToDoTaskerSwapTaskEvent(this.fromId, this.toId);
  @override
  List<Object?> get props => [fromId, toId];
}

class ToDoTaskerVendorLocationTapEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  ToDoTaskerVendorLocationTapEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ToDoTaskerVendorLocationUpdateEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  final Map<String, dynamic>? selectedModel;
  ToDoTaskerVendorLocationUpdateEvent(this.model, this.selectedModel);
  @override
  List<Object?> get props => [model, selectedModel];
}

class ToDoTaskerSaveVehiclesPersonsEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  final List<Map<String, dynamic>>? selected;
  ToDoTaskerSaveVehiclesPersonsEvent({required this.model, this.selected});
  @override
  List<Object?> get props => [model, selected];
}

class ToDoTaskerVehicleGroupTapEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  ToDoTaskerVehicleGroupTapEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ToDoTaskerSaveAddressEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  final Map<String, dynamic>? selected;
  ToDoTaskerSaveAddressEvent(this.model, this.selected);
  @override
  List<Object?> get props => [model, selected];
}

class ToDoTaskerSaveResourcesEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  final List<Map<String, dynamic>>? selected;
  ToDoTaskerSaveResourcesEvent(this.model, this.selected);
  @override
  List<Object?> get props => [model, selected];
}

class ToDoTaskerCompleteOdometerEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  final num currentOdometer, nextMilesCheck, nextOdometer;
  ToDoTaskerCompleteOdometerEvent(this.model, this.currentOdometer, this.nextMilesCheck, this.nextOdometer);
  @override
  List<Object?> get props => [model, currentOdometer, nextMilesCheck, nextOdometer];
}

class ToDoTaskerCompleteDropCarEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  final DateTime date;
  final TimeOfDay time;
  final String? notes;
  ToDoTaskerCompleteDropCarEvent(this.model, this.date, this.time, this.notes);
  @override
  List<Object?> get props => [model, date, time, notes];
}

class ToDoTaskerUndoCompleteEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  ToDoTaskerUndoCompleteEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ToDoTaskerVehicleHistoryTapEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  ToDoTaskerVehicleHistoryTapEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ToDoTaskerRefreshEvent extends ToDoTaskerEvent {}

class ToDoTaskerViewVehicleEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  ToDoTaskerViewVehicleEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ToDoTaskerUserFilterEvent extends ToDoTaskerEvent {
  final List<Map<String, dynamic>>? users;
  ToDoTaskerUserFilterEvent(this.users);
  @override
  List<Object?> get props => [users];
}

class ToDoTaskerFilterTaskEvent extends ToDoTaskerEvent {}

class ToDoTaskerTaskFilterEvent extends ToDoTaskerEvent {
  final List<dynamic>? tasks;
  ToDoTaskerTaskFilterEvent(this.tasks);
  @override
  List<Object?> get props => [tasks];

}

class ToDoTaskerViewCustomLinkEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  ToDoTaskerViewCustomLinkEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ToDoTaskerViewAttachmentEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  ToDoTaskerViewAttachmentEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ToDoTaskerViewReasonAttachmentEvent extends ToDoTaskerEvent {
  final Map<String, dynamic>? model;
  ToDoTaskerViewReasonAttachmentEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class ToDoTaskerSaveRecordEvent extends ToDoTaskerEvent {
  final File? audio;
  ToDoTaskerSaveRecordEvent(this.audio);
  @override
  List<Object?> get props => [audio];
}