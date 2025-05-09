
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/leave_management/leave_verification/bloc/leave_verification_event.dart';
import 'package:fairpytasker/UI/leave_management/leave_verification/bloc/leave_verification_state.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveVerificationBloc extends Bloc<LeaveVerificationEvent, LeaveVerificationState>{

  final APiRepository _apiRepository = APiRepository();
  TextEditingController reasonController = TextEditingController();
  List<dynamic> statusName = [
    {'id':1,'name':'Approved'},
    {'id':2,'name':'Rejected'},
    {'id':3,'name':'Pending'},];
  dynamic selectedStatus;
  dynamic model;

  LeaveVerificationBloc():super(LeaveVerificationLoadingState()){
    on<LeaveVerificationInitialEvent>(_onLeaveVerificationInitialEvent);
    on<LeaveVerificationSubmitEvent>(_onLeaveVerificationSubmitEvent);
    on<LeaveVerificationStatusChangeEvent>(_onLeaveVerificationStatusEvent);
  }

  void _onLeaveVerificationInitialEvent(LeaveVerificationInitialEvent event, Emitter<LeaveVerificationState> emit)async {
    try{
      model = event.data;
      reasonController.text = model?['admin_reason'] ?? '';
      selectedStatus = statusName.where((e) => e['name'] == model['status']).firstOrNull;
      emit(LeaveVerificationCommonState());
    }catch(e){
     emit(LeaveVerificationErrorState(e.toString()));
   }
  }

  void _onLeaveVerificationSubmitEvent(LeaveVerificationSubmitEvent event, Emitter<LeaveVerificationState> emit)async {
    try {
      await _apiRepository.leaveApprove(body: _saveData());
      FBroadcast.instance().broadcast("refreshLeaveList");
      emit(LeaveVerificationSuccessState());
    } catch (e) {
      emit(LeaveVerificationErrorState(e.toString()));
    }
  }

    void _onLeaveVerificationStatusEvent(
        LeaveVerificationStatusChangeEvent event,
        Emitter<LeaveVerificationState> emit) async {
      try {
        selectedStatus = event.selectedData;
        emit(LeaveVerificationCommonState());
      } catch (e) {
        emit(LeaveVerificationErrorState(e.toString()));
      }
    }

    Map<String, String> _saveData() {
      Map<String, String> data = {};
      data['id'] = model['id'].toString();
      data['reason'] = reasonController.text;
      data['status'] = selectedStatus['name'];
      return data;
    }


}