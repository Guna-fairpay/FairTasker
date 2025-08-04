import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_dialog_event.dart';
part 'category_dialog_state.dart';

class CategoryDialogBloc extends Bloc<CategoryDialogEvent, CategoryDialogState>{

  final APiRepository _apiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();

  List<dynamic> category =[];
  dynamic selectedCategory;
  List<dynamic> subCategories =[];
  dynamic selectedSubCategory;
  dynamic model;


  Future<List<Map<String, dynamic>>?> _getExpenseCategory() async => await getIt<CommonService>().expenseCategory();


  CategoryDialogBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<CategoryEvent>(_onCategoryEvent);
    on<SubCategoryEvent>(_onSubCategoryEvent);
    on<UpdateEvent>(_onUpdateEvent);
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<CategoryDialogState> emit) async {
    emit(LoadingState());
    model = event.model;
    var response = await _getExpenseCategory();
    category = List.from(response ?? []).where((g) => g['id'] == 76).toList();
    selectedCategory = category.firstWhereOrNull((r)=> r['id'].toString() == model?['category_id'].toString());
    subCategories = List.from(selectedCategory?['subcategories'] ?? []);
    subCategories.removeWhere((g) => g['id'] == 100,);
    subCategories.sort((a, b) => a['id'].compareTo(b['id']));
    selectedSubCategory = subCategories.firstWhereOrNull((r)=> r['id'].toString() == model?['subcategory_id'].toString());
    emit(CommonState());
  }

  Future<void> _onCategoryEvent(CategoryEvent event, Emitter<CategoryDialogState> emit) async {
    selectedCategory = event.selectedCategory;
    emit(CommonState());
  }

  Future<void> _onSubCategoryEvent(SubCategoryEvent event, Emitter<CategoryDialogState> emit) async {
    selectedSubCategory = event.selectedSubCategory;
    emit(CommonState());
  }

  Future<void> _onUpdateEvent(UpdateEvent event, Emitter<CategoryDialogState> emit) async {
    try {
      emit(LoadingState());
      var response = await _apiRepository.addOtherExpense(
        id: model['id'],
        body: _savePersonExpense(),
      );
      if(response?['data'] != null){
        _broadcast.broadcast("expense_person_refresh");
        emit(SuccessState(response?['message']));
      }else{
        emit(CommonState());
      }
    }catch (e){
      emit(ErrorState(e));
      Console.of.error(e);
    }
  }

  Map<String, dynamic> _savePersonExpense() {
    Map<String, dynamic> baseBody = {};
    baseBody['approved'] = model['approved'];
    baseBody['category_id'] = "${selectedCategory?['id'] ??''}";
    baseBody['cohort_id'] = null;
    baseBody['expense_amount'] = model['approved'];
    baseBody['expense_date'] =  model['expense_date'];
    baseBody['expense_description'] = model['expense_description'];
    baseBody['expense_to'] = "${selectedSubCategory?['expense_to'] ??''}";
    baseBody['payment_method_id'] = model['payment_method_id'];
    baseBody['platform'] = "TaskerApp";
    baseBody['subcategory_id'] = "${selectedSubCategory?['id'] ??''}";
    Console.of.log(jsonEncode(baseBody), name: "Expense_Body");
    return baseBody;
  }

}