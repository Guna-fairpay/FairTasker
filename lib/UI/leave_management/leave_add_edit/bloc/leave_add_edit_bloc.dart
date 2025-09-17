
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/leave_management/leave_add_edit/bloc/leave_add_edit_event.dart';
import 'package:fairpytasker/UI/leave_management/leave_add_edit/bloc/leave_add_edit_state.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/timeday_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveAddEditBloc extends Bloc<LeaveAddEditEvent, LeaveAddEditState> {

  final APiRepository _apiRepository = APiRepository();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode? autoValidateMode;

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TimeOfDay startTime = const TimeOfDay(hour: 08, minute: 00);
  TimeOfDay endTime = const TimeOfDay(hour: 13, minute: 00);

  List<String> buttonValue = ['first', 'second'];
  String? currentButton;

  List<dynamic>leaveTypes = [];

  dynamic selectedLeaveType;
  dynamic model;

  LeaveAddEditBloc():super (LeaveAddEditLoadingState()) {

    on<LeaveAddEditInitialEvent>(_onLeaveAddEditInitialEvent);
    on<LeaveTypeSelectionEvent>(_onLeaveTypeSelectionEvent);
    on<StartDateSelectionEvent>(_onStartDateSelectionEvent);
    on<EndDateSelectionEvent>(_onEndDateSelectionEvent);
    on<StartTimeSelectionEvent>(_onStartTimeSelectionEvent);
    on<EndTimeSelectionEvent>(_onEndTimeSelectionEvent);
    on<RadioButtonSelectionEvent>(_onRadioButtonSelectionEvent);
    on<SaveLeaveEvent>(_onSaveLeaveEvent);
  }

  void _onLeaveAddEditInitialEvent(LeaveAddEditInitialEvent event, Emitter<LeaveAddEditState> emit) async {
    try{
      emit(LeaveAddEditLoadingState());
      var leaveType = await getIt<CommonService>().getLeaveListType();
      leaveTypes =  leaveType;
      if(event.data != null){
        model = event.data;
        currentButton = model['half_day_period'] == "Last" ? buttonValue.last : buttonValue.first;
        startDate = model['start_date'].toString().toDateTime() ?? DateTime.now();
        endDate= model['end_date'].toString().toDateTime() ?? DateTime.now();
        startTime = model['start_time'].toString().toTimeOfDay() ?? const TimeOfDay(hour: 08, minute: 00);
        endTime = model['end_time'].toString().toTimeOfDay() ?? const TimeOfDay(hour: 13, minute: 00);
        reasonController.text = model['reason'];
        selectedLeaveType = leaveTypes.where((e) => e['id'].toString() == model['leave_type_id'].toString()).firstOrNull;
      }else{
        currentButton = buttonValue.first;

      }
      emit(LeaveAddEditCommonState());
    }catch(e){
      Console.of.error("Error", error: e);
      emit(LeaveAddEditErrorState(e.toString()));
    }
  }

  void _onLeaveTypeSelectionEvent(LeaveTypeSelectionEvent event, Emitter<LeaveAddEditState> emit){
    try{
      if(['8','9'].contains(selectedLeaveType?['id'].toString())
      && selectedLeaveType != event.selectedLeaveType){
        startTime = const TimeOfDay(hour: 08, minute: 00);
        endTime = const TimeOfDay(hour: 13, minute: 00);
        currentButton = buttonValue.first;
      }
      selectedLeaveType = event.selectedLeaveType;
      emit(LeaveAddEditCommonState());
    }catch(e){
      emit(LeaveAddEditErrorState(e.toString()));
    }
  }

  void _onStartDateSelectionEvent(StartDateSelectionEvent event, Emitter<LeaveAddEditState> emit) {
    try {
      startDate = event.selectedStartDate;
      emit(LeaveAddEditCommonState());
    } catch (e) {
      emit(LeaveAddEditErrorState(e.toString()));
    }
  }

  void _onEndDateSelectionEvent(EndDateSelectionEvent event, Emitter<LeaveAddEditState> emit) {
    try {
      endDate = event.selectedEndDate;
      emit(LeaveAddEditCommonState());
    } catch (e) {
      emit(LeaveAddEditErrorState(e.toString()));
    }
  }

  void _onStartTimeSelectionEvent(StartTimeSelectionEvent event, Emitter<LeaveAddEditState> emit) {
    try {
      startTime = event.selectedStartTime;
      emit(LeaveAddEditCommonState());
    } catch (e) {
      emit(LeaveAddEditErrorState(e.toString()));
    }
  }

  void _onEndTimeSelectionEvent(EndTimeSelectionEvent event, Emitter<LeaveAddEditState> emit) {
    try {
      endTime = event.selectedEndTime;
      emit(LeaveAddEditCommonState());
    } catch (e) {
      emit(LeaveAddEditErrorState(e.toString()));
    }
  }

  void _onRadioButtonSelectionEvent(RadioButtonSelectionEvent event, Emitter<LeaveAddEditState> emit) {
    try {
      currentButton = event.value;
      if(currentButton == buttonValue.first){
        startTime = const TimeOfDay(hour: 08, minute: 00);
        endTime = const TimeOfDay(hour: 13, minute: 00);
      }else{
        startTime = const TimeOfDay(hour: 13, minute: 00);
        endTime = const TimeOfDay(hour: 18, minute: 00);
      }
      emit(LeaveAddEditCommonState());
    } catch (e) {
      emit(LeaveAddEditErrorState(e.toString()));
    }
  }

  Future<void> _onSaveLeaveEvent(SaveLeaveEvent event, Emitter<LeaveAddEditState> emit) async {
    autoValidateMode = AutovalidateMode.onUserInteraction;
    if(formKey.currentState?.validate() == false) return emit(LeaveAddEditCommonState());
    try{
      autoValidateMode = null;
      emit(LeaveAddEditLoadingState());
      Console.of.log(_saveLeaveData());
      if(model != null){
      var response =  await _apiRepository.updateLeave(id: model['id'].toString(),body:  _saveLeaveData());
      }else{
      var response =  await _apiRepository.addLeave(body: _saveLeaveData());
      }
      FBroadcast.instance().broadcast("refreshLeaveList");
      emit(LeaveAddEditSuccessState());
    }catch(e){
      emit(LeaveAddEditErrorState(e.toString()));
    }}

  Map<String,String>_saveLeaveData(){
    final String leaveDuration = startDateController.text == endDateController.text ?'Single' :'Multi';
    final String halfDay = (selectedLeaveType['id'].toString() == '8') ? currentButton ?? '' : 'Hours';
    String startT = '';
    String endT = '';
    if(['8','9'].contains(selectedLeaveType['id']?.toString())) {
      startT = startTime.toHMS() ?? '';
      endT = endTime.toHMS() ?? '';
    }
    Map<String,String> data = {};
    data['end_date'] = endDate.toFormat() ?? '';
    data['end_time'] = endT;
    data['half_day_period'] = halfDay;
    data['leave_duration'] = leaveDuration;
    data['leave_type_id'] = selectedLeaveType?['id'].toString() ?? '';
    data['reason'] = reasonController.text;
    data['start_date'] = startDate.toFormat() ?? '';
    data['start_time'] = startT;
    return data;
  }


}