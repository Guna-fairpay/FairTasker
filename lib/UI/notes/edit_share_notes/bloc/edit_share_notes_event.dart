part of 'edit_share_notes_bloc.dart';

abstract class EditShareNotesEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends EditShareNotesEvent{
  final Map<String, dynamic> data;
  InitialEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class RemoveEvent extends EditShareNotesEvent{
  final Map<String, dynamic> data;
  RemoveEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class AddEvent extends EditShareNotesEvent{}

class SaveEvent extends EditShareNotesEvent{
  final List<Map<String, dynamic>> data;
  SaveEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class DatePickerEvent extends EditShareNotesEvent{
  final DateTime? date;
  final Map<String, dynamic>? model;
  DatePickerEvent({this.date, this.model});
  @override
  List<Object?> get props => [date, model];
}

class CheckEvent extends EditShareNotesEvent{
  final Map<String, dynamic>? model;
  final bool? completeStatus;
  CheckEvent({this.model, this.completeStatus});
  @override
  List<Object?> get props => [model, completeStatus];
}

class DeleteDialogEvent extends EditShareNotesEvent{
  final Map<String, dynamic>? model;
  DeleteDialogEvent(this.model);
  @override
  List<Object?> get props => [model];
}