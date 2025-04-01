


import 'package:equatable/equatable.dart';

class TaskListState extends Equatable {
  final bool isLoading;
  final List<Map<String, dynamic>> data;
  final bool pop;

  const TaskListState(
      {
        required this.pop,
        this.isLoading =false,
        this.data = const [],
      }
      );

  TaskListState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? data,
    bool? pop,
}) => TaskListState(
    isLoading: isLoading ?? this.isLoading,
    data: data ?? this.data,
    pop: pop ?? this.pop,
  );

  @override
  List<Object> get props => [
    isLoading,
    data,
    pop,
  ];
}