

import 'package:equatable/equatable.dart';

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

