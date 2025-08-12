part of 'cohort_change_dialog_bloc.dart';

abstract class CohortChangeDialogState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadingState extends CohortChangeDialogState{}

class CommonState extends CohortChangeDialogState{
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class ErrorState extends CohortChangeDialogState{
  final dynamic message;
  ErrorState({required this.message});
  @override
  List<Object?> get props => [message];
}

class SuccessState extends CohortChangeDialogState{
  final dynamic data;
  SuccessState({required this.data});
  @override
  List<Object?> get props => [data];
}