import 'dart:async';

import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Sub%20Category/subcategory_page/bloc/subcategory_events.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Sub%20Category/subcategory_page/bloc/subcategory_states.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubCategoryBloc extends Bloc<SubCategoryEvent, SubCategoryState> {
  final APiRepository _aPiRepository = APiRepository();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  Map<String, dynamic>? selectedCategory, selectedSubCategory;
  Map<String, dynamic>? selectedModel;
  List<Map<String, dynamic>> _apiResponse = [];
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
    on<SubCategorySubCategorySelectEvent>(_onSubCategorySelectEvent);
    on<SubCategoryPageEvent>(_onPageEvent);
  }

  int get totalPages => (_totalCount / itemsPerPage).ceil();

  Future<Map<String, dynamic>?> _fetchCategories() async => await _aPiRepository.getExpensesCategory();

  void _onInitialEvent(SubCategoryInitialEvent event, Emitter<SubCategoryState> emit) async {
    try {
      emit(SubCategoryLoadingState());
      var response = await _fetchCategories();
      _apiResponse = List.from(response?['data'] ?? []);
      mainCategories = _apiResponse;
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

  void _onSearchEvent(SubCategorySearchEvent event, Emitter<SubCategoryState> emit) {
    var query = event.query?.toLowerCase();
    if (query?.trim().isNotNullOrEmpty ?? false) {
      filteredResponse = _subCategories.where((element) => (element['name'].toLowerCase().contains(query)) || (element['categoryName'].toLowerCase().contains(query))).toList();
    } else {
      filteredResponse = _subCategories;
    }
    _totalCount = filteredResponse.length;
    currentPage = 1;
    filteredResponse = paginateList(data: filteredResponse, currentPage: currentPage, itemsPerPage: itemsPerPage);
    emit(SubCategoryCommonState());
  }

  void _onDeleteEvent(SubCategoryDeleteEvent event, Emitter<SubCategoryState> emit) {
    var model = event.model;
    _subCategories.removeWhere((element) => element['id'] == model['id']);
    _totalCount = _subCategories.length;
    filteredResponse = paginateList(data: _subCategories, currentPage: currentPage, itemsPerPage: itemsPerPage);
    emit(SubCategoryCommonState());
  }

  void _onDeleteTapEvent(SubCategoryDeleteTapEvent event, Emitter<SubCategoryState> emit) {
    emit(SubCategoryShowDeleteDialogState(event.model));
  }

  void _onSaveEvent(SubCategorySaveEvent event, Emitter<SubCategoryState> emit) {
    if (formKey.currentState?.validate() ?? false) {

    }
  }

  void _onCancelEvent(SubCategoryCancelEvent event, Emitter<SubCategoryState> emit) {
    nameController.clear();
    selectedModel = null;
    selectedCategory = null;
    selectedSubCategory = null;
    subcategoriesList = [];
    emit(SubCategoryCommonState());
  }

  void _onEditEvent(SubCategoryEditEvent event, Emitter<SubCategoryState> emit) {
    selectedModel = event.model;
    nameController.text = selectedModel!['name'];
    emit(SubCategoryCommonState());
  }

  void _onCategorySelectEvent(SubCategoryCategorySelectEvent event, Emitter<SubCategoryState> emit) {
    selectedCategory = event.model;
    emit(SubCategoryCommonState());
  }

  void _onSubCategorySelectEvent(SubCategorySubCategorySelectEvent event, Emitter<SubCategoryState> emit) {
    selectedSubCategory = event.model;
    emit(SubCategoryCommonState());
  }

  void _onPageEvent(SubCategoryPageEvent event, Emitter<SubCategoryState> emit) {
    currentPage = event.page;
    filteredResponse = paginateList(data: _subCategories, currentPage: currentPage, itemsPerPage: itemsPerPage);
    emit(SubCategoryCommonState());
  }
}