part of 'task_filter_dialog_bloc.dart';

abstract class TaskFilterDialogEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends TaskFilterDialogEvent{
  final List<dynamic> taskFilterList;
  final bool? isAll;
  InitialEvent({required this.taskFilterList, this.isAll});
  @override
  List<Object?> get props => [taskFilterList, isAll];
}

class AllCheckEvent extends TaskFilterDialogEvent{}

class TitleCheckEvent extends TaskFilterDialogEvent{
  final dynamic value;
  TitleCheckEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

class TaskCheckEvent extends TaskFilterDialogEvent{
  final dynamic value;
  TaskCheckEvent({required this.value});
  @override
  List<Object?> get props => [value];
}

