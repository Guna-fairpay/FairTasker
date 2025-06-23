
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'category_filter_event.dart';
part 'category_filter_state.dart';

class CategoryFilterBloc extends Bloc<CategoryFilterEvent, CategoryFilterState>{

  bool isAll = false;
  List<Map<String, dynamic>> popupFilterData = [];

  CategoryFilterBloc() : super(CategoryFilterCommonState()) {
    on<CategoryFilterInitialEvent>(_onCategoryFilterInitialEvent);
    on<CategoryFilterSelectAllEvent>(_onSelectAllEvent);
    on<CategoryFilterSelectCategoryEvent>(_onSelectCategoryEvent);
    on<CategoryFilterSelectSubCategoryEvent>(_onSelectSubCategoryEvent);
  }

  Future<void> _onCategoryFilterInitialEvent(CategoryFilterInitialEvent event, Emitter<CategoryFilterState> emit) async {
    try {
      popupFilterData = transformCategoryData(data: event.expenseDetails,idList:  event.idList);
      popupFilterData.sort((a, b) => a['category_name'].compareTo(b['category_name']));
      isAll = (popupFilterData.where((element) => List.from(element['sub_category'] ?? []).map((e) => e['checked']).contains(false)).isEmpty);
      Console.of.log(popupFilterData.toString());
      emit(CategoryFilterCommonState());
    } catch (e) {
      _error(e.toString());
      emit(CategoryFilterCommonState());
    }
  }

  Future<void> _onSelectAllEvent(CategoryFilterSelectAllEvent event, Emitter<CategoryFilterState> emit) async{
    try {
      isAll = !isAll;
      if (isAll) {
        popupFilterData.forEach((element) {
          element['sub_category'].forEach((e) {
            e['checked'] = true;
          });
        });
      } else {
        popupFilterData.forEach((element) {
          element['sub_category'].forEach((e) {
            e['checked'] = false;
          });
        });
      }
      var data = popupFilterData.where((element) => List.from(element['sub_category'] ?? []).map((e) => e['checked']).contains(true)).toList();
      emit(OnchangeState(value: data));
    } catch (e) {
      _error(e.toString());
      emit(CategoryFilterCommonState());
    }
  }

  Future<void> _onSelectCategoryEvent(CategoryFilterSelectCategoryEvent event, Emitter<CategoryFilterState> emit) async{
    try {
      var categoryValue = event.model;
      for (var element in popupFilterData) {
        if (element['id'] == categoryValue['id']) {
          for (var e in (element['sub_category'] ?? [])) {
            e['checked'] = event.value;
          }
        }
      }
      if(popupFilterData.where(
              (element) => List.from(element['sub_category'] ?? []).map(
                  (e) => e['checked']).contains(false)).isEmpty){
        isAll = true;
      }else{
        isAll = false;
      }
      var data = popupFilterData.where((element) => List.from(element['sub_category'] ?? []).map((e) => e['checked']).contains(true)).toList();
      emit(OnchangeState(value: data));
    } catch (e) {
      _error(e.toString());
      emit(CategoryFilterCommonState());
    }
  }

  Future<void> _onSelectSubCategoryEvent(CategoryFilterSelectSubCategoryEvent event, Emitter<CategoryFilterState> emit) async{
    try {
      var subCategoryValue = event.model;
      for (var element in popupFilterData) {
        if (List.from(element['sub_category'] ?? []).map((e) => e['id']).contains(subCategoryValue['id'])) {
          for (var e in (element['sub_category'] ?? [])) {
            if (e['id'] == subCategoryValue['id']) e['checked'] = !e['checked'];
          }
        }
      }
      if(popupFilterData.where(
              (element) => List.from(element['sub_category'] ?? []).map(
                      (e) => e['checked']).contains(false)).isEmpty){
        isAll = true;
      }else{
        isAll = false;
      }
      var data = popupFilterData.where((element) => List.from(element['sub_category'] ?? []).map((e) => e['checked']).contains(true)).toList();
      emit(OnchangeState(value: data));
    } catch (e) {
      _error(e.toString());
      emit(CategoryFilterCommonState());
    }
  }

  List<Map<String, dynamic>> transformCategoryData({List<Map<String, dynamic>>? data, dynamic idList}) {
    List<Map<String, dynamic>> categories = List<Map<String, dynamic>>.from(data ?? []).map((e) => Map<String, dynamic>.from(e['category'] ?? {})).toList();
    List<Map<String, dynamic>> subcategories = List<Map<String, dynamic>>.from(data ?? []).map((e) => Map<String, dynamic>.from(e['subcategory'] ?? {})).toList();
    List<Map<String, dynamic>> result = categories.map((cat) {
      int catId = cat['id'];
      List<Map<String, dynamic>> matchedSub = subcategories
          .where((sub) => sub['parent_id'].toString() == catId.toString()).toList().distinct((element) => element['id']);
      return {
        "category_name": cat['name'],
        "id": cat['id'],
        "sub_category": matchedSub.map((e) => e..putIfAbsent("checked", () => (idList?['sub_categories']).toString().contains(e['id'].toString()) ? true : false)),
      };
    }).toList();
    result = result.distinct((element) => element['id']);
    return result;
  }

  void _error(String message){
    Console.of.error(message);
    Toaster.showError(message);
  }

}
