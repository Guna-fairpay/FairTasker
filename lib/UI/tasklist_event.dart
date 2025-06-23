


import 'package:equatable/equatable.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

abstract class TaskListEvent extends Equatable {
  const TaskListEvent();
  @override
  List<Object> get props => [];
}

class TaskListInitial extends TaskListEvent {
  final String startDate;
  final String endDate;
  const TaskListInitial(
      this.startDate,
      this.endDate,
      );
  @override
  List<Object> get props => [];
}

class HideSupportEvent extends TaskListEvent {
  final bool value;
  const HideSupportEvent({required this.value});
  @override
  List<Object> get props => [value];
}

class ExtraHoursEvent extends TaskListEvent {
  final bool value;
  const ExtraHoursEvent({required this.value});
  @override
  List<Object> get props => [value];
}

class TaskIncompleteEvent extends TaskListEvent {
  final bool value;
  const TaskIncompleteEvent({required this.value});
  @override
  List<Object> get props => [value];
}

class OffShoreTeamEvent extends TaskListEvent {
  final bool value;
  const OffShoreTeamEvent({required this.value});
  @override
  List<Object> get props => [value];
}

class individualCheckEvent extends TaskListEvent {
  final bool value;
  final int id;
  const individualCheckEvent({required this.value,required this.id});
  @override
  List<Object> get props => [value,id];
}

class UpdateDateRangeEvent extends TaskListEvent {
  final DateRange selectedRange;
  const UpdateDateRangeEvent({required this.selectedRange});
  @override
  List<Object> get props => [selectedRange];
}

