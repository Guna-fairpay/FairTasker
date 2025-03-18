import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fairpytasker/Response/assigned_to_response.dart';
import 'package:fairpytasker/Response/general_response.dart';
import 'package:fairpytasker/Response/user_group_response.dart';
import 'package:fairpytasker/Response/vehicle_history_response.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/response_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/file_saver.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import '../Response/subcategories_response.dart';
import '../UI/Finance/Expense/Response/expense_response.dart';
import '../UI/Vehicle/vehicle_expense_history/response/vehicle_expense_history_response.dart';
import '../Utilities/Utils.dart';
import '../Utilities/str.dart' show Str;

class APiRepository {
  final ApiClient _apiClient = ApiClient();

  String get _searchHistoryApi => "get-vehicle-search-history";

  String get _editToDoApi => "edit-todo";

  String get _updateToDoApi => "update-todo";

  String get _resourcesApi => "getresources";

  String get _groupPersonApi => "group-person";

  String get _completeToDoApi => "complete-todo";

  String get _deleteToDoApi => "delete-todo";

  String get _vehicleCategoriesApi => "vehicle_status/categories";

  String get _vehicleStatusApi => "vehicleStatusApi";

  String get _getCohortsApi => "getCohortsData";

  String get _turoVehiclesList => "getTuroVehiclesList";

  String get _generateInvoiceApi => "generate-invoice";

  String get _updateTodoExpense => "expenses_update";

  String get _expenses => "expenses";

  String get _deleteVehicles => "delete-vehicles";

  String get _getVehicleExpense => "getVehicleExpenses";

  String get _deleteExpenseImage => "expense_attachment";

  String get _deleteExpenseTodo => "delete-expense-todo";

  String get _miscellaneousVehicles => "vehicle_config/miscellaneous_vehicles";

  String get _saveNote => "vehicle_status/save_note/";

  String get _createStatusToDo => "create-status-todo";

  String get _users => "user-list";

  String get _vehicleStatusCheck => "vehicle_status_checklist_api/";

  String get _updateStatusToDo => "update-status-todo";

  String get _getFilter => "getFilter";

  String get _saveFilter => "saveFilter";

  String get _expenseApprove => "expense-approval";

  String get _locations => "locations";

  String get _getBranch => "getBranch";

  String get _vendors => "vendors";

  String get _vehiclePartsList => "vehicle-parts-list";

  String get _vehicleSupplies => "vehicle-supplies";

  String get _taskCategoryGroup => "taskCategoryGroup";

  String get _getToDoList => "todo-data";

  String get _groupVehicle => "group-vehicle";

  String get _activeVehicles => "active_vehicles";

  String get _saveBouncieVehicle => "save-bouncie-vehicle";

  String get _taskExpenseData => "task-expenses-data";

  String get _getWorkingHoursByUser => "getWorkingHourByUser";

  String get _userPunchList => "userPunchList";

  String get _expensesCategory => "expenses_category";

  String get _paymentType => "payment-methods";

  int? get _branchId => Session.of.getInt(Str.branchIdPrefText);

  String? get _userId => Session.of.getString(Str.userIdPrefText);

  Future<VehicleHistoryResponse?> getVehicleHistoryList(String vin,
      {int? currentPage, int itemsPerPage = 5, String? search}) async {
    try {
      String apiUrl = '${Str.BASE_URL}$_searchHistoryApi';
      final Map<String, dynamic> map = {};
      map['page'] = currentPage;
      map['vin'] = vin;
      if (search?.isNotEmpty ?? false) map['search'] = search;
      map['itemsPerPage'] = itemsPerPage;
      map.removeWhere((key, value) => value == null);
      final http.Response? response =
          await _apiClient.callGetMethod(apiUrl, params: map);
      var mapData = await response.mapData;
      return VehicleHistoryResponse.fromJson(mapData ?? {});
    } on Exception {
      rethrow;
    }
  }

  Future<AssignedToResponse?> getResourcesList() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_resourcesApi";
      final http.Response? response = await _apiClient.callGetMethod(
        apiUrl,
      );
      var mapData = await response.mapData;
      return (mapData != null) ? AssignedToResponse.fromJson(mapData) : null;
    } catch (error) {
      rethrow;
    }
  }

  Future<UserGroupResponse?> getGroupPersonList() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_groupPersonApi";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return (mapData != null) ? UserGroupResponse.fromJson(mapData) : null;
    } catch (error) {
      rethrow;
    }
  }

  Future<GeneralResponse?> completeToDo(dynamic todoId,
      {bool status = true}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_completeToDoApi/$todoId";
      final Map<String, dynamic> map = {};
      map['status'] = status;
      final http.Response? response =
          await _apiClient.callPostMethod(apiUrl, body: jsonEncode(map));
      var mapData = await response.mapData;
      return GeneralResponse.fromJson(mapData);
    } catch (error) {
      rethrow;
    }
  }

  Future<GeneralResponse?> deleteToDo(dynamic todoId, dynamic reason) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_deleteToDoApi/$todoId";
      final Map<String, dynamic> map = {};
      map['reason'] = reason;
      final http.Response? response =
          await _apiClient.callDelete(apiUrl, body: map);
      var mapData = await response.mapData;
      return GeneralResponse.fromJson(mapData);
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> editToDo(dynamic todoId) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_editToDoApi/$todoId";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getVehicleCategories() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vehicleCategoriesApi";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getVehicleStatus(dynamic statusId,
      {dynamic cohortId}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vehicleStatusApi";
      Map<String, dynamic> params = {};
      if (statusId != null && statusId != 0 && statusId != "0")
        params['vehicle_status'] = statusId;
      if (cohortId != null && cohortId != 0 && cohortId != "0")
        params['cohort_id'] = cohortId;
      params['branch_code'] = Session.of.getInt(Str.branchIdPrefText);
      final http.Response? response =
          await _apiClient.callGetMethod(apiUrl, params: params);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getCohorts() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_getCohortsApi";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getTuroVehiclesList() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_turoVehiclesList";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateToDoApi(
      {Map<String, dynamic>? body, List<File>? images, String? todoId}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_updateToDoApi/$todoId";
      final http.Response? response = await _apiClient.callPostMethodWithBody(
          apiUrl,
          body: body?..putIfAbsent('type', () => "inline"),
          files: images?.map((e) => e.path).toList(),
          fieldName: "files",
          autoIncrement: true);
      if (response != null) {
        if (response.isSuccess) {
          var mapData = await response.mapData;
          Toaster.showSuccess(
              mapData?['message'] ?? "Todo Updated Successfully");
          return mapData;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('callLoginAPI.exception2 : ${error.toString()}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateTodoExpense(
      {Map<String, dynamic>? body,
      List<File>? images,
      String? expenseId}) async {
    try {
      String apiUrl = '';
      if (expenseId != null) {
        apiUrl = "${Str.LIST_BASE_URL}$_updateTodoExpense/$expenseId";
      } else {
        apiUrl = "${Str.LIST_BASE_URL}$_expenses";
      }
      final http.Response? response = await _apiClient.callPostMethodWithBody(
          apiUrl,
          body: body?..putIfAbsent('type', () => "inline"),
          autoIncrement: true,
          fieldName: "files",
          files: images?.map((e) => e.path).toList());
      if (response != null) {
        if (response.isSuccess) {
          var mapData = await response.mapData;
          Toaster.showSuccess(
              mapData?['message'] ?? "Todo Updated Successfully");
          return mapData;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('callLoginAPI.exception2 : ${error.toString()}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> generateInvoice(
      {Map<String, String>? body}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_generateInvoiceApi";
      final http.Response? response =
          await _apiClient.callPostMethod(apiUrl, body: jsonEncode(body));
      if (response != null) {

        if (response.isSuccess) {
          var path = await FileSaver.instance.saveFile(response);
          Toaster.showSuccess("Invoice Generated Successfully $path");
          return {'message': path};
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('callInvoiceAPI.exception : ${error.toString()}');
      return null;
    }
  }

  Future<GeneralResponse?> deleteTodoVehicle({String? id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_deleteVehicles/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return GeneralResponse.fromJson(mapData);
    } catch (error) {
      rethrow;
    }
  }

  Future<VehicleExpenseHistoryResponse?> getVehicleExpense(
      {String? vin}) async {
    try {
      String apiUrl = '${Str.LIST_BASE_URL}$_getVehicleExpense/$vin';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return (mapData != null)
          ? VehicleExpenseHistoryResponse.fromJson(mapData)
          : null;
    } catch (error) {
      rethrow;
    }
  }

  Future<VehicleExpenseHistoryResponse?> getEditVehicleExpense(
      {String? id}) async {
    try {
      String apiUrl = '${Str.LIST_BASE_URL}$_expenses/$id/edit';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return (mapData != null)
          ? VehicleExpenseHistoryResponse.fromJson(mapData)
          : null;
    } catch (error) {
      rethrow;
    }
  }

  Future<GeneralResponse?> deleteVehicleExpenseImage(
    dynamic todoVehicleId,
  ) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_deleteExpenseImage/$todoVehicleId";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return GeneralResponse.fromJson(mapData);
    } catch (error) {
      rethrow;
    }
  }

  Future<GeneralResponse?> deleteVehicleExpense(
    dynamic vehicleExpenseId,
  ) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_expenses/$vehicleExpenseId";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return GeneralResponse.fromJson(mapData);
    } catch (error) {
      rethrow;
    }
  }

  Future<GeneralResponse?> deleteExpenseTodo(
    dynamic todoVehicleId,
  ) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_deleteExpenseTodo";
      final http.Response? response = await _apiClient.callPostMethod(apiUrl,
          body: jsonEncode({
            'todo_id': '$todoVehicleId',
          }));
      var mapData = await response.mapData;
      return GeneralResponse.fromJson(mapData);
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateVehicleExpenseHistory(
      {Map<String, dynamic>? body,
      List<File>? images,
      String? expenseId}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_updateTodoExpense/$expenseId";
      log("${images?.length}", name: "updateVehicleExpenseHistory");
      final http.Response? response = await _apiClient.callPostMethodWithBody(
          apiUrl,
          body: body,
          autoIncrement: true,
          fieldName: "files",
          files: images?.map((e) => e.path).toList());
      if (response != null) {
        if (response.isSuccess) {
          var mapData = await response.mapData;
          Toaster.showSuccess(
              mapData?['message'] ?? "Todo Updated Successfully");
          return mapData;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('callLoginAPI.exception2 : ${error.toString()}');
      return null;
    }
  }

  Future<GeneralResponse?> deleteTodo({String? id, dynamic reason}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_deleteToDoApi/$id";
      final http.Response? response = await _apiClient.callPostMethod(apiUrl,
          body: jsonEncode({
            'reason': '$reason',
          }));
      var mapData = await response.mapData;
      return GeneralResponse.fromJson(mapData);
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getMiscellaneousVehicles() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_miscellaneousVehicles";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> saveNote(
      {required dynamic vin, required DateTime? date}) async {
    try {
      if ((vin.toString().isNullOrEmpty) || (date == null))
        throw Exception(
            (vin.toString().isNullOrEmpty) ? "Invalid VIN" : "Invalid Date");
      String apiUrl = "${Str.LIST_BASE_URL}$_saveNote$vin";
      Map<String, dynamic> body = {
        "followup_date": date.toFormat(format: "yyyy-MM-dd") ?? ""
      };
      final http.Response? response =
          await _apiClient.callPostMethod(apiUrl, body: jsonEncode(body));
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> createStatusToDo(
      {required Map<String, dynamic> body}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_createStatusToDo";
      final http.Response? response =
          await _apiClient.callPostMethod(apiUrl, body: jsonEncode(body));
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUsers() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_users";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> vehicleStatusCheck(
      {required dynamic vin}) async {
    if (vin.toString().isNullOrEmpty) throw Exception("Invalid VIN");
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vehicleStatusCheck$vin";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateStatusToDo(
      {required Map<String, dynamic> body}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_updateStatusToDo";
      final http.Response? response =
          await _apiClient.callPostMethod(apiUrl, body: jsonEncode(body));
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getFilter(
      {required dynamic filterName, required dynamic model}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getFilter";
      Map<String, dynamic> params = {"filter_name": filterName, "model": model};
      final http.Response? response =
          await _apiClient.callGetMethod(apiUrl, params: params);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> saveFilter(
      {required dynamic filterName,
      required dynamic model,
      required dynamic filterData}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_saveFilter";
      var body = {
        "filter_name": filterName,
        "model": model,
        "filter_data": filterData
      };
      log("${jsonEncode(body)}", name: "UPLOAD_BODY");
      final http.Response? response =
          await _apiClient.callPostMethod(apiUrl, body: jsonEncode(body));
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<ExpenseResponse?> getVehicleExpenseList(
      {String? minDate, String? maxDate}) async {
    try {
      String apiUrl =
          '${Str.LIST_BASE_URL}$_expenses/all?minDate=$minDate&maxDate=$maxDate&platformCustom=tasker-app';
      Console.of.log(apiUrl);
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return (mapData != null) ? ExpenseResponse.fromJson(mapData) : null;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> expenseApprove(
      {String? id, String? approved}) async {
    try {
      String apiUrl = '${Str.LIST_BASE_URL}$_expenseApprove';
      final http.Response? response = await _apiClient.callPostMethod(apiUrl,
          body: jsonEncode({'approved': approved, 'expenseId': id}));
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }
Future<Map<String, dynamic>?> getLocations() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_locations";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getBranch() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getBranch";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getVendors() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vendors";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getParts() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vehiclePartsList";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getSupplies() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vehicleSupplies";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getTaskCategoryGroup() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_taskCategoryGroup";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getToDoList(
      {String? selectedDate, bool status = false, String? resourceId}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getToDoList";
      Map<String, dynamic> params = {
        "resource": resourceId ?? "",
        "date": selectedDate,
        "status": status ? "Completed" : "In Progress",
        "branch_id": _branchId ?? 1
      };
      Console.of.log(params);
      final http.Response? response =
          await _apiClient.callGetMethod(apiUrl, params: params);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getGroupVehicle() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_groupVehicle";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getActiveVehicles() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_activeVehicles";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getBouncieVehicles() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_saveBouncieVehicle";
      final http.Response? response = await _apiClient.callPostMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getTaskExpenseData() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_taskExpenseData";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>?> getWorkingHoursByUser() async {
    try {
      String apiUrl = "${Str.GOPORTAL_BASE_URL}$_getWorkingHoursByUser/$_userId";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      var listData = List<Map<String, dynamic>>.from(mapData?['data'] ?? []);
      return listData;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>?> getUserPunchList() async {
    try {
      String apiUrl = "${Str.GOPORTAL_BASE_URL}$_userPunchList";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      var listData = List<Map<String, dynamic>>.from(mapData?['data'] ?? []);
      return listData;
    } catch (e) {
      rethrow;
    }
  }

  Future<SubCategoriesResponse?> getExpenseTo() async {
    try {
      String apiUrl = '${Str.LIST_BASE_URL}$_expensesCategory';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return (mapData != null)
          ? SubCategoriesResponse.fromJson(mapData)
          : null;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getPaymentType() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_paymentType";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }


}
