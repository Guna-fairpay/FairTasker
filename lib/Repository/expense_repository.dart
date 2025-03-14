//
// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:fairpytasker/Response/expense_other_response.dart';
// import 'package:fairpytasker/Response/Response.dart';
// import 'package:http/http.dart' as http;
// import 'package:fairpytasker/Utilities/str.dart';
// import 'package:fairpytasker/Utilities/utils.dart';
// import 'package:fairpytasker/data/api_client.dart';
// import 'package:flutter/cupertino.dart';
//
// import '../Response/categories_response.dart';
// import '../Response/expense_other_categories.dart';
// import '../Response/expense_other_payments.dart';
// import '../Response/expense_person_response.dart';
//
//
// class ExpenseRepository {
//   ApiClient apiClient = ApiClient();
//
//   Future<ExpenseResponse?> getExpense(String? minDate,String? maxDate ) async {
//     try {
//       String apiUrl = "${Str.LIST_BASE_URL}expenses/all?minDate=$minDate&maxDate=$maxDate&platformCustom=TaskerApp";
//       debugPrint("getExpenses apiUrl: $apiUrl");
//
//       final http.Response? response = await apiClient.callGetMethod(apiUrl);
//       if (response != null) {
//         if (response.statusCode == 200) {
//           ExpenseResponse expenseResponse =
//           ExpenseResponse.fromJson(json.decode(response.body));
//
//           return expenseResponse; // Return departmentResponse here
//         } else {
//           Utils.showNoResultFound();
//           return null;
//         }
//       } else {
//         return null;
//       }
//     } catch (error) {
//       log('getExpense.exception : ${error.toString()}');
//       return null;
//     }
//   }
//
//   Future<ExpenseResponse?> createExpenseData(
//       int? id,
//       String? vehicleId,
//       String? expenseAmount,
//       String? paymentMethodId,
//       String? expenseDescription,
//       String? categoryId,
//       String? subcategoryId,
//       String? expenseTo,
//       String? expenseDate,
//       String? odometer,
//       ) async {
//     try {
//       String body = jsonEncode({
//         "vehicle_id":vehicleId,
//         "expense_amount": expenseAmount,
//         "payment_method_id": paymentMethodId,
//         "expense_description": expenseDescription,
//         "category_id": categoryId,
//         "subcategory_id": subcategoryId,
//         "expense_to": expenseAmount,
//         "expense_date": expenseAmount,
//         "odometer": odometer,
//         "platform": "TaskerApp",
//         "status": "1"
//       });
//
//       String apiUrl = '';
//       http.Response? response;
//       if(id != null) {
//         apiUrl = "${Str.LIST_BASE_URL}expenses_update/$id";
//         debugPrint("getAssignedTo apiUrl: $apiUrl");
//         response = await apiClient.callPostMethod(apiUrl, body: body);
//       }else{
//         apiUrl = "${Str.LIST_BASE_URL}expenses";
//         debugPrint("getAssignedTo apiUrl: $apiUrl");
//         response = await apiClient.callPostMethod(apiUrl, body: body);
//       }
//       if (response != null) {
//         ExpenseResponse expenseResponse =
//         ExpenseResponse.fromJson(json.decode(response.body));
//         if (response.statusCode == 200) {
//           return expenseResponse;
//         } else {
//           return expenseResponse;
//         }
//       } else {
//         return null;
//       }
//     } catch (error) {
//       log('department.exception : ${error.toString()}');
//       return null;
//     }
//   }
//
//   Future<ExpenseResponse?> deleteExpense(String? id) async {
//     try {
//       String apiUrl = "${Str.LIST_BASE_URL}expenses/$id";
//
//       final http.Response? response = await apiClient.callDelete(apiUrl);
//
//       if (response != null) {
//         ExpenseResponse expenseResponse =
//         ExpenseResponse.fromJson(json.decode(response.body));
//
//         if (response.statusCode == 200) {
//           return expenseResponse;
//         } else {
//           return expenseResponse;
//         }
//       } else {
//         return null;
//       }
//     } catch (error) {
//       log('expense.exception : ${error.toString()}');
//       return null;
//     }
//   }
//
//   //----------------------------------------------------------
//
//   Future<ExpensePersonResponse?> getExpensePersonData(String minDate, String maxDate) async {
//     final String apiUrl = '${Str.LIST_BASE_URL}ajaxPersonExpense';
//     final Map<String, String> payload = {
//       'minDate': minDate,
//       'maxDate': maxDate,
//       'platformCustom': 'tasker-web',
//     };
//
//     try {
//       final http.Response? response = await apiClient.callPostMethod(apiUrl, body: jsonEncode(payload),);
//
//       if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
//         return ExpensePersonResponse.fromJson(json.decode(response.body));
//       } else {
//         Utils.showSomethingWentWrong();
//         return null;
//       }
//     } catch (e) {
//       log('Error in getExpensePersonData: $e');
//       return null;
//     }
//   }
//
//   Future<ExpenseOtherResponse?> getExpenseOtherData(String minDate, String maxDate) async {
//     const String apiUrl = '${Str.LIST_BASE_URL}ajaxOtherExpense';
//     final Map<String, String> payload = {
//       'minDate': minDate,
//       'maxDate': maxDate,
//     };
//
//     try {
//       final http.Response? response = await apiClient.callPostMethod(apiUrl, body: jsonEncode(payload),);
//
//       if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
//         return ExpenseOtherResponse.fromJson(json.decode(response.body));
//       } else {
//         Utils.showSomethingWentWrong();
//         return null;
//       }
//     } catch (e) {
//       log('Error in getExpensePersonData: $e');
//       return null;
//     }
//   }
//
//   Future<ExpensePayments?> getExpensePayments() async {
//     try {
//       String apiUrl = "${Str.LIST_BASE_URL}payment-methods";
//       debugPrint("getCategories apiUrl: $apiUrl");
//       final http.Response? response =
//       await apiClient.callGetMethod(apiUrl, );
//       if (response != null) {
//         ExpensePayments expensePayments =
//         ExpensePayments.fromJson(json.decode(response.body));
//         if (response.statusCode == 200 || response.statusCode == 201) {
//           return expensePayments;
//         }else {
//           Utils.showNoResultFound();
//           debugPrint('getCategories response.statusCode: ${response.statusCode}');
//           return null;
//         }
//       } else {
//         return null;
//       }
//     } catch (error) {
//       log('getCategories.exception : ${error.toString()}');
//       return null;
//     }
//   }
//
//
//   Future<ExpenseCategories?> getExpenseCategories() async {
//     try {
//       String apiUrl = "${Str.LIST_BASE_URL}expenses_category";
//       debugPrint("getCategories apiUrl: $apiUrl");
//       final http.Response? response =
//       await apiClient.callGetMethod(apiUrl, );
//       if (response != null) {
//         ExpenseCategories expenseCategories =
//         ExpenseCategories.fromJson(json.decode(response.body));
//         if (response.statusCode == 200 || response.statusCode == 201) {
//           return expenseCategories;
//         }else {
//           Utils.showNoResultFound();
//           debugPrint('getCategories response.statusCode: ${response.statusCode}');
//           return null;
//         }
//         /*  } else {
//           Utils.showSomethingWentWrong();
//           return null;
//         }*/
//       } else {
//         return null;
//       }
//     } catch (error) {
//       log('getCategories.exception : ${error.toString()}');
//       return null;
//     }
//   }
//
//
//   Future<ExpenseOtherResponse?> createOtherData(
//     int? id,
//     int? approved,
//     String? expenseDate,
//     double? expenseAmount,
//     String? categoryId,
//     String? subcategoryId,
//     String? expenseDescription,) async {
//     try {
//       // Construct the API URL
//       String apiUrl = id != null
//           ? "${Str.LIST_BASE_URL}storeOtherExpense/$id"
//           : "${Str.LIST_BASE_URL}storeOtherExpense";
//
//       // Build the request body
//       Map<String, dynamic> body = {
//         "id": id,
//         "approved": approved,
//         "expense_amount": expenseAmount ?? 0.0,
//         "expense_description": expenseDescription ?? '',
//         "category_id": categoryId ?? '',
//         "subcategory_id": subcategoryId ?? '',
//         "expense_date": expenseDate ?? '',
//       };
//
//       debugPrint("API URL: $apiUrl");
//       debugPrint("Request Body: ${jsonEncode(body)}");
//
//       // Make the API call
//       http.Response? response = await apiClient.callPostMethod(apiUrl, body: jsonEncode(body));
//
//       // Handle the response
//       if (response != null) {
//         debugPrint("Response Status: ${response.statusCode}");
//         debugPrint("Response Body: ${response.body}");
//         print("Response Body: ${response.body}");
//
//         if (response.statusCode == 200) {
//           return ExpenseOtherResponse.fromJson(json.decode(response.body));
//         } else {
//           log("Error: ${response.body}");
//           return ExpenseOtherResponse.fromJson(json.decode(response.body)); // Optional: Return partial error response
//         }
//       } else {
//         log("Error: No response from server");
//         return null;
//       }
//     } catch (error, stacktrace) {
//       log("Exception: ${error.toString()}", stackTrace: stacktrace);
//       return null;
//     }
//
//
//   }
// }
//
