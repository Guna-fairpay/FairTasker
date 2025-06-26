import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'expense_summery_event.dart';
part 'expense_summery_state.dart';

class ExpenseSummeryBloc extends Bloc<ExpenseSummeryEvent, ExpenseSummeryState>{

  final APiRepository apiRepository = APiRepository();
  final FBroadcast _broadcast = FBroadcast.instance();

  List<dynamic>? expenseData;
  List<dynamic> cohortData = [];
  List<dynamic> vehicleList = [];
  List<dynamic> categoryList = [];
  List<dynamic> subCategoryList = [];
  List<dynamic> cohort = [];
  List<dynamic> expenseTo = [
    {"id" : 1, "name" : "FairPY"},
    {"id" : 4, "name" : "Cohort"},
  ];
  dynamic selectedExpenseTo;
  dynamic selectedCategory;
  dynamic selectedSubCategory;
  double fairPYTotal = 0.0;
  double cohortTotal = 0.0;
  dynamic title;
  dynamic total;
  dynamic saveData;
  dynamic vehicleModel;

  bool isCohort = false;
  bool isFairPY = false;

  Future<List<Map<String, dynamic>>> _getExpenseSummeryData() async => await getIt<CommonService>().getExpenseCategories();
  Future<List<Map<String, dynamic>>> _getCohorts() async => await getIt<CommonService>().getCohorts();

  ExpenseSummeryBloc() : super(LoadingState()){
    on<InitialEvent>(_onInitialEvent);
    on<VehicleListingEvent>(_onVehicleListingEvent);
    on<CohortAndCategoryEvent>(_onCohortAndCategoryEvent);
    on<CategoryEvent>(_onCategoryEvent);
    on<SubCategoryEvent>(_onSubCategoryEvent);
    on<ExpenseToEvent>(_onExpenseToEvent);
    on<SaveEvent>(_onSaveEvent);
    on<VehicleRefreshEvent>(_onVehicleRefreshEvent);
    on<ExpenseEditEvent>(_onExpenseEditEvent);
    _broadcast.register("expense_vehicle_refresh", (value, callback){
      add(InitialEvent(value));
      add(VehicleRefreshEvent());
    } );
  }
  Future<void> _onInitialEvent(InitialEvent event, Emitter<ExpenseSummeryState> emit) async {
    try {
      expenseData = event.model;
      cohort = await _getCohorts();
      expenseData?.forEach((element) {
        if(element['expense_to'] == 1){
          fairPYTotal += element['expense_amount'];
        }else{
          cohortTotal += element['expense_amount'];
        }
      });

      for (var data in (expenseData ?? [])) {
        Map<String, dynamic>? cohort = {
          'cohort_id': data['cohort']?['id'],
          'cohort_name': data['cohort']?['cohort'],
          'fairPY_amount': 0.0,
          'cohort_amount': 0.0,
        };
        bool exists = cohortData.any((e) => e['cohort_id'] == cohort['cohort_id']);
        if (!exists) {
          cohortData.add(cohort);
        }
          if(data['expense_to'] == 1){
            cohortData.firstWhere((e) => e['cohort_id'] == cohort['cohort_id'])['fairPY_amount'] += data['expense_amount'];
          }else{
          if(data['expense_to'] != 0) cohortData.firstWhere((e) => e['cohort_id'] == cohort['cohort_id'])['cohort_amount'] += data['expense_amount'];
          }
      }
      cohortData.sort((a, b) => a['cohort_id'].compareTo(b['cohort_id']));
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onVehicleListingEvent(VehicleListingEvent event, Emitter<ExpenseSummeryState> emit){
    try {
      vehicleModel = event.model;
      isCohort = event.isCohort ?? false;
      isFairPY = event.isFairPY ?? false;
      fetchVehicle();
      emit(VehicleListingState(vehicleList));
    } catch (e) {
      _onError(e, emit);
    }
  }

  Future<void> _onCohortAndCategoryEvent(CohortAndCategoryEvent event, Emitter<ExpenseSummeryState> emit) async {
    try {
      var response = await _getExpenseSummeryData();
      saveData = event.model;
      selectedCategory = null;
      selectedSubCategory = null;
      selectedExpenseTo = null;
      categoryList = response;
      selectedCategory = categoryList.firstWhereOrNull((element) => element['id'].toString() == event.model?['category_id'].toString());
      subCategoryList = List.from(selectedCategory?['sub_categories'] ?? []);
      selectedSubCategory = subCategoryList.firstWhereOrNull((element) => element['id'].toString() == event.model?['subcategory_id'].toString());
      selectedExpenseTo = expenseTo.firstWhereOrNull((element) => element['id'] == event.model?['expense_to']);
      emit(CohortAndCategoryState());
    }catch(e){
      _onError(e, emit);
    }
  }

  void _onCategoryEvent(CategoryEvent event, Emitter<ExpenseSummeryState> emit){
    try {
      selectedCategory = event.model;
      subCategoryList = List.from(selectedCategory?['sub_categories'] ?? []);
      selectedSubCategory = null;
      selectedExpenseTo = null;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onSubCategoryEvent(SubCategoryEvent event, Emitter<ExpenseSummeryState> emit){
    try {
      selectedSubCategory = event.model;
      selectedExpenseTo = expenseTo.firstWhereOrNull((element) => element['id'] == event.model?['expense_to']);
      emit(CommonState());
      } catch (e) {
      _onError(e, emit);
    }
  }

  void _onExpenseToEvent(ExpenseToEvent event, Emitter<ExpenseSummeryState> emit){
    try {
      selectedExpenseTo = event.model;
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onSaveEvent(SaveEvent event, Emitter<ExpenseSummeryState> emit) async {
    try{
      emit(LoadingState());
      var response = await apiRepository.expenseAddOrUpdateApi(
          expenseId: "${saveData?['id']}",
          body: await _updateCategorys(saveData));
      if(response?['data'] != null){
        var data = List.from(response?['data']).first;
        expenseData?.forEach((element) {
          if (element['id'] == data['id']) {
            element['cohort_id'] = data['cohort_id'];
            element['category_id'] = data['category_id'];
            element['subcategory_id'] = data['subcategory_id'];
            element['expense_to'] = data['expense_to'];
            element['cohort']?['id'] = data['cohort_id'];
            element['cohort']?['cohort'] = cohort.firstWhereOrNull((e) => e['id'] == data['cohort_id'])['cohort'];
            element['category']?['id'] = data['category_id'];
            element['category']?['name'] = selectedCategory['name'];
            element['subcategory']?['id'] = data['subcategory_id'];
            element['subcategory']?['name'] = selectedSubCategory['name'];
          }
        });
        _broadcast.broadcast("expense_vehicle_refresh", value: expenseData);
        emit(SuccessState(response?['message']));
      }else{
        emit(ErrorState(response?['message']));
      }
    }catch(e){
    _onError(e, emit);
    }
  }

  void _onVehicleRefreshEvent(VehicleRefreshEvent event, Emitter<ExpenseSummeryState> emit){
    try {
      fetchVehicle();
      emit(CommonState());
    } catch (e) {
      _onError(e, emit);
    }
  }

  void _onExpenseEditEvent(ExpenseEditEvent event, Emitter<ExpenseSummeryState> emit){
    try {
      emit(ExpenseEditState(event.model));
    }catch(e){
      _onError(e, emit);
    }
  }

  Future<Map<String, String>> _updateCategorys(dynamic expense) async {
    Map<String, String> baseBody = {};
    baseBody['approved'] ="${expense['approved']}";
    baseBody['category_id'] = "${selectedCategory?['id'] ?? ''}";
    baseBody['cohort_id'] = "${expense["cohort_id"] ?? ''}";
    baseBody['employee_id'] = "${getIt<CommonService>().userId}";
    baseBody['expense_amount'] = '${expense['expense_amount']??''}';
    baseBody['expense_date'] = '${expense['expense_date']??''}';
    baseBody['expense_description'] = '${expense['expense_description']??''}';
    baseBody['expense_to'] = "${selectedExpenseTo?['id'] ?? ''}";
    baseBody['odometer'] = "${expense['odometer'] ?? ''}";
    baseBody['payment_method_id'] = "${expense['payment_method_id'] ?? ''}";
    baseBody['platform'] = "TaskerApp";
    baseBody['subcategory_id'] = "${selectedSubCategory?['id'] ?? ''}";
    baseBody['vin'] = "${expense['vin'] ?? ''}";
    Console.of.log(jsonEncode(baseBody), name: "Expense_Body");
    return baseBody;
  }

  void _onError(dynamic error, Emitter<ExpenseSummeryState> emit){
    Console.of.log(error);
    emit(ErrorState(error));
  }

  void fetchVehicle(){
    title = "${vehicleModel?['cohort_name']} / ${isFairPY ? 'FairPY' : 'Cohort'}";
    if(isFairPY){
      vehicleList.clear();
      vehicleList = expenseData?.where((element) => element['expense_to'] == 1 && element['cohort_id'] == vehicleModel?['cohort_id']).toList() ?? [];
    }
    if(isCohort){
      vehicleList.clear();
      vehicleList = expenseData?.where((element) => (element['expense_to'] != 1) && element['cohort']?['id'] == vehicleModel?['cohort_id']).toList() ?? [];
    }
    for (var element in vehicleList) {
      element['attachments_paths'] = element['attachments'].map((e) => e['path'].toString().toStorageURL).toList();
    }
    vehicleList.sort((a, b) => b['created_at'].compareTo(a['created_at']));
    total = vehicleList
        .map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0)
        .sum;
  }

}