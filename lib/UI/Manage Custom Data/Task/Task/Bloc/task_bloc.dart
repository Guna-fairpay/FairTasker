
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Task/Bloc/task_state.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState>{

  final APiRepository _apiRepository = APiRepository();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController taskController = TextEditingController();
  final TextEditingController timeTakenController = TextEditingController();
  AutovalidateMode autoValidateMode = AutovalidateMode.onUserInteraction;
  final FBroadcast _broadcast = FBroadcast.instance();

  List<Map<String, dynamic>> apiResponse = [];
  // List<Map<String, dynamic>> noCategoryResponse = [];
  List<Map<String, dynamic>> _unfilteredResponse = [];
  List<Map<String, dynamic>> filteredResponse = [];
  List<dynamic> get category => getIt<CommonService>().expenseCategoriesList;
  List<dynamic> get subcategory => List.from(category.firstWhereOrNull((element) => element['id'] == selectedCategory?['id'])?['sub_categories'] ?? []);
  List<dynamic>listSubcategory=[];
  List<dynamic>usersType=[{'id': 0, 'name': 'Select'}, {'id': 1, 'name': 'Support Task'}];
  dynamic selectedCategory;
  dynamic selectedSubCategory;
  dynamic selectedUserType;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int itemsPerPage = 10;
  int currentIndex = 1;
  int totalCount = 0;
  bool noCategory = false;
  bool isEdit = false;
  bool isEnable = true;
  dynamic selectedData;
  int selectedTab = 0;

  TaskBloc() : super(TaskLoadingState()){

    on<TaskInitialEvent>(_onTaskInitialEvent);

    on<TaskPaginationEvent>((event, emit) {
      currentIndex = event.page;
      _paginate();
      emit(TaskCommonState());
    });

    on<NoCategoryEvent>((event, emit) {
      noCategory = !noCategory;
      List<Map<String, dynamic>> result = [];
      if(noCategory){
        result = apiResponse.where((element) => element['subcategory_id'].toString().isNullOrEmpty).toList();
      }else{
        result = apiResponse.where((element) => element['subcategory_id'].toString().isNotNullOrEmpty).toList();
      }
      currentIndex = 1;
      totalCount = result.length;
      _unfilteredResponse = result;
      _paginate();
      emit(TaskCommonState());
    });

    on<EditTaskEvent>((event, emit) {
      isEdit = true;
      selectedData = event.data;
      taskController.text = "${event.data['task']??''}";
      timeTakenController.text = "${event.data['time_taken']??''}";
      selectedCategory={};
      selectedSubCategory={};
      selectedCategory=category.firstWhereOrNull((element) => element['id'].toString()==event.data['category_id'].toString());
      // subcategory=selectedCategory?['sub_categories']??[];
      selectedSubCategory=subcategory.firstWhereOrNull((element) => element['id'].toString()==event.data['subcategory_id'].toString());
      selectedUserType=usersType.firstWhere((element) => element['id'].toString()==event.data['user_type'].toString());
      emit(TaskCommonState());
    });

    on<EditCloseEvent>(_onEditCloseEvent);

    on<CategoryDropDownEvent>((event, emit) {
      selectedCategory = event.data;
      // subcategory=[];
      selectedSubCategory={};
      // subcategory=event.data['sub_categories'];
      emit(TaskCommonState());
    });

    on<SubcategoryDropDownEvent>((event, emit) {
      selectedSubCategory = event.data;
      emit(TaskCommonState());
    });

    on<UserTypeDropDownEvent>((event, emit) {
      selectedUserType = event.data;
      emit(TaskCommonState());
    });

    on<DeleteTaskEvent>(_onDeleteTaskEvent);
    on<SearchTaskEvent>(_onSearchEvent);
    on<SaveTaskEvent>(_onSaveTaskEvent);
    on<ListCategoryDropDownSelectionEvent>(_onListCategoryDropDownSelectionEvent);
    on<ListSubCategoryDropDownSelectionEvent>(_onListSubCategoryDropDownSelectionEvent);
    on<TaskTabChangeEvent>(_onTabChangeEvent);

  }

  List<Map<String, dynamic>> get noCategoryResponse {
    List<Map<String, dynamic>> result = [];
    if(noCategory){
      result = apiResponse.where((element) => element['subcategory_id'].toString().isNullOrEmpty).toList();
    }else{
      result = apiResponse.where((element) => element['subcategory_id'].toString().isNotNullOrEmpty).toList();
    }
    return result;
  }

  void _paginate() {
    filteredResponse = paginateList(data: _unfilteredResponse, currentPage: currentIndex, itemsPerPage: itemsPerPage);
  }

  void _onDeleteTaskEvent(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try{
      emit(TaskLoadingState());
      var response = await _apiRepository.deleteTaskExpensesData(event.data['id']);
      List<Map<String, dynamic>> result = [];
      if(response?['message']!=null){
        apiResponse.removeWhere((element) => element['id'] == event.data['id']);
        if(noCategory){
          result = apiResponse.where((element) => element['subcategory_id'].toString().isNullOrEmpty).toList();
        }else{
          result = apiResponse.where((element) => element['subcategory_id'].toString().isNotNullOrEmpty).toList();
        }
        totalCount = result.length;
        _unfilteredResponse = result;
        _paginate();
        Toaster.showSuccess(response?['message']);
        isEdit = false;
        selectedData = null;
        taskController.clear();
        timeTakenController.text = '30';
        selectedCategory={};
        selectedSubCategory = {};
        selectedUserType= usersType.first;
        _search();
        _broadcast.broadcast(Str.addToDoRefresh);
        _broadcast.broadcast(Str.editToDoRefresh);
        emit(TaskCommonState());
      }
    }catch(e){
      Toaster.showError(e.toString());
      _search();
      emit(TaskCommonState());
    }
  }

  Future<void> _onSaveTaskEvent(SaveTaskEvent event, Emitter<TaskState> emit) async {
    // if (formKey.currentState?.validate() == false) return;
    if(taskController.text.isEmpty) return Toaster.showError('Task field is required');
    try{
      emit(TaskLoadingState());
        var data = {
          'category_id': "${selectedCategory?['id']??''}",
          'subcategory_id': "${selectedSubCategory?['id']??''}",
          'task':taskController.text,
          'time_taken':timeTakenController.text,
          'user_type': "${selectedUserType?['id']??''}",
          'platform':'tasker-app'
        };
      Console.of.log(data);
        var response = await _apiRepository.taskAddOrUpdate(body: data,id: selectedData?['id']);
        /*var taskResponse= */await getIt<CommonService>().getTaskExpenseData(reset: true);
      if (response?["data"] != null) {
        final newData = response?["data"];
        taskController.clear();
        timeTakenController.text = '30';
        selectedCategory={};
        selectedSubCategory={};
        selectedUserType= usersType.first;
        //formKey.currentState?.reset();
       /* selectedData = null;
        isEdit = false;*/
        if (selectedData != null) {
          selectedData = null;
          isEdit = false;
          apiResponse.removeWhere((e) => e['id'] == newData['id']);
          apiResponse.add(newData);
        } else {
          apiResponse.add(newData);
        }
        //apiResponse=taskResponse;
        apiResponse.sort((a, b) => b['id'].compareTo(a['id']));
        final List<Map<String, dynamic>> result = noCategory
            ? apiResponse.where((e) => e['subcategory_id'].toString().isNullOrEmpty).toList()
            : apiResponse.where((e) => e['subcategory_id'].toString().isNotNullOrEmpty).toList();
        totalCount = result.length;
        _unfilteredResponse = result;
        _paginate();
        Toaster.showSuccess(response?['message']);
        _search();
        _broadcast.broadcast(Str.addToDoRefresh);
        _broadcast.broadcast(Str.editToDoRefresh);
        emit(TaskCommonState());
      }
      else{
          Console.of.log(response,name: 'TESTCASE0');
          Toaster.showError(response);
          _search();
          emit(TaskCommonState());
        }
    }catch(e){
      Toaster.showError(e.toString());
      Console.of.log(e.toString(),name: 'TESTCASE1');
      _search();
      emit(TaskCommonState());
    }
  }

  void _onEditCloseEvent(EditCloseEvent event, Emitter<TaskState> emit) {
    isEdit = false;
    isEnable = false;
    selectedData = {};
    taskController.clear();
    timeTakenController.text = '30';
    selectedCategory={};
    selectedSubCategory={};
    selectedUserType= usersType.first;
    emit(TaskCommonState());
  }

  void _onTaskInitialEvent(TaskInitialEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoadingState());
    Console.of.log(event.title);
    if(event.title != null){
      taskController.text=event.title.toString();
    }
    var response= await getIt<CommonService>().getTaskExpenseData(reset: true);
    var categories = await getIt<CommonService>().getExpenseCategories();
    // category=List.from(categories);
    response.removeWhere((element) => element['deleted_at'].toString().isNotNullOrEmpty);
    response.sort((a, b) => b['id'].compareTo(a['id']));
    selectedUserType = usersType[0];
    apiResponse =List.from(response);
    timeTakenController.text='30';
    _unfilteredResponse = noCategoryResponse;
    _paginate();
    totalCount = noCategoryResponse.length;
    emit(TaskCommonState());
  }

  Future<void> _onListCategoryDropDownSelectionEvent(ListCategoryDropDownSelectionEvent event, Emitter<TaskState> emit) async {
    var itemModel = event.listModel;
    var dropDown = event.dropDownData;
    itemModel['category_id'] = dropDown['id'];
    itemModel['subcategory_id'] = null;
    _search();
    emit(TaskCommonState());
    var data={
      'category_id': "${itemModel['category_id']}",
      'subcategory_id': "${null}",
      'task': "${itemModel['task']}",
      'time_taken': "${itemModel['time_taken']}",
      'user_type': "${itemModel['user_type']}",
      'platform':'tasker-app',
    };
    var response = await _apiRepository.taskAddOrUpdate(body: data,id: itemModel['id']);
    // emit(TaskCommonState());
  }

  Future<void> _onListSubCategoryDropDownSelectionEvent(ListSubCategoryDropDownSelectionEvent event, Emitter<TaskState> emit) async {
    Console.of.debug(event.dropDownData);
    Console.of.debug(event.listModel);
    var itemModel = event.listModel;
    var dropDown = event.dropDownData;
    itemModel['subcategory_id'] = dropDown['id'];
    _search();
    emit(TaskCommonState());
    var data={
      'category_id': "${itemModel['category_id']}",
      'subcategory_id': "${itemModel['subcategory_id']}",
      'task': "${itemModel['task']}",
      'time_taken': "${itemModel['time_taken']}",
      'user_type': "${itemModel['user_type']}",
      'platform':'tasker-app'};
    var response = await _apiRepository.taskAddOrUpdate(body:data,id: itemModel['id']);
    // emit(TaskCommonState());
  }

  void _onTabChangeEvent(TaskTabChangeEvent event, Emitter<TaskState> emit) {
    selectedTab = event.tabIndex;
    _search();
    emit(TaskCommonState());
  }

  void _search(){
    var query = searchController.text.toLowerCase();
    List<Map<String, dynamic>> filteredData = [];

    if (query.trim().isNotNullOrEmpty) {
      filteredData = apiResponse.where((element) {
        return [
          element['task'],
          element['category_name'],
          element['subcategory_name'],
        ].any((value) => value?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    } else {
      filteredData = noCategoryResponse;
    }
    currentIndex=1;
    totalCount = filteredData.length;
    _unfilteredResponse = filteredData;
    _paginate();
  }

  void _onSearchEvent(SearchTaskEvent event, Emitter<TaskState> emit) {
    _search();
    emit(TaskCommonState());
  }


}
