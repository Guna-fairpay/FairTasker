
import 'package:equatable/equatable.dart';

abstract class LeaveAddEditEvent extends Equatable {
 @override
  List<Object> get props => [];
}

class LeaveAddEditInitialEvent extends LeaveAddEditEvent {
  final dynamic data;
  LeaveAddEditInitialEvent({this.data});
  @override
  List<Object> get props => [data];
}

class LeaveTypeSelectionEvent extends LeaveAddEditEvent {
  final dynamic selectedLeaveType;
  LeaveTypeSelectionEvent({this.selectedLeaveType});
  @override
  List<Object> get props => [selectedLeaveType];
}

class StartDateSelectionEvent extends LeaveAddEditEvent {
  final dynamic selectedStartDate;
  StartDateSelectionEvent({this.selectedStartDate});
  @override
  List<Object> get props => [selectedStartDate];
}

class EndDateSelectionEvent extends LeaveAddEditEvent {
  final dynamic selectedEndDate;
  EndDateSelectionEvent({this.selectedEndDate});
  @override
  List<Object> get props => [selectedEndDate];
}

class StartTimeSelectionEvent extends LeaveAddEditEvent {
  final dynamic selectedStartTime;
  StartTimeSelectionEvent({this.selectedStartTime});
  @override
  List<Object> get props => [selectedStartTime];
}

class EndTimeSelectionEvent extends LeaveAddEditEvent {
  final dynamic selectedEndTime;
  EndTimeSelectionEvent({this.selectedEndTime});
  @override
  List<Object> get props => [selectedEndTime];
}

class RadioButtonSelectionEvent extends LeaveAddEditEvent {
  final dynamic value;
  RadioButtonSelectionEvent({this.value});
  @override
  List<Object> get props => [value];
}

class SaveLeaveEvent extends LeaveAddEditEvent {}
