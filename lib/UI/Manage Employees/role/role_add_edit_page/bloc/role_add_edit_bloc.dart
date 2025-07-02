import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'role_add_edit_event.dart';
part 'role_add_edit_state.dart';

class RoleAddEditBloc extends Bloc<RoleAddEditEvent, RoleAddEditState>{

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode? autoValidateMode = AutovalidateMode.onUserInteraction;
  final APiRepository _apiRepository = APiRepository();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final List<dynamic> basedOn = [{'id': 1, 'name': 'Role'}, {'id': 2, 'name': 'User'}];
  dynamic selectedBase;
  final List<dynamic> permission = [];
  final List<dynamic> user = [];
  List<dynamic> selectedPermissionId = [];
  dynamic selectedUser;
  dynamic model;
  bool isEdit = false;
  bool isUserEdit = false;
  bool isRoleEdit = false;

  dynamic message;

  Future<Map<String, dynamic>?> _getEmployeeData() async => await _apiRepository.getEmployeeData();
  Future<Map<String, dynamic>?> _getPermissionList() async => await _apiRepository.getPermissionList();
  Future<Map<String, dynamic>?> _getEditRole({dynamic id}) async => await _apiRepository.getEditRole(id: id);
  Future<Map<String, dynamic>?> _getEditUserRole({dynamic id}) async => await _apiRepository.getEditUserRole(id: id);
  Future<Map<String, dynamic>?> _addEditUserRole({dynamic id, dynamic body}) async => await _apiRepository.saveUserRole(id: id, body: body);

  RoleAddEditBloc() : super(LoadingState()) {
    on<InitialEvent>(_initialEvent);
    on<BaseOnEvent>(_baseOnEvent);
    on<PermissionEvent>(_permissionEvent);
    on<SaveEvent>(_saveEvent);
    on<UserEvent>(_userEvent);
  }

  Future<void> _initialEvent(InitialEvent event, Emitter<RoleAddEditState> emit) async {
    try {
      isEdit = (event.data != null);
      selectedBase = basedOn.first;
      emit(LoadingState());
      var response = await _getEmployeeData();
      user.addAll(response?['role'] ?? []);
      var permissionResponse = await _getPermissionList();
      permission.addAll(permissionResponse?['permission'] ?? []);
      if(event.data != null){
        selectedBase = null;
        if(event.isUserEdit){
          isUserEdit = event.isUserEdit;
          var response = await _getEditUserRole(id: event.data['id']);
          model = response;
          userController.text = "${model?['user']?['first_name'] ?? ''} ${model?['user']?['last_name'] ?? ''}";
        }else{
          isRoleEdit = event.isRoleEdit;
          var response = await _getEditRole(id: event.data['id']);
          model = response;
          roleController.text = model['role']?['name'];
        }
        selectedPermissionId = model['rolePermissions'];
      }
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }


  Future<void> _userEvent(UserEvent event, Emitter<RoleAddEditState> emit) async {
    try {
      selectedUser = event.data;
      Console.of.log(selectedUser);
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _baseOnEvent(BaseOnEvent event, Emitter<RoleAddEditState> emit) async {
    try {
      selectedBase = event.data;
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _permissionEvent(PermissionEvent event, Emitter<RoleAddEditState> emit) async {
    try {
      if(selectedPermissionId.contains(event.data['id'])){
        selectedPermissionId.remove(event.data['id']);
      }else{
        selectedPermissionId.add(event.data['id']);
      }
      emit(CommonState());
    } catch (e) {
      _error(e, emit);
    }
  }

  Future<void> _saveEvent(SaveEvent event, Emitter<RoleAddEditState> emit) async {
    if(formKey.currentState?.validate() == false) return emit(CommonState());
    try {
      emit(LoadingState());
      if(selectedPermissionId.isEmpty) return emit(ErrorState('The permission field is required.'));
      var response = await (
          (isUserEdit || selectedBase?['id'] == 2)
          ? _addEditUserRole(id: model?['user']?['id'], body: {
            'name': "",
            'permission' : selectedPermissionId,
            'user':(selectedUser != null) ? selectedUser['id'] : model?['user']?['id'],})
          : _addEditUserRole(id: model?['role']?['id'], body: {
            'name': roleController.text,
            'permission' : selectedPermissionId,
            'user': "",})
      );
      if(response?['status'] == 200){
        if(!isUserEdit) FBroadcast.instance().broadcast('refreshRoles');
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
    } catch (e) {
      _error(e, emit);
    }
  }

  void _error(dynamic error, Emitter<RoleAddEditState> emit) {
    emit(ErrorState(error));
    Console.of.error(error);
  }

}