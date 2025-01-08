import 'dart:convert';
import 'dart:developer';
import 'package:fairpytasker/Response/department_response.dart';
import 'package:http/http.dart' as http;
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:flutter/cupertino.dart';

class DepartmentRepository {
  ApiClient apiClient = ApiClient();

  Future<DepartmentListResponse?> getDepartment() async {
    try {
      String apiUrl = "${Str.BASE_URL}departmentList";
      debugPrint("getAssignedTo apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          DepartmentListResponse departmentResponse =
              DepartmentListResponse.fromJson(json.decode(response.body));

          return departmentResponse; // Return departmentResponse here
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

  Future<DepartmentResponse?> createDepartment(
      int? id, String? head, String? name) async {
    try {
      String body = jsonEncode(
          {"head": head, "name": name, "platform": "TaskerApp", "status": "1"});

      String apiUrl = '';
      http.Response? response;
      if (id != null) {
        apiUrl = "${Str.BASE_URL}updateDepartment/$id";
        debugPrint("getAssignedTo apiUrl: $apiUrl");
        response = await apiClient.callPostMethod(apiUrl, body: body);
      } else {
        apiUrl = "${Str.BASE_URL}addDepartment";
        debugPrint("getAssignedTo apiUrl: $apiUrl");
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }
      if (response != null) {
        DepartmentResponse departmentResponse =
            DepartmentResponse.fromJson(json.decode(response.body));

        if (response.statusCode == 200) {
          return departmentResponse;
        } else {
          return departmentResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('department.exception : ${error.toString()}');
      return null;
    }
  }

  Future<DepartmentResponse?> deleteDepartment(String? id) async {
    try {
      String apiUrl = "${Str.BASE_URL}deleteDepartment/$id";

      final http.Response? response = await apiClient.callDelete(apiUrl);

      if (response != null) {
        DepartmentResponse feedbackResponse =
            DepartmentResponse.fromJson(json.decode(response.body));

        if (response.statusCode == 200) {
          return feedbackResponse;
        } else {
          return feedbackResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('feedback.exception : ${error.toString()}');
      return null;
    }
  }
}
