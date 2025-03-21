

import 'dart:math';

import 'package:date_time/date_time.dart' hide DateRange;
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

class WorkingHoursState extends Equatable {
  final List<Map<String, dynamic>>? data;
  final List<Map<String, dynamic>>? history;
  final List<Map<String, dynamic>>? resources;
  final List<Map<String, dynamic>>? combinedData;
  final List<Map<String, dynamic>> workActiveHours;
  final List<Map<String, dynamic>> dropDownData;
  final List<int> totalHoursValue;
  final List<String> activeHours;
  final String startDate;
  final String endDate;
  final bool isLoading;
  final List<Map<String, dynamic>> taskComponentsData;
  final List<Map<String, dynamic>> taskBased;
  final List<Map<String, dynamic>> hourlyBased;
  final DateRange? selectedDateRange;
  final TextEditingController? taskNameController;
  final TextEditingController? amountController;
  final List<dynamic> selectedBase1;
  final dynamic selectedBase;
  final bool isEditMode;
  final bool isHourEditMode;
  final int? taskId;
  final int? userId;
  final dynamic selectedDate;
  final List<dynamic> resource;
  final dynamic dropDownEvent;
  final dynamic selectedResource;
  final List<dynamic>userList;
  final dynamic selectedUser;
  final List<Map<String,dynamic>> comments;
  final List<Map<String,dynamic>> hoursData1;
  final List<Map<String,dynamic>> hoursData2;

  const WorkingHoursState(
      {
        this.data,
        this.history,
        this.resources,
        this.isLoading = false,
        this.combinedData,
        this.workActiveHours = const [],
        this.totalHoursValue = const [],
        this.activeHours = const [],
        this.dropDownData = const [],
        this.startDate = '',
        this.endDate = '',
        this.taskComponentsData = const [],
        this.taskBased = const [],
        this.hourlyBased = const [],
        this.selectedDateRange,
        this.taskNameController,
        this.amountController,
        this.selectedBase1 = const [],
        this.selectedBase,
        this.isEditMode = false,
        this.isHourEditMode = false,
        this.taskId,
        this.userId,
        this.selectedDate,
        this.resource = const [],
        this.dropDownEvent,
        this.selectedResource,
        required this.userList,
        required this.selectedUser,
        this.comments = const [],
        this.hoursData1 = const [],
        this.hoursData2 = const [],
      });

  WorkingHoursState copyWith({
    List<Map<String, dynamic>>? data,
    List<Map<String, dynamic>>? history,
    List<Map<String, dynamic>>? resources,
    List<Map<String, dynamic>>? combinedData,
    List<Map<String, dynamic>>? workActiveHours,
    List<Map<String, dynamic>>? dropDownData,
    List<String>? activeHours,
    List<int>? totalHoursValue,
    String? startDate,
    String? endDate,
    bool? isLoading,
    List<Map<String, dynamic>>? taskComponentsData,
    List<Map<String, dynamic>>? taskBased,
    List<Map<String, dynamic>>? hourlyBased,
    DateRange? selectedDateRange,
    TextEditingController? taskNameController,
    TextEditingController? amountController,
    List<dynamic>? selectedBase1,
    dynamic selectedBase,
    bool? isEditMode,
    bool? isHourEditMode,
    int? taskId,
    int? userId,
    DateTime? selectedDate,
    List<dynamic>? resource,
    dynamic dropDownEvent,
    dynamic selectedResource,
    List<dynamic>?userList,
    dynamic selectedUser,
    List<Map<String,dynamic>>? comments,
    List<Map<String,dynamic>>? hoursData1,
    List<Map<String,dynamic>>? hoursData2,
}) => WorkingHoursState(
    data: data ?? this.data,
    history: history ?? this.history,
    resources: resources ?? this.resources,
    isLoading: isLoading ?? this.isLoading,
    combinedData: combinedData ?? this.combinedData,
    workActiveHours: workActiveHours ?? this.workActiveHours,
    totalHoursValue: totalHoursValue ?? this.totalHoursValue,
    activeHours: activeHours ?? this.activeHours,
    dropDownData: dropDownData ?? this.dropDownData,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    taskComponentsData: taskComponentsData ?? this.taskComponentsData,
    taskBased: taskBased ?? this.taskBased,
    hourlyBased: hourlyBased ?? this.hourlyBased,
    selectedDateRange: selectedDateRange ?? this.selectedDateRange,
    taskNameController: taskNameController,
    amountController: amountController,
    selectedBase1: selectedBase1 ?? this.selectedBase1,
    selectedBase: selectedBase,
    isEditMode: isEditMode ?? this.isEditMode,
    isHourEditMode: isHourEditMode ?? this.isHourEditMode,
    taskId: taskId ?? this.taskId,
    userId: userId ?? this.userId,
    selectedDate: selectedDate ?? this.selectedDate,
    resource: resource ?? this.resource,
    dropDownEvent: dropDownEvent,
    selectedResource: selectedResource,
    userList: userList ?? this.userList,
    selectedUser: selectedUser ?? this.selectedUser,
    comments: comments ?? this.comments,
    hoursData1: hoursData1 ?? this.hoursData1,
    hoursData2: hoursData2 ?? this.hoursData2,
  );

  @override
  List<Object?> get props => [
    data,
    history,
    resources,
    isLoading,
    combinedData,
    workActiveHours,
    totalHoursValue,
    activeHours,
    dropDownData,
    startDate,
    endDate,
    taskComponentsData,
    taskBased,
    hourlyBased,
    selectedDateRange,
    taskNameController,
    amountController,
    selectedBase1,
    selectedBase,
    isEditMode,
    isHourEditMode,
    taskId,
    userId,
    selectedDate,
    resource,
    dropDownEvent,
    selectedResource,
    userList,
    selectedUser,
    comments,
    hoursData1,
    hoursData2,
    Random().nextDouble()
  ];
}

//
// import 'package:equatable/equatable.dart';
// import 'package:fairpytasker/UI/CheckIn%20CheckOut/Response/workingHoursResponse.dart';
// import 'package:fairpytasker/UI/CheckIn%20CheckOut/Response/workingReasonResponse.dart';
//
// import '../Response/checkInOutResponse.dart';
//
//
// abstract class TaskState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }
//
// class TaskInitialState extends TaskState {}
//
// class TaskLoadingState extends TaskState {}
//
// class TaskErrorState extends TaskState {
//   final String errorMessage;
//
//   TaskErrorState(this.errorMessage);
//
//   @override
//   List<Object?> get props => [errorMessage];
// }
//
// class TaskLoadedState extends TaskState {
//   final WorkingHoursResponse history;
//   TaskLoadedState(this.history);
//   @override
//   List<Object?> get props => [history];
// }
//
// class CommentLoadedState extends TaskState
// {
//   final WorkingReasonResponse comment;
//   CommentLoadedState(this.comment);
//   @override
//   List<Object?> get props => [comment];
// }
//
// class CheckInoutReasonLoadedState extends TaskState
// {
//   final CheckInOutReasonResponse data;
//   CheckInoutReasonLoadedState(this.data);
//   @override
//   List<Object?> get props => [data];
// }
//
// class TaskHistoryLoadedState extends TaskState {
//   final dynamic taskHistory;
//   final List<Map<String, dynamic>> combinedList;
//   TaskHistoryLoadedState({required this.taskHistory, required this.combinedList});
//
//   @override
//   List<Object?> get props => [taskHistory];
// }
//
// class GetConfigurationLoadedState extends TaskState {
//   final dynamic data;
//
//   GetConfigurationLoadedState({required this.data});
//
//   @override
//   List<Object?> get props => [data];
// }
//
// class CategoryGroupLoadedState extends TaskState {
//   final dynamic data;
//
//   CategoryGroupLoadedState({required this.data});
//
//   @override
//   List<Object?> get props => [data];
// }
//
// class CohortDataLoadedState extends TaskState {
//   final dynamic data;
//
//   CohortDataLoadedState({required this.data});
//
//   @override
//   List<Object?> get props => [data];
// }

// working_hours_state.dart

