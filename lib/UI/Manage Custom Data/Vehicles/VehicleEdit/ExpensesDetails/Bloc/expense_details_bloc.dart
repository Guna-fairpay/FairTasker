import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/Bloc/expense_details_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/Bloc/expense_details_state.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseDetailsBloc
    extends Bloc<ExpenseDetailsEvent, ExpenseDetailsState> {
  final APiRepository _apiRepository = APiRepository();
  List<Map<String, dynamic>> expenseDetails = [];
  List<Map<String, dynamic>> filteredExpenseDetails = [];
  List<Map<String, dynamic>> rmExpenseDetails = [];/// Repair And Maintenance Details
  List<Map<String, dynamic>> filteredRmExpenseDetails = [];
  List<Map<String, dynamic>> _filtered = [];
  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> usersList = [];
  Map<String, dynamic> idList = {};
  TextEditingController searchController = TextEditingController();
  TextEditingController rmSearchController = TextEditingController();
  dynamic expenseAmount;
  dynamic rmExpenseAmount;

  ExpenseDetailsBloc() : super(ExpenseDetailsLoadingState()) {
    on<ExpenseDetailsInitialEvent>(_onExpenseDetailsInitialEvent);
    on<SearchExpenseEvent>(_onSearchExpenseEvent);
    on<SearchRmExpenseEvent>(_onSearchRmExpenseEvent);
    on<FilterCategoryEvent>(_onFilterCategoryEvent);

  }

  Future<void> _onExpenseDetailsInitialEvent(
      ExpenseDetailsInitialEvent event, Emitter<ExpenseDetailsState> emit) async {
      try {
        emit(ExpenseDetailsLoadingState());
        var editVehicleExpenseDetailsResponse =
        await _getEditVehicleExpenseDetails(vin: event.vin);
        var usersList = await getIt<CommonService>().getUsers();

        apiResponse = List.from(editVehicleExpenseDetailsResponse?['data']);
        apiResponse = employeeNames(apiResponse, usersList);
        apiResponse = cohortList(apiResponse);

        expenseDetails = apiResponse
            .where((element) =>
        element['category']['id'].toString() != '1' &&
            element['category']['id'].toString() != "18")
            .toList();
        rmExpenseDetails = apiResponse
            .where((element) =>
        element['category']['id'].toString() == "1" ||
            element['category']['id'].toString() == "18")
            .toList();
        _filtered = expenseDetails;
        filteredExpenseDetails = _filtered;
        filteredRmExpenseDetails = rmExpenseDetails;
        expenseAmount = expenseDetails
            .map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0)
            .sum;
        rmExpenseAmount = rmExpenseDetails
            .map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0)
            .sum;
        idFinder(filteredExpenseDetails);
        // var categoryIds = filteredExpenseDetails.map((e) => e['category']['id']).toList();
        // var subCategoryIds = filteredExpenseDetails.map((e) => e['subcategory']['id']).toList();
        // idList["categories"] = categoryIds;
        // idList["sub_categories"] = subCategoryIds;
        emit(ExpenseDetailsLoadedState());
      } catch (e) {
        emit(ExpenseDetailsErrorState(e.toString()));
        log(e.toString(), name: "ExpenseDetailsErrorState");
      }
      emit(ExpenseDetailsLoadedState());
  }

  Future<void> _onSearchExpenseEvent(SearchExpenseEvent event, Emitter<ExpenseDetailsState> emit) async{
    var searchQuery = event.query;
    _filtered = filterExpenses(expenseDetails, searchQuery);
    filteredExpenseDetails = _filtered;
    emit(ExpenseDetailsCommonState());
  }

  Future<void> _onSearchRmExpenseEvent(SearchRmExpenseEvent event, Emitter<ExpenseDetailsState> emit) async{
    var searchQuery = event.query;
    filteredRmExpenseDetails = filterExpenses(rmExpenseDetails, searchQuery);
    emit(ExpenseDetailsCommonState());
  }

  Future<void> _onFilterCategoryEvent(FilterCategoryEvent event, Emitter<ExpenseDetailsState> emit) async{
    try {
      var categoryValue = event.categoryValue;
      var catId = categoryValue?.map((e) => e['id'],).toList();
      var subId = categoryValue?.map((e) => e['sub_category']).expand((element) => element).where((element) => (element['checked'] == true)).map((e) => e['id']).toList();
      Console.of.log("CATE: $catId , SUBCATEGORY: $subId", name: "FilterCategoryEvent");
      var filterValue =  _filtered.where((element) =>
      (catId?.contains(element['category']['id']) ?? false) &&
          (subId?.contains(element['subcategory']['id']) ?? false)).toList();
      filteredExpenseDetails = filterValue;
      idFinder(filteredExpenseDetails);
      Console.of.log("CATE: $catId , SUBCATEGORY: $subId", name: "FilterCategoryEvent");
      emit(ExpenseDetailsCommonState());
    } catch (e) {
      Toaster.showError(e.toString());
      emit(ExpenseDetailsCommonState());
    }
  }



  ///EDIT VEHICLE EXPENSE DETAILS API CALL
  Future<Map<String, dynamic>?> _getEditVehicleExpenseDetails(
          {String? vin}) async =>
      await _apiRepository.getEditVehicleExpenseDetails(vin: vin);

  List<Map<String, dynamic>> cohortList(List<Map<String, dynamic>> apiResponse) {
    return apiResponse.map((item) {
      item['cohortName'] = (item['expense_to'] == 4)
          ? (item['cohort']?['cohort'] ?? '')
          : ((item['expense_to_data']?['expense_to']) ?? '');
      return item;
    }).toList();
  }

  List<Map<String, dynamic>> employeeNames(
      List<Map<String, dynamic>> apiResponse,
      List<Map<String, dynamic>> usersList) {
    return apiResponse = apiResponse.map((e) {
      e.putIfAbsent("employee_name", () {
        var user = usersList.firstWhere(
          (element) => element['id'] == e['employee_id'],
          orElse: () => {},
        );
        return List<String>.from(
            [user['first_name'] ?? "", user['last_name'] ?? ""]).toInitial;
      });
      return e;
    }).toList();
  }

  List<Map<String, dynamic>> filterExpenses(
      List<Map<String, dynamic>> expenseDetails, String searchQuery) {
    if (searchQuery.isEmpty) return expenseDetails;
    return expenseDetails.where((element) {
      final query = searchQuery.toLowerCase();
      return (element['expense_to_data']?['expense_to']?.toString().toLowerCase() ?? '')
          .contains(query) ||
          (element['cohortName']?.toString().toLowerCase() ?? '').contains(query) ||
          (element['category']?['name']?.toString().toLowerCase() ?? '').contains(query) ||
          (element['subcategory']?['name']?.toString().toLowerCase() ?? '').contains(query) ||
          element['expense_amount'].toString().contains(query);
    }).toList();
  }

  Map<String, dynamic> idFinder(List<Map<String, dynamic>> data,){
    var categoryIds = data.map((e) => e['category']['id']).toList();
    var subCategoryIds = data.map((e) => e['subcategory']['id']).toList();
    idList["categories"] = categoryIds;
    idList["sub_categories"] = subCategoryIds;
    return idList;
  }

}
