
import 'dart:async';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/Bloc/supplies_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/Bloc/supplies_state.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuppliesBloc extends Bloc<SuppliesEvent, SuppliesState>{

  final APiRepository _apiRepository = APiRepository();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  AutovalidateMode autoValidateMode = AutovalidateMode.onUserInteraction;
  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> filteredResponse = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int itemsPerPage = 10;
  int currentIndex = 1;
  int totalCount = 0;
  bool isEdit = false;
  dynamic selectedData;
  int selectedTab = 0;

  SuppliesBloc() : super(SuppliesLoadingState()){

    on<SuppliesInitialEvent>(_onSuppliesInitialEvent);
    on<DeleteSuppliesEvent>(_onDeleteTaskEvent);
    on<SaveSuppliesEvent>(_onSaveTaskEvent);
    on<SearchSuppliesEvent>(_onSearchSuppliesEvent);

    on<SuppliesPaginationEvent>((event, emit) {
      currentIndex = event.page;
      filteredResponse = paginateList(data: apiResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage);
      emit(SuppliesCommonState());
    });

    on<EditSuppliesEvent>((event, emit) {
      Console.of.log(event.data);
      isEdit = true;
      selectedData = event.data;
      nameController.text=event.data['name']??'';
      notesController.text=event.data['description']??'';
      emit(SuppliesCommonState());
    });

    on<EditCloseEvent>((event, emit) async {
      isEdit = false;
      selectedData = null;
      nameController.clear();
      notesController.clear();
      emit(SuppliesCommonState());
      await Future.delayed(Durations.short4);
      nameController.addListener(_listener);
      emit(SuppliesCommonState());
    });

  }

  void _listener() {}

  void _onDeleteTaskEvent(DeleteSuppliesEvent event, Emitter<SuppliesState> emit) async {
    try{
      emit(SuppliesLoadingState());
      var response = await _apiRepository.deleteSuppliesData(event.data['id']);
      if(response?['message']!=null){
        apiResponse.removeWhere((element) => element['id'] == event.data['id']);
        totalCount = apiResponse.length;
        filteredResponse = paginateList(data: apiResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage);
        Toaster.showSuccess(response?['message']);
        isEdit = false;
        selectedData = null;
        nameController.clear();
        notesController.clear();
        _search();
        emit(SuppliesCommonState());
      }
    }catch(e){
      Toaster.showError(e.toString());
      _search();
      emit(SuppliesCommonState());
    }
  }

  void _onSaveTaskEvent(SaveSuppliesEvent event, Emitter<SuppliesState> emit) async {
    try{
      if(nameController.text.isEmpty){
        Toaster.showError('Please enter name');
        return;
      }
      emit(SuppliesLoadingState());
      var data = {
        'name':nameController.text,
        'description':notesController.text,
        "platform": "tasker-app",
        "status": "1"
      };
      Console.of.log(data);
      var response = await _apiRepository.suppliesAddOrUpdate(body: data,id: selectedData?['id']);
      if (response?["data"] != null) {
        final newData = response!["data"];
        nameController.clear();
        notesController.clear();
        if (selectedData != null) {
          isEdit = false;
          selectedData = null;
          apiResponse.removeWhere((e) => e['id'] == newData['id']);
          apiResponse.add(newData);
        } else {
          apiResponse.add(newData);
        }
        apiResponse.sort((a, b) => b['id'].compareTo(a['id']));
        totalCount = apiResponse.length;
        filteredResponse = paginateList(
          data: apiResponse,
          currentPage: currentIndex,
          itemsPerPage: itemsPerPage,
        );
        Toaster.showSuccess("Supplies added successfully");
        _search();
        emit(SuppliesCommonState());
      }
      else{
        Console.of.log(response,name: 'TESTCASE0');
        Toaster.showError(response);
        _search();
        emit(SuppliesCommonState());
      }
    }catch(e){
      Toaster.showError(e.toString());
      Console.of.log(e.toString(),name: 'TESTCASE1');
      _search();
      emit(SuppliesCommonState());
    }
  }

  void _onSuppliesInitialEvent(SuppliesInitialEvent event, Emitter<SuppliesState> emit) async {
    try{
      emit(SuppliesLoadingState());
      var response = await getIt<CommonService>().getSuppliesList(reset: true);
      apiResponse =response;
      apiResponse.sort((a, b) => b['id'].compareTo(a['id']));
      filteredResponse.clear();
      filteredResponse = paginateList(
          data: apiResponse,
          currentPage: currentIndex,
          itemsPerPage: itemsPerPage);
      totalCount = apiResponse.length;
      emit(SuppliesCommonState());
    }catch(e){
      Toaster.showError(e.toString());
      emit(SuppliesCommonState());
    }
  }

  void _search(){
    var query = searchController.text.toLowerCase();
    List<Map<String, dynamic>> filteredData = [];

    if (query.trim().isNotNullOrEmpty) {
      filteredData = apiResponse.where((element) {
        return [
          element['name'],
        ].any((value) => value?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    } else {
      filteredData = apiResponse;
    }
    currentIndex=1;
    totalCount = filteredData.length;
    filteredResponse = paginateList(data: filteredData, currentPage: currentIndex, itemsPerPage: itemsPerPage,);

  }

  void _onSearchSuppliesEvent(SearchSuppliesEvent event, Emitter<SuppliesState> emit) {
    _search();
     emit(SuppliesCommonState());
  }

}
