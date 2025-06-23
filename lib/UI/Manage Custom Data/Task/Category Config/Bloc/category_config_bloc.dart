import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Category%20Config/Bloc/category_config_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Category%20Config/Bloc/category_config_state.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryConfigBloc extends Bloc<CategoryConfigEvent, CategoryConfigState>{

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode? autoValidateMode;
  final APiRepository _apiRepository = APiRepository();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> filteredResponse = [];
  List<Map<String, dynamic>> _unFilteredResponse = [];

  List<dynamic>category=[];
  List<dynamic>usersType=[
    {'id': 0, 'name': 'Select'},
    {'id': 1, 'name': 'Support Task'}
  ];

  dynamic selectedCategory;
  dynamic selectedUserType;
  dynamic selectedData;

  int itemsPerPage = 10;
  int currentIndex = 1;
  int totalCount = 0;
  int selectedTab = 0;

  bool isEdit = false;

  CategoryConfigBloc() : super(CategoryConfigLoadingState()){

    on<CategoryConfigInitialEvent>(_onCategoryConfigInitialEvent);
    on<SearchCategoryConfigEvent>(_onSearchCategoryConfigEvent);
    on<DeleteCategoryConfigEvent>(_onDeleteTaskEvent);
    on<SaveCategoryConfigEvent>(_onSaveTaskEvent);
    on<CategoryConfigPaginationEvent>(_onCategoryConfigPaginationEvent);
    on<EditCategoryConfigEvent>(_onEditCategoryConfigEvent);
    on<EditCloseEvent>(_onEditCloseEvent);
    on<CategoryDropDownEvent>(_onCategoryDropDownEvent);
    on<UserTypeDropDownEvent>(_onUserTypeDropDownEvent);

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
      selectedUserType = usersType.firstOrNull;
      filteredResponse.clear();
      _unFilteredResponse = apiResponse;
      filteredResponse = paginateList(
          data: _unFilteredResponse,
          currentPage: currentIndex,
          itemsPerPage: itemsPerPage);
      totalCount = _unFilteredResponse.length;
      emit(CategoryConfigCommonState());
    }catch(e){
      Toaster.showError(e.toString());
      emit(CategoryConfigCommonState());
    }
  }

  void _onSearchCategoryConfigEvent(SearchCategoryConfigEvent event, Emitter<CategoryConfigState> emit) {
    _search();
    emit(CategoryConfigCommonState());
  }

  void _onDeleteTaskEvent(DeleteCategoryConfigEvent event, Emitter<CategoryConfigState> emit) async {
    try{
      emit(CategoryConfigLoadingState());
       await _apiRepository.deleteCategoryConfigData(event.data['id']);
        apiResponse.removeWhere((element) => element['id'] == event.data['id']);
        totalCount = apiResponse.length;
        _unFilteredResponse = apiResponse;
        filteredResponse = paginateList(data: _unFilteredResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage);
        if(selectedData == event.data){
          nameController.clear();
          selectedCategory={};
          selectedUserType=usersType.first;
          isEdit = false;
          selectedData = null;
        }
        _search();
        emit(CategoryConfigCommonState());
     // }
    }catch(e){
      Toaster.showError(e.toString());
      emit(CategoryConfigCommonState());
    }
  }

  void _onSaveTaskEvent(SaveCategoryConfigEvent event, Emitter<CategoryConfigState> emit) async {
    autoValidateMode = AutovalidateMode.onUserInteraction;
    if (formKey.currentState?.validate() == false) return emit(CategoryConfigCommonState());
    try{
      autoValidateMode = null;
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

        nameController.clear();
        selectedCategory={};
        selectedUserType={};
        if (selectedData != null) {
          isEdit = false;
          selectedData = null;
          add(CategoryConfigInitialEvent());
        } else {
          add(CategoryConfigInitialEvent());
        }
      }
      else{
        Console.of.log(response,name: 'TESTCASE0');
        Toaster.showError(response?['message']);
        _search();
        emit(CategoryConfigCommonState());
      }
    }catch(e){
      Toaster.showError(e.toString());
      Console.of.log(e.toString(),name: 'TESTCASE1');
      _search();
      emit(CategoryConfigCommonState());
    }
  }

  void _onCategoryConfigPaginationEvent(CategoryConfigPaginationEvent event, Emitter<CategoryConfigState> emit) async {
    currentIndex = event.page;
    filteredResponse = paginateList(data: _unFilteredResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage);
    emit(CategoryConfigCommonState());
  }

  void _onEditCategoryConfigEvent(EditCategoryConfigEvent event, Emitter<CategoryConfigState> emit) async {
    isEdit = true;
    selectedData = event.data;
    selectedCategory={};
    nameController.text=event.data['name'];
    selectedCategory=category.firstWhereOrNull((element) => element['id'].toString()==event.data['parent_id'].toString());
    selectedUserType=usersType.firstWhere((element) => element['id'].toString()==event.data['todo_user_type'].toString());
    emit(CategoryConfigCommonState());
  }

  void _onEditCloseEvent(EditCloseEvent event, Emitter<CategoryConfigState> emit) async {
    autoValidateMode = null;
    isEdit = false;
    selectedData = {};
    nameController.clear();
    selectedCategory={};
    selectedUserType=usersType.firstOrNull;
    emit(CategoryConfigCommonState());
  }

  void _onCategoryDropDownEvent(CategoryDropDownEvent event, Emitter<CategoryConfigState> emit) {
    selectedCategory = event.data;
    emit(CategoryConfigCommonState());
  }

  void _onUserTypeDropDownEvent(UserTypeDropDownEvent event, Emitter<CategoryConfigState> emit) {
    selectedUserType = event.data;
    emit(CategoryConfigCommonState());
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
    _unFilteredResponse = filteredData;
    totalCount = filteredData.length;
    currentIndex=1;
    filteredResponse = paginateList(data: _unFilteredResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage,);
  }

}
