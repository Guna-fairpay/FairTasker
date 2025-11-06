import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'task_cohort_filter_event.dart';
part 'task_cohort_filter_state.dart';

class TaskCohortFilterBloc extends Bloc<TaskCohortFilterEvent, TaskCohortFilterState> {

  APiRepository apiRepository = APiRepository();

  List<dynamic>? cohortIdList;
  List? get cohortList => [...getIt<CommonService>().cohortsList, ...[{"id":null, "cohort":"Other"}]];

  bool allSelected = false;

  TaskCohortFilterBloc() : super(TaskCohortFilterLoadingState()) {
    on<TaskCohortFilterInitialEvent>(_onTaskCohortFilterInitialEvent);
    on<TaskCohortFilterSelectAllEvent>(_onTaskCohortFilterSelectAllEvent);
    on<TaskCohortFilterSingleSelectionEvent>(_onTaskCohortFilterSingleSelectionEvent);
  }

  void _onTaskCohortFilterInitialEvent(TaskCohortFilterInitialEvent event, Emitter<TaskCohortFilterState> emit) {
    try {
      emit(TaskCohortFilterLoadingState());
      cohortIdList = event.cohortIdList;
      allSelected = (cohortIdList?.length == cohortList?.length);
      emit(TaskCohortFilterCommonState());
    }catch (e) {
      _error("TaskCohortFilterInitialEvent :( ${e.toString()}");
      emit(TaskCohortFilterCommonState());
    }
  }

  void _onTaskCohortFilterSelectAllEvent(TaskCohortFilterSelectAllEvent event, Emitter<TaskCohortFilterState> emit) {
    try {
      if(!allSelected){
        cohortIdList = cohortList?.map((e) => e['id']).toList();
        allSelected = true;
      }else{
        cohortIdList?.clear();
        allSelected = false;
      }
      emit(EmitValueState(value: cohortIdList));
    } catch (e) {
      _error("TaskCohortFilterSelectAllEvent :( ${e.toString()}");
      emit(TaskCohortFilterCommonState());
    }
  }

  void _onTaskCohortFilterSingleSelectionEvent(TaskCohortFilterSingleSelectionEvent event, Emitter<TaskCohortFilterState> emit) {
    try {
      if((cohortIdList?.contains(event.selectedCohort['id'])) ?? false){
      cohortIdList?.removeWhere((element) => element == event.selectedCohort['id']);
      }else{
        cohortIdList?.add(event.selectedCohort['id']);
      }
      if((cohortList?.every((e) => cohortIdList!.contains(e['id']))) ?? false){
        allSelected = true;
      }else{
        allSelected = false;
      }
      emit(EmitValueState(value: cohortIdList));
    } catch (e) {
      _error("TaskCohortFilterSingleSelectionEvent :( ${e.toString()}");
      emit(TaskCohortFilterCommonState());
    }
  }

  void _error(String message) {
    Toaster.showError(message);
    Console.of .error(message);
  }

}