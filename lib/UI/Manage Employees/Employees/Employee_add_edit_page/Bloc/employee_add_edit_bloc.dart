
import 'dart:async';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_List_Page/Bloc/employees_view_event.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_List_Page/Bloc/employees_view_state.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeAddEditBloc extends Bloc<EmployeesViewEvent, EmployeesViewState>{

  final APiRepository _apiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController searchController = TextEditingController();

  AutovalidateMode autoValidateMode = AutovalidateMode.onUserInteraction;

  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> _unFilteredResponse = [];
  List<Map<String, dynamic>> filteredResponse = [];

  int selectedTab = 0;
  int itemsPerPage = 10;
  int currentIndex = 1;
  int totalCount = 0;


  EmployeeAddEditBloc() : super(EmployeesLoadingState()){

    on<EmployeesInitialEvent>(_onEmployeeInitialEvent);
    on<DeleteEmployeesEvent>(_onDeleteEmployeeEvent);
    on<SearchEmployeesEvent>(_onSearchEmployeesEvent);

    on<EmployeesPaginationEvent>((event, emit) {
      currentIndex = event.page;
      filteredResponse = paginateList(
          data: _unFilteredResponse,
          currentPage: currentIndex,
          itemsPerPage: itemsPerPage);
      emit(EmployeesCommonState());
    });
  }

  void _onDeleteEmployeeEvent(DeleteEmployeesEvent event, Emitter<EmployeesViewState> emit) async {
    try{
      emit(EmployeesLoadingState());
      Console.of.log(apiResponse);
      var response = await _apiRepository.deleteEmployee(id:event.data['id']);
      await getIt<CommonService>().getResources(reset: true);
      await getIt<CommonService>().getUsers(reset: true);
      FBroadcast.instance().broadcast("refresh_add");
      if(response?['message']!=null){
        apiResponse.removeWhere((element) => element['id'] == event.data['id']);
        totalCount = apiResponse.length;
        _unFilteredResponse = apiResponse;
        filteredResponse = paginateList(data: _unFilteredResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage);
        Toaster.showSuccess(response?['message']);
        _search();
        _broadcast.broadcast(Str.addToDoRefresh);
        _broadcast.broadcast(Str.editToDoRefresh);
        emit(EmployeesCommonState());
      }
    }catch(e){
      Toaster.showError(e.toString());
      emit(EmployeesCommonState());
    }
  }

  void _onEmployeeInitialEvent(EmployeesInitialEvent event, Emitter<EmployeesViewState> emit) async {
    try{
      emit(EmployeesLoadingState());
      var response = await _apiRepository.getEmployeeData();
      apiResponse =List.from(response?['role']);

      apiResponse = apiResponse
          .mapIndexed((index, element) => {...element, 'index': index + 1})
          .toList();
      filteredResponse.clear();
      _unFilteredResponse = apiResponse;
      filteredResponse = paginateList(
          data: _unFilteredResponse,
          currentPage: currentIndex,
          itemsPerPage: itemsPerPage);
      totalCount = _unFilteredResponse.length;
      emit(EmployeesCommonState());
    }catch(e){
      Toaster.showError(e.toString());
      emit(EmployeesCommonState());
    }
  }

  void _search(){
    var query = searchController.text.toLowerCase();
    List<Map<String, dynamic>> filteredData = [];
    if (query.trim().isNotNullOrEmpty) {
      filteredData = apiResponse.where((element) {
        return [
          element['first_name'],
          element['last_name'],
          element['phone'],
          element['email'],
          element['departments']?['name'],
        ].any((value) => value?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    } else {
      filteredData = apiResponse;
    }
    _unFilteredResponse = filteredData;
    currentIndex=1;
    totalCount = filteredData.length;
    filteredResponse = paginateList(data: _unFilteredResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage,);
  }

  void _onSearchEmployeesEvent(SearchEmployeesEvent event, Emitter<EmployeesViewState> emit) {
    _search();
    emit(EmployeesCommonState());
  }

}
