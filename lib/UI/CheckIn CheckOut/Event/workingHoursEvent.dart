
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class WorkingHoursEvent extends Equatable {
  const WorkingHoursEvent();

  @override
  List<Object?> get props => [];
}

class WorkingHoursInitialEvent extends WorkingHoursEvent {
  final String? minDate;
  final String? maxDate;
  const WorkingHoursInitialEvent(this.minDate, this.maxDate);
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
  TaskDateChangeEvent(this.selectedDate);
  @override
  List<Object?> get props => [selectedDate];
}

class EnterEditModeEvent extends WorkingHoursEvent {}

class ExitEditModeEvent extends WorkingHoursEvent {}



class fetchEmployeeCommentEvent extends WorkingHoursEvent {
  final int hrmId;
  final String fromDate;
  final String toDate;

  const fetchEmployeeCommentEvent({
    required this.hrmId,
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object?> get props => [hrmId, fromDate, toDate];
}

// class GetWorkingHoursDataEvent extends WorkingHoursEvent {
//   final String minDate;
//   final String maxDate;
//
//   const GetWorkingHoursDataEvent({required this.minDate, required this.maxDate});
//
//   @override
//   List<Object?> get props => [minDate, maxDate];
// }
//
// class GetWorkingHistoryCountEvent extends WorkingHoursEvent {
//   final String? startDate;
//   final String? endDate;
//
//   const GetWorkingHistoryCountEvent({this.startDate, this.endDate});
//
//   @override
//   List<Object?> get props => [startDate, endDate];
// }
//
// class GetActiveHoursDataEvent extends WorkingHoursEvent {
//   final String minDate;
//   final String maxDate;
//
//   const GetActiveHoursDataEvent({required this.minDate, required this.maxDate});
//
//   @override
//   List<Object?> get props => [minDate, maxDate];
// }



//
// import 'package:equatable/equatable.dart';
//
// abstract class TaskCountEvent extends Equatable {
//   const TaskCountEvent();
// }
//
// class FetchTaskCountEvent extends TaskCountEvent {
//   final int userId;
//   final String fromDate;
//   final String toDate;
//
//    const FetchTaskCountEvent({
//     required this.userId,
//     required this.fromDate,
//     required this.toDate,
//   });
//
//   @override
//   List<Object?> get props => [userId, fromDate, toDate];
// }
//
// class FetchCheckInoutReasonEvent extends TaskCountEvent {
//   final int hrmId;
//   final String fromDate;
//   final String toDate;
//
//   const FetchCheckInoutReasonEvent({
//     required this.hrmId,
//     required this.fromDate,
//     required this.toDate,
//   });
//
//   @override
//   List<Object?> get props => [hrmId, fromDate, toDate];
// }
//
// class fetchEmployeeComment extends TaskCountEvent {
//   final int hrmId;
//   final String fromDate;
//   final String toDate;
//
//   const fetchEmployeeComment({
//     required this.hrmId,
//     required this.fromDate,
//     required this.toDate,
//   });
//
//   @override
//   List<Object?> get props => [hrmId, fromDate, toDate];
// }
//
// class fetchEmployeeTaskHistoryEvent extends TaskCountEvent{
//   final String to;
//   final String from;
//   final int? userId;
//
//   fetchEmployeeTaskHistoryEvent({
//     required this.to,
//     required this.from,
//     required this.userId,
// });
//
//   @override
//   List<Object?> get props => [to, from, userId,];
// }
//
// class fetchWorkingGetConfigurationEvent extends TaskCountEvent {
//   const fetchWorkingGetConfigurationEvent();
//   @override
//   List<Object> get props => [];
// }
//
// class fetchTaskCategoryGroupEvent extends TaskCountEvent {
//   const fetchTaskCategoryGroupEvent();
//   @override
//   List<Object> get props => [];
// }
//
// class fetchCohortsDataEvent extends TaskCountEvent {
//   const fetchCohortsDataEvent();
//   @override
//   List<Object> get props => [];
// }

// working_hours_event.dart
