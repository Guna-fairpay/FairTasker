import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'department_add_edit_event.dart';
part 'department_add_edit_state.dart';

class DepartmentAddEditBloc extends Bloc<DepartmentAddEditEvent, DepartmentAddEditState>{

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode? autoValidateMode = AutovalidateMode.onUserInteraction;
  APiRepository apiRepository = APiRepository();
  final TextEditingController nameController = TextEditingController();
  List<dynamic> headsList = [];
  dynamic selectedHead;
  dynamic model;
  bool isEdit = false;

  Future<Map<String, dynamic>?> _getDepartment({dynamic id}) async => await apiRepository.getEditDepartment(id: id);
  Future<Map<String, dynamic>?> _getHeadList() async => await apiRepository.getHeadList();
  Future<Map<String, dynamic>?> _saveDepartment({dynamic body, dynamic id}) async => await apiRepository.saveDepartment(body: body, id: id);

  DepartmentAddEditBloc():super(LoadingState()){
    on<InitialEvent>(_initialEvent);
    on<SaveEvent>(_saveEvent);
    on<HeadSelectionEvent>(_headSelectionEvent);
  }

  Future<void> _initialEvent(InitialEvent event, Emitter<DepartmentAddEditState> emit) async {
    try {
      emit(LoadingState());
      isEdit = event.model != null;
      var response = await _getHeadList();
      headsList = List.from(response?['users'] ?? []);
      headsList.removeWhere((element) => element['id'] == 2);
      if (event.model != null) {
        var response = await _getDepartment(id: event.model['id']);
        model = response?['department'];
        nameController.text = model?['name'] ?? '';
        selectedHead = headsList.firstWhereOrNull((element) => element['id'].toString() == model?['head'].toString());
      }
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }
  Future<void> _saveEvent(SaveEvent event, Emitter<DepartmentAddEditState> emit) async {
    if (formKey.currentState?.validate() == false) return emit(CommonState());
    try {
      emit(LoadingState());
      var response = await _saveDepartment(body: {
        'head': selectedHead?['id'],
        'name': nameController.text,
      }, id: model?['id']);
      if(response?['status'] == 200) {
        FBroadcast.instance().broadcast("refresh_department");
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _headSelectionEvent(HeadSelectionEvent event, Emitter<DepartmentAddEditState> emit) {
    try {
      selectedHead = event.value;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onError(dynamic error, Emitter<DepartmentAddEditState> emit) {
    Console.of.error(error);
    emit(ErrorState(error));
  }
}