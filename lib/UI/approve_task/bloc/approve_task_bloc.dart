import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/int_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

part 'approve_task_event.dart';
part 'approve_task_state.dart';

class ApproveTaskBloc extends Bloc<ApproveTaskEvent, ApproveTaskState>{

  final APiRepository _apiRepository = APiRepository();

  DateRange selectedDateRange = DateRange(DateTime.now().subtract(const Duration(days: 7)), DateTime.now());

  bool hideSupport = true;
  bool extraHours = true;
  bool isTaskIncomplete = false;
  bool isOffShorTeam = false;

  List<dynamic>? apiResponse;
  List<dynamic>? filterResponse;

  Future<Map<String, dynamic>?> _getApproveTask({dynamic fromDate, dynamic toDate}) async => await _apiRepository.getApproveTask(fromDate: fromDate, toDate: toDate);
  Future<Map<String, dynamic>?> _approveTodo({dynamic body,}) async => await _apiRepository.approveTodo(body: body);

  ApproveTaskBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<HideSupportEvent>(_onHideSupportEvent);
    on<ExtraHoursEvent>(_onExtraHoursEvent);
    on<DateRangeEvent>(_onDateRangeEvent);
    on<ListCheckEvent>(_onListCheckEvent);
    on<TaskInCompletedEvent>(_onTaskInCompletedEvent);
    on<OffShorTeamEvent>(_onOffShorTeamEvent);
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<ApproveTaskState> emit) async {
    try{
      emit(LoadingState());
      await fetchData();
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onHideSupportEvent(HideSupportEvent event, Emitter<ApproveTaskState> emit) {
    try{
      hideSupport = !hideSupport;
      _extraHours();
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onExtraHoursEvent(ExtraHoursEvent event, Emitter<ApproveTaskState> emit) {
    try{
      extraHours = !extraHours;
      _extraHours();
      //_hideSupport();
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  Future<void> _onDateRangeEvent(DateRangeEvent event, Emitter<ApproveTaskState> emit) async {
    try{
      emit(LoadingState());
      selectedDateRange = event.dateRange;
      await fetchData();
      emit(CommonState());
    }catch(e) {
      _onError(e, emit);
    }
  }

  Future<void> _onListCheckEvent(ListCheckEvent event, Emitter<ApproveTaskState> emit) async {
    try {
      emit(LoadingState());
      var data = event.data;
      var response = await _approveTodo(body: {
        "id": data['id'],
        "approved": event.isApproved == true ? 1 : 0,
      });
      apiResponse?.forEach((element) {
        if (element['id'].toString() == (response?['data']?['id']).toString()) {
          element['complete_time_approved'] = response?['data']?['complete_time_approved'].toString().toNumeric;
        }
      });
      filterResponse = apiResponse;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onTaskInCompletedEvent(TaskInCompletedEvent event, Emitter<ApproveTaskState> emit) {
    try {
      isTaskIncomplete = !isTaskIncomplete;
      if(isTaskIncomplete){
        filterResponse?.sort((a, b) => a['complete_time_approved'].compareTo(b['complete_time_approved']));
      }else{
        filterResponse?.sort((a, b) => b['complete_time_approved'].compareTo(a['complete_time_approved']));
      }
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onOffShorTeamEvent(OffShorTeamEvent event, Emitter<ApproveTaskState> emit) {
    try {
      isOffShorTeam = !isOffShorTeam;
      if(isOffShorTeam){
        filterResponse?.sort((a, b) => b['todo_user_type'].compareTo(a['todo_user_type']));
      }else{
        filterResponse?.sort((a, b) => a['todo_user_type'].compareTo(b['todo_user_type']));
      }
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> fetchData() async {
    var response = await _getApproveTask(fromDate: selectedDateRange.start.toFormat(), toDate: selectedDateRange.end.toFormat());
    apiResponse = List.from(response?['data'] ?? [])
        .map((e) {
          if((e['complete_time_taken'] != null) && (e['complete_time_taken'] != e['allotted_time'])){
            int? workingHours = e?['complete_time_taken'].toString().parseDurationToMinutes;
            int? totalHours = e?['allotted_time'].toString().parseDurationToMinutes;
            int? extraMin = (totalHours ?? 0) - (workingHours ?? 0);
            e['extraMin'] = extraMin.abs().minutesToHourMinute;
            return e;
          }else{
            return e;
          }
    }).toList();
    _extraHours();
  }

  void _onError(dynamic error, Emitter<ApproveTaskState> emit) {
    Console.of.error(error);
    emit(ErrorState(error));
  }

  void _extraHours() {
    if (extraHours) {
      Console.of.log(extraHours);
      filterResponse = apiResponse?.where((task) => (task['extraMin'] != null) && (task['complete_time_approved'] != 1)).toList();
      Console.of.log(filterResponse?.length);
    }else if (hideSupport) {
      filterResponse = apiResponse?.where((task) => task['todo_user_type'] != 1).toList();
    }
    else{
      filterResponse = apiResponse;
    }
  }
}