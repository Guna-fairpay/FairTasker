part of 'task_cohort_filter_bloc.dart';

abstract class TaskCohortFilterState extends Equatable{
  @override
  List<Object?> get props => [];
}

class TaskCohortFilterLoadingState extends TaskCohortFilterState {}

class TaskCohortFilterCommonState extends TaskCohortFilterState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class EmitValueState extends TaskCohortFilterState {
  final dynamic value;
  EmitValueState({required this.value});
  @override
  List<Object?> get props => [value, Random().nextDouble()];
}