import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart' show TapDownDetails;

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