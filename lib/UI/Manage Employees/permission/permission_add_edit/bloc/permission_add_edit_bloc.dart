import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'permission_add_edit_event.dart';
part 'permission_add_edit_state.dart';


class PermissionAddEditBloc extends Bloc<PermissionAddEditEvent, PermissionAddEditState>{

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode? autoValidateMode = AutovalidateMode.onUserInteraction;
  APiRepository apiRepository = APiRepository();
  final TextEditingController nameController = TextEditingController();
  dynamic model;
  bool isEdit = false;

  Future<Map<String, dynamic>?> _getEditPermission({dynamic id}) async => await apiRepository.getEditPermission(id: id);
  Future<Map<String, dynamic>?> _savePermission({dynamic body, dynamic id}) async => await apiRepository.savePermission(body: body, id: id);

  PermissionAddEditBloc():super(LoadingState()){
    on<InitialEvent>(_initialEvent);
    on<SaveEvent>(_saveEvent);
  }

  Future<void> _initialEvent(InitialEvent event, Emitter<PermissionAddEditState> emit) async {
    try {
      emit(LoadingState());
      isEdit = event.model != null;
      if (event.model != null) {
        var response = await _getEditPermission(id: event.model['id']);
        model = response?['permission'];
        nameController.text = model?['name'] ?? '';
      }
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }
  Future<void> _saveEvent(SaveEvent event, Emitter<PermissionAddEditState> emit) async {
    if (formKey.currentState?.validate() == false) return emit(CommonState());
    try {
      emit(LoadingState());
      var response = await _savePermission(body: {
        'name': nameController.text,
      }, id: model?['id']);
      if(response?['status'] == 200) {
        FBroadcast.instance().broadcast("refresh_permission");
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onError(dynamic error, Emitter<PermissionAddEditState> emit) {
    Console.of.error(error);
    emit(ErrorState(error));
  }
}