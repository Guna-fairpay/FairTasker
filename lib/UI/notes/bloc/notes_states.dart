part of 'notes_bloc.dart';

abstract class NotesStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotesLoadingState extends NotesStates {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class NotesCommonState extends NotesStates {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class NotesErrorState extends NotesStates {
  final dynamic error;
  NotesErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

class NotesDatePickerState extends NotesStates {
  final DateTime? date;
  NotesDatePickerState(this.date);
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class NotesAddNewState extends NotesStates {
  final dynamic noteId;
  final DateTime selectedDate;
  NotesAddNewState({this.noteId, required this.selectedDate});
  @override
  List<Object?> get props => [noteId, selectedDate, Random().nextDouble()];
}

class NotesDeletePermissionState extends NotesStates {
  final Map<String, dynamic>? data;
  NotesDeletePermissionState(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class NotesEditTaskTapState extends NotesStates {
  final Map<String, dynamic>? data;
  NotesEditTaskTapState(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class NotesAddTaskTapState extends NotesStates {
  final Map<String, dynamic>? data;
  NotesAddTaskTapState(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class NotesCheckTapState extends NotesStates {
  final Map<String, dynamic>? data;
  final bool isAll;
  final bool? status;
  NotesCheckTapState(this.data, {this.isAll = false, this.status});
  @override
  List<Object?> get props => [data, isAll, status, Random().nextDouble()];
}

class TimePickerState extends NotesStates {
  final dynamic model;
  TimePickerState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}