import 'package:fairpytasker/UI/CheckIn%20CheckOut/Event/workingHoursEvent.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/State/workingHoursState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Repository/workingHoursRepository.dart';

import '../Response/taskCategoryGroupResponse.dart';

class TaskBloc extends Bloc<TaskCountEvent, TaskState> {
  TaskRepository taskRepo = TaskRepository();

  TaskBloc() : super(TaskInitialState()) {
    on<FetchTaskCountEvent>(_onFetchTaskCount);
    on<fetchEmployeeComment>(_onFetchComment);
    on<FetchCheckInoutReasonEvent>(_onFetchCheckInoutReason);
    on<fetchEmployeeTaskHistoryEvent>(_onFetchTaskHistory);
    on<fetchWorkingGetConfigurationEvent>(_onFetchGetConfiguration);
    on<fetchTaskCategoryGroupEvent>(_onFetchCategoryGroup);
    on<fetchCohortsDataEvent>(_onFetchCohortsData);
  }

  Future<void> _onFetchTaskCount(
      FetchTaskCountEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoadingState());
    try {
      final history = await taskRepo.fetchEmployeeTaskCount(
        userId: event.userId,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
      emit(TaskLoadedState(history!));
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }
  }

  Future<void> _onFetchComment(
      fetchEmployeeComment event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoadingState());
    try {
      final comment = await taskRepo.fetchEmployeeComments(
        hrmId: event.hrmId,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
      emit(CommentLoadedState(comment!));
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }
  }

  Future<void> _onFetchCheckInoutReason(
      FetchCheckInoutReasonEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoadingState());
    try {
      final data = await taskRepo.fetchCheckInoutReason(
        hrmId: event.hrmId,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
      emit(CheckInoutReasonLoadedState(data!));
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }
  }

  Future<void> _onFetchTaskHistory(
      fetchEmployeeTaskHistoryEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoadingState());
    try {
      final taskHistory = await taskRepo.fetchEmployeeTaskHistory(
        to: event.to,
        from: event.from,
        userId: event.userId,
      );

      if (taskHistory?.history2 == null || taskHistory!.history2!.isEmpty) {
        emit(TaskErrorState("No task history found"));
        return;
      }

      List<Map<String, dynamic>> combinedList = [];

      void extractData(Map<String, dynamic> item)
      {
        combinedList.add({
          "vehicle_name": item["vehicles"]?.isNotEmpty ?? false
              ? item["vehicles"][0]["vehicle_name"]
              : null,
          "todo_date": item["todo_date"],
          "complete_time_taken": item["complete_time_taken"],
          "fname": item["users"]?["first_name"],
          "lname": item["users"]?["last_name"],
          "location": item["location"],
          "notes": item["notes"],
          "reference_id": item["reference_id"],
          "mileage": item["mileage"],
          "expense_amount": item["expense_amount"],
          "expense_description": item["expense_description"],
          "category_name": item["category_name"],
          "subcategory_name": item["subcategory_name"],
          "expense_attachment": item["expense_attachment"],
        });
      }

      taskHistory.history2!.forEach(extractData);

      print("combinedList $combinedList");

      emit(TaskHistoryLoadedState(taskHistory: taskHistory, combinedList: combinedList));
    } catch (e) {
      print("taskHistory exception $e");
      emit(TaskErrorState(e.toString()));
    }
  }



  Future<void> _onFetchGetConfiguration(
      fetchWorkingGetConfigurationEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoadingState());
    try {
      final data = await taskRepo.fetchGetConfiguration();
      emit(GetConfigurationLoadedState(data: data));
    } catch (e) {
      print("FetchConfigExcep $e");
      emit(TaskErrorState(e.toString()));
    }
  }

  Future<void> _onFetchCategoryGroup(
      fetchTaskCategoryGroupEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoadingState());
    try {
      final response = await taskRepo.fetchCategoryGroup();
      final data = response?.data?.map((data) {
        return {
          'id': data['id'],
          'name': data['name'],
        };
      }).toList();

      emit(CategoryGroupLoadedState(data: data));
    } catch (e) {
      print("CategoryGroupExcep $e");
      emit(TaskErrorState(e.toString()));
    }
  }

  Future<void> _onFetchCohortsData(
      fetchCohortsDataEvent event,
      Emitter<TaskState> emit,
      ) async {
    emit(TaskLoadingState());
    try {
      // Fetch the already-parsed CohortsDataResponse object
      final response = await taskRepo.fetchCohortData();

      // Use the `data` property directly
      final cohortList = response?.data?.map((cohort) {
        return {
          'id': cohort['id'],
          'cohort': cohort['cohort'],
        };
      }).toList();

      emit(CohortDataLoadedState(data: cohortList));
    } catch (e) {
      print("CohortException $e");
      emit(TaskErrorState(e.toString()));
    }
  }


}