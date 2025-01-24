
import 'package:equatable/equatable.dart';

abstract class TaskCountEvent extends Equatable {
  const TaskCountEvent();
}

class FetchTaskCountEvent extends TaskCountEvent {
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

class FetchCheckInoutReasonEvent extends TaskCountEvent {
  final int hrmId;
  final String fromDate;
  final String toDate;

  const FetchCheckInoutReasonEvent({
    required this.hrmId,
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object?> get props => [hrmId, fromDate, toDate];
}

class fetchEmployeeComment extends TaskCountEvent {
  final int hrmId;
  final String fromDate;
  final String toDate;

  const fetchEmployeeComment({
    required this.hrmId,
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object?> get props => [hrmId, fromDate, toDate];
}

class fetchEmployeeTaskHistoryEvent extends TaskCountEvent{
  final String to;
  final String from;
  final int? userId;

  fetchEmployeeTaskHistoryEvent({
    required this.to,
    required this.from,
    required this.userId,
});

  @override
  List<Object?> get props => [to, from, userId,];
}

class fetchWorkingGetConfigurationEvent extends TaskCountEvent {
  const fetchWorkingGetConfigurationEvent();
  @override
  List<Object> get props => [];
}

class fetchTaskCategoryGroupEvent extends TaskCountEvent {
  const fetchTaskCategoryGroupEvent();
  @override
  List<Object> get props => [];
}

class fetchCohortsDataEvent extends TaskCountEvent {
  const fetchCohortsDataEvent();
  @override
  List<Object> get props => [];
}