
import 'dart:async';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/Bloc/supplies_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/Bloc/supplies_state.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuppliesBloc extends Bloc<SuppliesEvent, SuppliesState>{

  final APiRepository _apiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  AutovalidateMode? autoValidateMode;

  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> _unFilteredResponse = [];
  List<Map<String, dynamic>> filteredResponse = [];

  int selectedTab = 0;
  int itemsPerPage = 10;
  int currentIndex = 1;
  int totalCount = 0;

  dynamic selectedData;

  bool isEdit = false;

  SuppliesBloc() : super(SuppliesLoadingState()){

    on<SuppliesInitialEvent>(_onSuppliesInitialEvent);
    on<DeleteSuppliesEvent>(_onDeleteTaskEvent);
    on<SaveSuppliesEvent>(_onSaveTaskEvent);
    on<SearchSuppliesEvent>(_onSearchSuppliesEvent);

    on<SuppliesPaginationEvent>((event, emit) {
      currentIndex = event.page;
      _pagenate();
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

  void _pagenate() {
    filteredResponse = paginateList(data: _unFilteredResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage);
  }

  void _listener() {}

  void _onDeleteTaskEvent(DeleteSuppliesEvent event, Emitter<SuppliesState> emit) async {
    try{
      emit(SuppliesLoadingState());
      var response = await _apiRepository.deleteSuppliesData(event.data['id']);
      await getIt<CommonService>().getSuppliesList(reset: true);
      if(response?['message']!=null){
        apiResponse.removeWhere((element) => element['id'] == event.data['id']);
        totalCount = apiResponse.length;
        _unFilteredResponse = apiResponse;
        _pagenate();
        Toaster.showSuccess(response?['message']);
        if(selectedData == event.data){
          isEdit = false;
          selectedData = null;
          nameController.clear();
          notesController.clear();
        }
        _search();
        _broadcast.broadcast(Str.addToDoRefresh);
        _broadcast.broadcast(Str.editToDoRefresh);
        emit(SuppliesCommonState());
      }
    }catch(e){
      Toaster.showError(e.toString());
      _search();
      emit(SuppliesCommonState());
    }
  }

  void _onSaveTaskEvent(SaveSuppliesEvent event, Emitter<SuppliesState> emit) async {
    autoValidateMode  = AutovalidateMode.onUserInteraction;
    if(formKey.currentState?.validate() == false) return emit(SuppliesCommonState());
    try{
      autoValidateMode = null;
      emit(SuppliesLoadingState());
      var data = {
        'name':nameController.text,
        'description':notesController.text,
        "platform": "tasker-app",
        "status": "1"
      };
      Console.of.log(data);
      var response = await _apiRepository.suppliesAddOrUpdate(body: data,id: selectedData?['id']);
      await getIt<CommonService>().getSuppliesList(reset: true);
      if (response?["data"] != null) {
        final newData = response!["data"];
        nameController.clear();
        notesController.clear();
        if (selectedData != null) {
          isEdit = false;
          selectedData = null;
          apiResponse.removeWhere((e) => e['id'] == newData['id']);
          apiResponse.add(newData);
          Toaster.showSuccess("Supplies updated successfully");
        } else {
          apiResponse.add(newData);
          Toaster.showSuccess("Supplies added successfully");
        }
        apiResponse.sort((a, b) => b['id'].compareTo(a['id']));
        totalCount = apiResponse.length;
        _unFilteredResponse = apiResponse;
        _pagenate();
        _search();
        _broadcast.broadcast(Str.addToDoRefresh);
        _broadcast.broadcast(Str.editToDoRefresh);
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
      if(event.title!=null){
        nameController.text = event.title??'';
      }
      var response = await getIt<CommonService>().getSuppliesList(reset: true);
      apiResponse =List.from(response);
      apiResponse.sort((a, b) => b['id'].compareTo(a['id']));
      filteredResponse.clear();
      _unFilteredResponse = apiResponse;
      _pagenate();
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
    _unFilteredResponse = filteredData;
    _pagenate();
  }

  void _onSearchSuppliesEvent(SearchSuppliesEvent event, Emitter<SuppliesState> emit) {
    _search();
     emit(SuppliesCommonState());
  }

}
