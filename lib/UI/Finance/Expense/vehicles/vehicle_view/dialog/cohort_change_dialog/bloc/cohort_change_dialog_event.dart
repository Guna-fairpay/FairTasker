part of 'cohort_change_dialog_bloc.dart';

abstract class CohortChangeDialogEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class InitialEvent extends CohortChangeDialogEvent{
  final dynamic data;
  InitialEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class CohortDropdownEvent extends CohortChangeDialogEvent{
  final dynamic data;
  CohortDropdownEvent({required this.data});
  @override
  List<Object?> get props => [data];
}

class UpdateCohortEvent extends CohortChangeDialogEvent{}