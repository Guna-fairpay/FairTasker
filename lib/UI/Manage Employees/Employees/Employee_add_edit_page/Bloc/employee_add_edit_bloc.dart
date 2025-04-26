
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/Bloc/employee_add_edit_event.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/Bloc/employee_add_edit_state.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeAddEditBloc extends Bloc<EmployeeAddEditEvent, EmployeeAddEditState>{

  final APiRepository _apiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AutovalidateMode autoValidateMode = AutovalidateMode.onUserInteraction;

  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> roleList = [];
  List<Map<String, dynamic>> departmentList = [];
  dynamic selectedRole={};
  dynamic selectedDepartment={};

  bool isShow = true;

  EmployeeAddEditBloc() : super(EmployeeAddEditLoadingState()){

    on<EmployeesAddEditInitialEvent>(_onEmployeeInitialEvent);
    on<ShowPasswordEvent>(_onShowPasswordEvent);
    on<EmployeeSaveEvent>(_onEmployeeSaveEvent);

  }

  void _onEmployeeInitialEvent(EmployeesAddEditInitialEvent event, Emitter<EmployeeAddEditState> emit) async {
    try{
      emit(EmployeeAddEditLoadingState());
      var response = await _apiRepository.getEmployeeData();
      apiResponse =List.from(response?['role']);
      emit(EmployeeAddEditCommonState());
    }catch(e){
      Toaster.showError(e.toString());
      emit(EmployeeAddEditCommonState());
    }
  }

  void _onShowPasswordEvent(ShowPasswordEvent event, Emitter<EmployeeAddEditState> emit) {
    isShow = !isShow;
    emit(EmployeeAddEditCommonState());
  }

  void _onEmployeeSaveEvent(EmployeeSaveEvent event, Emitter<EmployeeAddEditState> emit) async {
    if(firstNameController.text.isEmpty||lastController.text.isEmpty
        ||emailController.text.isEmpty||mobileController.text.isEmpty
        ||passwordController.text.isEmpty||selectedRole==null)
    {
      Toaster.showError("Please fill all fields");
    }else{
      try{
        emit(EmployeeAddEditLoadingState());
        Map<String, dynamic> body = {
          "first_name": firstNameController.text,
          "last_name": lastController.text,
          "email": emailController.text,
          "mobile": mobileController.text,
          "password": passwordController.text,
          "role_id": selectedRole['id'],
          "department_id": selectedDepartment['id'],
        };

      }catch(e){
        Toaster.showError(e.toString());
        emit(EmployeeAddEditCommonState());
      }
    }
  }

}
