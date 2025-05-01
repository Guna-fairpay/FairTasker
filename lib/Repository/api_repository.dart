import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fairpytasker/Response/assigned_to_response.dart';
import 'package:fairpytasker/Response/cohorts_response.dart';
import 'package:fairpytasker/Response/employee_response.dart';
import 'package:fairpytasker/Response/general_response.dart';
import 'package:fairpytasker/Response/leave_management_employee_list_response.dart';
import 'package:fairpytasker/Response/user_group_response.dart';
import 'package:fairpytasker/Response/vehicle_history_response.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/response_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/timeday_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/file_saver.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import '../Response/GetActiveHoursResponse.dart';
import '../Response/GetWorkingHoursData.dart';
import '../Response/punchList_Response.dart';
import '../Response/subcategories_response.dart';
import '../Response/expense_response.dart';
import '../Response/todo_list_response.dart';
import '../Response/working_history_count_response.dart';
import '../UI/CheckIn CheckOut/Response/checkInOutResponse.dart';
import '../UI/CheckIn CheckOut/Response/taskCategoryGroupResponse.dart';
import '../UI/CheckIn CheckOut/Response/workingGetConfiguration.dart';
import '../UI/CheckIn CheckOut/Response/workingHoursResponse.dart';
import '../UI/CheckIn CheckOut/Response/workingReasonResponse.dart';
import '../UI/CheckIn CheckOut/Response/workingTaskResponse.dart';
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

  String get _updateExpense => "expenses_update";

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

  String get _location_address => "location_address";

  String get _getBranch => "getBranch";

  String get _vendors => "vendors";

  String get _vendorTypes => "vendor-types";

  String get _vendorImageDelete => "vendor-image-delete";

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

  String get _getTodoDetails => "get-todo-details";

  String get _getPersonExpense => "ajaxPersonExpense";

  String get _getEmployeeList => "employeeList";

  String get _personExpenseApproval => "person-expense-approval";

  String get _editPersonExpense => "editPersonExpense";

  String get _personExpense => "personExpenses";

  String get _personExpenseAdd => "storePersonExpense";

  String get _updatePersonExpense => "updatePersonExpense";

  String get _personExpenseAttachment => "person_expense_attachment";

  String get _personExpenseHistory => "ajaxPersonExpense";

  String get _expenseCategories => "expenseCategories";

  String get _changeToDoByGroup => "change-todo-by-group";

  String get _swapToDo => "swap-todo";

  String get _getPreviousOdometer => "getPreviousOdometer";

  String get _getTodoOdometer => "getTodoOdometer";

  String get _addTodoOdometer => "addTodoOdometer";

  String get _addTodo => "add-todo";

  String get _relatedToDos => "related-todos";

  String get _expenseLogs => "expenseLogs";

  String get _deleteTodoImage => "deleteTodoImage";

  String get _vehiclesApi => "vehiclesApi";

  String get _editVehicleExpenseDetails => "filter?vin";

  String get _privateRentalVehiclesList => "private_rental_vehicles_list";

  String get _privateRentalCustomersList => "private_rental_customers_list";

  String get _getEditPrivateRental => "private_rental_edit";

  String get _addPrivateRental => "private_rental_assign";

  String get _editPrivateRental => "private_rental_update";

  String get _vehicleImages => "vehicle_images";

  String get _feedback => "feedback";

  String get _getVoiceTextList => "getVoiceTextList";

  String get _vehicleNotesHistory => "vehicle_notes_history";

  String get _updateNote => "vehicle_status/update_note/";

  String get _deleteNote => "vehicle_status/delete_note/";

  String get _vehicleConfig => "vehicle_config/categories";

  String get _vehicleConfigCheckList => "vehicle_config/checklist";

  String get _vehicleStatusCheckList => "vehicle_status_checklist_api";

  String get _createChecklistTodo => "create-checklist-todo";

  String get _vehicleStatusChecklist => "vehicle_status/checklist";

  String get _vehicleStatusUpdate => "vehicleStatusUpdate";

  String get _saveAudio => "save-audio";

  String get _checklistReorder => "vehicle_config/checklist_reorder";

  String get _notes => "notes";

  String get _updateNoteStatus => "updateNoteStatus";

  String get _addNoteItem => "addNoteItem";

  String get _updateNoteItem => "updateNoteItem";

  String get _removeNoteItem => "removeNoteItem";

  String get _saveWorkingHour => "saveWorkingHour";

  String get _updateWorkingHour => "updateWorkingHour";

  String get _getTaskCategory => "taskCategory";

  String get _deleteTaskCategory => "deleteTaskCategory";

  String get _addTaskCategory => "addTaskCategory";

  String get _updateTaskCategory => "updateTaskCategory";

  String get _deleteRecurringTodo => "delete-recurring-todo";

  String get _toDoDataRange => "todo-data-range";

  String get _employeeActiveHours => "employeeActiveHours";

  String get _employeeHistoryCount => "employeeHistoryCount";

  String get _employeeWorkHours => "employeeWorkHours";

  String get _importTuroVehicles => "importTuroVehicles";

  String get _uploadTodo => "upload-todo";

  String get _getOdometerValue => "get-vehicle-data";

  String get _deleteVehicleParts => "delete-vehicle-parts";

  String get _deleteSupplies => "delete-supplies";

  String get _getBillList => "bill-list";

  String get _deleteBill => "delete-bill";

  String get _addBill => "upload-bill";

  String get _editBill => "update-bill";

  String get _updateBillStatus => "updataBillStatus";

  String get _getEditBill => "edit-bill";

  String get _deleteBillImage => "delete-bill-image";

  String get _getMaintenanceCheckList => "getMaintanceCheckList";

  String get _addEmployee => "employeeAdd";

  String get _updateEmployee => "updateUser";

  String get _addUser => "addUser";

  String get _todo => "todo";

  String get _swapNoteItems => "swapNoteItems";

  String get _swapNotes => "swapNotes";

  String get _setDefaultVehicleConfig => "setDefaultVehicleConfig";

  String get _getVehicleHistory => "get-vehicle-history";

  String get _getUserList => "userList";

  String get _deleteUser => "deleteUser";

  String get _getRoles => "getroles";

  String get _getDepartments => "getdepartments";

  String get _getEditUser => "editUser";

  String get _deleteTodoNoteAttachment => "deleteTodoNoteAttachment";

  String get _deleteTodoMileageAttachment => "deleteTodoMileageAttachment";

  int? get _branchId => Session.of.getInt(Str.branchIdPrefText);

  String? get _userId => Session.of.getString(Str.userIdPrefText);

  int? get _hrmId => Session.of.getInt(Str.hrmIdPrefText);

  Future<VehicleHistoryResponse?> getVehicleHistoryList(
      {String? vin, dynamic groupId, int? currentPage, int itemsPerPage = 5, String? search}) async {
    try {
      String apiUrl = '${Str.BASE_URL}$_searchHistoryApi';
      final Map<String, dynamic> map = {};
      map['page'] = currentPage;
      if (vin.isNotNullOrEmpty) map['vin'] = vin;
      if (groupId.toString().isNotNullOrEmpty) map['groupId'] = groupId;
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
    if (todoId.toString().isNullOrEmpty) throw Exception("Invalid Todo Id");
    try {
      String apiUrl = "${Str.BASE_URL}$_completeToDoApi/$todoId";
      final Map<String, dynamic> map = {};
      map['status'] = status;
      Console.of.debug(map);
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
      return mapData?['todo'];
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
      if (statusId != null && statusId != 0 && statusId != "0") params['vehicle_status'] = statusId;
      if (cohortId != null && cohortId != 0 && cohortId != "0") params['cohort_id'] = cohortId;
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
          fieldName: "images",
          autoIncrement: true);
      if (response != null) {
        if (response.isSuccess) {
          var mapData = await response.mapData;
          log(mapData.toString(), name: "updateToDoApi");

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
        apiUrl = "${Str.LIST_BASE_URL}$_updateExpense/$expenseId";
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
      {Map<String, dynamic>? body}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_generateInvoiceApi";
      final http.Response? response =
          await _apiClient.callPostMethod(apiUrl, body: jsonEncode(body));
      if (response != null) {
        if (response.isSuccess) {
          var path = await FileSaver.instance.saveFile(response);
          Toaster.showSuccess("Invoice Generated Successfully");
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

  Future<Map<String, dynamic>?> getEditVehicleExpense(
      {String? id}) async {
    if (id.toString().isNullOrEmpty) return null;
    try {
      String apiUrl = '${Str.LIST_BASE_URL}$_expenses/$id/edit';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteVehicleExpenseImage(
    dynamic todoVehicleId,
  ) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_deleteExpenseImage/$todoVehicleId";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return mapData;
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
      String apiUrl = "${Str.LIST_BASE_URL}$_updateExpense/$expenseId";
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

  Future<Map<String,dynamic>?> deleteTodo({String? id, dynamic reason}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_deleteToDoApi/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl, body: {'reason': '$reason'});
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }


  Future<Map<String,dynamic>?> deleteRecurringTodo({String? id, dynamic reason,String? from,String? to}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_deleteRecurringTodo/$id?from=$from&to=$to&reason=$reason";
      final http.Response? response = await _apiClient.callDelete(apiUrl, body: {'reason': '$reason'});
      var mapData = await response.mapData;
      return mapData;
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
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return (mapData != null) ? ExpenseResponse.fromJson(mapData) : null;
    } catch (error) {
      rethrow;
    }
  }

  Future<ExpenseResponse?> getPersonExpense(
      {String? minDate, String? maxDate}) async {
    try {
      String apiUrl = '${Str.LIST_BASE_URL}$_getPersonExpense';
      final http.Response? response = await _apiClient.callPostMethod(apiUrl,
          body: jsonEncode({'minDate': minDate, 'maxDate': maxDate, 'platformCustom': 'tasker-app'}));
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

  Future<List<Map<String, dynamic>>?> getVendorsType() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vendorTypes";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      final dynamic decodedData = json.decode(response?.body ?? '[]');

      if (decodedData is List) {
        return List<Map<String, dynamic>>.from(decodedData);
      } else {
        return null; // or throw an error if the format is unexpected
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> createVendor({
    int? id,
    String? name,
    String? vendorTypeId,
    String? address,
    String? phone,
    String? expertise,
    String? description,
    String? latitude,
    String? longitude,
    String? website,
    List<File>? images,
    }) async {
    try {
      String apiUrl = '';
      if (id != null) {
        apiUrl = "${Str.LIST_BASE_URL}vendors/$id";
      } else {
        apiUrl = "${Str.LIST_BASE_URL}vendors";
      }
      Map<String, String> reqMap ={
        "name": name??'',
        "type_id": vendorTypeId??'',
        "address": address??'',
        "phone": phone??'',
        "expertise": expertise??'',
        "description": description??'',
        "latitude": latitude??'',
        "longitude": longitude??'',
        "website": website??'',
        "platform": "TaskerApp",
        "status": "1",
      };
      log('repository_side : $reqMap');
      var request = http.MultipartRequest("POST", Utils.getUri(apiUrl));
      request.headers.addAll(Utils.getHeaders());
      request.fields.addAll(reqMap);

      for (int i = 0; i < (images?.length ?? 0); i++) {
        var file = images![i];
        var multipartFile = http.MultipartFile.fromBytes(
          'images[$i]',
          (await file.readAsBytes()).toList(),
          filename: file.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      http.StreamedResponse streamedResponse = await request.send();

      if(streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201){
        final http.Response response =
        await http.Response.fromStream(streamedResponse);
        return json.decode(response.body);
      }
      else {
        Utils.showSomethingWentWrong();
        return null;
      }
    } catch (error) {
      log('createVendor.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> deleteVendor(int? vendorId) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vendors/$vendorId";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          log('deleteVendor api.response.body: ${response.body}');
          log('deleteVendor api.statusCode: ${response.statusCode}');
          return true;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('deleteVendor.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> createVendorType(int? id, String? name) async {
    try {
      String body =
      jsonEncode({"name": name, "platform": "TaskerApp", "status": "1"});
      String apiUrl = '';
      http.Response? response;
      if (id != null) {
        apiUrl = "${Str.LIST_BASE_URL}vendor-types/$id";
        response = await _apiClient.callPutMethod(apiUrl, body: body);
      } else {
        apiUrl = "${Str.LIST_BASE_URL}vendor-types";
        response = await _apiClient.callPostMethod(apiUrl, body: body);
      }
      log("createVendorTypeData apiUrl: $apiUrl");
      log("createVendorTypeData body: ${response?.body ?? ''}");
      if (response != null) {
        log('createVendorTypeData api.response.body: ${response.body}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          log('createVendorTypeData api.statusCode: ${response.statusCode}');

          GeneralResponse generalResponse =
          GeneralResponse.fromJson(json.decode(response.body));
          Utils.showMobileToast(generalResponse.message!);
          return true;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('createVendorTypeData.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> deleteVendorType(int? Id) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vendorTypes/$Id";

      final http.Response? response = await _apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          log('deleteVendor api.response.body: ${response.body}');
          log('deleteVendor api.statusCode: ${response.statusCode}');
          return true;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('deleteVendor.exception : ${error.toString()}');
      return null;
    }
  }

  //delete image for vendor page
  Future<bool?> deleteImages(int? id) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vendorImageDelete/$id";
      log("deleteExpenseImages apiUrl: $apiUrl");
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          log('deleteExpenseImages api.response.body: ${response.body}');
          log('deleteExpenseImages api.statusCode: ${response.statusCode}');
          return true;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('deleteExpenseImages.exception : ${error.toString()}');
      return null;
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
      {String? selectedDate, bool? status, String? resourceId}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getToDoList";
      Map<String, dynamic> params = {
        "resource": resourceId ?? "",
        "date": selectedDate,
        "branch_id": _branchId ?? 1
      };
      if (status != null) params["status"] = status ? "Completed" : "In Progress";
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
      String apiUrl = "${Str.GOPORTAL_BASE_URL}$_getWorkingHoursByUser/$_hrmId";
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

  Future<Map<String, dynamic>?> getTodoDetails({String? expenseId}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getTodoDetails?expense_id=$expenseId";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData?['data'];
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> expenseAddOrUpdateApi(
      {Map<String, dynamic>? body,
        List<File>? images,
        String? expenseId}) async {
    try {
      String apiUrl = '';
      if (expenseId != null) {
        apiUrl = "${Str.LIST_BASE_URL}$_updateExpense/$expenseId";
      } else {
        apiUrl = "${Str.LIST_BASE_URL}$_expenses";
      }
      final http.Response? response = await _apiClient.callPostMethodWithBody(
          apiUrl,
          body: body,
          autoIncrement: true,
          fieldName: "files",
          files: images?.map((e) => e.path).toList());
      if (response != null) {
        if (response.isSuccess) {
          var mapData = await response.mapData;
          Toaster.showSuccess(mapData?['message'] ?? "Expense Added Successfully");
          return mapData;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('callExpenseAddOrUpdateAPI : ${error.toString()}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> createSubCategory(
      {String? expenseTo,
        String? name,
        String? parentId}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_expensesCategory";
      var body = {
        "expense_to": expenseTo ?? '',
        "name": name ?? '',
        "parent_id": parentId ??'',
        "platform" : "tasker-app",
      };
      Console.of.log(body);
      final http.Response? response =
      await _apiClient.callPostMethod(apiUrl, body:jsonEncode(body));
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<LeaveManagementEmployeeListResponse?> getEmployeeList() async {
    try {
      String apiUrl = "${Str.GOPORTAL_BASE_URL}$_getEmployeeList";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return (mapData != null)
          ? LeaveManagementEmployeeListResponse.fromJson(mapData)
          : null;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> approvePersonExpense(
      {String? id, String? approved}) async {
    try {
      String apiUrl = '${Str.LIST_BASE_URL}$_personExpenseApproval';
      final http.Response? response = await _apiClient.callPostMethod(apiUrl,
          body: jsonEncode({'approved': approved, 'expenseId': id}));
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getEditPersonExpense({String? expenseId}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_editPersonExpense?expenseId=$expenseId";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData?['data'];
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralResponse?> deletePersonExpense(
      dynamic personExpenseId,
      ) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_personExpense/$personExpenseId";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return GeneralResponse.fromJson(mapData);
    } catch (error) {
      rethrow;
    }
  }


  Future<bool?> createLocation({int? id, String? name, List<dynamic>? address}) async {
    try {
      log(" id - ${id} name - ${name} address - ${address}");
      Map<String, dynamic> body = {
        "platform": 'TaskerApp',
        "status": "1",
      };

      if (id != null && address != null) {
        log("Block 1");
        final newAddresses = address.where((addr) =>
        addr is Map && !addr.containsKey('id')).toList();

        for (final addr in newAddresses) {
          final response = await _apiClient.callPostMethod(
            "${Str.LIST_BASE_URL}$_location_address",
            body: jsonEncode({
              "location_id": id,
              "address": addr['address'] is List ? addr['address'] : [addr['address']],
              "platform": addr['platform'] ?? 'TaskerApp',
            }),
          );

          if (response?.statusCode != 200) {
            log("Failed to create address: ${addr['address']}");
            return false;
          }
        }
        final addressWithId = address.where((addr) => addr is Map && addr.containsKey('id')).toList();
        for (final addr in addressWithId){
          final response = await _apiClient.callPostMethod("${Str.LIST_BASE_URL}$_location_address/${addr['id']}",
              body: jsonEncode({
                'address':addr['address'],
                'platform':'TaskerApp',
                'location_id':id,
              })
          );

          if (response?.statusCode != 200) {
            log("Failed to create address: ${addr['address']}");
            return false;
          }
        }
      }

      String apiUrl;
      if (id != null && name != null) {
        log("Block 2");
        apiUrl = "${Str.LIST_BASE_URL}locations/$id";
        body["name"] = name;

        if (address != null) {
          log("Block 3");
          body["address"] = address.where((addr) =>
          addr is Map && addr.containsKey('id')).toList();
        }
      } else {
        log("Block 4");
        apiUrl = "${Str.LIST_BASE_URL}locations";
        body["name"] = name;
        body["address"] = address?.map((a) =>
        a is Map ? a['address'] : a).toList() ?? [];
      }

      final response = await _apiClient.callPostMethod(
        apiUrl,
        body: jsonEncode(body),
      );

      return response?.statusCode == 200 || response?.statusCode == 201;
    } catch (error) {
      log('Error: $error');
      return null;
    }
  }


  Future<bool?> deleteLocation(int? id) async {
    try {
      String apiUrl = '';
      apiUrl = "${Str.LIST_BASE_URL}$_location_address/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          return true;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('deleteLocation.exception : ${error.toString()}');
      return null;
    }
  }

  // delete for location list item
  Future<bool?> delete(int? id) async {
    try {
      String apiUrl;
      apiUrl = '${Str.LIST_BASE_URL}locations/$id';
      log("delete-locations apiUrl: $apiUrl");
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          return true;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('delete Location For Item.exception : ${error.toString()}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> personExpenseAddOrUpdateApi(
      {Map<String, dynamic>? body,
        List<File>? images,
        String? expenseId}) async {
    try {
      String apiUrl = '';
      if (expenseId != null) {
        apiUrl = "${Str.LIST_BASE_URL}$_updatePersonExpense/$expenseId";
      } else {
        apiUrl = "${Str.LIST_BASE_URL}$_personExpenseAdd";
      }
      final http.Response? response = await _apiClient.callPostMethodWithBody(
          apiUrl,
          body: body,
          autoIncrement: true,
          fieldName: "files",
          files: images?.map((e) => e.path).toList());
      if (response != null) {
        if (response.isSuccess) {
          var mapData = await response.mapData;
          Toaster.showSuccess(mapData?['message'] ?? "Expense Added Successfully");
          return mapData;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('callPersonExpenseAddOrUpdateAPI : ${error.toString()}');
      return null;
    }
  }


  Future<GeneralResponse?> deletePersonExpenseImage(
      dynamic id,
      ) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_personExpenseAttachment/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return GeneralResponse.fromJson(mapData);
    } catch (error) {
      rethrow;
    }
  }

  Future<ExpenseResponse?> getPersonExpenseHistory(
      {String? minDate, String? maxDate}) async {
    try {
      String apiUrl =
          '${Str.LIST_BASE_URL}$_personExpenseHistory';
      var body = {
        "minDate": minDate,
        "maxDate": maxDate,
        "platformCustom": "tasker-app"
      };
      Console.of.log(apiUrl);
      final http.Response? response = await _apiClient.callPostMethod(apiUrl,body: jsonEncode(body));
      var mapData = await response.mapData;
      return (mapData != null) ? ExpenseResponse.fromJson(mapData) : null;
    } catch (error) {
      rethrow;
    }
  }

  Future<CohortsResponse?> getExpenseCategories() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_getCohortsApi";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return (mapData != null)
          ? CohortsResponse.fromJson(mapData)
          : null;
    } catch (e) {
      rethrow;
    }
  }


  Future<Map<String, dynamic>?> changeToDoByGroup({required List<String> todoList, dynamic groupId, dynamic groupName, DateTime? date, TimeOfDay? time}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_changeToDoByGroup";
      Map<String, dynamic> body = {
        "todoList": todoList,
        "group_id": groupId,
        "groupName": groupName,
        "todoDate": date?.toFormat(format: "yyyy-MM-dd"),
        "todoTime" : time?.toHMS()
      };
      var bodyVal = jsonEncode(body);
      Console.of.log(bodyVal);
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateToDo({required Map<String, dynamic> body, required dynamic toDoId}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_updateToDoApi/$toDoId";
      body.putIfAbsent("type", () => "inline");
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> swapToDo({required dynamic fromId, required dynamic toId}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_swapToDo";
      Map<String, dynamic> body = {
        "from" : "$fromId",
        "to" : "$toId"
      };
      body.putIfAbsent("type", () => "inline");
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getPreviousOdometer({required dynamic date, dynamic identifierId, required dynamic vin}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getPreviousOdometer";
      Map<String, dynamic> body = {
        "todo_date" : date,
        "identifier_id" : identifierId,
        "vin" : vin
      };
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  /*
  * SAMPLE RESPONSE
  * {
    "status": true,
    "data": {
        "id": 292,
        "todo_id": 43001,
        "current_odometer": 1,
        "next_miles_check": 2,
        "next_odometer": 3,
        "deleted_at": null,
        "created_at": "2025-03-20T12:35:03.000000Z",
        "updated_at": "2025-03-20T12:35:03.000000Z"
    },
    "message": "Odometer found"
}
  */
  Future<Map<String, dynamic>?> getTodoOdometer({required dynamic toDoId}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getTodoOdometer/$toDoId";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> addToDoOdometer({required dynamic toDoId, required dynamic currentOdometer, required dynamic nextOdometer, required dynamic nextMilesCheck}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_addTodoOdometer";
      Map<String, dynamic> body = {
        "current_odometer" : currentOdometer,
        "next_miles_check" : nextMilesCheck,
        "next_odometer" : nextOdometer,
        "todo_id" : toDoId
      };
      body.putIfAbsent("type", () => "inline");
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> completeTodo({required dynamic todoId, required Map<String, dynamic> body}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_completeToDoApi/$todoId";
      // body.putIfAbsent("type", () => "inline");
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> completeTodoWithAttachments({required dynamic todoId, required Map<String, dynamic> body, required List<Map<String, String?>> infusedFiles}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_completeToDoApi/$todoId";
      body.putIfAbsent("type", () => "inline");
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(apiUrl, body: body, infusedFiles: infusedFiles);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> addToDo({required Map<String, dynamic> body, List<dynamic>? infusedFiles}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_addTodo";
      body.putIfAbsent("type", () => "inline");
      final http.Response? response = await  _apiClient.callPostMethodWithBodyDynamic(apiUrl, body: body, infusedFiles: infusedFiles);
      var mapData = await response.mapData;
      Console.of.log(mapData, name: "ADD_TODO_RESPONSE");
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>?> relatedToDos({required List<dynamic> todoIds}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_relatedToDos?id=$todoIds";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      var listData = List<Map<String, dynamic>>.from(mapData?['todos'] ?? []);
      return listData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateGroupVehicle({Map<String, dynamic>? body, required dynamic groupId}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_groupVehicle/$groupId";
      body?.putIfAbsent("type", () => "inline");
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body, method: "PUT");
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> saveGroupVehicle({Map<String, dynamic>? body}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_groupVehicle";
      body?.putIfAbsent("type", () => "inline");
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body, method: "POST");
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteGroupVehicle({required dynamic groupId}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_groupVehicle/$groupId";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>?> expenseLogs({dynamic vin}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_expenseLogs";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = List<Map<String, dynamic>>.from(jsonDecode(response?.body ?? ""));
      return (vin.toString().isNotNullOrEmpty) ?  mapData.where((element) => element['vin'] == vin).toList() : mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> uploadExpenseLogs({required Map<String, dynamic>? body, required dynamic infusedFiles}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_expenseLogs";
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(apiUrl, body: body, infusedFiles: infusedFiles);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteExpenseLog({dynamic logId}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_expenseLogs/$logId";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteTodoImage(
      dynamic todoId,
      ) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_deleteTodoImage/$todoId";
      final http.Response? response = await _apiClient.callPostMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteActiveVehicle(dynamic id) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vehiclesApi/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> moveVehicleToPrivateRental(
      {dynamic rentalData}) async {
    try {
      String body = jsonEncode({
        "branch_code":rentalData['branch_code'],
        "cohort_id":rentalData['cohort_id'],
        "purchase_date":rentalData['purchase_date'],
        "purchase_price":rentalData['purchase_price'],
        "vehicle_status":rentalData['vehicle_status'],
        "rental_status": 3,
        "vehicle_number": rentalData['vehicle_number'],
        "vehicle_id": rentalData['vehicle_id'],
        "vin": rentalData['vin'],
        "make": rentalData['make'],
        "model": rentalData['model'],
        "year": rentalData['year'],
        "platform_from": "TaskerApp"
      });
      String apiUrl = "${Str.LIST_BASE_URL}$_vehiclesApi/${rentalData['id']}";
      final http.Response? response = await _apiClient.callPostMethod(apiUrl, body:body,);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String,dynamic>?> getEditVehicleExpenseDetails(
      {String? vin}) async {
    try {
      String apiUrl = '${Str.LIST_BASE_URL}$_expenses/$_editVehicleExpenseDetails=$vin&platformCustom=tasker-app';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String,dynamic>?> getPrivateRentalVehicleList() async {
    try {
      String apiUrl = '${Str.LIST_BASE_URL}$_privateRentalVehiclesList';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData?['data'];
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String,dynamic>?> getPrivateRentalCustomersList() async {
    try {
      String apiUrl = '${Str.LIST_BASE_URL}$_privateRentalCustomersList';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData?['data'];
      } catch (error) {
      rethrow;
    }
  }

  Future<Map<String,dynamic>?> getEditPrivateRentalData({String? id}) async {
    try {
      String apiUrl = '${Str.LIST_BASE_URL}$_getEditPrivateRental/$id';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData?['data'];
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> privateRentalAddOrUpdateApi(
      {Map<String, dynamic>? body,
        List<File>? images,
        String? id}) async {
    try {
      String apiUrl = '';
      if (id != null) {
        apiUrl = "${Str.LIST_BASE_URL}$_editPrivateRental/$id";
      } else {
        apiUrl = "${Str.LIST_BASE_URL}$_addPrivateRental";
      }
      final http.Response? response = await _apiClient.callPostMethodWithBody(
          apiUrl,
          body: body,
          autoIncrement: true,
          fieldName: "images",
          files: images?.map((e) => e.path).toList());
      if (response != null) {
        var mapData = await response.mapData;
        log(jsonEncode(mapData), name: "Response");
        if (mapData?['success'] == true) {
          var mapData = await response.mapData;
          Toaster.showSuccess(mapData?['message']);
          return mapData;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('callPersonExpenseAddOrUpdateAPI : ${error.toString()}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> uploadFeedback({required Map<String, dynamic>? body, List<Map<String, String?>>? infusedFiles}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_feedback";
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(apiUrl, body: body, infusedFiles: infusedFiles);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> vehicleAddOrUpdateApi(
      {Map<String, dynamic>? body,
        List<Map<String, String?>>? infusedFiles,
        String? id}) async {
    try {
      String apiUrl = '';
      if (id != null) {
        apiUrl = "${Str.LIST_BASE_URL}$_vehiclesApi/$id";
      } else {
        apiUrl = "${Str.LIST_BASE_URL}$_vehiclesApi";
      }
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(
          apiUrl,
          body: body,
          infusedFiles: infusedFiles,
      );
      if (response != null) {
        var mapData = await response.mapData;
        return mapData;
      } else {
        return null;
      }
    } catch (error) {
      log('callPersonExpenseAddOrUpdateAPI : ${error.toString()}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteVehicleImage(dynamic id) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vehicleImages/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String,dynamic>?> getVoiceToTextData({String? startDate, String? endDate}) async {
    try {
      String apiUrl = '${Str.BASE_URL}$_getVoiceTextList?from=$startDate&to=$endDate';
      Console.of.log(apiUrl);
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String,dynamic>?> getVehicleNotes({String? vin}) async {
    try {
      String apiUrl = '${Str.LIST_BASE_URL}$_vehicleNotesHistory/$vin';
      Console.of.log(apiUrl);
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> saveVehicleNotes(
      {required dynamic vin, required Map<String, dynamic>? body}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_saveNote$vin";
      final http.Response? response =
      await _apiClient.callPostMethodWithBody(apiUrl, body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateVehicleNotes(
      {required dynamic id, required Map<String, dynamic>? body}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_updateNote$id";
      final http.Response? response =
      await _apiClient.callPostMethodWithBody(apiUrl, body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteNote(dynamic id) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_deleteNote$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getVehicleStatusConfig({String? vin}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vehicleConfig";
      Map<String, dynamic> body = {"vin": vin};
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl,body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> vehicleConfigCheckList({required Map<String, dynamic>? body}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vehicleConfigCheckList";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl,body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> vehicleStatusCheckList({String? vin}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vehicleStatusCheckList/$vin";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData?['data'];
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> createChecklistTodo({required Map<String, dynamic>? body}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_createChecklistTodo";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl,body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> vehicleStatusChecklist({required Map<String, dynamic>? body}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vehicleStatusChecklist";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl,body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> vehicleStatusUpdate({required Map<String, dynamic>? body}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vehicleStatusUpdate";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl,body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String,dynamic>?> saveAudio({File? audio}) async {
    try {
      String apiUrl = '${Str.BASE_URL}$_saveAudio';
      var infusedFile = {"audio" : audio?.path};
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(apiUrl, infusedFiles: infusedFile);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> vehicleCheckListSwap({required Map<String, dynamic>? body}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_checklistReorder";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl,body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getNotes({DateTime? selectedDate, bool status = false}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_notes";
      var body = {
        "date" : selectedDate?.toFormat(),
        "branch_id" : _branchId,
        "status" : status ? 1 : 0
      };
      final http.Response? response = await _apiClient.callGetMethod(apiUrl,params: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getNote({required dynamic id}) async {
    try {
      if (id.toString().isNullOrEmpty) throw Exception("Invalid Note Id");
      String apiUrl = "${Str.BASE_URL}$_notes/$id";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> createNote({Map<String, dynamic>? body}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_notes";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> putNotes({Map<String, dynamic>? body, required dynamic id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_notes/$id";
      // body?['type'] = "inline";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body, method: "PUT");
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateNoteStatus({Map<String, dynamic>? body, required dynamic id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_updateNoteStatus/$id";
      body?['type'] = "inline";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body, method: "POST");
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteNotes({required dynamic id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_notes/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> addNoteItem({required dynamic id, Map<String, dynamic>? body}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_addNoteItem/$id";
      body?['type'] = "inline";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body, method: "POST");
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateNoteItem({required dynamic id, Map<String, dynamic>? body}) async {
    Console.of.debug(body);
    try {
      String apiUrl = "${Str.BASE_URL}$_updateNoteItem/$id";
      // body?['type'] = "inline";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body, method: "POST");
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> removeNoteItem({required dynamic id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_removeNoteItem/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> saveWorkingHour({required Map<String, dynamic>? body}) async {
    try {
      String apiUrl = "${Str.GOPORTAL_BASE_URL}$_saveWorkingHour";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateWorkingHour({required Map<String, dynamic>? body}) async {
    try {
      String apiUrl = "${Str.GOPORTAL_BASE_URL}$_updateWorkingHour/$_hrmId";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body, method: "PUT");
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getExpensesCategory({dynamic id}) async {
    try {
      String apiUrl = ((id == null) || (id == 0)) ? '${Str.LIST_BASE_URL}$_expensesCategory' : '${Str.LIST_BASE_URL}$_expensesCategory/$id';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> saveExpensesCategory({String? name, dynamic expenseTo, dynamic parentId}) async {
    try {
      String apiUrl = '${Str.LIST_BASE_URL}$_expensesCategory';
      var body = {
        "name" : name ?? "",
        "platform" : "tasker-app"
      };
      if ((expenseTo != null) && (expenseTo != 0)) body['expense_to'] = "$expenseTo";
      if ((parentId != null) && (parentId != 0)) body['parent_id'] = "$parentId";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateExpensesCategory({String? name, required dynamic id,  dynamic expenseTo, dynamic parentId}) async {
    try {
      String apiUrl = '${Str.LIST_BASE_URL}$_expensesCategory/$id';
      var body = {
        "name" : name ?? "",
        "platform" : "tasker-app"
      };
      if ((expenseTo != null) && (expenseTo != 0)) body['expense_to'] = "$expenseTo";
      if ((parentId != null) && (parentId != 0)) body['parent_id'] = "$parentId";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteExpensesCategory({required dynamic id}) async {
    try {
      String apiUrl = '${Str.LIST_BASE_URL}$_expensesCategory/$id';
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, method: "DELETE");
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteTaskExpensesData(
      dynamic id,
      ) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_taskExpenseData/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> taskAddOrUpdate(
      {Map<String, dynamic>? body, dynamic id}) async {
    try {
      String apiUrl = '';
      if (id != null) {
        apiUrl = "${Str.LIST_BASE_URL}$_taskExpenseData/$id";
      } else {
        apiUrl = "${Str.LIST_BASE_URL}$_taskExpenseData";
      }
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(
        apiUrl,
        body: body,
      );
      if (response != null) {
        if (response.isSuccess) {
          var mapData = await response.mapData;
          return mapData;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('callTaskAddOrUpdateAPI : ${error.toString()}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTaskCategory() async {
    try {
      String apiUrl = '${Str.BASE_URL}$_getTaskCategory';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteCategoryConfigData(
      dynamic id,
      ) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_deleteTaskCategory/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> categoryConfigAddOrUpdate(
      {Map<String, dynamic>? body, dynamic id}) async {
    try {
      String apiUrl = '';
      if (id != null) {
        apiUrl = "${Str.BASE_URL}$_updateTaskCategory/$id";
      } else {
        apiUrl = "${Str.BASE_URL}$_addTaskCategory";
      }
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(
        apiUrl,
        body: body,
      );
      if (response != null) {
        if (response.isSuccess) {
          var mapData = await response.mapData;
          return mapData;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('callCategoryConfigAddOrUpdateAPI : ${error.toString()}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> deletePartsData(
      dynamic id,
      ) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vehiclePartsList/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> partsAddOrUpdate(
      {Map<String, dynamic>? body, dynamic id}) async {
    try {
      String apiUrl = '';
      http.Response? response;
      if (id != null) {
        apiUrl = "${Str.LIST_BASE_URL}$_vehiclePartsList/$id";
        response = await _apiClient.callPutMethod(
          apiUrl,
          body:jsonEncode(body),
        );
      } else {
        apiUrl = "${Str.LIST_BASE_URL}$_vehiclePartsList";
        response = await _apiClient.callPostMethodWithBodyDynamic(
          apiUrl,
          body: body,
        );
      }
      if (response != null) {
        if (response.isSuccess) {
          var mapData = await response.mapData;
          return mapData;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('callPartsAddOrUpdateAPI : ${error.toString()}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> suppliesAddOrUpdate(
      {Map<String, dynamic>? body, dynamic id}) async {
    try {
      String apiUrl = '';
      http.Response? response;
      if (id != null) {
        apiUrl = "${Str.LIST_BASE_URL}$_vehicleSupplies/$id";
        response = await _apiClient.callPutMethod(
          apiUrl,
          body:jsonEncode(body),
        );
      } else {
        apiUrl = "${Str.LIST_BASE_URL}$_vehicleSupplies";
        response = await _apiClient.callPostMethodWithBodyDynamic(
          apiUrl,
          body: body,
        );
      }
      if (response != null) {
        if (response.isSuccess) {
          var mapData = await response.mapData;
          return mapData;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('callSuppliesAddOrUpdateAPI : ${error.toString()}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteSuppliesData(
      dynamic id,
      ) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vehicleSupplies/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> toDoDataRange({DateTime? date, bool isCompleted = false}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_toDoDataRange";
      Map<String, dynamic> params = {
        "date" : date?.toFormat(),
        "status" : isCompleted ? "Completed" : "Pending"
      };
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: params);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> employeeActiveHours({DateTime? fromDate, DateTime? toDate}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_employeeActiveHours";
      Map<String, dynamic> params = {
        "from" : fromDate?.toFormat(),
        "to" : toDate?.toFormat()
      };
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: params);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> employeeHistoryCount({DateTime? fromDate, DateTime? toDate}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_employeeHistoryCount";
      Map<String, dynamic> params = {
        "from" : fromDate?.toFormat(),
        "to" : toDate?.toFormat()
      };
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: params);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> employeeWorkHours({DateTime? fromDate, DateTime? toDate}) async {
    try {
      String apiUrl = "${Str.GOPORTAL_BASE_URL}$_employeeWorkHours";
      Map<String, dynamic> params = {
        "startDate" : fromDate?.toFormat(),
        "endDate" : toDate?.toFormat()
      };
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: params);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> importTuroReservation({required String? text}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_importTuroVehicles";
      Map<String, dynamic> body = { "data" : text};
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> uploadToDo({required String? text}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_uploadTodo";
      Map<String, dynamic> body = { "reservation" : text};
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getOdometerValue({required String? vin}) async {
    try {
      String apiUrl = '${Str.BASE_URL}$_getOdometerValue?vin=$vin';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteVehicleParts({required dynamic id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_deleteVehicleParts/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteSupplies({required dynamic id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_deleteSupplies/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getMaintenanceCheckList() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getMaintenanceCheckList";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }
//
  Future<GetActiveHoursResponse?> getActiveHoursResponse(
      String start, String end) async {
    try {
      String apiUrl = "${Str.BASE_URL}employeeActiveHours?from=$start&to=$end";
      log("getWorkingHistory apiUrl: $apiUrl");

      final http.Response? response = await _apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        GetActiveHoursResponse getActiveHours =
        GetActiveHoursResponse.fromJson(json.decode(response.body));
        if(getActiveHours.status == 200){
          return getActiveHours;
        }
        return getActiveHours;
      } else {
        Utils.showNoResultFound();
        return null;
      }
    } catch (error) {
      log('getWorkingHistory.exception : ${error.toString()}');
      return null;
    }
  }

  Future<TaskCategoryGroupResponse?> getTaskCategoryGroups() async {
    try {
      String apiUrl = "${Str.BASE_URL}taskCategoryGroup";
      log("getAssignedTo apiUrl: $apiUrl");

      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response != null) {

        if (response.statusCode == 200) {

          TaskCategoryGroupResponse taskCategoryGroupResponse =
          TaskCategoryGroupResponse.fromJson(json.decode(response.body));
          return taskCategoryGroupResponse; // Return departmentResponse here
        } else {
          Utils.showNoResultFound();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getTaskCategoryGroup.exception : ${error.toString()}');
      return null;
    }
  }

  Future<GetWorkingHoursDataResponse?> getWorkingHoursData(
      String start, String end) async {
    try {
      String apiUrl =
          "${Str.GOPORTAL_BASE_URL}employeeWorkHours?startDate=$start&endDate=$end";
      log("getWorkingHistory apiUrl: $apiUrl");

      final http.Response? response = await _apiClient.callGetMethod(apiUrl,);
      if (response != null) {
        GetWorkingHoursDataResponse getWorkingHoursDataResponse =
        GetWorkingHoursDataResponse.fromJson(json.decode(response.body));

        if ((getWorkingHoursDataResponse.status ?? false)) {

          return getWorkingHoursDataResponse;
        } else {
          Utils.showNoResultFound();
          log('---------------> ${getWorkingHoursDataResponse.status!}');
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getWorkingHistory.exception : ${error.toString()}');
      return null;
    }
  }

  Future<WorkingHistoryCountResponse?> getWorkingHistoryCount(
      String start, String end) async {
    try {
      String apiUrl = "${Str.BASE_URL}employeeHistoryCount?from=$start&to=$end";
      log("getWorkingHistory apiUrl: $apiUrl");
      final http.Response? response = await _apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        WorkingHistoryCountResponse workingHistoryCountResponse =
        WorkingHistoryCountResponse.fromJson(json.decode(response.body));
        if(workingHistoryCountResponse.status == 200){
          return workingHistoryCountResponse;
        }
        return workingHistoryCountResponse;
      } else {
        Utils.showNoResultFound();
        return null;
      }
    } catch (error) {
      log('getWorkingHistory.exception : ${error.toString()}');
      return null;
    }
  }


  Future<bool?> deleteTaskConfiguration(int? id) async {
    try {
      String apiUrl = "${Str.BASE_URL}delete-configuration/$id";

      log("deleteTaskConfiguration apiUrl: $apiUrl");
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          return true;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('deleteTaskConfiguration.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> addTaskConfiguration(
      int? id,
      int? userId,
      String? name,
      String? amount,
      String? task) async {
    try {
      String body = jsonEncode({"amount": amount, "task_name": name, "type":task, "id":id, "user_id": userId});
      print("repository side $body");
      String apiUrl = '';
      http.Response? response;
      if (id == null && userId==null) {
        log("$task",name: "TaskBased");
        apiUrl = "${Str.BASE_URL}add-configuration";
        response = await _apiClient.callPostMethod(apiUrl, body: body);
      }else if(id == null)
      {
        log("$task",name: "HourBased");
        apiUrl = "${Str.BASE_URL}add-configuration";
        response = await _apiClient.callPostMethod(apiUrl, body: body);
      }
      else {
        log("update config");
        apiUrl = "${Str.BASE_URL}update-configuration/$id";
        response = await _apiClient.callPostMethod(apiUrl, body: body);
        log("${response?.body}" ,name: "update config");
      }
      log("addTaskConfiguration apiUrl: $apiUrl");
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          return true;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('addTaskConfiguration.exception : ${error.toString()}');
      return null;
    }
  }

  Future<CheckInOutReasonResponse?> fetchCheckInoutReason({
    required int hrmId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final String apiUrl =
          '${Str
          .BASE_URL}checkinout-reason?hrm_id=$hrmId&from=$fromDate&to=$toDate';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response != null) {
        //print("Api response ${response.body}");
        if (response.statusCode == 200) {
          final CheckInOutReasonResponse checkInOutReasonResponse =
          CheckInOutReasonResponse.fromJson(jsonDecode(response.body));
          return checkInOutReasonResponse;
        } else {
          log('API Error: ${response.statusCode}, Body: ${response.body}');
          return null;
        }
      } else {
        log('API Response is null');
        return null;
      }
    } catch (e) {
      log('Exception in fetchCheckInoutReason: $e');
      return null;
    }
  }

  //need
  Future<WorkingHoursResponse?> fetchEmployeeTaskCount({
    required int userId,
    required String fromDate,
    required String toDate,
  }) async
  {
    try {
      final String apiUrl =
          '${Str
          .BASE_URL}employeeTaskCount?user_id=$userId&from=$fromDate&to=$toDate';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response != null) {
        print("Api response ${response.body}");
        if (response.statusCode == 200) {
          final WorkingHoursResponse workingHoursResponse =
          WorkingHoursResponse.fromJson(jsonDecode(response.body));
          return workingHoursResponse;
        } else {
          log('API Error: ${response.statusCode}, Body: ${response.body}');
          return null;
        }
      } else {
        log('API Response is null');
        return null;
      }
    } catch (e) {
      log('Exception in fetchEmployeeTaskCount: $e');
      return null;
    }
  }

  Future<WorkingReasonResponse?> fetchEmployeeComments({
    required int? hrmId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      print("-------->hrmId $hrmId fromDate $fromDate toDate $toDate");
      final String apiUrl = '${Str.BASE_URL}edit-comments?hrm_id=$hrmId&from=$fromDate&to=$toDate';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response != null) {
        print("Api response ${response.body}");
        if (response.statusCode == 200) {
          final WorkingReasonResponse workingReasonResponse =
          WorkingReasonResponse.fromJson(jsonDecode(response.body));
          return workingReasonResponse;
        } else {
          log('API Error: ${response.statusCode}, Body: ${response.body}');
          return null;
        }
      } else {
        log('API Response is null');
        return null;
      }
    } catch (e) {
      log('Exception in fetchEmployeeComments: $e');
      return null;
    }
  }

  Future<WorkingTaskResponse?> fetchEmployeeTaskHistory({
    required dynamic to,
    required dynamic from,
    required dynamic userId,
    required List<dynamic>? cohortIds, // Allow cohortIds to be nullable
  }) async {
    try {
      print("Request parameters - from: $from, to: $to, userId: $userId, cohortIds: $cohortIds");

      // Construct the base API URL
      String apiUrl = '${Str.BASE_URL}employeeTaskHistory?to=$to&user_id=$userId&from=$from';

      // Append cohort IDs only if they are not null or empty
      if (cohortIds != null && cohortIds.isNotEmpty) {
        String cohortQuery = cohortIds.map((id) => 'cohort_id[]=$id').join('&');
        apiUrl += '&$cohortQuery';
      }

      print("Final API URL: $apiUrl");

      final http.Response? response = await _apiClient.callGetMethod(apiUrl);

      if (response != null) {
        print("Response body: ${response.body}");
        if (response.statusCode == 200) {
          return WorkingTaskResponse.fromJson(jsonDecode(response.body));
        } else {
          print('Failed to load task history. Status code: ${response.statusCode}');
          throw Exception('Failed to load task history. Status code: ${response.statusCode}');
        }
      } else {
        log('API Response is null');
        return null;
      }
    } catch (e) {
      print('Exception: Error fetching task history: $e');
      throw Exception('Error fetching task history: $e');
    }
  }


  Future<WorkingGetConfigurationResponse?> fetchGetConfiguration() async {
    try{
      final String apiUrl = '${Str.BASE_URL}getConfiguration';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      log("Api URL $apiUrl");
      if(response != null){
        if (response.statusCode == 200) {
          WorkingGetConfigurationResponse workingGetConfigurationResponse = WorkingGetConfigurationResponse.fromJson(jsonDecode(response.body));
          return workingGetConfigurationResponse;
        } else {
          throw Exception(
              'Failed to load task history. Status code: ${response.statusCode}');
        }
      }else {
        log('API Response is null');
      }
    } catch (e) {
      throw Exception('Error fetching task history: $e');
    }
    return null;
  }

  Future<CohortsDataResponse?> fetchCohortData() async
  {
    try{
      final String apiUrl = '${Str.LIST_BASE_URL}getCohortsData';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      print("Api URL $apiUrl");
      if(response != null){
        //debugPrint("Response body ${response.body}");
        if (response.statusCode == 200) {
          CohortsDataResponse cohortsDataResponse = CohortsDataResponse.fromJson(jsonDecode(response.body));
          return cohortsDataResponse;
        } else {
          throw Exception(
              'Failed to load . Status code: ${response.statusCode}');
        }
      }else {
        log('API Response is null');
      }
    } catch (e) {
      throw Exception('Error fetching : $e');
    }
    return null;
  }


  Future<AssignedToResponse?> getAssignedTo() async {
    try {
      String apiUrl = "${Str.BASE_URL}getresources";
      log("getAssignedTo apiUrl: $apiUrl");
      final http.Response? response = await _apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        AssignedToResponse assignedToResponse =
        AssignedToResponse.fromJson(json.decode(response.body));
        if (assignedToResponse.status == 200 ||
            assignedToResponse.status == 201) {
          return assignedToResponse;
        } else {
          Utils.showNoResultFound();
          //debugPrint('---------------> ${assignedToResponse.status!}');
          return null;
        }
        /*  } else {
          Utils.showSomethingWentWrong();
          return null;
        }*/
      } else {
        return null;
      }
    } catch (error) {
      log('getAssignedTo.exception : ${error.toString()}');
      return null;
    }
  }

  Future<TodoListResponse?> editTodoData({dynamic id}) async {
    try {
      String apiUrl = '${Str.BASE_URL}edit-todo/$id';
      log("edit-todo apiUrl: $apiUrl");

      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          TodoListResponse todoListResponse =
          TodoListResponse.fromJson(json.decode(response.body));

          return todoListResponse;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('edit-todo.exception : ${error.toString()}');
      return null;
    }
  }

  Future<UserGroupResponse?> fetchUserGroupingList() async {
    try {
      String apiUrl = '${Str.BASE_URL}group-person';
      log("fetchUserGroupingList apiUrl: $apiUrl");

      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          UserGroupResponse userGroupResponse =
          UserGroupResponse.fromJson(json.decode(response.body));
          return userGroupResponse;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('fetchUserGroupingList.exception : ${error.toString()}');
      return null;
    }
  }

  Future<PunchlistResponse?> fetchPunchList() async
  {
    try{
      final String apiUrl = '${Str.GOPORTAL_BASE_URL}getWorkingHours';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      print("Api URL $apiUrl");
      if(response != null){
        if(response.statusCode == 200 ) {
          PunchlistResponse punchlistResponse = PunchlistResponse.fromJson(jsonDecode(response.body));
          return punchlistResponse;
        } else {
          throw Exception(
              'Failed to load . Status code: ${response.statusCode}');
        }
      } else {
        log('API Response is null');
      }
    } catch (e) {
      throw Exception('Error fetching : $e');
    }
    return null;
  }
  //

  Future<List<Map<String, dynamic>>?> todo() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_todo";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return List.from(mapData?['todos']);
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getBillList({String? from, String? to}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getBillList?from=$from&to=$to";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteBill({required dynamic id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_deleteBill/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> billAddOrUpdate(
      {Map<String, dynamic>? body, dynamic id,List<File>? images,}) async {
    try {
      String apiUrl = '';
      if (id != null) {
        apiUrl = "${Str.BASE_URL}$_editBill/$id";
      } else {
        apiUrl = "${Str.BASE_URL}$_addBill";
      }
      Console.of.debug(body??'ERROR');
      final http.Response? response = await _apiClient.callPostMethodWithBody(
        apiUrl,
        body: body,
        fieldName: 'images',
        autoIncrement: true,
        files: images?.map((e) => e.path).toList()
      );
      Console.of.debug("billAddOrUpdateResponse ${response?.body}");
      if (response != null) {
        if (response.isSuccess) {
          var mapData = await response.mapData;
          return mapData;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('billAddOrUpdateAPI : ${error.toString()}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getEditBillData({dynamic id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getEditBill/$id";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteBillImage({required dynamic id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_deleteBillImage/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateBillStatus({required dynamic id,required Map<String,String> status}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_updateBillStatus/$id";
      final http.Response? response = await _apiClient.callPostMethodWithBody(apiUrl,body: status);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> swapNoteItems({required Map<String,dynamic>? body}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_swapNoteItems";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl,body: body);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> swapNotes({required Map<String,dynamic>? body}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_swapNotes";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl,body: body);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> addEmployee({required Map<String,String> body}) async {
    try{
      String apiUrl = "${Str.GOPORTAL_BASE_URL}$_addEmployee";
      final http.Response? response = await _apiClient.callPostMethodWithBody(apiUrl,body: body);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateEmployee({required Map<String,String> body,required dynamic id}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_updateEmployee/$id";
      final http.Response? response = await _apiClient.callPostMethodWithBody(apiUrl,body: body);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> adduser({required Map<String,String> body}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_addUser";
      final http.Response? response = await _apiClient.callPostMethodWithBody(apiUrl,body: body);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> setDefaultVehicleConfig({required String vin}) async {
    try{
      String apiUrl = "${Str.LIST_BASE_URL}$_setDefaultVehicleConfig/$vin";
      final http.Response? response = await _apiClient.callPostMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getVehicleHistory({required String vin}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_getVehicleHistory?vin=$vin&itemsPerPage=5";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getEmployeeData({dynamic id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getUserList";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteEmployee({required dynamic id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_deleteUser/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> cleanCar({required Map<String, dynamic> body}) async {
    String apiUrl = "${Str.BASE_URL}$_addTodo";
    final http.Response? response = await _apiClient.callPostMethod(apiUrl, body: jsonEncode(body));
    if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
      return response.mapData;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getRoleData() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getRoles";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getDepartmentData() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getDepartments";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getEmployeeById({required dynamic id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getEditUser/$id";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteTodoNoteAttachment(dynamic id,) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_deleteTodoNoteAttachment/$id";
      final http.Response? response = await _apiClient.callPostMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteTodoMileageAttachment(dynamic id,) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_deleteTodoMileageAttachment/$id";
      final http.Response? response = await _apiClient.callPostMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> vehicleStatusCreateTask({required Map<String, dynamic> body}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_addTodo";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        return response.mapData;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

}
