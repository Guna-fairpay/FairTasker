part of 'share_notes_edit_dialog_bloc.dart';

abstract class ShareNotesEditDialogState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends ShareNotesEditDialogState{}

class CommonState extends ShareNotesEditDialogState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends ShareNotesEditDialogState {
  final dynamic message;
  ErrorState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class SuccessState extends ShareNotesEditDialogState {
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class DeleteDialogState extends ShareNotesEditDialogState {
  final dynamic model;
  DeleteDialogState(this.model);
  @override
  List<Object?> get props => [model, Random().nextDouble()];
}