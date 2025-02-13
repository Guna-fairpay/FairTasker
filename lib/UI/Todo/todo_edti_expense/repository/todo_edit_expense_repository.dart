
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../../../Response/expense_summary_response.dart';
import '../../../../Utilities/Str.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../data/api_client.dart';

class TodoEditExpenseRepository {
  ApiClient apiClient = ApiClient();

  Future<Map<String, dynamic>?> createExpense(
      int? expenseId,
      List<File>? files,
      int? categoryId,
      int? subCategoryId,
      int? paymentId,
      int? expenseTo,
      String? expenseAmount,
      String? expenseDescription,
      String? cohortId,
      String? vin,
      int? todoId,
      String? expenseDate,
      String? odometer) async {
    try {
      String apiUrl = '';
      if (expenseId != null) {
        apiUrl = "${Str.LIST_BASE_URL}expenses_update/$expenseId";
      } else {
        apiUrl = "${Str.LIST_BASE_URL}expenses";
      }
      debugPrint('createExpense.apiUrl: $apiUrl');
      Map<String, String> reqMap = {
        "category_id": "$categoryId",
        "subcategory_id": "$subCategoryId",
        "payment_method_id": "$paymentId",
        "expense_to": "$expenseTo",
        "expense_amount": "$expenseAmount",
        "expense_description": "$expenseDescription",
        "expense_date": expenseId != null
            ? "$expenseDate"
            : Utils.convertCurrentDateToStringFormat(DateTime.now()),
        "cohort_id": cohortId??'',
        "vin": vin ?? '',
        "odometer": odometer ?? '',
        "type": "inline",
        "platform": "TaskerApp"
      };
      debugPrint('createExpense.reqMap: $reqMap');
      var request = http.MultipartRequest("POST", Utils.getUri(apiUrl));
      request.headers.addAll(Utils.getHeaders());
      request.fields.addAll(reqMap);
      for (int i = 0; i < (files?.length ?? 0); i++) {
        var file = files![i];
        var multipartFile = http.MultipartFile.fromBytes(
          'files[$i]',
          (await file.readAsBytes()).toList(),
          filename: file.path.split('/').last,
        );
        request.files.add(multipartFile);
      }
      http.StreamedResponse streamedResponse = await request.send();
      debugPrint('createExpense.statusCode: ${streamedResponse.statusCode}');
      if (streamedResponse.statusCode == 200) {
        final http.Response response =
        await http.Response.fromStream(streamedResponse);
        return json.decode(response.body);
      } else {
        // Handle error response
        Utils.showSomethingWentWrong();
        return null;
      }
    } catch (error) {
      debugPrint('createExpenseData.exception : ${error.toString()}');
      return null;
    }
  }

  Future<ExpenseSummaryResponse?> getEditExpenseTodo(String? expenseId) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}expenses/$expenseId/edit";
      debugPrint("getAExpenseTodo apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        ExpenseSummaryResponse expenseSummaryResponse =
        ExpenseSummaryResponse.fromJson(json.decode(response.body));
        if (response.statusCode == 200 || response.statusCode == 201) {
          return expenseSummaryResponse;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getAExpenseTodo.exception : ${error.toString()}');
      return null;
    }
  }

}

