
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/Bloc/employee_add_edit_event.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/Bloc/employee_add_edit_state.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeAddEditBloc extends Bloc<EmployeeAddEditEvent, EmployeeAddEditState>{

  final APiRepository _apiRepository = APiRepository();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AutovalidateMode? autoValidateMode;

  Map<String, dynamic> apiResponse = {};
  List<Map<String, dynamic>> roleList = [];
  List<Map<String, dynamic>> departmentList = [];
  dynamic selectedRole;
  dynamic selectedDepartment;
  bool isEdit = false;
  bool isShow = true;

  EmployeeAddEditBloc() : super(EmployeeAddEditLoadingState()){

    on<EmployeesAddEditInitialEvent>(_onEmployeeInitialEvent);
    on<ShowPasswordEvent>(_onShowPasswordEvent);
    on<EmployeeSaveEvent>(_onEmployeeSaveEvent);
    on<RoleSelectionEvent>(_onRoleSelectionEvent);
    on<DepartmentSelectionEvent>(_onDepartmentSelectionEvent);

  }

  void _onEmployeeInitialEvent(EmployeesAddEditInitialEvent event, Emitter<EmployeeAddEditState> emit) async {
    try{
      isEdit = event.id != null ? true : false;
      Console.of.log(isEdit);
      emit(EmployeeAddEditLoadingState());
      if(event.id != null){
        var departmentResponse = await _apiRepository.getDepartmentData();
        var response = await _apiRepository.getEmployeeById(id: event.id);
        apiResponse = response?['user'];
        roleList = List.from(response?['role'] ?? []);
        departmentList =List.from(departmentResponse?['department'] ?? []);
        firstNameController.text = response?['user']?['first_name'] ?? '';
        lastController.text = response?['user']?['last_name'] ?? '';
        emailController.text = response?['user']?['email'] ?? '';
        mobileController.text = response?['user']?['phone'] ?? '';
        selectedRole = roleList.where(
                (element) => element['id'].toString() ==  (apiResponse['role']?['id']).toString()).firstOrNull;
        selectedDepartment =List.from(departmentResponse?['department'] ?? []).where(
                (element) => element['id'].toString() ==  (apiResponse['department']).toString()).firstOrNull;
      }else{
      var roleResponse = await _apiRepository.getRoleData();
      var departmentResponse = await _apiRepository.getDepartmentData();
      roleList = List.from(roleResponse?['role'] ?? []);
      departmentList = List.from(departmentResponse?['department'] ?? []);
      }
      emit(EmployeeAddEditCommonState());
    }catch(e){
      Toaster.showError(e.toString(),);
      Console.of.error('EmployeesAddEditInitialEvent',error: e);
      emit(EmployeeAddEditCommonState());
    }
  }

  void _onShowPasswordEvent(ShowPasswordEvent event, Emitter<EmployeeAddEditState> emit) {
    isShow = !isShow;
    emit(EmployeeAddEditCommonState());
  }

  void _onEmployeeSaveEvent(EmployeeSaveEvent event, Emitter<EmployeeAddEditState> emit) async {
    autoValidateMode = AutovalidateMode.onUserInteraction;
    if(formKey.currentState?.validate() == false) return emit(EmployeeAddEditCommonState());
      try{
        autoValidateMode = null;
        emit(EmployeeAddEditLoadingState());
        Map<String, String> data = {
          "first_name": firstNameController.text,
          "last_name": lastController.text,
          "email": emailController.text,
          "phone": mobileController.text,
          if(!isEdit) "password": passwordController.text,
          "role": "${selectedRole['id']}",
          "department": "${selectedDepartment['id']}",
        };
        if(!isEdit){
        var response = await _apiRepository.adduser(body: data);
        // Console.of.debug(response,name: 'AddAPI',);
        if(response != null){
          Toaster.showSuccess(response['message']);
          Map<String, String> body = {
            "first_name": firstNameController.text,
            "last_name": lastController.text,
            "email": emailController.text,
            "password": passwordController.text,
          };
          var addValue= await _apiRepository.addEmployee(body: body);
          // Console.of.debug(addValue,name: 'addValue',);
          if(addValue?['employee']!=null){
            Map<String, String> body = {
              "department": "${selectedDepartment['id']}",
              "first_name": firstNameController.text,
              "last_name": lastController.text,
              "email": emailController.text,
              "hrm_id": "${addValue?['employee']['id']??''}",
              "role": "${selectedRole['id']}",
              "phone": mobileController.text,
            };
            var id=response['user']['id']??'';
            await _apiRepository.updateEmployee(body: body,id: id);
            // Console.of.debug(editValue);
          }else{
            Toaster.showError(addValue?['message']);
          }
        }
        } else {
          var response = await _apiRepository.updateEmployee(body: data,id: "${apiResponse['id']}");
          if(response?['status']==200){
          Toaster.showSuccess(response?['message']);
          }
        }
        getIt<CommonService>().getResources(reset: true);
        getIt<CommonService>().getUsers(reset: true);
        FBroadcast.instance().broadcast(Str.addToDoRefresh);
        FBroadcast.instance().broadcast("refreshEmployees");
        emit(EmployeeAddEditSuccessState());
      }catch(e){
        Toaster.showError(e.toString());
        emit(EmployeeAddEditCommonState());
      }
  }

  void _onRoleSelectionEvent(RoleSelectionEvent event, Emitter<EmployeeAddEditState> emit) {
    selectedRole = event.value;
    emit(EmployeeAddEditCommonState());
  }

  void _onDepartmentSelectionEvent(DepartmentSelectionEvent event, Emitter<EmployeeAddEditState> emit) {
    selectedDepartment = event.value;
    emit(EmployeeAddEditCommonState());
  }

}
