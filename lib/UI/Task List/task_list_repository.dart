
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:flutter/cupertino.dart';
import '../../Response/task_list_response.dart';

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
          return taskListViewResponse; // Return departmentResponse here
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
}
