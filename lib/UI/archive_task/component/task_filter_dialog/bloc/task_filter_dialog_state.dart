part of 'task_filter_dialog_bloc.dart';

abstract class TaskFilterDialogState extends Equatable{
  @override
  List<Object?> get props => [];
}

class CommonState extends TaskFilterDialogState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class EmitValueState extends TaskFilterDialogState{
  final List<dynamic> value;
  EmitValueState({required this.value});
  @override
  List<Object?> get props => [value, Random().nextDouble()];
}

class ErrorState extends TaskFilterDialogState{
  final dynamic message;
  ErrorState({required this.message});
  @override
  List<Object?> get props => [message, Random().nextDouble()];
}