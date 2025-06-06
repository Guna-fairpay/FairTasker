part of 'shared_notes_bloc.dart';

abstract class SharedNotesState extends Equatable{
  @override
  List<Object?> get props => [];
}

class CommonState extends SharedNotesState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class LoadingState extends SharedNotesState{}

class ErrorState extends SharedNotesState{
  final dynamic error;
  ErrorState(this.error);
  @override
  List<Object?> get props => [error, Random().nextDouble()];
}

class SuccessState extends SharedNotesState{
  final dynamic message;
  SuccessState(this.message);
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}

class DatePickerState extends SharedNotesState{
  final DateTime date;
  DatePickerState(this.date);
  @override
  List<Object?> get props => [date, Random().nextDouble()];
}

class DeletePermissionState extends SharedNotesState{
  final dynamic data;
  DeletePermissionState(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class AddTaskTapState extends SharedNotesState{
  final dynamic data;
  AddTaskTapState(this.data);
  @override
  List<Object?> get props => [data, Random().nextDouble()];
}

class EditTaskTapState extends SharedNotesState {
  final dynamic data;
  final List<dynamic>? list;
  EditTaskTapState({this.data, this.list});
  @override
  List<Object?> get props => [data, list, Random().nextDouble()];
}

class CheckAllState extends SharedNotesState {
  final dynamic data;
  final bool isAll;
  final bool? status;
  CheckAllState(this.data, {required this.isAll, required this.status});
  @override
  List<Object?> get props => [data, isAll, status, Random().nextDouble()];

}