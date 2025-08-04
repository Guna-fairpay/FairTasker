part of 'shared_notes_bloc.dart';

abstract class SharedNotesEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends SharedNotesEvent{}

class MoveTomorrowEvent extends SharedNotesEvent{
  final dynamic data;
  MoveTomorrowEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class MoveCompleteEvent extends SharedNotesEvent{
  final dynamic data;
  MoveCompleteEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class SwapNoteItemsEvent extends SharedNotesEvent{
  final dynamic data;
  SwapNoteItemsEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class PreviousDayEvent extends SharedNotesEvent{}

class DatePickerEvent extends SharedNotesEvent{
  final DateTime? date;
  DatePickerEvent({this.date});
  @override
  List<Object?> get props => [date, Random().nextDouble()];
}

class AddNewEvent extends SharedNotesEvent{}

class EditEvent extends SharedNotesEvent {
  final dynamic data;
  EditEvent(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class DeletePermissionEvent extends SharedNotesEvent {
  final dynamic data;
  DeletePermissionEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class DeleteEvent extends SharedNotesEvent {
  final dynamic data;
  DeleteEvent(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class AddTaskTapEvent extends SharedNotesEvent {
  final List<dynamic>? list;
  AddTaskTapEvent({required this.list});
  @override
  List<Object?> get props => [list, Random().nextDouble()];
}

class EditTaskTapEvent extends SharedNotesEvent {
  final dynamic data;
  final List<dynamic>? list;
  EditTaskTapEvent({this.data, this.list});
  @override
  List<Object?> get props => [data, list, Random().nextDouble()];
}

class CheckAllDialogEvent extends SharedNotesEvent {
  final dynamic data;
  final bool isAll;
  final bool? status;
  CheckAllDialogEvent(this.data, {required this.isAll, required this.status});
  @override
  List<Object?> get props => [data, isAll, status];
}

class CheckAllEvent extends SharedNotesEvent {
  final Map<String, dynamic>? data;
  final bool? isAll;
  final bool? status;
  CheckAllEvent(this.data, {this.isAll = false, this.status});
  @override
  List<Object?> get props => [data, isAll, status];
}

class SearchEvent extends SharedNotesEvent {
  final String? value;
  SearchEvent(this.value);
  @override
  List<Object?> get props => [value, Random().nextDouble()];
}

class SwapProducts extends SharedNotesEvent {
  final dynamic data;
  SwapProducts(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}


class ReloadEvent extends SharedNotesEvent {}