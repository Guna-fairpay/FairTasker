import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class TCCDEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class TCCDInitialEvents extends TCCDEvents {
  final Map<String, dynamic>? model;
  TCCDInitialEvents({this.model});
  @override
  List<Object?> get props => [model];
}

class CheckListsDropdownEvent extends TCCDEvents {
  final dynamic value;
  CheckListsDropdownEvent({this.value});
  @override
  List<Object?> get props => [value];
}

class DateChangeEvent extends TCCDEvents {
  final DateTime selectedDate;
  DateChangeEvent({required this.selectedDate});
  @override
  List<Object?> get props => [selectedDate];
}

class TimeChangeEvent extends TCCDEvents {
  final TimeOfDay selectedTime;
  TimeChangeEvent({required this.selectedTime});
  @override
  List<Object?> get props => [selectedTime];
}

class VLocationChangeEvent extends TCCDEvents {
  final dynamic vLocation;
  VLocationChangeEvent(this.vLocation);
  @override
  List<Object?> get props => [vLocation];
}

class AddressSelectionEvent extends TCCDEvents {
  final dynamic data;
  final bool isChecked;
  AddressSelectionEvent(this.data, this.isChecked);
  @override
  List<Object?> get props => [data, isChecked];
}