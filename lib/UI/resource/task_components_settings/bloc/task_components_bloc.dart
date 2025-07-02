
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'task_components_event.dart';
part 'task_components_state.dart';

class TaskComponentBloc extends Bloc<TaskComponentEvent,TaskComponentState> {

  APiRepository apiRepository = APiRepository();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode? autoValidateMode;

  TextEditingController taskNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  List<dynamic> baseList = [
    {'id': '1', 'title': 'Task based'},
    {'id': '2', 'title': 'Hourly based'} ];

  List<dynamic>? apiResponse;
  List<dynamic>? taskBaseList;
  List<dynamic>? hourlyBaseList;
  List<dynamic>? userId;

  dynamic selectedBase;
  dynamic selectedResource;
  dynamic editData;

  int selectedTab = 0;

  bool isHourBased = false;
  bool isEdit = false;

  List get _resourceList => getIt<CommonService>().usersList;
  List get resourceList {
    var list = List.from(getIt<CommonService>().usersList);
    list.removeWhere((element) => (element['id'] == 2) ||  (element['deleted_at'].toString().isNotNullOrEmpty)  /*|| (element['branch_id'] != getIt<CommonService>().branchId)*/ );
    return list;
  }

  TaskComponentBloc() :super(TaskComponentLoadingState()){
    on<TaskComponentInitialEvent>(_onTaskComponentsInitialEvent);
    on<TaskComponentDropdownBaseEvent>(_onTaskComponentsDropdownBaseEvent);
    on<TaskComponentResourceDropdownEvent>(_onTaskComponentsResourceDropdownEvent);
    on<TaskComponentTabBarEvent>(_onTaskComponentsTabBarEvent);
    on<TaskComponentEditEvent>(_onTaskComponentsEditEvent);
    on<TaskComponentClearAllFieldEvent>(_onTaskComponentsClearAllFieldEvent);
    on<TaskComponentSaveEvent>(_onTaskComponentsSaveEvent);
    on<TaskComponentDeleteEvent>(_onTaskComponentDeleteEvent);
  }

  Future<void> _onTaskComponentsInitialEvent(TaskComponentInitialEvent event, Emitter<TaskComponentState> emit) async {
    try {
      emit(TaskComponentLoadingState());
      await refetch();
      emit(TaskComponentCommentState());
    } catch (e) {
      _onError("TaskComponentInitialEvent ${e.toString()}");
      emit(TaskComponentCommentState());
    }
  }

  Future<void> _onTaskComponentsDropdownBaseEvent(TaskComponentDropdownBaseEvent event, Emitter<TaskComponentState> emit) async {
    try {
      if(selectedBase != event.value){
        selectedBase = event.value;
        if (selectedBase['id'] == '2') {
          isHourBased = true;
          selectedTab = 1;
        } else {
          isHourBased = false;
          selectedTab = 0;
        }
        add(TaskComponentClearAllFieldEvent());
      }
      emit(TaskComponentCommentState());
      } catch (e) {
      _onError("TaskComponentDropdownBaseEvent ${e.toString()}");
      emit(TaskComponentCommentState());
    }
  }

  void _onTaskComponentsResourceDropdownEvent(TaskComponentResourceDropdownEvent event, Emitter<TaskComponentState> emit) {
    try {
      selectedResource = event.value;
      emit(TaskComponentCommentState());
    } catch (e) {
      _onError("TaskComponentResourceDropdownEvent ${e.toString()}");
      emit(TaskComponentCommentState());
    }
  }

  void _onTaskComponentsTabBarEvent(TaskComponentTabBarEvent event, Emitter<TaskComponentState> emit) {
    try {
      selectedTab = event.tabIndex;
      emit(TaskComponentCommentState());
    } catch (e) {
      _onError("TaskComponentTabBarEvent ${e.toString()}");
      emit(TaskComponentCommentState());
    }
  }

  void _onTaskComponentsEditEvent(TaskComponentEditEvent event, Emitter<TaskComponentState> emit) {
     try{
       isEdit = event.value.isNotEmpty;
       editData = event.value;
       if(event.value['type'] == 'task') {
         isHourBased = false;
         selectedResource = null;
         selectedBase = baseList.first;
         taskNameController.text = event.value['task_name'];
         amountController.text = event.value['amount'];
       } else {
         formKey.currentState?.reset();
         autoValidateMode = null;
         isHourBased = true;
         taskNameController.clear();
         selectedBase = baseList.last;
         amountController.text = event.value['amount'];
         selectedResource = resourceList.firstWhereOrNull((e) => e['id'].toString() == event.value['user_id'].toString());
       }
       emit(TaskComponentCommentState());
     } catch (e) {
       _onError("TaskComponentEditEvent ${e.toString()}");
       emit(TaskComponentCommentState());
     }
  }

  void _onTaskComponentsClearAllFieldEvent(TaskComponentClearAllFieldEvent event, Emitter<TaskComponentState> emit) {
     try{
       formKey.currentState?.reset();
       autoValidateMode = null;
       isEdit = false;
       editData = null;
       selectedResource = null;
       taskNameController.clear();
       amountController.clear();
       emit(TaskComponentCommentState());
     }catch(e){
       _onError("TaskComponentsClearAllFieldEvent ${e.toString()}");
       emit(TaskComponentCommentState());
     }
   }

   Future<void> _onTaskComponentDeleteEvent(TaskComponentDeleteEvent event, Emitter<TaskComponentState> emit) async {
     try {
       emit(TaskComponentLoadingState());
       var response = await apiRepository.deleteConfiguration(id: event.value['id']);
       if(response?['status'] == 200){
         await refetch();
       }
       if((event.value['id'].toString()) == (editData?['id'].toString())){
         add(TaskComponentClearAllFieldEvent());
       }
       emit(TaskComponentCommentState());
       } catch (e) {
       _onError("TaskComponentDeleteEvent ${e.toString()}");
       emit(TaskComponentCommentState());
     }
   }

   Future<void> _onTaskComponentsSaveEvent(TaskComponentSaveEvent event, Emitter<TaskComponentState> emit) async {
     autoValidateMode = AutovalidateMode.onUserInteraction;
     if (formKey.currentState?.validate() == false) return emit(TaskComponentCommentState());
     try {
      autoValidateMode = null;
      if((userId ?? []).contains(selectedResource?['id']) && !isEdit) return emit(ErrorState('User already exist'));
      emit(TaskComponentLoadingState());
      var response = await apiRepository.addConfiguration(id: isEdit ? "${editData['id']}" : null, body: _data);
      if(response?['status'] == 200){
        await refetch();
        isEdit = false;
        editData = null;
        add(TaskComponentClearAllFieldEvent());
        // if(isEdit){
        //   apiResponse?.removeWhere((element) => element['id'] == editData['id']);
        //   apiResponse?.add(response?['data']);
        //   filterData(apiResponse);
        //   editData = null;
        //   isEdit = false;
        //
        // } else {
        //   apiResponse?.add(response?['data']);
        //   filterData(apiResponse);
        //   add(TaskComponentClearAllFieldEvent());
        // }
      }
      emit(TaskComponentCommentState());
     }catch (e){
       _onError("TaskComponentSaveEvent ${e.toString()}");
       emit(TaskComponentCommentState());
     }
   }

   Map<String, dynamic> get _data {
     Map<String, dynamic> data = {};
       data['amount'] = amountController.text;
       data['task_name'] = taskNameController.text;
       data['type'] = selectedBase?['id'] == '1' ? 'task' : 'hourly';
       data['user_id'] = selectedResource?['id'] ?? '';
     Console.of.log(data, name: "PAYLOAD_DATA");
     return data;
   }

   void _onError(dynamic error) {
     Console.of.error(error);
     Toaster.showError(error,);
   }

   Future<void> filterData(List<dynamic>? apiResponse) async {
     taskBaseList = apiResponse?.where((element) => element['type'] == 'task').toList();
     hourlyBaseList = apiResponse?.where((element) => element['type'] == 'hourly').toList();
     hourlyBaseList?.forEach((e) {
       dynamic user;
       if (e['user_id'].toString().isNotNullOrEmpty) {
         user = _resourceList.firstWhereOrNull(
                 (element) => element['id'].toString() == e['user_id'].toString());
       }
       e['user_name'] = "${user?['first_name'] ?? ''} ${user?['last_name'] ?? ''}";
     });
   }

   Future<void> refetch()async {
     selectedBase = baseList.first;
     await getIt<CommonService>().getUsers();
     var response = await apiRepository.getConfiguration();
     apiResponse = response?['data'];
     userId = apiResponse?.where((element) => element['user_id'] != null).map((e) => e['user_id']).toList();
     // resourceList.removeWhere((element) => (userId ?? []).map((e) => e.toString()).contains(element['id'].toString()));
     filterData(apiResponse);
     Console.of.log(resourceList);
   }

}