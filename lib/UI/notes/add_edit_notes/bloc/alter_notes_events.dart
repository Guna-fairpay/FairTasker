part of 'alter_notes_bloc.dart';

abstract class AlterNotesEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class AlterNotesInitialEvent extends AlterNotesEvents {
  final dynamic noteId;
  final DateTime selectedDate;
  AlterNotesInitialEvent(this.noteId, this.selectedDate);
  @override
  List<Object?> get props => [noteId, selectedDate];
}

class AlterNotesAddEvent extends AlterNotesEvents {}
class AlterNotesRemoveEvent extends AlterNotesEvents {
  final Map<String, dynamic>? model;
  AlterNotesRemoveEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class AlterNotesDeleteEvent extends AlterNotesEvents {
  final Map<String, dynamic>? model;
  final String? type;
  AlterNotesDeleteEvent(this.model, this.type);
  @override
  List<Object?> get props => [model, type];
}

class AlterNotesShowHideNotesEvent extends AlterNotesEvents {
  final Map<String, dynamic>? model;
  final bool? showNotes;
  AlterNotesShowHideNotesEvent(this.model, this.showNotes);
  @override
  List<Object?> get props => [model, showNotes];
}

class AlterNotesCreateUpdateTaskEvent extends AlterNotesEvents {
  final Map<String, dynamic>? model;
  AlterNotesCreateUpdateTaskEvent(this.model);
  @override
  List<Object?> get props => [model];
}

class AlterNotesTapUserEvent extends AlterNotesEvents {
  final Map<String, dynamic>? model;
  final Offset offset;
  AlterNotesTapUserEvent(this.model, this.offset);
  @override
  List<Object?> get props => [model, offset];
}

class AlterNotesUserSelectionEvent extends AlterNotesEvents {
  final Map<String, dynamic>? model;
  final List<dynamic>? selectedUsers;
  AlterNotesUserSelectionEvent(this.model, this.selectedUsers);
  @override
  List<Object?> get props => [model, selectedUsers];
}

class AlterNotesSaveEvent extends AlterNotesEvents {}

class AlterNotesCompleteEvent extends AlterNotesEvents {
  final Map<String, dynamic>? model;
  final bool? status;
  AlterNotesCompleteEvent(this.model, this.status);
  @override
  List<Object?> get props => [model, status];
}

class ViewTimePickerEvent extends AlterNotesEvents {
  final Map<String, dynamic>? model;
  final dynamic time;
  ViewTimePickerEvent(this.model, {this.time});
  @override
  List<Object?> get props => [model, time];
}

class PickSharingUsersEvent extends AlterNotesEvents {
  final Offset? offset;
  final Map<String, dynamic>? model;
  final List<dynamic>? selectedUsers;
  PickSharingUsersEvent(this.model, {this.offset, this.selectedUsers});
  @override
  List<Object?> get props => [model, selectedUsers, offset];
}