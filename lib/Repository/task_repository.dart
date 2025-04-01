
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:flutter/cupertino.dart';
import '../Response/task_response.dart';

class TaskRepository {
  ApiClient apiClient = ApiClient();

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

  Future<TaskExpenseResponse?> getTaskExpense() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}task-expenses-data";
      debugPrint("getAssignedTo apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          TaskExpenseResponse taskExpenseResponse =
          TaskExpenseResponse.fromJson(json.decode(response.body));

          return taskExpenseResponse; // Return departmentResponse here
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

  Future<TaskResponse?> createTask(int? id, String? task, String? category, String? subCategory,String? timeTaken,String? userType) async {
    try {
      String body = jsonEncode({
        "category_id": category,
        "subcategory_id": subCategory,
        "time_taken":timeTaken,
        "user_type":userType,
        "task": task,
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
      String apiUrl = "${Str.LIST_BASE_URL}deleteDepartment/$id";

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
}
