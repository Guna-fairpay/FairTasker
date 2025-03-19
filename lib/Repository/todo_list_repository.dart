
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Response/chat_message_response.dart';
import 'package:fairpytasker/Response/create_expense_field_data.dart';
import 'package:fairpytasker/Response/create_todo_params.dart';
import 'package:fairpytasker/Response/create_todo_status_response.dart';
import 'package:fairpytasker/Response/cumulative_cost_response.dart';
import 'package:fairpytasker/Response/expense_summary_details_response.dart';
import 'package:fairpytasker/Response/expense_summary_response.dart';
import 'package:fairpytasker/Response/location_response.dart';
import 'package:fairpytasker/UI/Todo/maintenance/maintenance_check_list_response.dart';
import 'package:fairpytasker/Response/parts_response.dart';
import 'package:fairpytasker/Response/supplies_response.dart';
import 'package:fairpytasker/Response/task_category_group_response.dart';
import 'package:fairpytasker/Response/task_detail_response.dart';
import 'package:fairpytasker/Response/task_history_response.dart';
import 'package:fairpytasker/Response/task_history_configuration_response.dart';
import 'package:fairpytasker/Response/user_group_response.dart';
import 'package:fairpytasker/Response/vehicle_status_config_response.dart';
import 'package:fairpytasker/Response/vendor_response.dart';
import 'package:fairpytasker/Response/voice_response.dart';
import 'package:fairpytasker/Response/working_history_count_response.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Response/categories_response.dart';
import 'package:fairpytasker/Response/subcategories_response.dart';
import 'package:fairpytasker/Response/vehicle_grouping_response.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/response_extension.dart';
import 'package:fairpytasker/core/app/helper/converter.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:fairpytasker/main.dart';
import 'package:fairpytasker/Response/assigned_to_response.dart';
import 'package:fairpytasker/Response/general_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../Response/GetActiveHoursResponse.dart';
import '../Response/GetWorkingHoursData.dart';
import '../Response/branch_response.dart';
import '../Response/category_config_response.dart';
import '../UI/Todo/CheckList/checklist_response.dart';
import '../Response/cohorts_response.dart';
import '../Response/create_fix_task_data.dart';
import '../Response/expense_other_categories.dart';
import '../Response/expense_other_response.dart';
import '../Response/expense_person_response.dart';
import '../UI/Finance/Expense/Response/expense_response.dart';
import '../Response/finance_statement_response.dart';
import '../Response/payment_response.dart';
import '../Response/task_miles.dart';
import '../Response/task_response.dart';
import '../Response/todo_list_response.dart';
import '../Response/vehicle_list_response.dart';
import '../Response/vehicle_miscellaneous_response.dart';
import '../Response/vehicle_status_checklist_response.dart';
import '../Response/vehicle_status_response.dart';
import '../Response/vehicle_status_response_list.dart';
import '../Response/working_history_response.dart';
import '../Response/working_hours_get_response.dart';
import '../UI/Todo/create_sparekey_data.dart';
import '../UI/Todo/maintenance/get_todolist_Response.dart';

class TodoListRepo {
  ApiClient apiClient = ApiClient();
  String? selectedHours;
  String? chosenDateTimeString;
  DateTime? chosenDateTime;
  String? startTimeTFString;
  // DateTime? chosenStartingDateTime;
  String? endTimeString;
  String? endTimeTFString;
  bool isVehicleEdit = false;
  List<Map<String, dynamic>> vehicleHistoryTempSearchList = [];
  int? branch;



  Future<bool?> updateVehicleGroupForItem(
      int vehicleGroupId, List<String> vinList, String name) async {
    try {
      String apiUrl = '${Str.BASE_URL}group-vehicle/$vehicleGroupId';
      // PartsData().toJsonList(partList);
      String body = jsonEncode({"name": name, "vin": vinList});

      final http.Response? response =
      await apiClient.callPutMethod(apiUrl, body: body);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          GeneralResponse generalResponse =
          GeneralResponse.fromJson(json.decode(response.body));

          return true;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      debugPrint('updateSupplyForItem.exception : ${error.toString()}');
      return null;
    }
  }

  Future<TodoListResponse?> editTodoData({dynamic id}) async {
    try {
      String apiUrl = '${Str.BASE_URL}edit-todo/$id';
      debugPrint("edit-todo apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
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
      debugPrint('edit-todo.exception : ${error.toString()}');
      return null;
    }
  }

  Future<CreateExpenseFieldData?> fetchDropdownValues() async {
    try {
      String apiUrl = '${Str.LIST_BASE_URL}getCohortsData';
      debugPrint("fetchDropdownValues apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          // debugPrint('fetchDropdownValues api.response.body: ${response.body}');
          // debugPrint('fetchDropdownValues api.statusCode: ${response.statusCode}');

          CreateExpenseFieldData cohortsResponse =
          CreateExpenseFieldData.fromJson(json.decode(response.body));

          return cohortsResponse;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      debugPrint('getProfileAPI.exception : ${error.toString()}');
      return null;
    }
  }

  Future<VehicleGroupingResponse?> fetchVehicleGroupingList() async {
    try {
      String apiUrl = '${Str.BASE_URL}group-vehicle';
      debugPrint("fetchVehicleGroupingList apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
         debugPrint('fetchVehicleGroupingList api.statusCode: ${response.statusCode}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          // debugPrint('fetchVehicleGroupingList api.response.body: ${response.body}');

          VehicleGroupingResponse vehicleGroupingResponse =
          VehicleGroupingResponse.fromJson(json.decode(response.body));

          return vehicleGroupingResponse;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      // debugPrint('fetchVehicleGroupingList.exception : ${error.toString()}');
      return null;
    }
  }

  Future<VehicleStatusResponse?> fetchVehicleStatusCategoryList() async {
    try {
      String apiUrl = '${Str.LIST_BASE_URL}vehicle_status/categories';
      // debugPrint("fetchVehicleStatusCategoryList apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        // debugPrint('fetchVehicleStatusCategoryList api.statusCode: ${response.statusCode}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          // debugPrint('fetchVehicleStatusCategoryList api.response.body: ${response.body}');

          VehicleStatusResponse vehicleStatusResponse =
          VehicleStatusResponse.fromJson(json.decode(response.body));

          return vehicleStatusResponse;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      debugPrint(
          'fetchVehicleStatusCategoryList.exception : ${error.toString()}');
      return null;
    }
  }

  Future<UserGroupResponse?> fetchUserGroupingList() async {
    try {
      String apiUrl = '${Str.BASE_URL}group-person';
      debugPrint("fetchUserGroupingList apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
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
      debugPrint('fetchUserGroupingList.exception : ${error.toString()}');
      return null;
    }
  }

  Future<VehicleListResponse?> fetchVehicleList() async {
    try {
      String apiUrl = '${Str.LIST_BASE_URL}active_vehicles';
      debugPrint("fetchVehicleList apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          VehicleListResponse vehicleListResponse =
          VehicleListResponse.fromJson(json.decode(response.body));

          return vehicleListResponse;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      debugPrint('fetchVehicleList.exception : ${error.toString()}');
      return null;
    }
  }

  Future<TodoListResponse?> callTodoListAPI(
      String? selectedDate, String? status, String? resourceId) async {
    try {
      String apiUrl;
      Utils.getIntPreference(Str.branchIdPrefText).then((branchId) {
        branch = branchId;
      });

      if (resourceId != null && resourceId != '') {
        resourceId.replaceAll('-1,', '');
        //"${Str.BASE_URL}todo-data?resource=$resourceId&date=${selectedDate ?? DateTime.now()}&status=$status&branch_id=$branch";
        apiUrl =
        "${Str.BASE_URL}todo-data?resource=&date=${selectedDate ?? DateTime.now()}&status=$status&branch_id=$branch";
        //$resourceId
        "${Str.BASE_URL}todo-data?resource=&date=${selectedDate ?? DateTime.now()}&status=$status&branch_id=$branch";
       /// "${Str.BASE_URL}todo-data?resource=$resourceId&date=${selectedDate ?? DateTime.now()}&status=$status&branch_id=$branch";
      } else {
        apiUrl =
        "${Str.BASE_URL}todo-data?date=${selectedDate ?? DateTime.now()}&status=$status&branch_id=$branch";

      }
      debugPrint("callTodoListAPI apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        if (response.statusCode == 200) {
          TodoListResponse todoListResponse =
          TodoListResponse.fromJson(json.decode(response.body));
          if (todoListResponse.status != 200 &&
              todoListResponse.status != 201) {
            Utils.showNoResultFound();
            return null;
          } else {
            debugPrint('---------------> ${todoListResponse.status!}');
            return todoListResponse;
          }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('callLoginAPI.exception1 : ${error.toString()}');
      return null;
    }
  }

  Future<TaskHistoryResponse?> getWorkingTaskHistory(
      String start, String end, String userId) async {
    try {
      String apiUrl =
          "${Str.BASE_URL}employeeTaskHistory?user_id=$userId&from=$start&to=$end";
      debugPrint("getWorkingTaskHistory apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        // if (response.statusCode == 200) {

        TaskHistoryResponse taskHistoryResponse =
        TaskHistoryResponse.fromJson(jsonDecode(response.body));
        // if (employeeTaskHistoryResponse) {
        return taskHistoryResponse;
        /*}else {
            Utils.showNoResultFound();
            debugPrint('---------------> ${employeeTaskHistoryResponse.status!}');
            return null;
          }*/
        /*  } else {
          Utils.showSomethingWentWrong();
          return null;
        }*/
      } else {
        return null;
      }
    } catch (error) {
      log('getWorkingTaskHistory.exception : ${error.toString()}');
      return null;
    }
  }

  Future<WorkingHistoryResponse?> getWorkingHistory(
      String start, String end) async {
    try {
      String apiUrl =
          "${Str.GOPORTAL_BASE_URL}employeeWorkHours?startDate=$start&endDate=$end";
      debugPrint("getWorkingHistory apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        // if (response.statusCode == 200) {

        WorkingHistoryResponse assignedToResponse =
        WorkingHistoryResponse.fromJson(json.decode(response.body));
        if ((assignedToResponse.status ?? false)) {
          return assignedToResponse;
        } else {
          Utils.showNoResultFound();
          debugPrint('---------------> ${assignedToResponse.status!}');
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
      log('getWorkingHistory.exception : ${error.toString()}');
      return null;
    }
  }

  Future<TaskHistoryConfigurationResponse?>
  getTaskHistoryConfiguration() async {
    try {
      String apiUrl = "${Str.BASE_URL}getConfiguration";
      debugPrint("getTaskHistoryConfiguration apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        // if (response.statusCode == 200) {

        TaskHistoryConfigurationResponse configurationResponse =
        TaskHistoryConfigurationResponse.fromJson(
            json.decode(response.body));
        // if (configurationResponse != null) {
        return configurationResponse;
        /*}else {
            Utils.showNoResultFound();
            debugPrint('---------------> ${assignedToResponse.status!}');
            return null;
          }*/
        /*  } else {
          Utils.showSomethingWentWrong();
          return null;
        }*/
      } else {
        return null;
      }
    } catch (error) {
      log('getTaskHistoryConfiguration.exception : ${error.toString()}');
      return null;
    }
  }



  Future<VehicleStatusResponseList?> getVehicleStatus() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}vehicleStatusApi";
      debugPrint("getVehicleStatus apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        // if (response.statusCode == 200) {
        VehicleStatusResponseList assignedToResponse = await parseString<VehicleStatusResponseList>(response.body, (json) => VehicleStatusResponseList.fromJson(json));
        // VehicleStatusResponseList assignedToResponse =
        // VehicleStatusResponseList.fromJson(json.decode(response.body));

        return assignedToResponse;
        /*  } else {
          Utils.showSomethingWentWrong();
          return null;
        }*/
      } else {
        return null;
      }
    } catch (error) {
      log('getVehicleStatus.exception : ${error.toString()}');
      return null;
    }
  }

  Future<VehicleStatusChecklistResponse?> getVehicleStatusCheckList(
      String? vinNumber) async {
    try {
      String apiUrl =
          "${Str.LIST_BASE_URL}vehicle_status_checklist_api/$vinNumber";
      debugPrint("getVehicleStatusCheckList apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        // if (response.statusCode == 200) {

        VehicleStatusChecklistResponse vehicleStatusChecklistResponse =
        VehicleStatusChecklistResponse.fromJson(json.decode(response.body));
        if ((vehicleStatusChecklistResponse.data != null)) {
          return vehicleStatusChecklistResponse;
        } else {
          Utils.showNoResultFound();
          // debugPrint('getVehicleStatus ${assignedToResponse.status!}');
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
      log('getVehicleStatusCheckList.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> getVehicleActiveStatus(
      String? vinNumber, int? vehicleStatus) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}vehicleActiveStatus";
      String body =
      jsonEncode({"vin": vinNumber, "vehicle_status": vehicleStatus});
      debugPrint("getVehicleActiveStatus apiUrl: $apiUrl");
      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          // VehicleStatusChecklistResponse vehicleStatusChecklistResponse =
          // VehicleStatusChecklistResponse.fromJson(json.decode(response.body));
          // if ((vehicleStatusChecklistResponse.data != null)) {
          //   return vehicleStatusChecklistResponse.data;
          // }else {
          //   Utils.showNoResultFound();
          // debugPrint('getVehicleStatus ${assignedToResponse.status!}');
          // return null;
          // }
          return true;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getVehicleStatusCheckList.exception : ${error.toString()}');
      return null;
    }
  }

//--
  Future<bool?> deleteTaskConfiguration(int? id) async {
    try {
      String apiUrl = "${Str.BASE_URL}delete-configuration/$id";

      debugPrint("deleteTaskConfiguration apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          // VehicleStatusChecklistResponse vehicleStatusChecklistResponse =
          // VehicleStatusChecklistResponse.fromJson(json.decode(response.body));
          // if ((vehicleStatusChecklistResponse.data != null)) {
          //   return vehicleStatusChecklistResponse.data;
          // }else {
          //   Utils.showNoResultFound();
          // debugPrint('getVehicleStatus ${assignedToResponse.status!}');
          // return null;
          // }
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
  //---

  Future<CreateTodoStatusResponse?> getVehicleCreateStatusTodo(
      int? categoryId,
      int? cohortId,
      String? cohortName,
      int? userId,
      String? vehImage,
      String? vehName,
      String? vinNumber,
      bool? isCreate,
      {String? categoryName,
        int? soldId}) async {
    try {
      String apiUrl = '';
      if (isCreate!) {
        apiUrl = "${Str.BASE_URL}create-status-todo";
      } else {
        apiUrl = "${Str.BASE_URL}update-status-todo";
      }
      String body = jsonEncode({
        "vin": vinNumber,
        "category_id": categoryId,
        "cohort_id": cohortId,
        "cohort_name": cohortName,
        "user_id": userId == 1 ? 2 : userId,
        "vehicle_image": vehImage,
        "vehicle_name": vehName
      });
      debugPrint("getVehicleCreateStatusTodo apiUrl: $apiUrl");
      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      // debugPrint('getVehicleCreateStatusTodo api.statusCode: ${response!.statusCode}');
      // debugPrint('getVehicleCreateStatusTodo api.response.body1: ${response!.body}');
      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (categoryName == 'PreSale') {
          CreateTodoParams createTodoParams =
          CreateTodoParams(vin: vinNumber, vehicleStatusCategory: soldId);
          bool? result = await vehicleStatusUpdate(createTodoParams);
          return result == true ? CreateTodoStatusResponse() : null;
          // return await vehicleStatusUpdate(createTodoParams) ? CreateTodoStatusResponse() : null;
        } else {
          debugPrint(
              'getVehicleCreateStatusTodo api.response.body1: ${response.body}');
          CreateTodoStatusResponse createTodoStatusResponse =
          CreateTodoStatusResponse.fromJson(json.decode(response.body));
          return createTodoStatusResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getVehicleCreateStatusTodo.exception : ${error.toString()}');
      return null;
    }
  }

  Future<TaskDetailResponse?> getTaskDetailData(int? id) async {
    try {
      String apiUrl = "${Str.BASE_URL}edit-todo/$id";

      debugPrint("getVehicleCreateStatusTodo apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        TaskDetailResponse taskDetailResponse =
        TaskDetailResponse.fromJson(json.decode(response.body));
        return taskDetailResponse;
      } else {
        return null;
      }
    } catch (error) {
      log('getVehicleCreateStatusTodo.exception : ${error.toString()}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> cleanCar({required Map<String, dynamic> body}) async {
    String apiUrl = "${Str.BASE_URL}add-todo";
    final http.Response? response = await apiClient.callPostMethod(apiUrl, body: jsonEncode(body));
    if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
      return response.mapData;
    }
    return null;
  }

  Future<bool?> addVehicleCreateTodo(
      int? checklistId,
      int? categoryId,
      int? cohortId,
      String? status,
      int? userId,
      String? title,
      String? vehName,
      String? vinNumber,
      String? todoTime,
      String? startAt,
      int? statusId) async {
    try {
      String apiUrl = "${Str.BASE_URL}add-todo";

      String body = jsonEncode({
        "vehicle_status_checklist": checklistId,
        "vehicle_status_category": categoryId,
        "status": status,
        "vehicle_status_id": statusId,
        "vin": vinNumber,
        "title": title,
        "user_id": int.parse(userIdGlobal) == 1 ? 2 : 1,
        "cohort_id": cohortId,
        "start_at": startAt,
        "todo_time": todoTime,
        "vehicle_name": vehName
      });
      // debugPrint("addVehicleCreateTodo apiUrl: $apiUrl");
      // debugPrint("addVehicleCreateTodo apiUrl: $body");
      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      debugPrint(
          'addVehicleCreateTodo api.statusCode: ${response!.statusCode}');
      //debugPrint('addVehicleCreateTodo api.response.body1: ${response.body}');
      print("Create Todo:${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        // GeneralResponse generalResponse = GeneralResponse.fromJson(json.decode(response.body));
        return true;
      } else {
        return null;
      }
    } catch (error) {
      log('addVehicleCreateTodo.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> selectedVehicleCategories(String? vinNumber, int? categoryId,
      int? checkboxValue, List<int>? categoryIds, int? isApi) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}vehicle_config/select_categories";
      String body = jsonEncode({
        "vin": vinNumber,
        "category_id": categoryId,
        "checkbox_value": checkboxValue,
        "isApi": isApi,
        "categoryIds": categoryIds
      });

      // debugPrint("selectedVehicleCategories apiUrl: $apiUrl");
      // debugPrint("selectedVehicleCategories body: $body");

      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null && response.statusCode == 200) {
        // if (response.statusCode == 200) {
        //  debugPrint('selectedVehicleCategories api.response.body1: ${response.body}');
        // debugPrint('selectedVehicleCategories api.statusCode: ${response.statusCode}');

        return true;
        /*  } else {
          Utils.showSomethingWentWrong();
          return null;
        }*/
      } else {
        return null;
      }
    } catch (error) {
      log('selectedVehicleCategories.exception : ${error.toString()}');
      return null;
    }
  }

  Future<VehicleStatusConfigResponse?> getVehicleStatusConfigList(
      String? vinNumber) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}vehicle_config/categories";
      String body = jsonEncode({"vin": vinNumber});

      debugPrint("getVehicleStatusConfigList apiUrl: $apiUrl");

      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        // if (response.statusCode == 200) {
        //  debugPrint('getVehicleStatusConfigList api.response.body1: ${response.body}');
        // debugPrint('getVehicleStatusConfigList api.statusCode: ${response.statusCode}');

        VehicleStatusConfigResponse vehicleStatusChecklistResponse =
        VehicleStatusConfigResponse.fromJson(json.decode(response.body));

        return vehicleStatusChecklistResponse;
        /*  } else {
          Utils.showSomethingWentWrong();
          return null;
        }*/
      } else {
        return null;
      }
    } catch (error) {
      log('getVehicleStatusConfigList.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> reorderVehicleStatusCheckList(
      String? vinNumber, int? categoryId, List<dynamic>? orderList) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}vehicle_config/checklist_reorder";
      String body = jsonEncode({
        "vin": vinNumber,
        "categoryId": categoryId,
        "orderChecklist": orderList
      });

      // debugPrint("reorderVehicleStatusCheckList apiUrl: $apiUrl");
      // debugPrint("reorderVehicleStatusCheckList body: $body");

      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        if (response.statusCode == 200) {
          //  debugPrint('reorderVehicleStatusCheckList api.response.body1: ${response.body}');
          // debugPrint('reorderVehicleStatusCheckList api.statusCode: ${response.statusCode}');

/*
          VehicleStatusConfigResponse vehicleStatusChecklistResponse =
          VehicleStatusConfigResponse.fromJson(json.decode(response.body));
*/

          return true;
        } else {
          Utils.showSomethingWentWrong();
          return false;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('reorderVehicleStatusCheckList.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> vehicleStatusCheckListCheck(
      String? vinNumber,
      int? categoryId,
      bool? checked,
      int? checkItemId,
      String? type,
      List<String>? categoryIds) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}vehicle_config/checklist";
      String body = jsonEncode({
        "vin": vinNumber,
        "categoryIds": categoryIds,
        "category_id": categoryId,
        "checkbox_value": (checked! ? 1 : 0),
        if (type != null) "type": type,
        if (type == null) "checklist_id": checkItemId,
        "isApi": 1
      });

      debugPrint("vehicleStatusCheckListCheck apiUrl: $apiUrl");
      debugPrint("vehicleStatusCheckListCheck body: $body");

      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        debugPrint(
            'vehicleStatusCheckListCheck api.statusCode: ${response.statusCode}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint(
              'vehicleStatusCheckListCheck api.response.body1: ${response.body}');

/*
          VehicleStatusConfigResponse vehicleStatusChecklistResponse =
          VehicleStatusConfigResponse.fromJson(json.decode(response.body));
*/

          return true;
        } else {
          Utils.showSomethingWentWrong();
          return false;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('vehicleStatusCheckListCheck.exception : ${error.toString()}');
      return null;
    }
  }

  Future<VehicleMiscellaneousResponse?> getMiscellaneousVehiclesList() async {
    try {
      String apiUrl =
          "${Str.LIST_BASE_URL}vehicle_config/miscellaneous_vehicles";
      debugPrint("getMiscellaneousVehiclesList apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        // if (response.statusCode == 200) {
        debugPrint(
            'getMiscellaneousVehiclesList api.response.body1: ${response.body}');
        debugPrint(
            'getMiscellaneousVehiclesList api.statusCode: ${response.statusCode}');

        VehicleMiscellaneousResponse vehicleMiscellaneousResponse =
        VehicleMiscellaneousResponse.fromJson(json.decode(response.body));
        // if ((vehicleMiscellaneousResponse.data != null)) {
        return vehicleMiscellaneousResponse;
        // }else {
        //   Utils.showNoResultFound();
        // debugPrint('getVehicleStatus ${assignedToResponse.status!}');
        // return null;
        // }
        /*  } else {
          Utils.showSomethingWentWrong();
          return null;
        }*/
      } else {
        return null;
      }
    } catch (error) {
      log('getMiscellaneousVehiclesList.exception : ${error.toString()}');
      return null;
    }
  }

  Future<AssignedToResponse?> getAssignedTo() async {
    try {
      String apiUrl = "${Str.BASE_URL}getresources";
      debugPrint("getAssignedTo apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
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

  Future<PartsResponse?> getParts() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}vehicle-parts-list";
      debugPrint("getParts apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        PartsResponse partsResponse =
        PartsResponse.fromJson(json.decode(response.body));
        if (response.statusCode == 200 || response.statusCode == 201) {
          return partsResponse;
        } else {
          Utils.showNoResultFound();
          debugPrint('getParts response.statusCode: ${response.statusCode}');
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
      log('getParts.exception : ${error.toString()}');
      return null;
    }
  }

  Future<CategoriesResponse?> getCategories() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}expenses_category";
      debugPrint("getCategories apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        CategoriesResponse categoriesResponse =
        CategoriesResponse.fromJson(json.decode(response.body));
        if (response.statusCode == 200 || response.statusCode == 201) {
          return categoriesResponse;
        } else {
          Utils.showNoResultFound();
          debugPrint(
              'getCategories response.statusCode: ${response.statusCode}');
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
      log('getCategories.exception : ${error.toString()}');
      return null;
    }
  }

  Future<SubCategoriesResponse?> getSubCategories() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}expenses_category";
      debugPrint("getCategories apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        // if (response.statusCode == 200) {
        debugPrint('getCategories api.statusCode: ${response.statusCode}');

        SubCategoriesResponse categoriesResponse =
        SubCategoriesResponse.fromJson(json.decode(response.body));
        if (response.statusCode == 200 || response.statusCode == 201) {
          return categoriesResponse;
        } else {
          Utils.showNoResultFound();
          debugPrint(
              'getCategories response.statusCode: ${response.statusCode}');
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
      log('getCategories.exception : ${error.toString()}');
      return null;
    }
  }

  Future<SuppliesResponse?> getSupplies() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}vehicle-supplies";
      debugPrint("getSupplies apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        SuppliesResponse suppliesResponse =
        SuppliesResponse.fromJson(json.decode(response.body));
        if (response.statusCode == 200 || response.statusCode == 201) {
          return suppliesResponse;
        } else {
          Utils.showNoResultFound();
          debugPrint('getSupplies response.statusCode: ${response.statusCode}');
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
      log('getSupplies.exception : ${error.toString()}');
      return null;
    }
  }

  Future<TaskExpenseResponse?> getTaskExpense() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}task-expenses-data";
      debugPrint("getTaskExpense apiUrl:2 $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        // if (response.statusCode == 200) {
        TaskExpenseResponse assignedToResponse =
        TaskExpenseResponse.fromJson(json.decode(response.body));
        if (assignedToResponse.data != null) {
          return assignedToResponse;
        } else {
          Utils.showNoResultFound();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getTaskExpense.exception : ${error.toString()}');
      return null;
    }
  }

  Future<ExpenseSummaryResponse?> getExpenseSummary(String? vinNumber) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}getVehicleExpenses/$vinNumber";
      debugPrint("getExpenseSummary apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        // if (response.statusCode == 200) {
        log('getExpenseSummary api.response.body: ${response.body}');
        debugPrint('getExpenseSummary api.statusCode: ${response.statusCode}');

        ExpenseSummaryResponse expenseSummaryResponse =
        ExpenseSummaryResponse.fromJson(json.decode(response.body));
        // if (expenseSummaryResponse != null) {
        return expenseSummaryResponse;
        // }else {
        //   Utils.showNoResultFound();
        //   return null;
        // }
      } else {
        return null;
      }
    } catch (error) {
      log('getExpenseSummary.exception : ${error.toString()}');
      return null;
    }
  }

  Future<VendorResponse?> getVendor() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}vendors";
      debugPrint("getAssignedTo apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        // if (response.statusCode == 200) {
        //   debugPrint('getAssignedTo api.response.body3: ${response.body}');
        //   debugPrint('getAssignedTo api.statusCode: ${response.statusCode}');

        VendorResponse assignedToResponse =
        VendorResponse.fromJson(json.decode(response.body));
        if (assignedToResponse.data != null) {
          return assignedToResponse;
        } else {
          Utils.showNoResultFound();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getAssignedTo.exception : ${error.toString()}');
      return null;
    }
  }

  Future<LocationResponse?> getLocation() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}locations";
      debugPrint("getLocation apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        LocationResponse assignedToResponse =
        LocationResponse.fromJson(json.decode(response.body));
        if (assignedToResponse.data != null) {
          return assignedToResponse;
        } else {
          Utils.showNoResultFound();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getLocation.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> createATodo(CreateTodoParams createTodoParams) async {
    try {
      String apiUrl = '';
      if (createTodoParams.todoId != null) {
        apiUrl = "${Str.BASE_URL}update-todo/${createTodoParams.todoId}";
      } else {
        apiUrl = "${Str.BASE_URL}add-todo";
      }
      Map<String, String> body = {
        "title": createTodoParams.todoTitle.toString(),
        if (createTodoParams.todoId != null)
          "todo_date": createTodoParams.todoDate.toString()
        else "start_at": createTodoParams.todoDate.toString(),
        if (createTodoParams.todoId != null)
          "type": "Inline",
        // if(createTodoParams.existingUserGroupId != null)
        //   "user_group_id": createTodoParams.existingUserGroupId!.toString(),
        "todo_time": createTodoParams.todoTime.toString(),
        "priority": createTodoParams.priority.toString(),
        "assigned_to": createTodoParams.assignedTo.toString(),
        "cohort_id": createTodoParams.cohortId.toString(),
        "cohort_name": createTodoParams.cohortName.toString(),
        "vin": createTodoParams.vin.toString(),
        "vehicle_name": createTodoParams.vehicleName.toString(),
        "vehicle_image": createTodoParams.vehicleImage.toString(),
        "maintenance_task_id":createTodoParams.maintenanceTaskId.toString(),
        "repeatPeriod":
        (createTodoParams.repeatPeriod ?? '').toString().toLowerCase(),
        "repeatDay":
        (createTodoParams.repeatDay ?? '').toString().toLowerCase(),
        "repeatWeek":
        (createTodoParams.repeatWeek ?? '').toString().toLowerCase(),
        "weekDay": createTodoParams.weekDay.toString(),
        "recur_monthly_type":
        (createTodoParams.recurMonthlyType ?? '').toString().toLowerCase(),
        "repeatDateMonth":
        (createTodoParams.repeatDateMonth ?? '').toString().toLowerCase(),
        "repeatMonth":
        (createTodoParams.repeatMonth ?? '').toString().toLowerCase(),
        "repeatDayMonth":
        (createTodoParams.repeatDayMonth ?? '').toString().toLowerCase(),
        "repeatDateYear":
        (createTodoParams.repeatDateYear ?? '').toString().toLowerCase(),
        "repeatMonthYear":
        (createTodoParams.repeatMonthYear ?? '').toString().toLowerCase(),
        "end_type": (createTodoParams.endType ?? '').toString().toLowerCase(),
        "end_at": (createTodoParams.endAt ?? '').toString().toLowerCase(),
        "end_after": (createTodoParams.endAfter ?? '').toString().toLowerCase(),
        "reminder":
        (createTodoParams.todoReminder ?? '').toString().toLowerCase(),
        "person": createTodoParams.person.toString(),
        "person_id": createTodoParams.personId.toString(),
        "time_sensitive":createTodoParams.timeSensitive.toString(),
        "vendor_id": createTodoParams.vendorId.toString(),
        "vendor_name": createTodoParams.vendorName.toString(),
        "location": createTodoParams.location.toString(),
        "location_id": createTodoParams.locationId.toString(),
        if (createTodoParams.multipleAddressList != null)
          "address": createTodoParams.multipleAddressList.toString(),
        "parts": createTodoParams.partList.toString(),
        "supplies": createTodoParams.supplyList.toString(),
        "notes": createTodoParams.notes.toString(),
        "vehicle_group_id": createTodoParams.vehicleGroupId.toString(),
        if (createTodoParams.todoId != null)
          "user_group_data": createTodoParams.selectedUserGroupId == null
              ? ''
              : (createTodoParams.selectedUserGroupId ?? []).toString(),
        "user_id": createTodoParams.selectedUserId == null
            ? ''
            : (createTodoParams.selectedUserId!).toString(),
        "vehicles": "${(createTodoParams.vehicleList ?? []).distinct((element) => element['vin']).map((e) => jsonEncode(e)).toList()}",
        "custom_link_id":"${createTodoParams.customLinkId ?? ""}",
        "custom_link":createTodoParams.customLink.toString(),
        "reference_id":createTodoParams.referenceId.toString(),
        "platform": "TaskerApp",
      };
      // var todoImages = createTodoParams.todoImage.mapIndexed((index, element) => http.MultipartFile.fromString("images[$index]", element.path));
      //debugPrint("createATodo apiUrl: $apiUrl");
      log("${jsonEncode(body)}", name: "POST_BODY");
      final http.Response? response =
      await apiClient.callPostMethodWithBody(apiUrl, body: body, files: createTodoParams.todoImage.map((e) => e.path).toList());
      if (response != null) {
        log('createATodo api.response.body: ${response.body}');
        if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('createATodo api.response.body: ${response.body}');
        debugPrint('createATodo api.statusCode: ${response.statusCode}');
        GeneralResponse generalResponse =
        GeneralResponse.fromJson(json.decode(response.body));
        if (generalResponse.status == 200 || generalResponse.status == 201) {
          Utils.showMobileToast(generalResponse.message!);
          return true;
        } else {
          Utils.showSomethingWentWrong();
          return false;
        }
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

 /* Future<bool?> createATodo(CreateTodoParams createTodoParams) async {
    try {
      String apiUrl = '';
      if (createTodoParams.userId != null && createTodoParams.userId!.isNotEmpty) {
        apiUrl = "${Str.BASE_URL}update-todo/${createTodoParams.userId}";
      } else {
        apiUrl = "${Str.BASE_URL}add-todo";
      }
      // Add fields to the request
      Map<String, String> reqMap={
        "title": createTodoParams.todoTitle ?? '',
        if (createTodoParams.userId != null && createTodoParams.userId!.isNotEmpty)
          "todo_date": createTodoParams.todoDate ?? '',
        if (createTodoParams.userId == null || createTodoParams.userId!.isEmpty)
          "start_at": createTodoParams.todoDate ?? '',
        if (createTodoParams.userId != null && createTodoParams.userId!.isNotEmpty)
          "type": "Inline",
        "todo_time": createTodoParams.todoTime ?? '',
        "priority": createTodoParams.priority ?? '',
        "assigned_to": jsonEncode(createTodoParams.assignedTo ?? []),
        "cohort_id": createTodoParams.cohortId ?? '',
        "cohort_name": createTodoParams.cohortName ?? '',
        "vin": createTodoParams.vin ?? '',
        "vehicle_name": createTodoParams.vehicleName ?? '',
        "vehicle_image": createTodoParams.vehicleImage ?? '',
        "repeatPeriod": createTodoParams.repeatPeriod ?? '',
        "repeatDay": createTodoParams.repeatDay ?? '',
        "repeatWeek": createTodoParams.repeatWeek ?? '',
        "weekDay": jsonEncode(createTodoParams.weekDay ?? []),
        "recur_monthly_type": createTodoParams.recurMonthlyType ?? '',
        "repeatDateMonth": createTodoParams.repeatDateMonth ?? '',
        "repeatMonth": createTodoParams.repeatMonth ?? '',
        "repeatDateYear": createTodoParams.repeatDateYear ?? '',
        "repeatDayMonth": createTodoParams.repeatDayMonth ?? '',
        "repeatMonthYear": createTodoParams.repeatMonthYear ?? '',
        "end_type": createTodoParams.endType ?? '',
        "end_at": createTodoParams.endAt ?? '',
        "end_after": createTodoParams.endAfter ?? '',
        "reminder": createTodoParams.todoReminder ?? '',
        "time_sensitive": createTodoParams.timeSensitive?.toString() ?? '',
        "person": createTodoParams.person ?? '',
        "person_id": createTodoParams.personId ?? '',
        "vendor_id": createTodoParams.vendorId ?? '',
        "vendor_name": createTodoParams.vendorName ?? '',
        "location": createTodoParams.location ?? '',
        "location_id": createTodoParams.locationId ?? '',
        if (createTodoParams.multipleAddressList != null)
          "address": jsonEncode(createTodoParams.multipleAddressList ?? []),
        "notes": createTodoParams.notes ?? '',
        "parts": jsonEncode(createTodoParams.partList),
        "supplies": jsonEncode(createTodoParams.supplyList),
        "vehicle_group_id": createTodoParams.vehicleGroupId ?? '',
        if (createTodoParams.userId != null &&
            createTodoParams.userId!.isNotEmpty)
          "user_group_data": createTodoParams.selectedUserGroupId == null
              ? ''
              : jsonEncode(createTodoParams.selectedUserGroupId ?? []),
        "user_id": createTodoParams.selectedUserId?.toString() ?? '',
        "vehicles": jsonEncode(createTodoParams.vehicleList ?? []),
        "custom_link_id": createTodoParams.customLinkId?.toString() ?? '',
        "custom_link": createTodoParams.customLink ?? '',
        "reference_id": createTodoParams.referenceId ?? '',
      };
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers.addAll(Utils.getHeaders());
      request.fields.addAll(reqMap);
      for (int i = 0; i < (createTodoParams.todoImage.length); i++) {
        var file = createTodoParams.todoImage[i];

        var multipartFile = http.MultipartFile.fromBytes(
          'todoimages[$i]',
          (await file.readAsBytes()).toList(),
          filename: file.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      // Send the request
      var response = await request.send();
      debugPrint('createTodoParams.statusCode: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseBody = await response.stream.bytesToString();
        debugPrint('createATodo response.body: $responseBody');
        GeneralResponse generalResponse =
        GeneralResponse.fromJson(json.decode(responseBody));
        if (generalResponse.status == 200 || generalResponse.status == 201) {
          Utils.showMobileToast(generalResponse.message!);
          return true;
        } else {
          Utils.showSomethingWentWrong();
          return false;
        }
      } else {
        Utils.showSomethingWentWrong();
        return null;
      }
    } catch (error) {
      log('createATodo.exception: ${error.toString()}');
      return null;
    }
  }*/



  Future<ExpenseSummaryResponse?> getAExpenseTodo(String? expenseId) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}expenses/$expenseId/edit";

      debugPrint("getAExpenseTodo apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        debugPrint('getAExpenseTodo api.response.body: ${response.body}');
        debugPrint('getAExpenseTodo api.statusCode: ${response.statusCode}');

        ExpenseSummaryResponse expenseSummaryResponse =
        ExpenseSummaryResponse.fromJson(json.decode(response.body));

        debugPrint('getAExpenseTodo api.statusCode: $expenseSummaryResponse');
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Utils.showMobileToast(generalResponse.message!);
          return expenseSummaryResponse;
        } else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          Utils.showSomethingWentWrong();
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
      log('getAExpenseTodo.exception : ${error.toString()}');
      return null;
    }
  }

  Future<ExpenseSummaryDetailResponse?> getAExpenseDetailTodo(
      String? expenseId) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}expenses/$expenseId/edit";

      debugPrint("getAExpenseDetailTodo apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        debugPrint('getAExpenseDetailTodo api.response.body: ${response.body}');
        debugPrint(
            'getAExpenseDetailTodo api.statusCode: ${response.statusCode}');

        ExpenseSummaryDetailResponse vehiclesData =
        ExpenseSummaryDetailResponse.fromJson(json.decode(response.body));
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Utils.showMobileToast(generalResponse.message!);
          return vehiclesData;
        } else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          Utils.showSomethingWentWrong();
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
      log('getAExpenseDetailTodo.exception : ${error.toString()}');
      return null;
    }
  }

  Future<CumulativeCostResponse?> getCumulativeCostList(String? vin) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}cumulative_cost/$vin";

      debugPrint("getCumulativeCostList apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        debugPrint('getCumulativeCostList api.response.body: ${response.body}');
        debugPrint(
            'getCumulativeCostList api.statusCode: ${response.statusCode}');

        CumulativeCostResponse cumulativeCostResponse =
        CumulativeCostResponse.fromJson(json.decode(response.body));
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Utils.showMobileToast(generalResponse.message!);
          return cumulativeCostResponse;
        } else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          Utils.showSomethingWentWrong();
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
      log('getCumulativeCostList.exception : ${error.toString()}');
      return null;
    }
  }

  Future<WorkingHoursGetResponse?> getWorkingHourByUser(int? id) async {
    try {
      String apiUrl = "${Str.GOPORTAL_BASE_URL}getWorkingHourByUser/$id";

      debugPrint("getWorkingHourByUser apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        debugPrint('getWorkingHourByUser api.response.body: ${response.body}');
        debugPrint(
            'getWorkingHourByUser api.statusCode: ${response.statusCode}');

        WorkingHoursGetResponse workingHoursGetResponse =
        WorkingHoursGetResponse.fromJson(json.decode(response.body));
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Utils.showMobileToast(generalResponse.message!);
          return workingHoursGetResponse;
        } else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          Utils.showSomethingWentWrong();
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
      log('getWorkingHourByUser.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> editExpenseTodo(
      int? expenseId,
      int? todoId,
      int? paymentMethodId,
      String? expenseAmount,
      String? expenseDescription,
      int? categoryId,
      int? subcategoryId,
      int? expenseTo,
      String? cohortId,
      String? vin,
      String? expenseDate,
      ) async {
    try{
      String apiUrl = "${Str.BASE_URL}update-todo/$todoId";
      String body;
      body = jsonEncode({
        "type": "Inline",
        "expense_id": expenseId,
        "payment_method_id": paymentMethodId,
        "expense_amount": expenseAmount,
        "expense_description": expenseDescription,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "expense_to": expenseTo,
        "cohort_id": cohortId,
        "vin": vin,
        "expense_date": expenseDate,
      });
      debugPrint("editExpenseTodo apiUrl: $apiUrl");
      debugPrint("editExpenseTodo body: $body");
      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
          debugPrint('editExpenseTodo api.response.body: ${response.body}');
          debugPrint('editExpenseTodo api.statusCode: ${response.statusCode}');
          GeneralResponse generalResponse =
          GeneralResponse.fromJson(json.decode(response.body));
          if (generalResponse.status == 200 || generalResponse.status == 201) {
            Utils.showMobileToast(generalResponse.message!);
            return true;
          } else {
            Utils.showSomethingWentWrong();
            return false;
          }
      }
      else{
        Utils.showSomethingWentWrong();
        return null;
      }
    }catch(e){
      log('editExpenseTodo.exception : ${e.toString()}');
      return null;
    }
  }



  Future<bool?> editATodoDate(
      String todoId,
      String? todoDate,
      bool? isDate,
      String? todoTime,
      List<String?>? resourceIdList,
      int? resourceId,
      String? notes,
      String? expenseId,
      List<int>? addresses) async {
    try {
      String apiUrl = "${Str.BASE_URL}update-todo/$todoId";
      String body;
      if (isDate != null) {
        if (isDate) {
          body = jsonEncode(
              {"type": "Inline", "todo_date": todoDate, "todo_time": todoTime});
        } else {
          body = jsonEncode({"type": "Inline", "todo_time": todoTime});
        }
      } else if (resourceIdList != null && resourceIdList.isNotEmpty) {
        // String jsonResourceStringList = jsonEncode(resourceIdList);
        // debugPrint("editATodoDate jsonResourceStringList: $jsonResourceStringList");
        // debugPrint("editATodoDate jsonResourceStringList1: ${jsonResourceStringList.toString()}");
        body = jsonEncode(
            {"type": "Inline", "user_group_data": resourceIdList.toString()});
      } else if (resourceId != null) {
        body = jsonEncode({"type": "Inline", 'user_id': resourceId.toString()});
      } else if (expenseId != null) {
        body = jsonEncode({"type": "Inline", 'expense_id': expenseId});
      } else if (addresses != null) {
        body = jsonEncode({"type": "Inline", 'address': addresses});
      } else {
        body = jsonEncode({"type": "Inline", 'notes': notes});
      }
      debugPrint("editATodoDate apiUrl: $apiUrl");
      debugPrint("editATodoDate body: $body");
      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        /*if (response.statusCode == 200 || response.statusCode == 201) {*/

        debugPrint('editATodoDate api.response.body: ${response.body}');

        GeneralResponse generalResponse =
        GeneralResponse.fromJson(json.decode(response.body));
        if (generalResponse.status == 200 || generalResponse.status == 201) {
          Utils.showMobileToast(generalResponse.message!);
          return true;
        } else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
         Utils.showSomethingWentWrong();
          return false;
        }
        /*  } else {
          Utils.showSomethingWentWrong();
          return null;
        }*/
      } else {
        return null;
      }
    } catch (error) {
      log('editATodoDate.exception : ${error.toString()}');
      return null;
    }
  }

 /* Future<bool?> editAVehiclePerson(
      int? todoId,
      int? todoUserId,
      String? todoVehicleName,
      int? cohortId,
      String? personName,
      String? cohortName,
      String? vin,
      String? vehicleImage,
      int? vehicleNumber) async {
    try {
      String apiUrl = "${Str.BASE_URL}update-todo/$todoId";
      String body;
      body = jsonEncode({
        "type": "Inline",
        "vehicle_name": todoVehicleName ?? '',
        "cohort_id": '${cohortId ?? 0}',
        "person_id": '${todoUserId ?? 0}',
        "person": personName ?? '',
        "cohort_name": cohortName ?? '',
        "vin": vin ?? '',
        "vehicle_image": vehicleImage ?? '',
        "vehicle_number": vehicleNumber ?? ''
      });

      debugPrint("editAVehiclePerson apiUrl: $apiUrl");
      debugPrint("editAVehiclePerson body: $body");
      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        *//*if (response.statusCode == 200 || response.statusCode == 201) {*//*

        debugPrint('editAVehiclePerson api.response.body: ${response.body}');
        debugPrint('editAVehiclePerson api.statusCode: ${response.statusCode}');

        GeneralResponse generalResponse =
        GeneralResponse.fromJson(json.decode(response.body));
        if (generalResponse.status == 200 || generalResponse.status == 201) {
          Utils.showMobileToast(generalResponse.message!);
          return true;
        } else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          Utils.showSomethingWentWrong();
          return false;
        }
          } else {
          Utils.showSomethingWentWrong();
          return null;
        }
    } catch (error) {
      log('editAVehiclePerson.exception : ${error.toString()}');
      return null;
    }
  }*/

  Future<bool?> editAVehiclePerson(
  int? todoId, List<dynamic> vehiclePersonData,String? person,String? personId,String? vehicleGroupId) async {
    try {
      String apiUrl = "${Str.BASE_URL}update-todo/$todoId";
      String body;
      body = jsonEncode({
        "type": "Inline",
        "vehicles":vehiclePersonData,
        "person":person,
        "person_id":personId,
        "vehicle_group_id":vehicleGroupId
      });
      debugPrint("editAVehiclePerson apiUrl: $apiUrl");
      debugPrint("editAVehiclePerson body: $body");
      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        /*if (response.statusCode == 200 || response.statusCode == 201) {*/

        /*debugPrint('editAVehiclePerson api.response.body: ${response.body}');
        debugPrint('editAVehiclePerson api.statusCode: ${response.statusCode}');
*/
        GeneralResponse generalResponse =
        GeneralResponse.fromJson(json.decode(response.body));
        if (generalResponse.status == 200 || generalResponse.status == 201) {
          Utils.showMobileToast(generalResponse.message!);
          return true;
        } else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          Utils.showSomethingWentWrong();
          return false;
        }
      } else {
        Utils.showSomethingWentWrong();
        return null;
      }
    } catch (error) {
      log('editAVehiclePerson.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> editAExpenseTodo(
      int? todoId,
      int? categoryId,
      int? subCategoryId,
      int? expenseTo,
      String? expenseAmount,
      String? expenseDescription,
      String? categoryName,
      String? subCategoryName) async {
    try {
      String apiUrl = "${Str.BASE_URL}update-todo/$todoId";
      String body;
      body = jsonEncode({
        "type": "Inline",
        "category_id": categoryId,
        "category_name": categoryName,
        "subcategory_id": subCategoryId,
        "subcategory_name": subCategoryName,
        "expense_to": expenseTo,
        "expense_amount": expenseAmount,
        "expense_description": expenseDescription
      });

      debugPrint("editAExpenseTodo apiUrl: $apiUrl");
      debugPrint("editAExpenseTodo body: $body");
      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        /*if (response.statusCode == 200 || response.statusCode == 201) {*/

        debugPrint('editAExpenseTodo api.response.body: ${response.body}');
        debugPrint('editAExpenseTodo api.statusCode: ${response.statusCode}');

        GeneralResponse generalResponse =
        GeneralResponse.fromJson(json.decode(response.body));
        if (generalResponse.status == 200 || generalResponse.status == 201) {
          Utils.showMobileToast(generalResponse.message!);
          return true;
        } else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          Utils.showSomethingWentWrong();
          return false;
        }
        /*  } else {
          Utils.showSomethingWentWrong();
          return null;
        }*/
      } else {
        return null;
      }
    } catch (error) {
      log('editAExpenseTodo.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> editAVendorLocation(int todoId, String? vendorName,
      String? locationName, int? vendorId, int? locationId) async {
    try {
      String apiUrl = "${Str.BASE_URL}update-todo/$todoId";
      String body;
      // if(vendorName == null) {
      body = jsonEncode({
        "type": "Inline",
        "location": locationName ?? '',
        "location_id": locationId ?? 0,
        "vendor_id": vendorId ?? 0,
        "vendor_name": vendorName ?? ''
      });
/*      }else{
        body = jsonEncode({"type": "Inline", "VendorName": vendorName});
      }*/
      debugPrint("editAVendorLocation apiUrl: $apiUrl");
      debugPrint("editAVendorLocation body: $body");
      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        /*if (response.statusCode == 200 || response.statusCode == 201) {*/

        debugPrint('editAVendorLocation api.response.body: ${response.body}');
        debugPrint(
            'editAVendorLocation api.statusCode: ${response.statusCode}');

        GeneralResponse generalResponse =
        GeneralResponse.fromJson(json.decode(response.body));
        if (generalResponse.status == 200 || generalResponse.status == 201) {
          Utils.showMobileToast(generalResponse.message!);
          return true;
        } else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          Utils.showSomethingWentWrong();
          return false;
        }
        /*  } else {
          Utils.showSomethingWentWrong();
          return null;
        }*/
      } else {
        return null;
      }
    } catch (error) {
      log('editAVendorLocation.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> swapTodo(String fromId, String toId) async {
    try {
      String apiUrl = "${Str.BASE_URL}swap-todo";

      String body = jsonEncode({"from": fromId, "to": toId});

      debugPrint("swapTodo apiUrl: $apiUrl");
      debugPrint("swapTodo body: $body");
      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        /*if (response.statusCode == 200 || response.statusCode == 201) {*/

        debugPrint('swapTodo api.response.body: ${response.body}');
        debugPrint('swapTodo api.statusCode: ${response.statusCode}');

        GeneralResponse generalResponse =
        GeneralResponse.fromJson(json.decode(response.body));
        if (generalResponse.status == 200 || generalResponse.status == 201) {
          Utils.showMobileToast(generalResponse.message!);
          return true;
        } else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          Utils.showSomethingWentWrong();
          return false;
        }
        /*  } else {
          Utils.showSomethingWentWrong();
          return null;
        }*/
      } else {
        return null;
      }
    } catch (error) {
      log('swapTodo.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> createVehicleStatusTodo(
      CreateTodoParams createTodoParams) async {
    try {
      String apiUrl = "${Str.BASE_URL}add-todo";
      String body = jsonEncode({
        "title": createTodoParams.todoTitle,
        "start_at": createTodoParams.todoDate,
        "todo_time": createTodoParams.todoTime,
        "user_id": createTodoParams.todoId,
        "cohort_id": createTodoParams.cohortId,
        "vin": createTodoParams.vin,
        "vehicle_name": createTodoParams.vehicleName,
        "notes": createTodoParams.notes,
        "vehicle_status_id": createTodoParams.vehicleStatusId,
        "vehicle_status_checklist": createTodoParams.vehicleStatusChecklist,
        "vehicle_status_category": createTodoParams.vehicleStatusCategory,
        "custom_task": createTodoParams.customTask
      });
      debugPrint("createVehicleStatusTodo apiUrl: $apiUrl");
      debugPrint("createVehicleStatusTodo body: $body");
      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        debugPrint(
            'createVehicleStatusTodo api.statusCode: ${response.statusCode}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint(
              'createVehicleStatusTodo api.response.body: ${response.body}');
          // GeneralResponse generalResponse = GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          //   Utils.showMobileToast(generalResponse.message!);
          return await vehicleStatusUpdate(createTodoParams);
        } else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          Utils.showSomethingWentWrong();
          return false;
        }
        /*  } else {
          Utils.showSomethingWentWrong();
          return null;
        }*/
      } else {
        return null;
      }
    } catch (error) {
      log('createVehicleStatusTodo.exception3 : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> vehicleStatusUpdate(CreateTodoParams createTodoParams) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}vehicleStatusUpdate";
      String body = jsonEncode({
        "vin": createTodoParams.vin,
        "vehicle_status": createTodoParams.vehicleStatusCategory
      });
      debugPrint("vehicleStatusUpdate apiUrl: $apiUrl");
      debugPrint("vehicleStatusUpdate body: $body");
      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        debugPrint(
            'vehicleStatusUpdate api.statusCode: ${response.statusCode}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint('vehicleStatusUpdate api.response.body: ${response.body}');
          // GeneralResponse generalResponse = GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          //   Utils.showMobileToast(generalResponse.message!);
          return true;
        } else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          Utils.showSomethingWentWrong();
          return false;
        }
        /*  } else {
          Utils.showSomethingWentWrong();
          return null;
        }*/
      } else {
        return null;
      }
    } catch (error) {
      log('vehicleStatusUpdate.exception3 : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> saveWorkingHour(int? isBreak, String? startDate,
      String? startTime, String? title, int? userId) async {
    try {
      String apiUrl = "${Str.GOPORTAL_BASE_URL}saveWorkingHour";
      /*{
    "start_date": "2024-05-18",
    "start_time": "14:05:07",
    "start_time_device_type": "Mobile",
    "title": "Todo",
    "user_id": 21,
    "is_break": 0
}*/
      String body = jsonEncode({
        "start_date": startDate,
        "start_time": startTime,
        "start_time_device_type": "Mobile",
        "title": title,
        "user_id": userId,
        "is_break": isBreak
      });
      debugPrint("createVehicleStatusTodo apiUrl: $apiUrl");
      debugPrint("createVehicleStatusTodo body: $body");
      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        /*if (response.statusCode == 200 || response.statusCode == 201) {*/

        debugPrint(
            'createVehicleStatusTodo api.response.body: ${response.body}');
        debugPrint(
            'createVehicleStatusTodo api.statusCode: ${response.statusCode}');

        GeneralResponse generalResponse =
        GeneralResponse.fromJson(json.decode(response.body));
        if (generalResponse.status == 200 || generalResponse.status == 201) {
          Utils.showMobileToast(generalResponse.message!);
          return true;
        } else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          Utils.showSomethingWentWrong();
          return false;
        }
        /*  } else {
          Utils.showSomethingWentWrong();
          return null;
        }*/
      } else {
        return null;
      }
    } catch (error) {
      log('createVehicleStatusTodo.exception3 : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> createCheckListTodo(CreateTodoParams createTodoParams) async {
    try {
      String apiUrl = "${Str.BASE_URL}create-checklist-todo";

      String body = jsonEncode({
        "checklist_id": createTodoParams.checklistId,
        "category_id": createTodoParams.categoryId,
        "checkbox_value": createTodoParams.checkboxValue,
        "config_id": createTodoParams.configId,
        "vin": createTodoParams.vin,
        "task_name": createTodoParams.taskName,
        "user_id": createTodoParams.todoId,
        "cohort_id": createTodoParams.cohortId,
        "cohort_name": createTodoParams.cohortName,
        "vehicle_name": createTodoParams.vehicleName,
        "vehicle_image": createTodoParams.vehicleImage
      });
      debugPrint("createCheckListTodo apiUrl: $apiUrl");
      debugPrint("createCheckListTodo body: $body");
      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        debugPrint('createCheckListTodo api.response.body: ${response.body}');
        debugPrint(
            'createCheckListTodo api.statusCode: ${response.statusCode}');

        // GeneralResponse generalResponse = GeneralResponse.fromJson(json.decode(response.body));
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Utils.showMobileToast(generalResponse.message!);
          return await createVehicleStatusCheckListTodo(createTodoParams);
          // return true;
        } else {
          Utils.showSomethingWentWrong();
          return false;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('createCheckListTodo.exception3 : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> createVehicleStatusCheckListTodo(
      CreateTodoParams createTodoParams) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}vehicle_status/checklist";

      String body = jsonEncode({
        "checklist_id": createTodoParams.checklistId,
        "category_id": createTodoParams.categoryId,
        "checkbox_value": createTodoParams.checkboxValue,
        "config_id": createTodoParams.configId,
        "vin": createTodoParams.vin
      });
      debugPrint("createVehicleStatusCheckListTodo apiUrl: $apiUrl");
      debugPrint("createVehicleStatusCheckListTodo body: $body");
      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        debugPrint(
            'createVehicleStatusCheckListTodo api.response.body: ${response.body}');
        debugPrint(
            'createVehicleStatusCheckListTodo api.statusCode: ${response.statusCode}');

        // GeneralResponse generalResponse = GeneralResponse.fromJson(json.decode(response.body));
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Utils.showMobileToast(generalResponse.message!);
          return true;
        } else {
          Utils.showSomethingWentWrong();
          return false;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('createVehicleStatusCheckListTodo.exception3 : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> deleteATodo(String todoId) async {
    try {
      String apiUrl = "${Str.BASE_URL}delete-todo/$todoId";
      debugPrint("deleteATodo apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          debugPrint('deleteATodo api.response.body: ${response.body}');
          debugPrint('deleteATodo api.statusCode: ${response.statusCode}');

          GeneralResponse generalResponse =
          GeneralResponse.fromJson(json.decode(response.body));
          if (generalResponse.status == 200 || generalResponse.status == 201) {
            // Utils.showNoResultFound();
            return true;
          } else {
            // debugPrint('---------------> ${TodoListResponse.status!}');
            return false;
          }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('callLoginAPI.exception4 : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> completeATodo(String? todoId, String? status) async {
    try {
      bool statusBool = status == "Completed" ? true : false;
      String apiUrl = "${Str.BASE_URL}complete-todo/${todoId.toString()}";
      debugPrint("completeATodo apiUrl: $apiUrl");
      String body = jsonEncode({"status": statusBool});
      debugPrint("completeATodo body: $body");

      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint('completeATodo api.response.body: ${response.body}');
          debugPrint('completeATodo api.statusCode: ${response.statusCode}');

        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('completeATodo.exception : ${error.toString()}');
      return null;
    }
    return null;
  }

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
            : Utils.convertDateToYearMonthDateFormat(DateTime.now().toString()),
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

  Future<ChatMessageResponse?> getChatsList(int sender, int receiver) async {
    try {
      String apiUrl =
          "${Str.BASE_URL}get-message?sender=$sender&receiver=$receiver";
      /*String body = jsonEncode({
        "title":createTodoParams.todoTitle,
        "todo_date":createTodoParams.todoDate
      });*/
      debugPrint("getChatsList apiUrl: $apiUrl");
      // debugPrint("createATodo body: $body");
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        debugPrint('getChatsList api.response.body: ${response.body}');
        debugPrint('getChatsList api.statusCode: ${response.statusCode}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          ChatMessageResponse chatMessageResponse =
          ChatMessageResponse.fromJson(json.decode(response.body));
          return chatMessageResponse;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getChatsList.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> sendChatMessages(
      int sender, int receiver, String createdAt, String message) async {
    try {
      String apiUrl = "${Str.BASE_URL}send-message";
      String body = jsonEncode({
        "createdAt": createdAt,
        "message": message,
        "receiver": receiver,
        "sender": sender
      });
      debugPrint("sendChatMessages apiUrl: $apiUrl");
      // debugPrint("createATodo body: $body");
      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        debugPrint('sendChatMessages api.response.body: ${response.body}');
        debugPrint('sendChatMessages api.statusCode: ${response.statusCode}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          // ChatMessageResponse chatMessageResponse = ChatMessageResponse.fromJson(json.decode(response.body));
          return true;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('sendChatMessages.exception : ${error.toString()}');
      return null;
    }
  }

  Future<ChecklistResponse?> getCheckList() async {
    try {
      String apiUrl = "${Str.BASE_URL}getCheckList";
      debugPrint("getCheckList apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        ChecklistResponse checklistResponse =
        ChecklistResponse.fromJson(jsonDecode(response.body));
        return checklistResponse;
      } else {
        return null;
      }
    } catch (error) {
      log('getCheckList.exception : ${error.toString()}');
      return null;
    }
  }

  Future<MaintenanceCheckListResponse?> getMaintenanceCheckList() async {
    try {
      String apiUrl = "${Str.BASE_URL}getMaintanceCheckList";
      debugPrint("getMaintenanceCheckList apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        MaintenanceCheckListResponse maintenanceCheckListResponse =
        MaintenanceCheckListResponse.fromJson(json.decode(response.body));
        return maintenanceCheckListResponse;
      } else {
        return null;
      }
    } catch (error) {
      log('getMaintenanceCheckList.exception : ${error.toString()}');
      return null;
    }
  }
  Future<GetTodoListResponse?> getTodoList() async {
    try {
      String apiUrl = "${Str.BASE_URL}todo";
      debugPrint("getTodoList apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        GetTodoListResponse getTodoListResponse =
        GetTodoListResponse.fromJson(json.decode(response.body));
        return getTodoListResponse;
      } else {
        return null;
      }
    } catch (error) {
      log('getTodoList.exception : ${error.toString()}');
      return null;
    }
  }

  Future<BranchResponse?> getBranchList() async {
    try {
      String apiUrl = "${Str.BASE_URL}getBranch";
      debugPrint("getBranch apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        BranchResponse branchResponse =
        BranchResponse.fromJson(jsonDecode(response.body));
        return branchResponse;
      } else {
        return null;
      }
    } catch (error) {
      log('getBranch.exception : ${error.toString()}');
      return null;
    }
  }

  Future<ExpenseResponse?> getExpense(String? minDate, String? maxDate) async {
    try {
      String apiUrl =
          "${Str.LIST_BASE_URL}expenses/all?minDate=$minDate&maxDate=$maxDate&platformCustom=TaskerApp";
      debugPrint("getExpenses apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          ExpenseResponse expenseResponse =
          ExpenseResponse.fromJson(json.decode(response.body));

          return expenseResponse; // Return departmentResponse here
        } else {
          Utils.showNoResultFound();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getExpense.exception : ${error.toString()}');
      return null;
    }
  }

  Future<ExpenseResponse?> createExpenseData(
      int? id,
      String? vehicleId,
      String? expenseAmount,
      String? paymentMethodId,
      String? expenseDescription,
      String? categoryId,
      String? subcategoryId,
      String? expenseTo,
      String? expenseDate,
      String? odometer,
      ) async {
    try {
      String body = jsonEncode({
        "vehicle_id": vehicleId,
        "expense_amount": expenseAmount,
        "payment_method_id": paymentMethodId,
        "expense_description": expenseDescription,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "expense_to": expenseAmount,
        "expense_date": expenseAmount,
        "odometer": odometer,
        "platform": "TaskerApp",
        "status": "1"
      });

      String apiUrl = '';
      http.Response? response;
      if (id != null) {
        apiUrl = "${Str.LIST_BASE_URL}expenses_update/$id";
        debugPrint("getAssignedTo apiUrl: $apiUrl");
        response = await apiClient.callPostMethod(apiUrl, body: body);
      } else {
        apiUrl = "${Str.LIST_BASE_URL}expenses";
        debugPrint("getAssignedTo apiUrl: $apiUrl");
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }
      if (response != null) {
        ExpenseResponse expenseResponse =
        ExpenseResponse.fromJson(json.decode(response.body));
        if (response.statusCode == 200) {
          return expenseResponse;
        } else {
          return expenseResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('department.exception : ${error.toString()}');
      return null;
    }
  }

  Future<ExpenseResponse?> deleteExpense(String? id) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}expenses/$id";

      final http.Response? response = await apiClient.callDelete(apiUrl);

      if (response != null) {
        ExpenseResponse expenseResponse =
        ExpenseResponse.fromJson(json.decode(response.body));

        if (response.statusCode == 200) {
          return expenseResponse;
        } else {
          return expenseResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('expense.exception : ${error.toString()}');
      return null;
    }
  }

  //----------------------------------------------------------

  Future<ExpensePersonResponse?> getExpensePersonData(
      String minDate, String maxDate) async {
    const String apiUrl = '${Str.LIST_BASE_URL}ajaxPersonExpense';
    final Map<String, String> payload = {
      'minDate': minDate,
      'maxDate': maxDate,
      'platformCustom': 'tasker-web',
    };

    try {
      final http.Response? response = await apiClient.callPostMethod(
        apiUrl,
        body: jsonEncode(payload),
      );

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        return ExpensePersonResponse.fromJson(json.decode(response.body));
      } else {
        Utils.showSomethingWentWrong();
        return null;
      }
    } catch (e) {
      log('Error in getExpensePersonData: $e');
      return null;
    }
  }

  Future<ExpenseOtherResponse?> getExpenseOtherData(
      String minDate, String maxDate) async {
    const String apiUrl = '${Str.LIST_BASE_URL}ajaxOtherExpense';
    final Map<String, String> payload = {
      'minDate': minDate,
      'maxDate': maxDate,
    };

    try {
      final http.Response? response = await apiClient.callPostMethod(
        apiUrl,
        body: jsonEncode(payload),
      );

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        return ExpenseOtherResponse.fromJson(json.decode(response.body));
      } else {
        Utils.showSomethingWentWrong();
        return null;
      }
    } catch (e) {
      log('Error in getExpensePersonData: $e');
      return null;
    }
  }

  Future<PaymentResponse?> getExpensePayments() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}payment-methods";
      debugPrint("getCategories apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        PaymentResponse expensePayments =
        PaymentResponse.fromJson(json.decode(response.body));
        if (response.statusCode == 200 || response.statusCode == 201) {
          return expensePayments;
        } else {
          Utils.showNoResultFound();
          debugPrint(
              'getCategories response.statusCode: ${response.statusCode}');
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getCategories.exception : ${error.toString()}');
      return null;
    }
  }

  Future<ExpenseCategories?> getExpenseCategories() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}expenses_category";
      debugPrint("getCategories apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        ExpenseCategories expenseCategories =
        ExpenseCategories.fromJson(json.decode(response.body));
        if (response.statusCode == 200 || response.statusCode == 201) {
          return expenseCategories;
        } else {
          Utils.showNoResultFound();
          debugPrint(
              'getCategories response.statusCode: ${response.statusCode}');
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
      log('getCategories.exception : ${error.toString()}');
      return null;
    }
  }


  Future<ExpenseOtherResponse?> createOtherData(
      int? id,
      int? approved,
      String? expenseDate,
      double? expenseAmount,
      String? categoryId,
      String? subcategoryId,
      String? expenseDescription,
      int? expenseTo, int? paymentId) async {
    try {

      String body = jsonEncode({
        "approved": approved,
        "expense_amount": expenseAmount,
        "expense_description": expenseDescription,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "expense_date": expenseDate,
        "expense_to":expenseTo,
        "payment_method_id":paymentId,
      });

      String apiUrl='';
      http.Response? response;
      if(id != null) {
        apiUrl = "${Str.LIST_BASE_URL}updateOtherExpense/$id";
        debugPrint("getAssignedTo apiUrl: $apiUrl");
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }else{
        apiUrl = "${Str.LIST_BASE_URL}storeOtherExpense";
        debugPrint("getAssignedTo apiUrl: $apiUrl");
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }
      if (response != null) {
        debugPrint("Response: ${response.body}");
        if (response.statusCode == 200) {
          return ExpenseOtherResponse.fromJson(jsonDecode(response.body));
        } else {
          debugPrint("Error: ${response.body}");
          return null;
        }
      }
    } catch (error, stacktrace) {
      log("Exception: ${error.toString()}", stackTrace: stacktrace);
    }
    return null;
  }

  Future<ExpenseOtherResponse?> deleteOtherData(int? id) async {
    try {
      //print("Repository side delete $id");
      String apiUrl = "${Str.LIST_BASE_URL}personExpenses/${id.toString()}";

      final http.Response? response = await apiClient.callDelete(apiUrl);

      if (response != null) {
        ExpenseOtherResponse expenseOtherResponse =
        ExpenseOtherResponse.fromJson(jsonDecode(response.body));

        if (response.statusCode == 200) {
          return expenseOtherResponse;
        } else {
          return expenseOtherResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('expenseOtherData.exception : ${error.toString()}');
      return null;
    }
  }

  Future<CohortsResponse?> getCohorts() async {
    try {
      String apiUrl = '${Str.LIST_BASE_URL}getCohortsData';
      debugPrint("fetchDropdownValues apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          CohortsResponse createExpenseFieldData =
          CohortsResponse.fromJson(json.decode(response.body));

          return createExpenseFieldData;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      debugPrint('getProfileAPI.exception : ${error.toString()}');
      return null;
    }
  }

  Future<PaymentResponse?> getPayment() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}payment-methods";
      debugPrint("getPayment apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          PaymentResponse paymentResponse =
          PaymentResponse.fromJson(json.decode(response.body));

          return paymentResponse; // Return departmentResponse here
        } else {
          Utils.showNoResultFound();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getPayment.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> deleteVehicle(int? id) async {
    try {
      String apiUrl = "${Str.BASE_URL}delete-vehicles/$id";

      debugPrint("delete-vehicles apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callDelete(apiUrl);
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
      log('delete-vehicles.exception : ${error.toString()}');
      return null;
    }
  }

  Future<VoiceResponse?> getVoiceTextList(String? from, String? to) async {
    try {
      String apiUrl =
          "${Str.BASE_URL}getVoiceTextList?from=$from&to=$to";
      debugPrint("getVoiceTextList apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {


        if (response.statusCode == 200||response.statusCode ==202) {


          VoiceResponse voiceResponse =
          VoiceResponse.fromJson(json.decode(response.body));
          return voiceResponse;
        } else {
          Utils.showNoResultFound();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getVoiceTextList.exception : ${error.toString()}');
      return null;
    }
  }

  Future<GetActiveHoursResponse?> getActiveHoursResponse(
      String start, String end) async {
    try {
      String apiUrl = "${Str.BASE_URL}employeeActiveHours?from=$start&to=$end";
      debugPrint("getWorkingHistory apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(
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
      debugPrint("getWorkingHistory apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl,);
      if (response != null) {
        GetWorkingHoursDataResponse getWorkingHoursDataResponse =
        GetWorkingHoursDataResponse.fromJson(json.decode(response.body));

        if ((getWorkingHoursDataResponse.status ?? false)) {

          return getWorkingHoursDataResponse;
        } else {
          Utils.showNoResultFound();
          debugPrint('---------------> ${getWorkingHoursDataResponse.status!}');
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
      if (id == null && userId!=null) {
        apiUrl = "${Str.BASE_URL}add-configuration";
      }else if(id == null && userId==null)
      {
        apiUrl = "${Str.BASE_URL}add-configuration";
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }
      else {
        apiUrl = "${Str.BASE_URL}update-configuration/$id";
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }
      debugPrint("addTaskConfiguration apiUrl: $apiUrl");
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

  Future<WorkingHistoryCountResponse?> getWorkingHistoryCount(
      String start, String end) async {
    try {
      String apiUrl = "${Str.BASE_URL}employeeHistoryCount?from=$start&to=$end";
      debugPrint("getWorkingHistory apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
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

  Future<FinanceStatementResponse?> getFinanceStatement() async {
    try {
      String apiUrl = "${Str.BASE_URL}statement?startDate=2024-01-01&endDate=2024-12-31&cohortIds[]=1";
      debugPrint("getEmployeeName apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      //print("employee value ${response?.body}");
      if (response != null) {
        if (response.statusCode == 200) {
          FinanceStatementResponse financeStatementResponse =
          FinanceStatementResponse.fromJson(json.decode(response.body));

          return financeStatementResponse; // Return departmentResponse here
        } else {
          Utils.showNoResultFound();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getFinanceStatement.exception : ${error.toString()}');
      return null;
    }
  }

  Future<CategoryConfigResponse?> getCategoryConfig() async {
    try {
      String apiUrl = "${Str.BASE_URL}taskCategory";
      debugPrint("getAssignedTo apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {

        if (response.statusCode == 200) {

          CategoryConfigResponse categoryConfigResponse =
          CategoryConfigResponse.fromJson(json.decode(response.body));
          return categoryConfigResponse; // Return departmentResponse here
        } else {
          Utils.showNoResultFound();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getCategoryConfig.exception : ${error.toString()}');
      return null;
    }
  }

  Future<CategoryConfigMessageResponse?> createCategoryConfig(
      {int? id, String? name, int? parentId, int? userType}) async {
    try {
      String body = jsonEncode({
        "name": name,
        "parent_id":parentId,
        "todo_user_type":userType,
        "platform": "TaskerApp",
        "status": "1"
      });

      String apiUrl = '';
      http.Response? response;

      if(id != null) {
        apiUrl = "${Str.BASE_URL}updateTaskCategory/$id";
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }else{
        apiUrl = "${Str.BASE_URL}addTaskCategory";
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }
      log('getTaskCategoryGroup.exception : ${response?.body}');
      if (response != null) {
        CategoryConfigMessageResponse categoryConfigResponse =
        CategoryConfigMessageResponse.fromJson(json.decode(response.body));
        if (response.statusCode == 200) {
          return categoryConfigResponse;
        } else {
          return categoryConfigResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('categoryConfig.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool> deleteCategoryConfig(int? id) async {
    try {
      String apiUrl = "${Str.BASE_URL}deleteTaskCategory/$id";
      final http.Response? response = await apiClient.callDelete(apiUrl);
      return response.isSuccess;
    } catch (error) {
      log('categoryConfig.exception : ${error.toString()}');
      return false;
    }
  }

  Future<TaskListResponse?> getTask() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}task-expenses-data";
      debugPrint("getAssignedTo apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          TaskListResponse taskListResponse =
          TaskListResponse.fromJson(json.decode(response.body));

          return taskListResponse; // Return departmentResponse here
        } else {
          Utils.showNoResultFound();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getAssignedTo.exception : ${error.toString()}');
      return null;
    }
  }

  Future<TaskResponse?> createTask(
      {int? id,
      int? categoryId,
      int? subCategoryId,
      String? task,
      String? timeTaken,
      int? userType}) async {
    try {
      String body = jsonEncode({
        "category_id": categoryId,
        "subcategory_id": subCategoryId,
        "task": task,
        "time_taken":timeTaken,
        "user_type":userType,
        "platform": "TaskerApp",
        "status": "1"
      });

      String apiUrl = '';
      http.Response? response;
      if(id != null) {
        apiUrl = "${Str.LIST_BASE_URL}task-expenses-data/$id";
        debugPrint("getAssignedTo apiUrl: $apiUrl");
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }else{
        apiUrl = "${Str.LIST_BASE_URL}task-expenses-data";
        debugPrint("getAssignedTo apiUrl: $apiUrl");
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }

      if (response != null) {
        TaskResponse taskResponse =
        TaskResponse.fromJson(json.decode(response.body));
        if (response.statusCode == 200) {
          return taskResponse;
        } else {
          return taskResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('task.exception : ${error.toString()}');
      return null;
    }
  }

  Future<TaskResponse?> deleteTask(String? id) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}task-expenses-data/$id";

      final http.Response? response = await apiClient.callDelete(apiUrl);

      if (response != null) {
        TaskResponse taskResponse =
        TaskResponse.fromJson(json.decode(response.body));

        if (response.statusCode == 200) {
          return taskResponse;
        } else {
          return taskResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('task.exception : ${error.toString()}');
      return null;
    }
  }

  Future<TaskCategoryGroupResponse?> getTaskCategoryGroup() async {
    try {
      String apiUrl = "${Str.BASE_URL}taskCategoryGroup";
      debugPrint("getAssignedTo apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
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

  Future<bool?> updatePartsForItem(int todoId, List<dynamic> partsList) async {
    try {
      String apiUrl = '${Str.BASE_URL}update-todo/$todoId';
      String body = jsonEncode({"parts": partsList, "type": "inline"});
      debugPrint("updatePartsForItem apiUrl: $body");
      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
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
      debugPrint('updatePartsForItem.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> updateSupplyForItem(
      int todoId, List<dynamic> suppliesList) async {
    try {
      String apiUrl = '${Str.BASE_URL}update-todo/$todoId';

      String body = jsonEncode({"supplies": suppliesList, "type": "inline"});
      debugPrint("updateSupplyForItem apiUrl: $apiUrl");

      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
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
      debugPrint('updateSupplyForItem.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> deletePartsForItem(int partsId) async {
    try {
      String apiUrl;
      apiUrl = '${Str.BASE_URL}delete-vehicle-parts/$partsId';
      debugPrint("delete-Part apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callDelete(apiUrl);
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
      debugPrint('delete Parts For Item.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> deleteSuppliesForItem(int suppliesId) async {
    try {
      String apiUrl;
      apiUrl = '${Str.BASE_URL}delete-supplies/$suppliesId';
      debugPrint("delete-Supplies apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callDelete(apiUrl);
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
      debugPrint('delete Supply For Item.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> allCheckInMainteance(CreateFixTaskData fixTask ) async {
    try {
      String apiUrl = "${Str.BASE_URL}update-todo/${fixTask.id}";
      String body = jsonEncode({
        "type" : "inline",
        "mandatory" : fixTask.mandatory
      });
      print("${fixTask}");
      log("$body", name: "POST_BODY");
      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);

      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return true;
      } else {
        return null;
      }
    } catch (error) {
      log('fixTask.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> completeTodo(int todoId) async {
    try {
      String apiUrl = '${Str.BASE_URL}complete-todo/$todoId';
      debugPrint("completeTodo apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callPostMethod(apiUrl);
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return true;
      } else {
        return null;
      }
    } catch (error) {
      log('fixTask.exception : ${error.toString()}');
      return null;
    }
  }


  Future<bool?> spareKeyTask(CreateSpareKeyData sparekeyData ) async {
    try {
      String apiUrl = "${Str.BASE_URL}add-todo";

      //title branch_id cohort_id identifier_id location location_id notes start_at time_sensitive(false) title todo_time todo_user_type user_group_id user_id
      //vehicle_name vehicles vendor_id vendor_name vin
      String body = jsonEncode({
        "title": sparekeyData.title,
        "branch_id":sparekeyData.branchId,
        "cohort_id":sparekeyData.cohortId,
        "identifier_id":sparekeyData.identifierId,
        "location":sparekeyData.location,
        "location_id":sparekeyData.locationId,
        "notes": sparekeyData.notes ,
        "start_at": sparekeyData.startAt,
        'time_sensitive': sparekeyData.timeSensitive,
        "todo_time": sparekeyData.todoTime,
        "todo_user_type": sparekeyData.todoUserType,
        "user_group_id": sparekeyData.userGroupId,
        "user_id": sparekeyData.userId,
        "vehicle_name": sparekeyData.vehicleName,
        "vehicles": sparekeyData.vehicles,
        "vendor_id": sparekeyData.vendorId,
         "vendor_name": sparekeyData.vendorName,
        "vin": sparekeyData.vin
      });
      log("$body", name: "POST_BODY");
      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return true;
      } else {
        return null;
      }
    } catch (error) {
      log('spareKeyTask.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> createFixTask(CreateFixTaskData createFixTaskData ) async {
    try {
      String apiUrl = "${Str.BASE_URL}add-todo";

      String body = jsonEncode({
        "identifier_id":createFixTaskData.identifierId,
        "user_group_id":createFixTaskData.userGroupId,
        "user_id":createFixTaskData.userId,
        "title": createFixTaskData.title,
        "maintenance_task_id":createFixTaskData.maintenanceTaskId,
        "notes":createFixTaskData.notes,
        "todo_time": createFixTaskData.todoTime,
        "start_at": createFixTaskData.startAt,
        'vehicles': createFixTaskData.vehicleList,
        "vendor_id": createFixTaskData.vendorId,
        "vendor_name": createFixTaskData.vendorName,
        "location": createFixTaskData.location,
        "location_id": createFixTaskData.locationId,
        "custom_link": createFixTaskData.customLink,
        "custom_link_id": createFixTaskData.customLinkId,
        "reference_id": createFixTaskData.referenceId,
        "comments" : createFixTaskData.comments,
        "vehicle_number": createFixTaskData.vehicleNumber,
        "platform": "TaskerApp",
      });
      log("$body", name: "POST_BODY");
      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return true;
      } else {
        return null;
      }
    } catch (error) {
      log('addVehicleCreateTodo.exception : ${error.toString()}');
      return null;
    }
  }

  Future<TaskMilesResponse?> getTaskMiles() async {
    try {
      String apiUrl = "${Str.BASE_URL}getTaskMiles";
      debugPrint("getTaskMiles apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        debugPrint('getTaskMiles api.response.body: ${response.body}');
        debugPrint('getTaskMiles api.statusCode: ${response.statusCode}');
        TaskMilesResponse taskMilesResponse =
        TaskMilesResponse.fromJson(json.decode(response.body));
        if (response.statusCode == 200 || response.statusCode == 201) {
          return taskMilesResponse;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getTaskMiles.exception : ${error.toString()}');
      return null;
    }
  }

  Future<PreviousOdometer?> getPreviousOdometer(String? todoDate, int? identifierId, String? vin) async {
    try {
      String apiUrl = "${Str.BASE_URL}getPreviousOdometer?todo_date=$todoDate&identifier_id=$identifierId&vin=$vin";
      debugPrint("getPreviousOdometer apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        debugPrint('getPreviousOdometer api.response.body: ${response.body}');
        debugPrint('getPreviousOdometer api.statusCode: ${response.statusCode}');
        PreviousOdometer previousOdometer = PreviousOdometer.fromJson(json.decode(response.body));
        if (response.statusCode == 200 || response.statusCode == 201) {
          return previousOdometer;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getPreviousOdometer.exception : ${error.toString()}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> addTodo({required Map<String, dynamic> body, required List<File>? images}) async {
    var url = "${Str.BASE_URL}add-todo";
    var response = await apiClient.callPostMethodWithBody(url, fieldName: "images", autoIncrement: true, files: images?.map((e) => e.path).toList(), body: body);
    return response.mapData;
  }

  ///---------

}





