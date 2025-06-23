part of 'edit_share_notes_bloc.dart';

abstract class EditShareNotesState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends EditShareNotesState{}

class ErrorState extends EditShareNotesState{
  final dynamic error;
  ErrorState(this.error);
  @override
  List<Object?> get props => [error, Random().nextDouble()];
}

class SuccessState extends EditShareNotesState{
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class CommonState extends EditShareNotesState{
  @override
  List<Object?> get props => [ Random().nextDouble()];
}

class DeleteDialogState extends EditShareNotesState{
  final Map<String, dynamic>? data;
  DeleteDialogState(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}