import 'dart:math';
import 'dart:ui' show Offset;

import 'package:equatable/equatable.dart';

abstract class AlterNotesStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class AlterNotesLoadingState extends AlterNotesStates {}
class AlterNotesErrorState extends AlterNotesStates {
  final dynamic message;
  AlterNotesErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}
class AlterNotesCommonState extends AlterNotesStates {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class AlterNotesRemovePermissionState extends AlterNotesStates {
  final Map<String, dynamic>? model;
  final bool showNotes, showTask;
  AlterNotesRemovePermissionState(this.model, this.showNotes, this.showTask);
  @override
  List<Object?> get props => [model, showNotes, showTask, Random().nextDouble()];
}

class AlterNotesTapUserState extends AlterNotesStates {
  final Map<String, dynamic>? model;
  final List<dynamic>? selectedUserIds;
  final Offset offset;
  AlterNotesTapUserState(this.model, this.offset, this.selectedUserIds);
  @override
  List<Object?> get props => [model, offset, selectedUserIds, Random().nextDouble()];
}

class AlterNotesCloseState extends AlterNotesStates {}