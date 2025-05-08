
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/leave_management/leave_verification/bloc/leave_verification_event.dart';
import 'package:fairpytasker/UI/leave_management/leave_verification/bloc/leave_verification_state.dart';
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
      selectedStatus = statusName.where((e) => e['name'] == model['status']).firstOrNull;
    }catch(e){
     emit(LeaveVerificationErrorState(e.toString()));
   }
  }

  void _onLeaveVerificationSubmitEvent(LeaveVerificationSubmitEvent event, Emitter<LeaveVerificationState> emit)async {}

  void _onLeaveVerificationStatusEvent(LeaveVerificationStatusChangeEvent event, Emitter<LeaveVerificationState> emit)async {
    try{
      selectedStatus = event.selectedData;
      emit(LeaveVerificationSuccessState());
    }catch(e){
      emit(LeaveVerificationErrorState(e.toString()));
    }
  }
}