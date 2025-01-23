import 'package:fairpytasker/UI/CheckIn%20CheckOut/Event/workingHoursEvent.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/State/workingHoursState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Repository/workingHoursRepository.dart';

class TaskBloc extends Bloc<TaskCountEvent, TaskState> {
  TaskRepository taskRepo = TaskRepository();

  TaskBloc() : super(TaskInitialState()) {
    on<FetchTaskCountEvent>(_onFetchTaskCount);
    on<fetchEmployeeComment>(_onFetchComment);
    on<FetchCheckInoutReasonEvent>(_onFetchCheckInoutReason);
    on<fetchEmployeeTaskHistoryEvent>(_onFetchTaskHistory);
    on<fetchWorkingGetConfigurationEvent>(_onFetchGetConfiguration);
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

      // Extract and combine relevant data from taskHistory (assuming it's a list of maps)
      List<int> combinedList = [];
      if (taskHistory?.history?.isNotEmpty ?? false) {
        for (var item in taskHistory?.history ?? []) {
          combinedList.addAll(item["2"] ?? []);
          combinedList.addAll(item["3"] ?? []);
        }
      }
      print("taskHistory $taskHistory combinedList $combinedList");

      emit(TaskHistoryLoadedState(taskHistory: taskHistory, combinedList: combinedList));
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }
  }

  Future<void> _onFetchGetConfiguration(
      fetchWorkingGetConfigurationEvent event,
      Emitter<TaskState> emit,
      ) async {
    // Handle fetching configuration data (implementation omitted for brevity)
  }
}