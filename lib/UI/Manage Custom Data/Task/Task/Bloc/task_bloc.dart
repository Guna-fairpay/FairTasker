
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState>{
  final APiRepository _apiRepository = APiRepository();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController taskController = TextEditingController();
  final TextEditingController timeTakenController = TextEditingController();
  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> filteredResponse = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // final FBroadcast _broadcast = FBroadcast.instance();

  TaskBloc() : super(TaskLoadingState()){

    on<TaskInitialEvent>((event, emit) async {
      //  emit(VehicleLoadingState());
      // var response= await _getVehicle();
      // response?.sort((a, b) => b['created_at'].compareTo(a['created_at']));
      // apiResponse = response??[];
      // filteredResponse.clear();
      // filteredResponse = apiResponse;
      //  emit(VehicleLoadedState());
    });

  }


}
