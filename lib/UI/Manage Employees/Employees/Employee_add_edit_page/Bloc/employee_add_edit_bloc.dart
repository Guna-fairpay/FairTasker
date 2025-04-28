
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/Bloc/employee_add_edit_event.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/Bloc/employee_add_edit_state.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
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
  bool isEdit = false;
  bool isShow = true;

  EmployeeAddEditBloc() : super(EmployeeAddEditLoadingState()){

    on<EmployeesAddEditInitialEvent>(_onEmployeeInitialEvent);
    on<ShowPasswordEvent>(_onShowPasswordEvent);
    on<EmployeeSaveEvent>(_onEmployeeSaveEvent);

  }

  void _onEmployeeInitialEvent(EmployeesAddEditInitialEvent event, Emitter<EmployeeAddEditState> emit) async {
    try{
      isEdit = event.id != null ? true : false;
      Console.of.log(isEdit);
      emit(EmployeeAddEditLoadingState());
      if(event.id != null){
        var departmentResponse = await _apiRepository.getDepartmentData();
        var response = await _apiRepository.getEmployeeById(id: event.id);
        roleList = List.from(response?['role']);
        departmentList =List.from(departmentResponse?['department']);
        firstNameController.text = response?['user']?['first_name'];
        lastController.text = response?['user']?['last_name'];
        emailController.text = response?['user']?['email'];
        mobileController.text = response?['user']?['phone'];
        selectedRole = roleList.firstWhere(
                (element) => element['id'].toString() ==  response?['user']?['role']['id'].toString());
        selectedDepartment = departmentResponse?['department'].firstWhere(
                (element) => element['id'].toString() ==  response?['user']?['department'].toString());
      }else{
      var roleResponse = await _apiRepository.getRoleData();
      var departmentResponse = await _apiRepository.getDepartmentData();
      roleList = List.from(roleResponse?['role']);
      departmentList = List.from(departmentResponse?['department']);
      }
      emit(EmployeeAddEditCommonState());
    }catch(e){
      Toaster.showError(e.toString());
      Console.of.error(e.toString());
      emit(EmployeeAddEditCommonState());
    }
  }

  void _onShowPasswordEvent(ShowPasswordEvent event, Emitter<EmployeeAddEditState> emit) {
    isShow = !isShow;
    emit(EmployeeAddEditCommonState());
  }

  void _onEmployeeSaveEvent(EmployeeSaveEvent event, Emitter<EmployeeAddEditState> emit) async {
    if(firstNameController.text.isEmpty || lastController.text.isEmpty
        ||emailController.text.isEmpty || mobileController.text.isEmpty
        ||passwordController.text.isEmpty || selectedRole==null)
    {
      Toaster.showError("Please fill all fields");
    }else{
      try{
        emit(EmployeeAddEditLoadingState());
        Map<String, String> data = {
          "first_name": firstNameController.text,
          "last_name": lastController.text,
          "email": emailController.text,
          "phone": mobileController.text,
          if(!isEdit)"password": passwordController.text,
          "role": "${selectedRole['id']}",
          "department": "${selectedDepartment['id']}",
        };
        if(isEdit){
          var response = await _apiRepository.adduser(body: data);
         }
        if(!isEdit){
        var response = await _apiRepository.adduser(body: data);
        if(response != null){
          Toaster.showSuccess(response['message']);
          Map<String, String> body = {
            "first_name": firstNameController.text,
            "last_name": lastController.text,
            "email": emailController.text,
            "password": passwordController.text,
          };
          var addValue= await _apiRepository.addEmployee(body: body);
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
            var editValue= await _apiRepository.updateEmployee(body: body,id: id);
            Console.of.debug(editValue);
          }else{
            Toaster.showError(addValue);
          }
        }
        }
        await getIt<CommonService>().getResources(reset: true);
        await getIt<CommonService>().getUsers(reset: true);
        FBroadcast.instance().broadcast("refresh_add");
      }catch(e){
        Toaster.showError(e.toString());
        emit(EmployeeAddEditCommonState());
      }
    }
  }

}
