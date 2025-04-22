
import 'dart:async';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/Bloc/parts_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/Bloc/parts_state.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PartsBloc extends Bloc<PartsEvent, PartsState>{

  final APiRepository _apiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  AutovalidateMode autoValidateMode = AutovalidateMode.onUserInteraction;

  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> filteredResponse = [];

  int selectedTab = 0;
  int itemsPerPage = 10;
  int currentIndex = 1;
  int totalCount = 0;

  bool isEdit = false;

  dynamic selectedData;


  PartsBloc() : super(PartsLoadingState()){

    on<PartsInitialEvent>(_onPartsInitialEvent);
    on<DeletePartsEvent>(_onDeleteTaskEvent);
    on<SavePartsEvent>(_onSaveTaskEvent);

    on<PartsPaginationEvent>((event, emit) {
      currentIndex = event.page;
      filteredResponse = paginateList(data: apiResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage);
      emit(PartsCommonState());
    });

    on<SearchPartsEvent>(_onSearchPartsEvent);

    on<EditPartsEvent>((event, emit) {
      Console.of.log(event.data);
      isEdit = true;
      selectedData = event.data;
      nameController.text=event.data['name'];
      notesController.text=event.data['note']??'';
      emit(PartsCommonState());
    });

    on<EditCloseEvent>((event, emit) async {
      isEdit = false;
      selectedData = null;
      nameController.clear();
      notesController.clear();
      emit(PartsCommonState());
      await Future.delayed(Durations.short4);
      nameController.addListener(_listener);
      emit(PartsCommonState());
    });

  }

  void _listener() {}

  void _onDeleteTaskEvent(DeletePartsEvent event, Emitter<PartsState> emit) async {
    try{
      emit(PartsLoadingState());
      var response = await _apiRepository.deletePartsData(event.data['id']);
      await getIt<CommonService>().getPartsList(reset: true);
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
        _broadcast.broadcast(Str.addToDoRefresh);
        emit(PartsCommonState());
      }
    }catch(e){
      Toaster.showError(e.toString());
      emit(PartsCommonState());
    }
  }

  void _onSaveTaskEvent(SavePartsEvent event, Emitter<PartsState> emit) async {
    try{
      if(nameController.text.isEmpty){
        Toaster.showError('Please enter name');
        return;
      }
      emit(PartsLoadingState());
      var data = {
        'name':nameController.text,
        'notes':notesController.text,
        "platform": "tasker-app",
        "status": "1"
      };
      Console.of.log(data);
      var response = await _apiRepository.partsAddOrUpdate(body: data,id: selectedData?['id']);
      await getIt<CommonService>().getPartsList(reset: true);
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
        Toaster.showSuccess("Parts added successfully");
        _search();
        _broadcast.broadcast(Str.addToDoRefresh);
        emit(PartsCommonState());
      }
      else{
        Console.of.log(response,name: 'TESTCASE0');
        Toaster.showError(response);
        _search();
        emit(PartsCommonState());
      }
    }catch(e){
      Toaster.showError(e.toString());
      Console.of.log(e.toString(),name: 'TESTCASE1');
      _search();
      emit(PartsCommonState());
    }
  }

  void _onPartsInitialEvent(PartsInitialEvent event, Emitter<PartsState> emit) async {
    try{
      emit(PartsLoadingState());
      var response = await getIt<CommonService>().getPartsList(reset: true);
      apiResponse =List.from(response);
      apiResponse.sort((a, b) => b['id'].compareTo(a['id']));
      filteredResponse.clear();
      filteredResponse = paginateList(
          data: apiResponse,
          currentPage: currentIndex,
          itemsPerPage: itemsPerPage);
      totalCount = apiResponse.length;
      emit(PartsCommonState());
    }catch(e){
      Toaster.showError(e.toString());
      emit(PartsCommonState());
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

  void _onSearchPartsEvent(SearchPartsEvent event, Emitter<PartsState> emit) {
    _search();
     emit(PartsCommonState());
  }

}
