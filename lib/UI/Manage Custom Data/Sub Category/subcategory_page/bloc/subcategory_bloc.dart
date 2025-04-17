import 'dart:async';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Sub%20Category/subcategory_page/bloc/subcategory_events.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Sub%20Category/subcategory_page/bloc/subcategory_states.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubCategoryBloc extends Bloc<SubCategoryEvent, SubCategoryState> {
  final APiRepository _aPiRepository = APiRepository();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  Map<String, dynamic>? selectedCategory, selectedExpenseTo;
  final Map<String, dynamic> _selectedCategory = {'id': 0, 'name': 'Select'}, _selectedExpenseTo = {'id': 0, 'expense_to': 'Select'};
  Map<String, dynamic>? selectedModel;
  List<Map<String, dynamic>> _apiResponse = [];
  List<Map<String, dynamic>> expenseTo = [];
  List<Map<String, dynamic>> subcategoriesList = []; // FROM SELECTED CATEGORY
  List<Map<String, dynamic>> filteredResponse = [];
  List<Map<String, dynamic>> mainCategories = [], _subCategories = [];
  int _totalCount = 0, itemsPerPage = 10, currentPage = 1;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  SubCategoryBloc() : super(SubCategoryLoadingState()) {
    on<SubCategoryInitialEvent>(_onInitialEvent);
    on<SubCategorySearchEvent>(_onSearchEvent);
    on<SubCategoryDeleteEvent>(_onDeleteEvent);
    on<SubCategoryDeleteTapEvent>(_onDeleteTapEvent);
    on<SubCategorySaveEvent>(_onSaveEvent);
    on<SubCategoryCancelEvent>(_onCancelEvent);
    on<SubCategoryEditEvent>(_onEditEvent);
    on<SubCategoryCategorySelectEvent>(_onCategorySelectEvent);
    on<SubCategoryExpenseToSelectEvent>(_onExpenseToSelectEvent);
    on<SubCategoryPageEvent>(_onPageEvent);
  }

  int get totalPages => (_totalCount / itemsPerPage).ceil();

  Future<Map<String, dynamic>?> _fetchCategories({dynamic id}) async => await _aPiRepository.getExpensesCategory(id: id);
  Future<Map<String, dynamic>?> _saveCategory() async => await _aPiRepository.saveExpensesCategory(name: nameController.text, expenseTo: selectedExpenseTo?['id'], parentId: selectedCategory?['id']);
  Future<Map<String, dynamic>?> _updateCategory() async => await _aPiRepository.updateExpensesCategory(name: nameController.text, expenseTo: selectedExpenseTo?['id'], parentId: selectedCategory?['id'], id: selectedModel?['id']);
  Future<Map<String, dynamic>?> _removeCategory(dynamic id) async => await _aPiRepository.deleteExpensesCategory(id: id);
  Future<List<Map<String, dynamic>>> _fetchCohorts() async => await getIt<CommonService>().getCohorts();

  void _onInitialEvent(SubCategoryInitialEvent event, Emitter<SubCategoryState> emit) async {
    try {
      emit(SubCategoryLoadingState());
      var response = await _fetchCategories();
      List<Map<String, dynamic>> coHorts = (await _fetchCohorts()).where((element) => List.from(element['expense_to']).isNotEmpty).map((e) => List<Map<String, dynamic>>.from(e['expense_to'])).expand((element) => element).toList();
      coHorts.sort((a, b) => a['id']?.compareTo(b['id']) ?? 0);
      expenseTo = coHorts;
      selectedExpenseTo = _selectedExpenseTo;
      selectedCategory = _selectedCategory;
      expenseTo.insert(0, selectedExpenseTo ?? _selectedExpenseTo);
      _apiResponse = List.from(response?['data'] ?? []);
      mainCategories = List.from(_apiResponse);
      mainCategories.insert(0, selectedCategory ?? _selectedCategory);
      _subCategories = _apiResponse.map((e) => List<Map<String, dynamic>>.from(e['subcategories'])).expand((element) => element).toList();
      _subCategories.sort((a, b) => b['id']?.compareTo(a['id']) ?? 0);
      _subCategories = _subCategories.map((e) => e..['categoryName'] = _apiResponse.firstWhere((element) => element['id'] == e['parent_id'])['name']).toList();
      _totalCount = _subCategories.length;
      filteredResponse = paginateList(data: _subCategories, currentPage: currentPage, itemsPerPage: itemsPerPage);
      emit(SubCategoryCommonState());
    } catch(e) {
      emit(SubCategoryErrorState(e));
    }
  }

  void _search() {
    var query = searchController.text.toLowerCase();
    if (query.trim().isNotNullOrEmpty) {
      filteredResponse = _subCategories.where((element) => (element['name'].toLowerCase().contains(query)) || (element['categoryName'].toLowerCase().contains(query))).toList();
    } else {
      filteredResponse = _subCategories;
    }
    _totalCount = filteredResponse.length;
    currentPage = 1;
    filteredResponse = paginateList(data: filteredResponse, currentPage: currentPage, itemsPerPage: itemsPerPage);
  }

  void _onSearchEvent(SubCategorySearchEvent event, Emitter<SubCategoryState> emit) {
    _search();
    emit(SubCategoryCommonState());
  }

  void _onDeleteEvent(SubCategoryDeleteEvent event, Emitter<SubCategoryState> emit) async {
    try {
      var model = event.model;
      emit(SubCategoryLoadingState());
      var response = await _removeCategory(model['id']);
      if (response != null) {
        if (selectedModel?['id'] == model['id']) _clearControllers();
        _subCategories.removeWhere((element) => element['id'] == model['id']);
        _totalCount = _subCategories.length;
        _search();
      }
      emit(SubCategoryCommonState());
    } catch (e) {
      emit(SubCategoryErrorState(e));
    }
  }

  void _onDeleteTapEvent(SubCategoryDeleteTapEvent event, Emitter<SubCategoryState> emit) {
    emit(SubCategoryShowDeleteDialogState(event.model));
  }

  void _onSaveEvent(SubCategorySaveEvent event, Emitter<SubCategoryState> emit) async {
    try {
      if (formKey.currentState?.validate() ?? false) {
        bool hasCategory = (selectedCategory?['id'] != 0);
        bool hasExpenseTo = (selectedExpenseTo?['id'] != 0);
        if (!hasExpenseTo || !hasCategory) {
          emit(SubCategoryErrorState( (!hasExpenseTo && !hasCategory) ?  "Select Category and Expense To" : (!hasExpenseTo) ? "Select Expense To" : "Select Category"));
          return;
        }
        emit(SubCategoryLoadingState());
        if (selectedModel == null) {
          // SAVE
          var response = await _saveCategory();
          if ((response != null) && (response['data'] != null) ) {
            Map<String, dynamic> data = response['data'];
            data['categoryName'] = selectedCategory?['name'];
            _subCategories.add(data);
          }
        } else {
          // UPDATE
          var response = await _updateCategory();
          if ((response != null) && (response['data'] != null)) {
            Map<String, dynamic> data = response['data'];
            data['categoryName'] = selectedCategory?['name'];
            _subCategories.removeWhere((element) => element['id'] == selectedModel?['id']);
            _subCategories.add(data);
          }
        }
      }
      _subCategories.sort((a, b) => b['id']?.compareTo(a['id']) ?? 0);
      _totalCount = _subCategories.length;
      filteredResponse = paginateList(data: _subCategories,
          currentPage: currentPage,
          itemsPerPage: itemsPerPage);
      _clearControllers();
      _search();
      emit(SubCategoryCommonState());
    } catch (e) {
      Console.of.error("Error Occurred", error: e);
      emit(SubCategoryErrorState(e));
    }
  }

  void _clearControllers() {
    selectedModel = null;
    nameController.clear();
    selectedCategory = _selectedCategory;
    selectedExpenseTo = _selectedExpenseTo;
    subcategoriesList = [];
  }

  void _onCancelEvent(SubCategoryCancelEvent event, Emitter<SubCategoryState> emit) {
    nameController.clear();
    selectedModel = null;
    selectedCategory = null;
    selectedExpenseTo = null;
    _search();
    emit(SubCategoryCommonState());
  }

  void _onEditEvent(SubCategoryEditEvent event, Emitter<SubCategoryState> emit) async {
    try {
      emit(SubCategoryLoadingState());
      var response = await _fetchCategories(id: event.model['id']);
      if ((response != null) && (response['data'] != null) && (response['data']['category'] != null)) {
        selectedModel = response['data']['category'];
        Console.of.log(selectedModel);
        nameController.text = selectedModel!['name'];
        selectedCategory =
            mainCategories.firstWhere((element) =>
            element['id'] ==
                selectedModel?['parent_id']);
        selectedExpenseTo = expenseTo.firstWhere((element) =>
        element['id'] ==
            selectedModel?['expense_to']);
      }
      emit(SubCategoryCommonState());
    } catch (e) {
      Console.of.error("Error Occurred", error: e);
      emit(SubCategoryErrorState(e));
    }
  }

  void _onCategorySelectEvent(SubCategoryCategorySelectEvent event, Emitter<SubCategoryState> emit) {
    selectedCategory = event.model;
    emit(SubCategoryCommonState());
  }

  void _onExpenseToSelectEvent(SubCategoryExpenseToSelectEvent event, Emitter<SubCategoryState> emit) {
    selectedExpenseTo = event.model;
    emit(SubCategoryCommonState());
  }

  void _onPageEvent(SubCategoryPageEvent event, Emitter<SubCategoryState> emit) {
    currentPage = event.page;
    filteredResponse = paginateList(data: _subCategories, currentPage: currentPage, itemsPerPage: itemsPerPage);
    emit(SubCategoryCommonState());
  }
}