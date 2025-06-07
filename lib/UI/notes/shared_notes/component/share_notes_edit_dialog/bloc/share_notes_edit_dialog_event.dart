part of 'share_notes_edit_dialog_bloc.dart';

abstract class ShareNotesEditDialogEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends ShareNotesEditDialogEvent{
  final dynamic model;
  final List<dynamic>? list;
  InitialEvent({this.model, this.list});
  @override
  List<Object?> get props => [model, list];
}

class DeleteDialogEvent extends ShareNotesEditDialogEvent{}

class DateEvent extends ShareNotesEditDialogEvent{
  final DateTime date;
  DateEvent(this.date);
  @override
  List<Object?> get props => [date];
}

class SaveEvent extends ShareNotesEditDialogEvent{}

class DeleteEvent extends ShareNotesEditDialogEvent{}