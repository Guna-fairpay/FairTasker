
import 'dart:convert';
import 'dart:developer';
import 'package:fairpytasker/UI/Task%20List/user_list_response.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:http/http.dart' as http;
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:flutter/cupertino.dart';
import '../../Response/assigned_to_response.dart';
import '../../Response/task_list_response.dart';
import '../../Response/task_response.dart';
import '../../Response/user_group_response.dart';
import '../../Response/vehicle_grouping_response.dart';
import '../../Response/vehicle_list_response.dart';

class TaskListRepository {
  ApiClient apiClient = ApiClient();

  Future<TaskListViewResponse?> getTaskList(String? startDate,String? endDate ) async {
    try {
      print("startDate---->$startDate  endDate----->$endDate");
      String apiUrl = "${Str.BASE_URL}getCompletedTodo?from=$startDate&to=$endDate";
      debugPrint("getTaskList apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {

        if (response.statusCode == 200) {
          TaskListViewResponse taskListViewResponse =
          TaskListViewResponse.fromJson(json.decode(response.body));
          print(response.body);
          return taskListViewResponse;
        } else {
          Utils.showNoResultFound();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getTaskList.exception : ${error.toString()}');
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

  Future<AssignedToResponse?> getAssignedTo() async {
    try {
      String apiUrl = "${Str.BASE_URL}getresources";
      debugPrint("getAssignedTo apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        // if (response.statusCode == 200) {
        debugPrint('getAssignedTo api.response.body: ${response.body}');
        debugPrint('getAssignedTo api.statusCode: ${response.statusCode}');

        AssignedToResponse assignedToResponse =
        AssignedToResponse.fromJson(json.decode(response.body));
        if (assignedToResponse.status == 200 ||
            assignedToResponse.status == 201) {
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
      log('getAssignedTo.exception : ${error.toString()}');
      return null;
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

  Future<bool?> approveTodo(int approve,int id) async {
    try {
      Map<String, dynamic> data = {
        "approved": approve,
        "id": id,
      };
      data.putIfAbsent("platform_type", () => getIt<CommonService>().currentPlatform);
      String body = jsonEncode(data);
      String apiUrl = "${Str.BASE_URL}approveTodo";
      debugPrint("getAssignedTo apiUrl: $apiUrl");
      final http.Response? response =
      await apiClient.callPostMethod(apiUrl, body: body);

    } catch (error) {
      log('getAssignedTo.exception : ${error.toString()}');
      return null;
    }
    return null;
  }

  Future<VehicleGroupingResponse?> getVehicleGroupData() async {
    try {
      String apiUrl = '';
      apiUrl = "${Str.BASE_URL}group-vehicle";
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
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
      log('VehicleGroupData.exception : ${error.toString()}');
      return null;
    }
  }

  Future<UserListResponse?> getUsers() async {
    try {
      String apiUrl = "${Str.BASE_URL}user-list";
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          UserListResponse userListResponse =
          UserListResponse.fromJson(json.decode(response.body));
          return userListResponse;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
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


}
