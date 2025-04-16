
import 'package:equatable/equatable.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

abstract class WorkingHoursEvent extends Equatable {
  const WorkingHoursEvent();

  @override
  List<Object?> get props => [];
}

class WorkingHoursInitialEvent extends WorkingHoursEvent {
  final String minDate;
  final String maxDate;
  const WorkingHoursInitialEvent({ required this.minDate, required this.maxDate});
  @override
  List<Object?> get props => [minDate, maxDate];
}

class ResourceDropDownEvent extends WorkingHoursEvent {
   dynamic selectedName;
   ResourceDropDownEvent(this.selectedName);
   @override
   List<Object?> get props => [selectedName];
}

class TaskComponentsInitialEvent extends WorkingHoursEvent {
  const TaskComponentsInitialEvent();
  @override
  List<Object> get props => [];
}

class CreateTaskEvent extends WorkingHoursEvent {
  final int? id;
  final int? userId;
  final String? taskName;
  final String? amount;
  final String? task;
  const CreateTaskEvent({this.id,this.userId, this.taskName, this.amount, this.task});
  @override
  List<Object?> get props => [id,userId, taskName, amount, task];
}

class UpdateTaskEvent extends WorkingHoursEvent {
  final int? id;
  final int? userId;
  final String? taskName;
  final String? amount;
  final String? task;
  const UpdateTaskEvent({this.id,this.userId, this.taskName, this.amount, this.task});
  @override
  List<Object?> get props => [id,userId, taskName, amount, task];
}

class UpdateDropdownValueEvent extends WorkingHoursEvent {
  final Map<String, dynamic> selectedBase;
  const UpdateDropdownValueEvent(this.selectedBase);

  @override
  List<Object?> get props => [selectedBase];
}


class DeleteTaskComponentsEvent extends WorkingHoursEvent {
  final int? id;
  const DeleteTaskComponentsEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class TaskDateChangeEvent extends WorkingHoursEvent {
  final DateTime selectedDate;
  const TaskDateChangeEvent(this.selectedDate);
  @override
  List<Object?> get props => [selectedDate];
}

class EnterEditModeEvent extends WorkingHoursEvent {}

class ExitEditModeEvent extends WorkingHoursEvent {}

class ResetResourceEvent extends WorkingHoursEvent {}

class ResetDropdownEvent extends WorkingHoursEvent {
  final bool isTaskBased; // true for Task based, false for Hour based
  const ResetDropdownEvent({required this.isTaskBased});
}

class fetchEmployeeCommentEvent extends WorkingHoursEvent {
  final int? hrmId;
  final String fromDate;
  final String toDate;
  final List<dynamic> dataList;
  final String ReasonPopupSelectedDateRange;
  const fetchEmployeeCommentEvent({
    required this.hrmId,
    required this.fromDate,
    required this.toDate,
    required this.dataList,
    required this.ReasonPopupSelectedDateRange,
  });
  @override
  List<Object?> get props => [hrmId, fromDate, toDate, dataList, ReasonPopupSelectedDateRange];
}

class HoursPopupEvent extends WorkingHoursEvent {
  final int hrmId;
  final int empID;
  final String fromDate;
  final String toDate;
  final List<dynamic> dataList;
  final String userName;
  final String HoursPopupSelectedDateRange;
  const HoursPopupEvent({
    required this.hrmId,
    required this.fromDate,
    required this.toDate,
    required this.dataList,
    required this.userName,
    required this.HoursPopupSelectedDateRange,
    required this.empID,
  });
  @override
  List<Object?> get props => [hrmId, fromDate, toDate, dataList, userName, HoursPopupSelectedDateRange, empID];
}

class FetchTaskCountEvent extends WorkingHoursEvent {
  final int userId;
  final String fromDate;
  final String toDate;
   const FetchTaskCountEvent({
    required this.userId,
    required this.fromDate,
    required this.toDate,
  });
  @override
  List<Object?> get props => [userId, fromDate, toDate];
}


class TaskInitialEvent extends WorkingHoursEvent{
  final String to;
  final String from;
  final int? userId;
  final List<int> cohortIds;
  TaskInitialEvent({
    required this.to,
    required this.from,
    required this.userId,
    required this.cohortIds,
});
  @override
  List<Object?> get props => [to, from, userId, cohortIds];
}

class ExtendedDetailsTaskEvent extends WorkingHoursEvent{
  final int id;
  const ExtendedDetailsTaskEvent({
    required this.id,
});
  @override
  List<Object?> get props => [id,];
}

class UpdateDateRangeEvent extends WorkingHoursEvent {
  final DateRange? selectedRange;
  const UpdateDateRangeEvent({required this.selectedRange});
  @override
  List<Object?> get props => [selectedRange];
}

class SwitchTabEvent extends WorkingHoursEvent {
  final bool isHourly;
  const SwitchTabEvent({required this.isHourly});
  @override
  List<Object?> get props => [isHourly];
}

