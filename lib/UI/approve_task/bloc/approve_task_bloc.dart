import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

part 'approve_task_event.dart';
part 'approve_task_state.dart';

class ApproveTaskBloc extends Bloc<ApproveTaskEvent, ApproveTaskState>{

  DateRange selectedDateRange = DateRange(DateTime.now().subtract(const Duration(days: 7)), DateTime.now());

  bool hideSupport = true;
  bool extraHours = true;
  bool isTaskIncomplete = false;
  bool isOffShorTeam = false;

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
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onHideSupportEvent(HideSupportEvent event, Emitter<ApproveTaskState> emit) {
    try{
      hideSupport = !hideSupport;
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onExtraHoursEvent(ExtraHoursEvent event, Emitter<ApproveTaskState> emit) {
    try{
      extraHours = !extraHours;
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  Future<void> _onDateRangeEvent(DateRangeEvent event, Emitter<ApproveTaskState> emit) async {
    try{
      selectedDateRange = event.dateRange;
      emit(CommonState());
    }catch(e) {
      _onError(e, emit);
    }
  }

  void _onListCheckEvent(ListCheckEvent event, Emitter<ApproveTaskState> emit) {
    try {} catch (e) {
      _onError(e, emit);
    }
  }

  void _onTaskInCompletedEvent(TaskInCompletedEvent event, Emitter<ApproveTaskState> emit) {
    try {
      isTaskIncomplete = !isTaskIncomplete;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onOffShorTeamEvent(OffShorTeamEvent event, Emitter<ApproveTaskState> emit) {
    try {
      isOffShorTeam = !isOffShorTeam;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onError(dynamic error, Emitter<ApproveTaskState> emit) {
    Console.of.error(error);
    emit(ErrorState(error));
  }

}