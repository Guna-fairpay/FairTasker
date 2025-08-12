import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'subcategory_dialog_state.dart';
part 'subcategory_dialog_event.dart';

class SubcategoryDialogBloc extends Bloc<SubcategoryDialogEvent, SubcategoryDialogState>{

  final APiRepository _apiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController subCategoryController = TextEditingController();

  List<dynamic> expenseTo =[];

  dynamic selectedExpenseTo;
  dynamic categoryId;

  Future<Map<String,dynamic>?> _getSubCategoryExpenseTo() async => await _apiRepository.getExpenseTo();
  Future<Map<String,dynamic>?> _addSubCategory({dynamic body}) async => await _apiRepository.addSubCategory(body: body);

  SubcategoryDialogBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<ExpenseToDropdownEvent>(_onExpenseToDropdownEvent);
    on<SaveSubcategoryEvent>(_onSaveSubcategoryEvent);
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<SubcategoryDialogState> emit) async {
    try {
      emit(LoadingState());
      categoryId = event.data;
      Console.of.log(categoryId);
      var response = await _getSubCategoryExpenseTo();
      expenseTo = response?['expenseTo'];
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onExpenseToDropdownEvent(ExpenseToDropdownEvent event, Emitter<SubcategoryDialogState> emit){
    try {
      selectedExpenseTo = event.data;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onSaveSubcategoryEvent(SaveSubcategoryEvent event, Emitter<SubcategoryDialogState> emit) async {
    try {
      if (formKey.currentState?.validate() == false) return emit(CommonState());
      emit(LoadingState());
      var response = await _addSubCategory(body: baseBody());
      if(response != null){
        _broadcast.broadcast("category_refresh");
        emit(SuccessState(response['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onError(e, Emitter<SubcategoryDialogState> emit){
    Console.of.log(e);
    emit(ErrorState(e.toString()));
  }

  Map<String, dynamic> baseBody(){
    Map<String, dynamic> body = {};
    body['name'] = subCategoryController.text;
    body['expense_to'] = selectedExpenseTo?['id'];
    body['parent_id'] = categoryId;
    body['platform'] = "tasker-app";
    Console.of.log(body);
    return body;
  }
}