import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fairpytasker/Remote/dio_remote_client.dart';
import 'package:fairpytasker/Response/assigned_to_response.dart';
import 'package:fairpytasker/Response/cohorts_response.dart';
import 'package:fairpytasker/Response/general_response.dart';
import 'package:fairpytasker/Response/user_group_response.dart';
import 'package:fairpytasker/Response/vehicle_history_response.dart';
import 'package:fairpytasker/UI/tasker/helper/tasker_helper.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/response_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/timeday_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/file_saver.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:http/http.dart' as http;
import '../Response/GetActiveHoursResponse.dart';
import '../Response/GetWorkingHoursData.dart';
import '../Response/expense_response.dart';
import '../Response/todo_list_response.dart';
import '../Response/working_history_count_response.dart';
import '../UI/Vehicle/vehicle_expense_history/response/vehicle_expense_history_response.dart';
import '../Utilities/Utils.dart';
import '../Utilities/str.dart' show Str;

class APiRepository {
  final ApiClient _apiClient = ApiClient();

  String get _getVehicleSearchHistory => "get-vehicle-search-history";

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

  String get _getCheckList => "getCheckList";

  String get _getPrivateRentalCheck => "getPrivateRentalCheck";

  String get _storeExpenseTemp => "storeExpenseTemp";

  String get _updateExpenseTemp => "updateExpenseTemp";

  String get _update_expense => "update-expense";

  String get _editExpenseTemp => "editExpenseTemp";

  String get _cumulativeCost => "cumulative_cost";

  String get _vehicleStatusUpdateApi => "vehicleStatusUpdateApi";

  String get _todoEmailCount => "todoEmailCount";

  String get _logs => "logs";

  String get _deleteLogAttachment => "delete-log-attachment";

  String get _updateLogs => "update-logs";

  String get _getCompletedTodo => "getCompletedTodo";

  String get _leaveList => "leaveList";

  String get _leaveTypeList => "leaveTypeList";

  String get _addLeave => "addLeave";

  String get _updateLeave => "updateLeave";

  String get _leaveApprove => "leaveApprove";

  String get _tollExport => "toll-export";

  String get _employeeTaskHistoryByDay => "employeeTaskHistoryByDay?date=";

  String get _getWorkingHours => "getWorkingHours";

  String get _employeeTaskCount => "employeeTaskCount";

  String get _editComments => "edit-comments";

  String get _employeeTaskHistory => "employeeTaskHistory";

  String get _getConfiguration => "getConfiguration";

  String get _addConfiguration => "add-configuration";

  String get _updateConfiguration => "update-configuration";

  String get _deleteConfiguration => "delete-configuration";

  String get _checkInOutMaster => "checkinout-master";

  String get _checkOilChangeTask => "checkOilChangeTask";

  String get _fairTechSupportTask => "getFairtechSupportTask";

  String get _getProjectStatus => "getProjectStatus";

  String get _getEodReports => "getEodReports";

  String get _getFairTechProjects => "getFairtechProjects";

  String get _getEmployeeHistoryByTask => "employeeHistoryByTask";

  String get _getOtherExpense => "ajaxOtherExpense";

  String get _addOtherExpense => "storeOtherExpense";

  String get _updateOtherExpense => "updateOtherExpense";

  String get _getSharedNotes => "products";

  String get _updateProductsStatus => "updateProductsStatus";

  String get _updateProductsItem => "updateProductsItem";

  String get _addProductsItem => "addProductsItem";

  String get _removeProductsItem => "removeProductsItem";

  String get _swapProductsItems => "swapProductsItems";

  String get _privateRentalEditCustomer => "private_rental_edit_customer";

  String get _privateRentalDeleteCustomer => "private_rental_delete_customer";

  String get _privateRentalStoreCustomer => "private_rental_store_customer";

  String get _privateRentalUpdateCustomer => "private_rental_update_customer";

  String get _getToDoModList => "todo-data-mod";

  String get _findCheckInHours => "findCheckInHours";

  String get _checkCleanCarTask => "checkCleanCarTask";

  String get _swapProducts => "swapProducts";

  String get _getBouncieVehicle => "getBouncieVehicle";

  String get _getCode => "get-code";

  String get _getBouncieToken => "getBouncieToken";

  String get _getDepartmentList => "departmentList";

  String get _getUsers => "getUsers";

  String get _getEditDepartment => "editDepartment";

  String get _updateDepartment => "updateDepartment";

  String get _addDepartment => "addDepartment";

  String get _deleteDepartment => "deleteDepartment";

  String get _getPermissionList => "permissionList";

  String get _getEditPermission => "editPermission";

  String get _addPermission => "addPermission";

  String get _updatePermission => "updatePermission";

  String get _deletePermission => "deletePermission";

  String get _roleList => "roleList";

  String get _editRole => "editRole";

  String get _editUserRole => "editUserRole";

  String get _updateUserRole => "updateRole";

  String get _addUserRole => "addRole";

  String get _deleteRole => "deleteRole";

  String get _vehicleExpenses => "vehilceExpenses";

  String get _personExpenses => "personExpenses";

  String get _otherExpenses => "otherExpenses";

  String get _getApproveTask => "getApproveTask";

  String get _approveTodo => "approveTodo";

  String get _getBouncies => "getBouncies";

  String get _checkInOut => "checkInOut";

  String get _revenueSummary => "revenueSummary";

  String get _leads => "leads";

  String get _exportLeads => "export-leads";

  String get _taskExport => "task-export";

  String get _getArchive => "archive-list";

  String get _updateArchive => "update-archive";

  String get _rentalCheckList => "rental-checklist";

  String get _getRentalToken => "getRentalToken";

  String get _verificationStatus => "verification-status";

  String get _licenseVerify => "booking/license/verify";

  String get _addressVerify => "booking/address-proof/verify";

  String get _agreementVerify => "booking/contract/verify";

  String get _getAgreementPdf => "get-agreement-pdf";

  String get _createPayment => "admin/create-payment/manual";

  String get _updatePayment => "admin/bookings/update/payment-model";

  String get _checkOutValues => "checkout-values";

  String get _saveCheckOut => 'checkout-value';

  String get _updateInsuranceRequirement => 'admin/bookings/update-insurance-requirement';

  String get _updateInsurance => 'admin/insurance/upload';

  String get _deleteInsurance => 'admin/insurance';

  String get _adminBooking => 'admin/bookings';

  String get _admin => 'admin';

  String get _booking => 'booking';

  String get _odometer => 'odometer';

  String get _checkIn => 'checkin';

  String get _updateDeposit => 'update-deposit';

  String get _checkInImages => 'checkin-images';

  String get _uploadCheckInImages => 'upload-checkin-image';

  String get _deletePrecheckImage => 'delete-precheck-image';

  String get _saveFairentalPrecheck => 'save-fairental-precheck';

  String get _bookingsInfo => 'bookings';

  int? get _branchId => Session.of.getInt(Str.branchIdPrefText);

  String? get _userId => Session.of.getString(Str.userIdPrefText);

  int? get _hrmId => Session.of.getInt(Str.hrmIdPrefText);
  
  Future<Map<String, dynamic>?> fetchReleaseNotes(dynamic version) async {
    try {
      return await RemoteClient.instance.getRequest("${Str.BASE_URL}release_note", queryParameters: { "version" : version });
    } catch (e) {
      rethrow;
    }
  }

  Future<VehicleHistoryResponse?> getVehicleHistoryList(
      {String? vin, dynamic groupId, int? currentPage, int itemsPerPage = 5, String? search}) async {
    try {
      String apiUrl = (search?.trim().isNotNullOrEmpty ?? false) ? '${Str.BASE_URL}$_getVehicleSearchHistory' : '${Str.BASE_URL}$_getVehicleHistory';
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
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
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
      map.putIfAbsent("platform_type", () => getIt<CommonService>().currentPlatform);
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
      map.putIfAbsent("platform_type", () => getIt<CommonService>().currentPlatform);
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

  @Deprecated("Use updateToDoApi instead")
  Future<Map<String, dynamic>?> getEmployeeTaskHistoryByDay(dynamic date, dynamic userId) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_employeeTaskHistoryByDay${date}&user_id=${userId}";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      log("${mapData}", name: "Response_TaskHistoryByDay");
      return mapData;
    } catch(error){
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
      {Map<String, dynamic>? body, List<File>? images, dynamic todoId}) async {
    try {
      body?.putIfAbsent("platform_type", () => getIt<CommonService>().currentPlatform);
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

          TaskerHelper.instance.scrollToIndex(mapData?['todo']?['id']);
          // Toaster.showSuccess(
          //     mapData?['message'] ?? "Todo Updated Successfully");
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
      dynamic expenseId}) async {
    try {
      String apiUrl = '';
      if (expenseId != null) {
        apiUrl = "${Str.LIST_BASE_URL}$_updateExpense/$expenseId";
      } else {
        apiUrl = "${Str.LIST_BASE_URL}$_expenses";
      }
      Console.of.log("🐅 ${jsonEncode(body)}", name: "PAYLOAD");
      final http.Response? response = await _apiClient.callPostMethodWithBody(
          apiUrl,
          body: body?..putIfAbsent('type', () => "inline"),
          autoIncrement: true,
          fieldName: "files",
          files: images?.map((e) => e.path).toList());
      if (response != null) {
        if (response.isSuccess) {
          var mapData = await response.mapData;
          // Toaster.showSuccess(
          //     mapData?['message'] ?? "Todo Updated Successfully");
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
      {dynamic id}) async {
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

  Future<Map<String,dynamic>?> deleteTodo({dynamic id, dynamic reason}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_deleteToDoApi/$id";
      Map<String, String> body = {'reason': "$reason"};
      body.putIfAbsent("platform_type", () => getIt<CommonService>().currentPlatform);
      final http.Response? response = await _apiClient.callDelete(apiUrl, body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }


  Future<Map<String,dynamic>?> deleteRecurringTodo({String? id, dynamic reason,String? from,String? to}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_deleteRecurringTodo/$id?from=$from&to=$to&reason=$reason";
      Map<String, String> body = {'reason': "$reason"};
      body.putIfAbsent("platform_type", () => getIt<CommonService>().currentPlatform);
      final http.Response? response = await _apiClient.callDelete(apiUrl, body: body);
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
      body.putIfAbsent("platform_type", () => getIt<CommonService>().currentPlatform);
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
      body.putIfAbsent("platform_type", () => getIt<CommonService>().currentPlatform);
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

  Future<Map<String, dynamic>?> getVehicleExpenseList(
      {String? minDate, String? maxDate}) async {
    try {
      String apiUrl =
          '${Str.LIST_BASE_URL}$_expenses/all?minDate=$minDate&maxDate=$maxDate&platformCustom=tasker-app';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
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
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
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

  Future<Map<String, dynamic>?> getExpenseTo() async {
    try {
      String apiUrl = '${Str.LIST_BASE_URL}$_expensesCategory';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
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

  Future<Map<String, dynamic>?> getTodoDetails({dynamic expenseId}) async {
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
        dynamic expenseId}) async {
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
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
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

  Future<Map<String, dynamic>?> getEmployeeList() async {
    try {
      String apiUrl = "${Str.GOPORTAL_BASE_URL}$_getEmployeeList";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData?['data'];
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

  Future<Map<String, dynamic>?> getEditPersonExpense({dynamic expenseId}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_editPersonExpense?expenseId=$expenseId";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData?['data'];
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deletePersonExpense(
      dynamic personExpenseId,
      ) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_personExpense/$personExpenseId";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return mapData;
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
      rethrow;
    }
  }


  Future<Map<String, dynamic>?> deleteAddress(dynamic id) async {
    try {
      String apiUrl = '';
      apiUrl = "${Str.LIST_BASE_URL}$_location_address/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      if (response.isSuccess) {
        return await response.mapData;
      }else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  // delete for location list item
  Future<Map<String, dynamic>?> deleteLocation(dynamic id) async {
    try {
      String apiUrl = '${Str.LIST_BASE_URL}$_locations/$id';
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      if (response.isSuccess) {
        return await response.mapData;
      }else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
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
        if (response.isSuccess) {
          return await response.mapData;
        }else {
          throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
        }
    } catch (error) {
      rethrow;
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
      body.putIfAbsent("platform_type", () => getIt<CommonService>().currentPlatform);
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
      body.putIfAbsent("platform_type", () => getIt<CommonService>().currentPlatform);
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      var mapData = await response.mapData;
      TaskerHelper.instance.scrollToIndex(mapData?['todo']?['id']);
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
      body.putIfAbsent("platform_type", () => getIt<CommonService>().currentPlatform);
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
      body.putIfAbsent("platform_type", () => getIt<CommonService>().currentPlatform);
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
      body.putIfAbsent("platform_type", () => getIt<CommonService>().currentPlatform);
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
      body.putIfAbsent("platform_type", () => getIt<CommonService>().currentPlatform);
      final http.Response? response = await  _apiClient.callPostMethodWithBodyDynamic(apiUrl, body: body, infusedFiles: infusedFiles);
      var mapData = await response.mapData;
      if ((mapData?['status'] == 200) && (List.from(mapData?['todo'] ?? []).isNotEmpty)) TaskerHelper.instance.scrollToIndex(List.from(mapData?['todo'] ?? []).firstOrNull?['id']);
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

  Future<Map<String, dynamic>?> updateExpenseLogs({required Map<String, dynamic>? body, required dynamic logId}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_expenseLogs/$logId";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
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
        dynamic id}) async {
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
      body?.putIfAbsent("platform_type", () => getIt<CommonService>().currentPlatform);
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
     var mapData = await response.mapData;
     return mapData;
    } catch (error) {
      log('callCategoryConfigAddOrUpdateAPI : ${error.toString()}');
      rethrow;
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
      body.putIfAbsent("platform_type", () => getIt<CommonService>().currentPlatform);
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getOdometerValue({required String? vin}) async {
    try {
      Map<String, dynamic> params = {"vin": vin,};
      String apiUrl = '${Str.BASE_URL}$_getOdometerValue';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: params);
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

  Future<List<Map<String, dynamic>>?> getWorkingHours() async
  {
    try{
      final String apiUrl = '${Str.GOPORTAL_BASE_URL}$_getWorkingHours';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      return List.from((await response?.mapData)?['data'] ?? []);
    } catch (e) {
      rethrow;
    }
  }
  //

  Future<List<Map<String, dynamic>>?> todo() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_todo";
      Map<String, dynamic> params = { "view": "day", "date" : DateTime.now().toFormat() };
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: params);
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

  Future<Map<String, dynamic>?> getVehicleHistory({required String vin, DateTime? dateTime, int itemsPerPage = 5}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_getVehicleHistory";
      Map<String, dynamic> params = {};
      params['vin'] = vin;
      if (dateTime != null) params['date'] = dateTime.toFormat();
      params['itemsPerPage'] = itemsPerPage;
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: params);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getEmployeeData() async {
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
    body.putIfAbsent("platform_type", () => getIt<CommonService>().currentPlatform);
    final http.Response? response = await _apiClient.callPostMethod(apiUrl, body: jsonEncode(body));
    if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
      var mapData = await response.mapData;
      if ((mapData?['status'] == 200) && (List.from(mapData?['todo'] ?? []).isNotEmpty)) TaskerHelper.instance.scrollToIndex(List.from(mapData?['todo'] ?? []).firstOrNull?['id']);
      return mapData;
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
      body.putIfAbsent("platform_type", () => getIt<CommonService>().currentPlatform);
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        var mapData = await response.mapData;
        if ((mapData?['status'] == 200) && (List.from(mapData?['todo'] ?? []).isNotEmpty)) TaskerHelper.instance.scrollToIndex(List.from(mapData?['todo'] ?? []).firstOrNull?['id']);
        return mapData;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getCheckList() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getCheckList";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      return response.mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getPrivateRentalCheck() async {
    try{
      String apiUrl = "${Str.BASE_URL}$_getPrivateRentalCheck";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> storeExpenseTemp(
      {required Map<String, dynamic> body, List<File>? images, dynamic id}) async {
    try{
      String apiUrl='';
      if(id != null){
        apiUrl = "${Str.LIST_BASE_URL}$_updateExpenseTemp/$id";
      }else{
        apiUrl = "${Str.LIST_BASE_URL}$_storeExpenseTemp";
      }
      final http.Response? response = await _apiClient.callPostMethodWithBody(
          apiUrl,
          body:body,
          autoIncrement: true,
          fieldName: "files",
          files: images?.map((e) => e.path).toList(),
      );
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateExpenseTemp({required Map<String, dynamic> body}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_update_expense";
      final http.Response? response = await _apiClient.callPostMethodWithBody(
        apiUrl,
        body:body,
      );
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> editExpenseTemp({dynamic id}) async {
    try{
      Console.of.log(id, name: "id");
      if (id.toString().isNullOrEmpty) return null;
      String apiUrl = "${Str.LIST_BASE_URL}$_editExpenseTemp/$id";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getCumulativeExpense({dynamic vin}) async {
    try{
      String apiUrl = "${Str.LIST_BASE_URL}$_cumulativeCost/$vin";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData?['data'];
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> vehicleStatusUpdateApi({Map<String, dynamic>? body, dynamic vin}) async {
    try{
      String apiUrl = "${Str.LIST_BASE_URL}$_vehicleStatusUpdateApi/$vin";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getTodoEmailCount({required Map<String,dynamic>body}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_todoEmailCount";
      final http.Response? response = await _apiClient.callPostMethod(apiUrl,body:jsonEncode(body));
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getLogs() async {
    try{
      String apiUrl = "${Str.BASE_URL}$_logs";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getLog({required dynamic id}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_logs/$id";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> uploadLog({Map<String, dynamic>? body, List<dynamic>? infusedFiles}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_logs";
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(apiUrl, body: body, infusedFiles: infusedFiles);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateLog({required dynamic logId,Map<String, dynamic>? body, List<dynamic>? infusedFiles}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_updateLogs/$logId";
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(apiUrl, body: body, infusedFiles: infusedFiles);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteLogAttachment({required dynamic attachmentId}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_deleteLogAttachment/$attachmentId";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteLog({required dynamic logId}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_logs/$logId";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>?> getCompletedTodo() async {
    try{
      String apiUrl = "${Str.BASE_URL}$_getCompletedTodo";
      Map<String, dynamic> params = { "from" : DateTime.now().toFormat(), "to" : DateTime.now().toFormat() };
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: params);
      var mapData = await response.mapData;
      return List.from(mapData?['data'] ?? []);
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String,dynamic>?> getLeaveList()async{
    try {
      String apiUrl = "${Str.GOPORTAL_BASE_URL}$_leaveList";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData?['data'];
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String,dynamic>?> getLeaveTypeList()async{
    try {
      String apiUrl = "${Str.GOPORTAL_BASE_URL}$_leaveTypeList";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData?['data'];
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String,dynamic>?> addLeave({Map<String,dynamic>? body})async{
    try {
      String apiUrl = "${Str.GOPORTAL_BASE_URL}$_addLeave/$_hrmId";
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(apiUrl,body: body);
      var mapData = await response.mapData;
      return mapData?['data'];
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String,dynamic>?> updateLeave({dynamic id,Map<String,dynamic>? body})async{
    try {
      String apiUrl = "${Str.GOPORTAL_BASE_URL}$_updateLeave/$id";
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(apiUrl,body: body);
      var mapData = await response.mapData;
      return mapData?['data'];
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String,dynamic>?> leaveApprove({dynamic id,Map<String,dynamic>? body})async{
    try {
      String apiUrl = "${Str.GOPORTAL_BASE_URL}$_leaveApprove";
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(apiUrl,body: body);
      var mapData = await response.mapData;
      return mapData?['data'];
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String,dynamic>?> tollExport({dynamic infusedFile})async{
    try {
      String apiUrl = "${Str.BASE_URL}$_tollExport";
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(apiUrl, infusedFiles: infusedFile);
      if (response?.isSuccess == true) {
        var mapData = await response.mapData;
        return mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String,dynamic>?> employeeTaskCount({required dynamic userId, required DateTime? from, required DateTime? to})async{
    try {
      String apiUrl = "${Str.BASE_URL}$_employeeTaskCount";
      Map<String, dynamic> params = {
        "user_id" : userId,
        "from" : from.toFormat(),
        "to" : to.toFormat(),
      };
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: params);
      if (response?.isSuccess == true) {
        var mapData = await response.mapData;
        return mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String,dynamic>?> editComments({required dynamic hrmId, required DateTime? from, required DateTime? to})async{
    try {
      String apiUrl = "${Str.BASE_URL}$_editComments";
      Map<String, dynamic> params = {
        "hrm_id" : hrmId,
        "from" : from.toFormat(),
        "to" : to.toFormat(),
      };
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: params);
      if (response?.isSuccess == true) {
        var mapData = await response.mapData;
        return mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String,dynamic>?> addConfiguration({String? id,Map<String,dynamic>? body})async{
    try {
      String apiUrl = '';
      if(id != null){
      apiUrl = "${Str.BASE_URL}$_updateConfiguration/$id";
      }else{
        apiUrl = "${Str.BASE_URL}$_addConfiguration";
      }
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(apiUrl,body: body);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteConfiguration({required dynamic id}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_deleteConfiguration/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String,dynamic>?> getEmployeeTaskHistory({required dynamic userId, required DateTime? from, required DateTime? to, List<dynamic>? cohorts})async{
    try {
      String apiUrl = "${Str.BASE_URL}$_employeeTaskHistory";
      Map<String, dynamic> params = {
        "to" : to.toFormat(),
        "user_id" : userId,
        "from" : from.toFormat(),
      };
      if (cohorts?.isNotEmpty ?? false) params['cohort_id[]'] = cohorts;
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: params);
      if (response?.isSuccess == true) {
        var mapData = await response.mapData;
        return mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String,dynamic>?> getConfiguration() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getConfiguration";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        var mapData = await response.mapData;
        return mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String,dynamic>?> getCheckInOutMaster() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_checkInOutMaster";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        var mapData = await response.mapData;
        return mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String,dynamic>?> getCheckOilChangeTask({required dynamic vin, dynamic id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_checkOilChangeTask";
      Map<String, dynamic> params = {};
      params['vin'] = vin;
      if (id.toString().isNotNullOrEmpty && (id.toString().toNumeric > 0)) params['id'] = id;
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: params);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getFairTechSupportTask({required Map<String,dynamic> body}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_fairTechSupportTask";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
      }catch(e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getFairTechTaskHistory({DateTime? startDate, DateTime? endDate, int page = 1, int itemsPerPage = 10}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_getEodReports";
      Map<String, dynamic>  params = {
        'startDate' : startDate.toFormat(),
        'endDate' : endDate.toFormat(),
        'page' : page,
        'perPage' : itemsPerPage,
      };
      final http.Response? response = await _apiClient.callGetMethod(apiUrl,params: params);
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getProjectStatus() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getProjectStatus";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getFairTechProjects() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getFairTechProjects";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getOtherExpense({String? startDate, String? endDate}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_getOtherExpense";
      Map<String, dynamic> params = {
        "minDate" : startDate,
        "maxDate" : endDate,
        "platformCustom" : "tasker-app"
      };
      Console.of.debug(params, name: "GetOtherExpense");
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(apiUrl, body: params);
      if (response != null) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getEmployeeHistoryByTask({dynamic dateTimeString, dynamic userId, List<dynamic>? cohorts}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getEmployeeHistoryByTask";
      Map<String, dynamic> params = {
        "date" : dateTimeString,
        "user_id" : userId,
      };
      if (cohorts?.isNotEmpty ?? false) params['cohort_id[]'] = cohorts;
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: params);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> expensesCategory() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_expensesCategory";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e) {
      rethrow;
    }
  }

  Future<Map<String,dynamic>?> addOtherExpense({dynamic id, Map<String,dynamic>? body, List<File>? images})async{
    try {
      String apiUrl = '';
      if(id.toString().isNotNullOrEmpty){
        apiUrl = "${Str.LIST_BASE_URL}$_updateOtherExpense/$id";
      }else{
        apiUrl = "${Str.LIST_BASE_URL}$_addOtherExpense";
      }
      final http.Response? response = await _apiClient.callPostMethodWithBody(
          apiUrl,
          body: body,
          autoIncrement: true,
          fieldName: "files",
          files: images?.map((e) => e.path).toList());
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getSharedNotes({dynamic dateTimeString}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getSharedNotes";
      Map<String, dynamic> params = {
        "date" : dateTimeString,
        "branch_id" : _branchId,
      };
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: params);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateSharedNotes({dynamic id, Map<String,dynamic>? body}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getSharedNotes/$id";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body, method: "PUT");
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateProductsStatus({Map<String, dynamic>? body, required dynamic id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_updateProductsStatus/$id";
      body?['type'] = "inline";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body, method: "POST");
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteShareNotes({required dynamic id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getSharedNotes/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getEditSharedNotes({required dynamic id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getSharedNotes/$id";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateProductsItem({Map<String, dynamic>? body, required dynamic id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_updateProductsItem/$id";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body, method: "POST");
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> removeProductsItem({required dynamic id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_removeProductsItem/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> swapProductsItems({required Map<String,dynamic>? body}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_swapProductsItems";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl,body: body);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getPrivateRentalEditCustomer({required dynamic id}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_privateRentalEditCustomer/$id";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deletePrivateRentalCustomer({required dynamic id}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_privateRentalDeleteCustomer/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> storePrivateRentalCustomer({required Map<String, dynamic> model, dynamic infusedFiles}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_privateRentalStoreCustomer";
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(apiUrl, body: model, infusedFiles: infusedFiles);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updatePrivateRentalCustomer(dynamic id, {required Map<String, dynamic> model, dynamic infusedFiles}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_privateRentalUpdateCustomer/$id";
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(apiUrl, body: model, infusedFiles: infusedFiles);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getToDoModList({String? selectedDate, bool? status, String? resourceId, bool showOther = false}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getToDoModList";
      Map<String, dynamic> params = {
        "resource": resourceId ?? "",
        "date": selectedDate,
        "branch_id": _branchId ?? 1,
      };
      if (showOther) params["showOther"] = showOther;
      if (status != null) params["status"] = status ? "Completed" : "In Progress";
      Console.of.log(params);
      // return await RemoteClient.instance.getRequest(apiUrl, queryParameters: params);
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: params);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> findCheckInHours() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_findCheckInHours";
      Map<String, dynamic> params = {
        "from": DateTime.now().toFormat() ?? "",
        "to": DateTime.now().toFormat(),
      };
      Console.of.log(params);
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: params);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> checkCleanCarTask({required dynamic vin, dynamic id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_checkCleanCarTask";
      Map<String, dynamic> params = {
        "vin": vin,
        "id": id,
      };
      Console.of.log(params);
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: params);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> swapProducts({required Map<String,dynamic>? body}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_swapProducts";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl,body: body);
      var mapData = await response.mapData;
      return mapData;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> addProductsItem({Map<String, dynamic>? body, required dynamic id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_addProductsItem/$id";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body, method: "POST");
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getPersonExpense({String? minDate, String? maxDate}) async {
    try {
      String apiUrl = '${Str.LIST_BASE_URL}$_getPersonExpense';
      Map<String, dynamic> params = {
        "minDate" : minDate,
        "maxDate" : maxDate,
        "platformCustom" : "tasker-app"
      };
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(apiUrl, body: params);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getBouncieVehicle({required dynamic token}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getBouncieVehicle";
      final Map<String, dynamic> body = {};
      body['token'] = token;
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body, method: "POST");
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getCode() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getCode";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getBouncieToken({required dynamic code}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getBouncieToken";
      Map<String, dynamic> body = {};
      body['code'] = code;
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getDepartmentList() async {
    try {
      String apiUrl = '${Str.BASE_URL}$_getDepartmentList';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getHeadList() async {
    try {
      String apiUrl = '${Str.BASE_URL}$_getUsers';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getEditDepartment({dynamic id}) async {
    try {
      String apiUrl = '${Str.BASE_URL}$_getEditDepartment/$id';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> saveDepartment({dynamic id, Map<String, dynamic>? body}) async {
    try {
      String apiUrl = '';
      if(id != null){
        apiUrl = '${Str.BASE_URL}$_updateDepartment/$id';
      }
      else{
        apiUrl = '${Str.BASE_URL}$_addDepartment';
      }
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteDepartment({dynamic id,}) async {
    try {
      String apiUrl = '${Str.BASE_URL}$_deleteDepartment/$id';
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getPermissionList() async {
    try {
      String apiUrl = '${Str.BASE_URL}$_getPermissionList';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getEditPermission({dynamic id}) async {
    try {
      String apiUrl = '${Str.BASE_URL}$_getEditPermission/$id';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> savePermission({dynamic id, Map<String, dynamic>? body}) async {
    try {
      String apiUrl = '';
      if(id != null){
        apiUrl = '${Str.BASE_URL}$_updatePermission/$id';
      }
      else{
        apiUrl = '${Str.BASE_URL}$_addPermission';
      }
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deletePermission({dynamic id,}) async {
    try {
      String apiUrl = '${Str.BASE_URL}$_deletePermission/$id';
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getRoleList() async {
    try {
      String apiUrl = '${Str.BASE_URL}$_roleList';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getEditRole({dynamic id}) async {
    try {
      String apiUrl = '${Str.BASE_URL}$_editRole/$id';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getEditUserRole({dynamic id}) async {
    try {
      String apiUrl = '${Str.BASE_URL}$_editUserRole/$id';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> saveUserRole({dynamic id, Map<String, dynamic>? body}) async {
    try {
      String apiUrl = '';
      if(id != null){
        apiUrl = '${Str.BASE_URL}$_updateUserRole/$id';
      }
      else{
        apiUrl = '${Str.BASE_URL}$_addUserRole';
      }
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteRole(dynamic id) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_deleteRole/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>?> getVendorType() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vendorTypes";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapListData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> addOrEditVendorType({dynamic id, dynamic body}) async {
    try {
      String apiUrl = '';
      final http.Response? response;
      if (id != null) {
        apiUrl = "${Str.LIST_BASE_URL}$_vendorTypes/$id";
        response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body, method: 'PUT');
      } else {
        apiUrl = "${Str.LIST_BASE_URL}$_vendorTypes";
        response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      }
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteVendorType(dynamic id) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vendorTypes/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      if (response?.statusCode == 204) {
        return {};
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getVendors() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vendors";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteVendorImages(dynamic id) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vendorImageDelete/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      if (response?.statusCode == 204) {
        return {"message" : "Deleted successfully!"};
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> addOrUpdateVendor({dynamic id, dynamic body, dynamic infusedFiles}) async {
    try {
      String apiUrl = '';
      if (id != null) {
        apiUrl = "${Str.LIST_BASE_URL}$_vendors/$id";
      } else {
        apiUrl = "${Str.LIST_BASE_URL}$_vendors";
      }
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(apiUrl, body: body, infusedFiles: infusedFiles);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getEditVendors(dynamic id) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vendors/$id/edit";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteVendor(dynamic id) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vendors/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      if (response?.isSuccess == true) {
        return {"message" : "Deleted successfully!"};
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getLocation(dynamic id) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_locations/$id/edit";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> saveLocation(Map<String, dynamic>? body) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_locations";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateLocation(dynamic id, {required Map<String, dynamic>? body}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_locations/$id";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateLocationAddress(dynamic id, {required Map<String, dynamic>? body}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_location_address/$id";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> saveLocationAddress({required Map<String, dynamic>? body}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_location_address";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> vehicleExpense(
      {String? minDate, String? maxDate}) async {
    try {
      String apiUrl = '${Str.BASE_URL}$_vehicleExpenses';
      var params = {
        "minDate": minDate,
        "maxDate": maxDate,
      };
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params:params );
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> personExpenses(
      {String? minDate, String? maxDate}) async {
    try {
      String apiUrl = '${Str.BASE_URL}$_personExpenses';
      var params = {
        "minDate": minDate,
        "maxDate": maxDate,
      };
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params:params );
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> otherExpenses(
      {String? minDate, String? maxDate}) async {
    try {
      String apiUrl = '${Str.BASE_URL}$_otherExpenses';
      var params = {
        "minDate": minDate,
        "maxDate": maxDate,
      };
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params:params );
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getBouncies() async {
    try {
      String apiUrl = '${Str.BASE_URL}$_getBouncies';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getCheckInOut({required DateTime? fromDate, required DateTime? toDate}) async {
    try {
      String apiUrl = '${Str.BASE_URL}$_checkInOut';
      Map<String, dynamic> params = {};
      params['from'] = fromDate?.toFormat();
      params['to'] = toDate?.toFormat();
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: params);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getApproveTask({dynamic fromDate, dynamic toDate}) async {
    try {
      String apiUrl = '${Str.BASE_URL}$_getApproveTask';
      var params = {
        "from": fromDate,
        "to": toDate,
      };
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params:params );
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(error){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> approveTodo({dynamic body}) async{
    try {
      String apiUrl = '${Str.BASE_URL}$_approveTodo';
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(apiUrl, body: body);
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(error){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getRevenueSummary({dynamic body}) async{
    try {
      String apiUrl = '${Str.LIST_BASE_URL}$_revenueSummary';
      return await RemoteClient.instance.getRequest(apiUrl, queryParameters: body);
      /*final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: body);
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }*/
    }catch(error){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteExpenseTodo(dynamic todoVehicleId,) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_deleteExpenseTodo";
      final http.Response? response = await _apiClient.callPostMethod(apiUrl, body: jsonEncode({'todo_id': '$todoVehicleId',}));
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteVehicleExpense(dynamic vehicleExpenseId,) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_expenses/$vehicleExpenseId";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateVehicleExpenseHistory({Map<String, dynamic>? body, List<File>? images, dynamic expenseId}) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_updateExpense/$expenseId";
      final http.Response? response = await _apiClient.callPostMethodWithBody(
          apiUrl,
          body: body,
          autoIncrement: true,
          fieldName: "files",
          files: images?.map((e) => e.path).toList());
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> taskExport({DateTime? fromDate, DateTime? toDate}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_taskExport";
      Map<String, dynamic> params = {
        "from" : fromDate?.toFormat(),
        "to" : toDate?.toFormat()
      };
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: params);
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch (error) {
      return null;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getLeads({dynamic page, dynamic search,dynamic type}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_leads";
      var parms = {'page' : page, 'search' : search, 'type' : type,};
      parms.removeWhere((key, value) => value == null);
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: parms);
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch (e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> addEditLeads({dynamic body, dynamic id}) async {
    try{
      String apiUrl = '';
      final http.Response? response;
      if(id != null){
        apiUrl = "${Str.BASE_URL}$_leads/$id";
        response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body,  method: 'PUT');
      }else{
        apiUrl = "${Str.BASE_URL}$_leads";
        response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body,);
      }
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch (e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getEditLeads({dynamic id}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_leads/$id";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch (e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteLeads({dynamic id}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_leads/$id";
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch (e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> exportLeads({dynamic body}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_exportLeads";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch (e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getArchive({dynamic from, dynamic to, dynamic archiveStatus}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_getArchive";
      var params = {
        "from" : from,
        "to" : to,
        "archive_status" : archiveStatus,
      };
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: params);
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch (e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateArchive({dynamic body}) async {
    try{
      String apiUrl = "${Str.BASE_URL}$_updateArchive";
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> rentalCheckList({dynamic bookingId}) async {
    try {
      String apiUrl = '${Str.BASE_URL}$_rentalCheckList/$bookingId';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(
            response?.body ?? "")?['message'] ??
            jsonDecode(response?.body ?? "")?['error'] ??
            "Some thing went wrong, try again later!..."}");
      }
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getRentalToken() async {
    try {
      String apiUrl = '${Str.BASE_URL}$_getRentalToken';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> verificationStatusUpdate({dynamic body, String? token}) async{
    try {
      String apiUrl = '${Str.FAIRENTAL_URL}admin/$_verificationStatus/update';
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body, token: token);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> licenseVerify({dynamic body, String? token}) async{
    try {
      String apiUrl = '${Str.FAIRENTAL_URL}admin/$_licenseVerify';
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body, token: token);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> addressVerify({dynamic body, String? token}) async{
    try {
      String apiUrl = '${Str.FAIRENTAL_URL}admin/$_addressVerify';
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body, token: token);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> agreementVerify({dynamic body, String? token}) async{
    try {
      String apiUrl = '${Str.FAIRENTAL_URL}admin/$_agreementVerify';
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body, token: token);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getAgreementPdf({dynamic id, String? token})async{
    try{
      String apiUrl = '${Str.FAIRENTAL_URL}$_getAgreementPdf';
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: {'booking_id': id}, token: token);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updatePayment({dynamic body, String? token})async{
    try{
      String apiUrl = '${Str.FAIRENTAL_URL}$_updatePayment';
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body, token: token);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> createPayment({dynamic body, String? token, List<dynamic>? images})async{
    try{
      String apiUrl = '${Str.FAIRENTAL_URL}$_createPayment';
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(
          apiUrl,
          body: body,
          infusedFiles: images,
          token: token,
      );
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> checkOutValues({dynamic id, String? token})async{
    try{
      String apiUrl = '${Str.FAIRENTAL_URL}admin/bookings/$id/$_checkOutValues';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, token: token);
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> saveCheckOut({required Map<String, dynamic> body, String? token, dynamic id, dynamic images})async{
    try{
      String apiUrl = '${Str.FAIRENTAL_URL}admin/bookings/$id/$_saveCheckOut';
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamicWithAutoIncrement(
        apiUrl,
        body: body,
        token: token,
        infusedFiles: images,
        autoIncrement: false,
      );
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else{
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");}
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateInsuranceRequirement({dynamic body, String? token})async{
    try{
      String apiUrl = '${Str.FAIRENTAL_URL}$_updateInsuranceRequirement';
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamic(apiUrl, token: token, body: body);
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else {
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateInsurance({required Map<String, dynamic> body, String? token, dynamic images})async{
    try{
      String apiUrl = '${Str.FAIRENTAL_URL}$_updateInsurance';
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamicWithAutoIncrement(
        apiUrl,
        body: body,
        token: token,
        infusedFiles: images,
        autoIncrement: false,
      );
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else{
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");}
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deleteInsurance({dynamic id, String? token}) async {
    try{
      String apiUrl = '${Str.FAIRENTAL_URL}$_deleteInsurance/$id';
      final http.Response? response = await _apiClient.callDelete(apiUrl, token: token);
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else{
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch(e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateDeposit({dynamic id, String? token, dynamic body}) async {
    try{
      String apiUrl = '${Str.FAIRENTAL_URL}$_adminBooking/$id/$_updateDeposit';
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body, token: token);
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else{
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
      } catch(e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> checkInOdometer({dynamic body, String? token}) async {
    try{
      String apiUrl = '${Str.FAIRENTAL_URL}$_adminBooking/$_checkIn/$_odometer';
      final http.Response? response = await _apiClient.callPostMethodWithRawBody(apiUrl, body: body, token: token);
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else{
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    } catch(e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getCheckInImages({dynamic id, String? token}) async {
    try{
      String apiUrl = '${Str.FAIRENTAL_URL}$_checkInImages/$id';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, token: token);
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else{
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> uploadCheckInImages({Map<String, dynamic>? body, dynamic infusedFiles}) async {
    try{
      String apiUrl = '${Str.BASE_URL}$_uploadCheckInImages';
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamicWithAutoIncrement(
        apiUrl,
        body: body,
        infusedFiles: infusedFiles,
        autoIncrement: false,
      );
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else{
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> deletePreCheckImage({dynamic id}) async {
    try {
      String apiUrl = '${Str.BASE_URL}$_deletePrecheckImage/$id';
      final http.Response? response = await _apiClient.callDelete(apiUrl);
      if (response?.isSuccess == true) {
        return await response.mapData;
      } else {
        throw Exception("${response?.statusCode}: ${jsonDecode(
            response?.body ?? "")?['message'] ??
            jsonDecode(response?.body ?? "")?['error'] ??
            "Some thing went wrong, try again later!..."}");
      }
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> saveFairentalPrecheck({dynamic infusedFiles, dynamic body})async{
    try{
      String apiUrl = '${Str.BASE_URL}$_saveFairentalPrecheck';
      final http.Response? response = await _apiClient.callPostMethodWithBodyDynamicWithAutoIncrement(
        apiUrl,
        body: body,
        infusedFiles: infusedFiles,
        autoIncrement: false,
      );
      if (response?.isSuccess == true) {
        return await response.mapData;
      }else{
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
      }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getBookingInfo({dynamic id, String? token}) async {
    try{
      String apiUrl = '${Str.FAIRENTAL_URL}$_bookingsInfo/$id';
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, token: token);
      if(response?.isSuccess == true){
        return await response.mapData;
      }else{
        throw Exception("${response?.statusCode}: ${jsonDecode(response?.body ?? "")?['message'] ?? jsonDecode(response?.body ?? "")?['error'] ?? "Some thing went wrong, try again later!..."}");
      }
    }catch(e){
      rethrow;
    }
  }

}
