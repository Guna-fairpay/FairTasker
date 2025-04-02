


import 'package:equatable/equatable.dart';

class TaskListState extends Equatable {
  final bool isLoading;
  final List<Map<String, dynamic>> data;
  final List<Map<String, dynamic>> resourceData;
  final List<Map<String, dynamic>> groupResourceData;
  final bool pop;
  final bool hideSupport;
  final bool extraHours;
  final bool isAscending;
  final bool offShore;
  final bool isChecked;

  const TaskListState(
      {
        required this.pop,
        this.isLoading =false,
        this.data = const [],
        this.resourceData = const [],
        this.groupResourceData = const [],
        this.hideSupport = true,
        this.extraHours = true,
        this.isAscending = false,
        this.offShore = false,
        this.isChecked = true,
      });

  TaskListState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? data,
    bool? pop,
    List<Map<String, dynamic>>? resourceData,
    List<Map<String, dynamic>>? groupResourceData,
    bool? hideSupport,
    bool? extraHours,
    bool? isAscending,
    bool? offShore,
    bool? isChecked,
  }) => TaskListState(
    isLoading: isLoading ?? this.isLoading,
    data: data ?? this.data,
    pop: pop ?? this.pop,
    resourceData: resourceData ?? this.resourceData,
    groupResourceData: groupResourceData ?? this.groupResourceData,
    hideSupport: hideSupport ?? this.hideSupport,
    extraHours: extraHours ?? this.extraHours,
    isAscending: isAscending ?? this.isAscending,
    offShore: offShore ?? this.offShore,
    isChecked: isChecked ?? this.isChecked,
  );

  @override
  List<Object> get props => [
    isLoading,
    data,
    pop,
    resourceData,
    groupResourceData,
    hideSupport,
    extraHours,
    isAscending,
    offShore,
    isChecked,
  ];
}