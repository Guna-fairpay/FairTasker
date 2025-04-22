import 'dart:async';

import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Categorys/category_page/bloc/category_events.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Categorys/category_page/bloc/category_states.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  List<Map<String, dynamic>> _apiResponse = [];
  final GlobalKey<FormState> formKey = GlobalKey();
  List<Map<String, dynamic>> filteredResponse = [];
  final APiRepository _aPiRepository = APiRepository();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final FBroadcast _fBroadcast = FBroadcast.instance();
  int currentPage = 1;
  int totalCount = 0;
  int itemsPerPage = 10;
  Map<String, dynamic>? selectedModel;
  CategoryBloc() : super(CategoryLoadingState()) {
   on<CategoryInitialEvent>(_onInitialEvent);
   on<CategoryPaginationEvent>(_onPaginationEvent);
   on<CategorySearchEvent>(_onSearchEvent);
   on<CategoryEditEvent>(_onEditEvent);
   on<CategoryDeleteEvent>(_onDeleteEvent);
   on<CategoryClearEvent>(_onClearEvent);
   on<CategorySaveEvent>(_onSaveEvent);
   on<CategoryDeleteTapEvent>(_onDeleteTapEvent);
  }

  int get totalPages => (totalCount / itemsPerPage).ceil();

  Future<Map<String, dynamic>?> _fetchCategories() async => await _aPiRepository.getExpensesCategory();
  Future<Map<String, dynamic>?> _saveCategory() async => await _aPiRepository.saveExpensesCategory(name: nameController.text);
  Future<Map<String, dynamic>?> _updateCategory() async => await _aPiRepository.updateExpensesCategory(name: nameController.text, id: selectedModel?['id']);
  Future<Map<String, dynamic>?> _deleteCategory(dynamic id) async => await _aPiRepository.deleteExpensesCategory(id: id);

  Future<void> _fetchCommonCate() async => await getIt<CommonService>().getExpenseCategories(reset: true);

  void _sortResponse() {
    _apiResponse.sort((a, b) => num.tryParse(b['id'].toString())?.compareTo(num.tryParse(a['id'].toString()) ?? 0) ?? 0);
  }

  void _onInitialEvent(CategoryInitialEvent event, Emitter<CategoryState> emit) async {
    try {
      emit(CategoryLoadingState());
      var response = await _fetchCategories();
      await _fetchCommonCate();
      _triggerBroadcast();
      _apiResponse = List.from(response?['data'] ?? []);
      _sortResponse();
      filteredResponse = paginateList(data: _apiResponse, currentPage: currentPage, itemsPerPage: itemsPerPage);
      totalCount = _apiResponse.length;
      emit(CategoryCommonState());
    } catch (e) {
      emit(CategoryErrorState(e));
    }
  }

  void _onPaginationEvent(CategoryPaginationEvent event, Emitter<CategoryState> emit) {
    currentPage = event.page;
    filteredResponse = paginateList(data: _apiResponse, currentPage: currentPage, itemsPerPage: itemsPerPage);
    emit(CategoryCommonState());
  }

  void _search() {
    var query = searchController.text.toLowerCase();
    List<Map<String, dynamic>> filteredData = [];
    if (query.trim().isNotNullOrEmpty) {
      filteredData = _apiResponse.where((element) => element['name'].toString().toLowerCase().contains(query)).toList();
    } else {
      filteredData = _apiResponse;
    }
    currentPage = 1;
    totalCount = filteredData.length;
    filteredResponse = paginateList(data: filteredData, currentPage: currentPage, itemsPerPage: itemsPerPage);
  }

  void _onSearchEvent(CategorySearchEvent event, Emitter<CategoryState> emit) {
    _search();
    emit(CategoryCommonState());
  }

  void _onEditEvent(CategoryEditEvent event, Emitter<CategoryState> emit) {
    selectedModel = event.model;
    nameController.text = (selectedModel?['name'] ?? "");
    emit(CategoryCommonState());
  }

  void _onDeleteEvent(CategoryDeleteEvent event, Emitter<CategoryState> emit) async {
    try {
      emit(CategoryLoadingState());
      Map<String, dynamic> model = event.model;
      var response = await _deleteCategory(model['id']);
      await _fetchCommonCate();
      _triggerBroadcast();
      if (response != null) {
        _apiResponse.removeWhere((element) => element['id'] == model['id']);
        totalCount = _apiResponse.length;
        if (selectedModel?['id'] == model['id']) _clearControllers();
        _sortResponse();
        _search();
      }
      emit(CategoryCommonState());
    } catch (e) {
      emit(CategoryErrorState(e));
    }
  }

  void _onClearEvent(CategoryClearEvent event, Emitter<CategoryState> emit) {
    selectedModel = null;
    nameController.clear();
    _search();
    emit(CategoryCommonState());
  }

  void _clearControllers() {
    selectedModel = null;
    nameController.clear();
  }

  void _onSaveEvent(CategorySaveEvent event, Emitter<CategoryState> emit) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    try {
      emit(CategoryLoadingState());
      if (selectedModel == null) {
        // SAVE
        var response = await _saveCategory();
        if ((response != null) && (response['data'] != null)) {
          _clearControllers();
          _apiResponse.add(response['data']);
          totalCount = _apiResponse.length;
          _sortResponse();
          _search();
        }
      } else {
        // UPDATE
        var response = await _updateCategory();
        if ((response != null) && (response['data'] != null)) {
          _clearControllers();
          _apiResponse = _apiResponse.map((e) {
           if (e['id'] == response['data']?['id']) {
             return e..['name'] = response['data']?['name'];
           } else {
             return e;
           }
          }).toList();
          totalCount = _apiResponse.length;
          _sortResponse();
          _search();
        }
      }
      await _fetchCommonCate();
      _triggerBroadcast();
      emit(CategoryCommonState());
    } catch (e) {
      emit(CategoryErrorState(e));
    }
  }

  void _triggerBroadcast() => _fBroadcast.broadcast(Str.refetchCate);

  void _onDeleteTapEvent(CategoryDeleteTapEvent event, Emitter<CategoryState> emit) => emit(CategoryDeleteTapState(event.model));
}