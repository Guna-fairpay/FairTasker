import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/Bloc/expense_details_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/Bloc/expense_details_state.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
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
  List<Map<String, dynamic>> apiResponse = [];
  List<Map<String, dynamic>> usersList = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController rmSearchController = TextEditingController();
  dynamic expenseAmount;
  dynamic rmExpenseAmount;

  ExpenseDetailsBloc() : super(ExpenseDetailsLoadingState()) {
    on<ExpenseDetailsInitialEvent>((event, emit) async {
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
        filteredExpenseDetails = expenseDetails;
        filteredRmExpenseDetails = rmExpenseDetails;
        expenseAmount = expenseDetails
            .map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0)
            .sum;
        rmExpenseAmount = rmExpenseDetails
            .map((e) => num.tryParse(e['expense_amount'].toString()) ?? 0)
            .sum;
        log(expenseDetails.length.toString(),
            name: "ExpenseDetailsInitialEvent");
        emit(ExpenseDetailsLoadedState());
      } catch (e) {
        emit(ExpenseDetailsErrorState(e.toString()));
        log(e.toString(), name: "ExpenseDetailsErrorState");
      }
      emit(ExpenseDetailsLoadedState());
    });

    on<SearchExpenseEvent>((event, emit) {
      var searchQuery = event.query;
      filteredExpenseDetails = filterExpenses(expenseDetails, searchQuery);
      emit(ExpenseDetailsCommonState());
    });

    on<SearchRmExpenseEvent>((event, emit) {
      var searchQuery = event.query;
      filteredRmExpenseDetails = filterExpenses(rmExpenseDetails, searchQuery);
      emit(ExpenseDetailsCommonState());
    });

  }

  ///EDIT VEHICLE EXPENSE DETAILS API CALL
  Future<Map<String, dynamic>?> _getEditVehicleExpenseDetails(
          {String? vin}) async =>
      await _apiRepository.getEditVehicleExpenseDetails(vin: vin);

  List<Map<String, dynamic>> cohortList(List<Map<String, dynamic>> apiResponse) {
    return apiResponse.map((item) {
      item['cohortName'] = (item['expense_to'] == 4)
          ? item['cohort']['cohort']??''
          : item['expense_to_data']['expense_to'] ?? '';
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


}
