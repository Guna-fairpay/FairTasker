import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_change_dialog_event.dart';
part 'category_change_dialog_state.dart';

class CategoryChangeDialogBloc extends Bloc<CategoryDialogEvent, CategoryDialogState>{

  final APiRepository _apiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();

  List<dynamic> category =[];
  dynamic selectedCategory;
  List<dynamic> subCategories =[];
  dynamic selectedSubCategory;
  dynamic model;
  dynamic userId;

  Future<List<Map<String, dynamic>>> _getExpenseCategories({bool refresh = false}) async => await getIt<CommonService>().getExpenseCategories(reset: refresh);
  Future<Map<String, dynamic>?> _updateCategories({dynamic id, dynamic body}) async => await _apiRepository.expenseAddOrUpdateApi(body: body, expenseId: id);

  CategoryChangeDialogBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<CategoryDropdownEvent>(_onCategoryDropdownEvent);
    on<SubcategoryDropdownEvent>(_onSubcategoryDropdownEvent);
    on<NavigateSubcategoryEvent>(_onNavigateSubcategoryEvent);
    on<UpdateCategoryEvent>(_onUpdateCategoryEvent);
    on<RefreshEvent>(_onRefreshEvent);
    _registerBroadcast();
  }

  Future<void> _onInitialEvent(InitialEvent event, Emitter<CategoryDialogState> emit) async {
    try {
      model = event.data;
      userId = getIt<CommonService>().userId;
      category = await _getExpenseCategories();
      selectedCategory = category.firstWhereOrNull((element) => element['id'].toString() == model?['category_id'].toString(),);
      subCategories = List.from(selectedCategory?['sub_categories'] ?? []);
      selectedSubCategory = subCategories.firstWhereOrNull((element) => element['id'].toString() == model?['subcategory_id'].toString(),);
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onCategoryDropdownEvent(CategoryDropdownEvent event, Emitter<CategoryDialogState> emit){
    try {
      if(event.data == selectedCategory) return emit(CommonState());
      selectedCategory = event.data;
      subCategories = List.from(selectedCategory?['sub_categories'] ?? []);
      selectedSubCategory = {};
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onSubcategoryDropdownEvent(SubcategoryDropdownEvent event, Emitter<CategoryDialogState> emit){
    try {
      if(event.data == selectedSubCategory) return emit(CommonState());
      selectedSubCategory = event.data;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onNavigateSubcategoryEvent(NavigateSubcategoryEvent event, Emitter<CategoryDialogState> emit){
    try {
      emit(SubcategoryState(selectedCategory?['id']));
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onUpdateCategoryEvent(UpdateCategoryEvent event, Emitter<CategoryDialogState> emit) async {
    try {
      emit(LoadingState());
      var data = _updateCategorys(model);
      var response = await _updateCategories(body: data, id: model['id']);
      if(response != null){
        _broadcast.broadcast("expense_vehicle_refresh");
        emit(SuccessState(response['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onRefreshEvent(RefreshEvent event, Emitter<CategoryDialogState> emit) async {
    try {
      emit(LoadingState());
      category = await _getExpenseCategories(refresh: true);
      selectedCategory = category.firstWhereOrNull((element) => element['id'].toString() == selectedCategory?['id'].toString(),);
      subCategories = List.from(selectedCategory?['sub_categories'] ?? []);
      emit(CommonState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onError(dynamic error, Emitter<CategoryDialogState> emit){
    Console.of.error(error.toString());
    emit(ErrorState(error.toString()));
  }

  Map<String, String> _updateCategorys(dynamic expense){
    Map<String, String> baseBody = {};
    baseBody['approved'] ="${expense['approved']}";
    baseBody['category_id'] = "${selectedCategory?['id'] ?? expense['category_id']??''}";
    baseBody['cohort_id'] = "${expense["cohort_id"] ?? ''}";
    baseBody['employee_id'] = "$userId";
    baseBody['expense_amount'] = '${expense['expense_amount']??''}';
    baseBody['expense_date'] = '${expense['expense_date']??''}';
    baseBody['expense_description'] = '${expense['expense_description']??''}';
    baseBody['expense_to'] = "${selectedSubCategory?['expense_to'] ?? expense['expense_to'] ?? ''}";
    baseBody['odometer'] = "${expense['odometer'] ?? ''}";
    baseBody['payment_method_id'] = "${expense['payment_method_id'] ?? ''}";
    baseBody['platform'] = "TaskerApp";
    baseBody['subcategory_id'] = "${selectedSubCategory?['id'] ?? expense['subcategory_id'] ?? ''}";
    baseBody['vin'] = "${expense['vin'] ?? ''}";
    Console.of.log(jsonEncode(baseBody), name: "Expense_Body");
    return baseBody;
  }

  void _registerBroadcast() {
    _broadcast.register("category_refresh", (value, callback) {
      Console.of.log("category_refresh");
      add(RefreshEvent());
    });
    getIt<CommonService>().branchUpdate(callback: () => add(RefreshEvent()));
  }


}