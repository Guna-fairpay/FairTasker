
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Category%20Config/Bloc/category_config_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Category%20Config/Bloc/category_config_state.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryConfigBloc extends Bloc<CategoryConfigEvent, CategoryConfigState>{

  final APiRepository _apiRepository = APiRepository();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  AutovalidateMode autoValidateMode = AutovalidateMode.onUserInteraction;
  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> filteredResponse = [];
  List<dynamic>category=[];
  List<dynamic>usersType=[{'id': 0, 'name': 'Select'}, {'id': 1, 'name': 'Support Task'}];
  dynamic selectedCategory;
  dynamic selectedUserType;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int itemsPerPage = 10;
  int currentIndex = 1;
  int totalCount = 0;
  bool isEdit = false;
  dynamic selectedData;
  int selectedTab = 0;

  CategoryConfigBloc() : super(CategoryConfigLoadingState()){

    on<CategoryConfigInitialEvent>(_onCategoryConfigInitialEvent);

    on<CategoryConfigPaginationEvent>((event, emit) {
      currentIndex = event.page;
      filteredResponse = paginateList(data: apiResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage);
      emit(CategoryConfigCommonState());
    });


    on<SearchCategoryConfigEvent>(_onSearchCategoryConfigEvent);

    on<EditCategoryConfigEvent>((event, emit) {
      Console.of.log(event.data);
      isEdit = true;
      selectedData = event.data;
      selectedCategory={};
      nameController.text=event.data['name'];
      selectedCategory=category.firstWhereOrNull((element) => element['id'].toString()==event.data['parent_id'].toString());
      selectedUserType=usersType.firstWhere((element) => element['id'].toString()==event.data['todo_user_type'].toString());
      emit(CategoryConfigCommonState());
    });

    on<EditCloseState>((event, emit) async {
      isEdit = false;
      selectedData = {};
      nameController.clear();
      selectedCategory={};
      selectedUserType=usersType[0];
      emit(CategoryConfigCommonState());
      await Future.delayed(Durations.short4);
      nameController.addListener(_listener);
      emit(CategoryConfigCommonState());
    });

    on<CategoryDropDownEvent>((event, emit) {
      selectedCategory = event.data;
      emit(CategoryConfigCommonState());
    });


    on<UserTypeDropDownEvent>((event, emit) {
      selectedUserType = event.data;
      emit(CategoryConfigCommonState());
    });

    on<DeleteCategoryConfigEvent>(_onDeleteTaskEvent);

    on<SaveCategoryConfigEvent>(_onSaveTaskEvent);

  }

  void _listener() {}

  void _onDeleteTaskEvent(DeleteCategoryConfigEvent event, Emitter<CategoryConfigState> emit) async {
    try{
      emit(CategoryConfigLoadingState());
      var response = await _apiRepository.deleteCategoryConfigData(event.data['id']);
      if(response?['message']!=null){
        apiResponse.removeWhere((element) => element['id'] == event.data['id']);

        totalCount = apiResponse.length;
        filteredResponse = paginateList(data: apiResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage);
        Toaster.showSuccess(response?['message']);
        emit(CategoryConfigCommonState());
      }
    }catch(e){
      Toaster.showError(e.toString());
      emit(CategoryConfigCommonState());
    }
  }

  void _onSaveTaskEvent(SaveCategoryConfigEvent event, Emitter<CategoryConfigState> emit) async {
    try{
      if(nameController.text.isEmpty){
        Toaster.showError('Please enter name');
        return;
      }
      emit(CategoryConfigLoadingState());
      Console.of.log(selectedCategory.toString(),name: 'TESTCASE1');
      var data = {
        'parent_id': "${selectedCategory?['id']??''}",
        'name':nameController.text,
        'todo_user_type': "${selectedUserType?['id']??''}",
      };
      Console.of.log(data);
      var response = await _apiRepository.categoryConfigAddOrUpdate(body: data,id: selectedData?['id']);
      if (response?["data"] != null) {
        final newData = response!["data"];
        nameController.clear();
        selectedCategory={};
        selectedUserType={};
        if (selectedData != null) {
          isEdit = false;
          selectedData = null;
          apiResponse.removeWhere((e) => e['id'] == newData['id']);
          newData.putIfAbsent('category_name', () => newData['parent_id'] != null
                ? category.firstWhere(
                (cat) => cat['id'].toString() == newData['parent_id'].toString(),
            orElse: () => {'name': ''},)['name'] : ''
          );
          apiResponse.add(newData);
        } else {
          newData.putIfAbsent('category_name', () => newData['parent_id'] != null
              ? category.firstWhere(
                (cat) => cat['id'].toString() == newData['parent_id'].toString(),
            orElse: () => {'name': ''},)['name'] : ''
          );
          apiResponse.add(newData);
        }
        apiResponse.sort((a, b) => b['id'].compareTo(a['id']));
        totalCount = apiResponse.length;
        filteredResponse = paginateList(
          data: apiResponse,
          currentPage: currentIndex,
          itemsPerPage: itemsPerPage,
        );
        Toaster.showSuccess(response['message']);
        emit(CategoryConfigCommonState());
      }
      else{
        Console.of.log(response,name: 'TESTCASE0');
        Toaster.showError(response?['message']);
        emit(CategoryConfigCommonState());
      }
    }catch(e){
      Toaster.showError(e.toString());
      Console.of.log(e.toString(),name: 'TESTCASE1');
      emit(CategoryConfigCommonState());
    }
  }

  void _onCategoryConfigInitialEvent(CategoryConfigInitialEvent event, Emitter<CategoryConfigState> emit) async {
    try{
      emit(CategoryConfigLoadingState());
      var response = await _apiRepository.getTaskCategory();
      apiResponse = List.from(response?['data']);

      category = apiResponse.where((element) => element['parent_id']==null,).toList();
      // category.insert(0, {'id': 0, 'name': 'Select'});
      apiResponse = apiResponse.map((e) => {...e,
        'category_name': e['parent_id'] != null ? category.firstWhere(
                (cat) => cat['id'].toString() == e['parent_id'].toString(),
            orElse: () => {'name': ''})['name'] : ''}).toList();

      apiResponse.sort((a, b) => b['id'].compareTo(a['id']));
      selectedUserType = usersType[0];
      filteredResponse.clear();
      filteredResponse = paginateList(
          data: apiResponse,
          currentPage: currentIndex,
          itemsPerPage: itemsPerPage);
      totalCount = apiResponse.length;
      emit(CategoryConfigCommonState());
    }catch(e){
      Toaster.showError(e.toString());
      emit(CategoryConfigCommonState());
    }
  }

  void _search(){
    var query = searchController.text.toLowerCase();
    List<Map<String, dynamic>> filteredData = [];
    if (query.trim().isNotNullOrEmpty) {
      filteredData = apiResponse.where((element) {
        return [
          element['name'],
          element['category_name'],
        ].any((value) => value?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    } else {
      filteredData = apiResponse;
    }
    totalCount = filteredData.length;
    currentIndex=1;
    filteredResponse = paginateList(data: filteredData, currentPage: currentIndex, itemsPerPage: itemsPerPage,);
  }

  void _onSearchCategoryConfigEvent(SearchCategoryConfigEvent event, Emitter<CategoryConfigState> emit) {
    _search();
    emit(CategoryConfigCommonState());
  }

}
