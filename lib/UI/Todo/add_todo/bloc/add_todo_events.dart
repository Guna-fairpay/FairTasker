import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AddToDoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddToDoInitialEvent extends AddToDoEvent {
  final bool showAppBar;

  AddToDoInitialEvent(this.showAppBar);

  @override
  List<Object?> get props => [showAppBar];
}

class AddToDoShowMoreEvent extends AddToDoEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class AddToDoShowPartsEvent extends AddToDoEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class AddToDoShowSuppliesEvent extends AddToDoEvent {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class AddToDoSelectedTaskIdentifierEvent extends AddToDoEvent {
  final Map<int, dynamic> selectedTaskIdentifier;
  AddToDoSelectedTaskIdentifierEvent(this.selectedTaskIdentifier);
  @override
  List<Object?> get props => [selectedTaskIdentifier];
}

class AddToDoVPersonEvent extends AddToDoEvent {
  final dynamic vPerson;
  AddToDoVPersonEvent(this.vPerson);
  @override
  List<Object?> get props => [vPerson];
}

class AddToDoVLocationEvent extends AddToDoEvent {
  final dynamic vLocation;
  AddToDoVLocationEvent(this.vLocation);
  @override
  List<Object?> get props => [vLocation];
}

class AddToDoPersonTapEvent extends AddToDoEvent {
  final dynamic person;
  final bool isSelected;
  AddToDoPersonTapEvent(this.person, this.isSelected);
  @override
  List<Object?> get props => [person, isSelected, Random().nextDouble()];
}

class AddToDoTaskManagerEvent extends AddToDoEvent {
  final dynamic taskManager;
  AddToDoTaskManagerEvent(this.taskManager);
  @override
  List<Object?> get props => [taskManager];
}

class AddToDoCleanCarDuration extends AddToDoEvent {
  final dynamic cleanCarDuration;
  AddToDoCleanCarDuration(this.cleanCarDuration);
  @override
  List<Object?> get props => [cleanCarDuration];
}

class AddToDoPlatformCheckEvent extends AddToDoEvent {}

class AddToDoPartSelectionEvent extends AddToDoEvent {
  final dynamic part;
  final bool isChecked;
  AddToDoPartSelectionEvent(this.isChecked, this.part);
  @override
  List<Object?> get props => [isChecked, part];
}

class AddToDoSupplySelectionEvent extends AddToDoEvent {
  final dynamic data;
  final bool isChecked;
  AddToDoSupplySelectionEvent(this.isChecked, this.data);
  @override
  List<Object?> get props => [isChecked, data];
}

class AddToDoCleanCarEvent extends AddToDoEvent {}

class AddToDoRecurringTypeEvent extends AddToDoEvent {
  final dynamic recurringType;
  AddToDoRecurringTypeEvent(this.recurringType);
  @override
  List<Object?> get props => [recurringType];
}

class AddToDoDateChangeEvent extends AddToDoEvent {
  final DateTime selectedDate;
  AddToDoDateChangeEvent(this.selectedDate);
  @override
  List<Object?> get props => [selectedDate];
}

class AddToDoTimeChangeEvent extends AddToDoEvent {
  final TimeOfDay selectedTime;

  AddToDoTimeChangeEvent(this.selectedTime);

  @override
  List<Object?> get props => [selectedTime];
}

class AddToDoTimeSensitiveEvent extends AddToDoEvent {}

class AddToDoAddAttachmentEvent extends AddToDoEvent {}

class AddToDoSelectLinkOptionEvent extends AddToDoEvent {
  final dynamic linkOption;
  AddToDoSelectLinkOptionEvent(this.linkOption);
  @override
  List<Object?> get props => [linkOption];
}

class AddToDoAddressSelectionEvent extends AddToDoEvent {
  final dynamic data;
  final bool isChecked;
  AddToDoAddressSelectionEvent(this.data, this.isChecked);
  @override
  List<Object?> get props => [data, isChecked];
}
