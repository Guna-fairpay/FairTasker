
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
