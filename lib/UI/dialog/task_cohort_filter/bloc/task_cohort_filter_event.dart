part of 'task_cohort_filter_bloc.dart';
abstract class TaskCohortFilterEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class TaskCohortFilterInitialEvent extends TaskCohortFilterEvent {
  final List<dynamic>? cohortIdList;
  TaskCohortFilterInitialEvent({required this.cohortIdList});
  @override
  List<Object?> get props => [cohortIdList];
}

class TaskCohortFilterSelectAllEvent extends TaskCohortFilterEvent {}

class TaskCohortFilterSingleSelectionEvent extends TaskCohortFilterEvent {
  final dynamic selectedCohort;
  TaskCohortFilterSingleSelectionEvent({required this.selectedCohort});
  @override
  List<Object?> get props => [selectedCohort];

}