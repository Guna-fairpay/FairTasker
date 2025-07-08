import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
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
    {'id': '2', 'title': 'Hourly based'}
  ];

  List<dynamic>? apiResponse;
  List<dynamic>? taskBaseList;
  List<dynamic>? hourlyBaseList;
  List<dynamic>? userId;
  List<dynamic> resourceList = [];

  dynamic selectedBase;
  dynamic selectedResource;
  dynamic editData;

  int selectedTab = 0;

  bool isHourBased = false;
  bool isEdit = false;

  // List get _resourceList => getIt<CommonService>().usersList;
  List get _resourceList {
    var list = List.from(getIt<CommonService>().usersList);
    list.removeWhere((element) => (element['id'] == 2) ||  (element['deleted_at'].toString().isNotNullOrEmpty)  /*|| (element['branch_id'] != getIt<CommonService>().branchId)*/ );
    return list;
  }

  TaskComponentBloc() :super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<DropdownBaseEvent>(_onDropdownBaseEvent);
    on<ResourceDropdownEvent>(_onResourceDropdownEvent);
    on<TabBarEvent>(_onTabBarEvent);
    on<EditEvent>(_onEditEvent);
    on<ClearAllFieldEvent>(_onClearAllFieldEvent);
    on<SaveEvent>(_onSaveEvent);
    on<DeleteEvent>(_onDeleteEvent);
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<TaskComponentState> emit) async {
    try {
      emit(LoadingState());
      selectedBase = baseList.first;
      await refetch();
      emit(CommentState());
    } catch (e) {
      _onError(e, emit);
      emit(CommentState());
    }
  }

  void _onDropdownBaseEvent(DropdownBaseEvent event, Emitter<TaskComponentState> emit) {
    try {
      if(selectedBase != event.value){
        selectedBase = event.value;
        isHourBased = selectedBase['id'] == '2';
        selectedTab = selectedBase['id'] == '2' ? 1 : 0;
        clearAll();
      }
      emit(CommentState());
      } catch (e) {
      _onError(e, emit);
      emit(CommentState());
    }
  }

  void _onResourceDropdownEvent(ResourceDropdownEvent event, Emitter<TaskComponentState> emit) {
    try {
      selectedResource = event.value;
      emit(CommentState());
    } catch (e) {
      _onError(e, emit);
      emit(CommentState());
    }
  }

  void _onTabBarEvent(TabBarEvent event, Emitter<TaskComponentState> emit) {
    try {
      selectedTab = event.tabIndex;
      emit(CommentState());
    } catch (e) {
      _onError(e, emit);
      emit(CommentState());
    }
  }

  void _onEditEvent(EditEvent event, Emitter<TaskComponentState> emit) {
     try{
       resourceList.removeWhere((element) => element['id'].toString() == editData?['user_id'].toString());
       isEdit = event.value.isNotEmpty;
       editData = event.value;
       if(editData['type'] == 'task') {
         isHourBased = false;
         selectedResource = null;
         selectedBase = baseList.first;
         taskNameController.text = editData['task_name'];
         amountController.text = editData['amount'];
       } else {
         formKey.currentState?.reset();
         autoValidateMode = null;
         isHourBased = true;
         taskNameController.clear();
         selectedBase = baseList.last;
         amountController.text = editData['amount'];
         resourceList.add(_resourceList.firstWhereOrNull((e) => e['id'].toString() == editData['user_id'].toString()));
         selectedResource = resourceList.firstWhereOrNull((e) => e['id'].toString() == editData['user_id'].toString());
       }
       emit(CommentState());
     } catch (e) {
       _onError(e, emit);
       emit(CommentState());
     }
  }

  void _onClearAllFieldEvent(ClearAllFieldEvent event, Emitter<TaskComponentState> emit) {
     try{
       clearAll();
       emit(CommentState());
     }catch(e){
       _onError(e, emit);
       emit(CommentState());
     }
   }

   Future<void> _onDeleteEvent(DeleteEvent event, Emitter<TaskComponentState> emit) async {
     try {
       emit(LoadingState());
       var response = await apiRepository.deleteConfiguration(id: event.value['id']);
       if(response?['status'] == 200){
         await refetch();
         if((event.value['id'].toString()) == (editData?['id'].toString())){
           clearAll();
         }
       }
       emit(CommentState());
     } catch (e) {
       _onError(e, emit);
       emit(CommentState());
     }
   }

   Future<void> _onSaveEvent(SaveEvent event, Emitter<TaskComponentState> emit) async {
     autoValidateMode = AutovalidateMode.onUserInteraction;
     if (formKey.currentState?.validate() == false) return emit(CommentState());
     try {
      autoValidateMode = null;
      emit(LoadingState());
      var response = await apiRepository.addConfiguration(id: isEdit ? "${editData['id']}" : null, body: _data);
      if(response?['status'] == 200){
        await refetch();
        clearAll();
      }
      emit(CommentState());
     }catch (e){
       _onError(e, emit);
       emit(CommentState());
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

   void _onError(dynamic error, Emitter<TaskComponentState> emit) {
     Console.of.error(error);
     emit(ErrorState(error));
   }

   Future<void> filterData(List<dynamic>? apiResponse) async {
     taskBaseList = apiResponse?.where((element) => element['type'] == 'task').toList();
     hourlyBaseList = apiResponse?.where((element) => element['type'] == 'hourly').toList();
     hourlyBaseList?.forEach((e) {
       dynamic user;
       if (e['user_id'].toString().isNotNullOrEmpty) {
         user = _resourceList.firstWhereOrNull((element) => element['id'].toString() == e['user_id'].toString());
       }
       e['user_name'] = "${user?['first_name'] ?? ''} ${user?['last_name'] ?? ''}";
     });
   }

   Future<void> refetch()async {
     await getIt<CommonService>().getUsers();
     var response = await apiRepository.getConfiguration();
     apiResponse = response?['data'];
     userId = apiResponse?.where((element) => element['user_id'] != null).map((e) => e['user_id']).toList();
     resourceList = List.from(_resourceList);
     resourceList.removeWhere((element) => (userId ?? []).map((e) => e.toString()).contains(element['id'].toString()));
     filterData(apiResponse);
   }

   void clearAll(){
     formKey.currentState?.reset();
     autoValidateMode = null;
     isEdit = false;
     resourceList.removeWhere((element) => element['id'].toString() == editData?['user_id'].toString());
     editData = null;
     selectedResource = null;
     taskNameController.clear();
     amountController.clear();
   }

}