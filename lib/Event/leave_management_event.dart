
import 'dart:core';

import 'package:equatable/equatable.dart';

abstract class LeaveManagementEvent extends Equatable {
  const LeaveManagementEvent();
}

class LeaveManagementInitialEvent extends LeaveManagementEvent {
  @override
  List<Object?> get props => [];
}

class GetLeaveManagementData extends LeaveManagementEvent {
  const GetLeaveManagementData();
  @override
  List<Object> get props => [];
}

class AddLeaveManagementData extends LeaveManagementEvent {

  final String leaveTypeId;
  final String startDate;
  final String endDate;
  final String reason;
  final String startTime;
  final String endTime;
  final String status;
  final int? userId;
  final int? id;

  const AddLeaveManagementData({
    required this.leaveTypeId,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.userId,
    required this.id,
  });
  @override
  List<Object?> get props =>
      [
        leaveTypeId,
        startDate,
        endDate,
        reason,
        startTime,
        endTime,
        status,
        userId,
        id
      ];
}

class DeleteLeaveManagement extends LeaveManagementEvent {
  final String id;

  const DeleteLeaveManagement({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class GetLeaveManagementEmployeeListData extends LeaveManagementEvent {
  const GetLeaveManagementEmployeeListData();
  @override
  List<Object> get props => [];
}

class GetLeaveTypeListData extends LeaveManagementEvent {
  const GetLeaveTypeListData();
  @override
  List<Object> get props => [];
}


