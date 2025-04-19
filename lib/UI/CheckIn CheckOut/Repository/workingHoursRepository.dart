import 'dart:convert';
import 'dart:developer';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Response/workingHoursResponse.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Response/workingReasonResponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../../Response/GetActiveHoursResponse.dart';
import '../../../Response/GetWorkingHoursData.dart';
import '../../../Response/assigned_to_response.dart';
import '../../../Response/punchList_Response.dart';
import '../../../Response/todo_list_response.dart';
import '../../../Response/user_group_response.dart';
import '../../../Response/working_history_count_response.dart';
import '../../../Utilities/Str.dart';
import '../../../Utilities/Utils.dart';
import '../../../data/api_client.dart';
import '../Response/checkInOutResponse.dart';
import '../Response/taskCategoryGroupResponse.dart';
import '../Response/workingGetConfiguration.dart';
import '../Response/workingTaskResponse.dart';

class TaskRepository {
  final ApiClient apiClient = ApiClient();

  //need

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


  Future<bool?> deleteTaskConfiguration(int? id) async {
    try {
      String apiUrl = "${Str.BASE_URL}delete-configuration/$id";

      debugPrint("deleteTaskConfiguration apiUrl: $apiUrl");
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
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }else if(id == null)
      {
        log("$task",name: "HourBased");
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

  Future<CheckInOutReasonResponse?> fetchCheckInoutReason({
    required int hrmId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final String apiUrl =
          '${Str
          .BASE_URL}checkinout-reason?hrm_id=$hrmId&from=$fromDate&to=$toDate';
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
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
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
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
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
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

      final http.Response? response = await apiClient.callGetMethod(apiUrl);

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
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      debugPrint("Api URL $apiUrl");
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
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
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

  Future<PunchlistResponse?> fetchPunchList() async
  {
    try{
      final String apiUrl = '${Str.GOPORTAL_BASE_URL}getWorkingHours';
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
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


}

