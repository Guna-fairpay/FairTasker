
import 'dart:convert';
import 'dart:developer';
import 'package:fairpytasker/Response/department_response.dart';
import 'package:fairpytasker/Response/leave_management_employee_list_response.dart';
import 'package:http/http.dart' as http;
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:flutter/cupertino.dart';
import '../Response/leave_management_response.dart';
import '../Response/leave_type_list_response.dart';


class LeaveManagementRepository {
  ApiClient apiClient = ApiClient();

  Future<LeaveManagementListResponse?> getLeaveList() async {
    try {
      String apiUrl = "${Str.GOPORTAL_BASE_URL}leaveList";
      debugPrint("getAssignedTo apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          LeaveManagementListResponse leaveManagementListResponse =
          LeaveManagementListResponse.fromJson(json.decode(response.body));

          return leaveManagementListResponse; // Return departmentResponse here
        } else {
          Utils.showNoResultFound();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getLeaveList.exception : ${error.toString()}');
      return null;
    }
  }

  Future<LeaveManagementResponse?> createLeaveList(
      int? id,
      int? userId,
      String? leaveTypeId,
      String? startDate,
      String? endDate,
      String? reason,
      String? startTime,
      String? endTime,
      String? status,
      ) async {
    try {
      String body = jsonEncode({
        "leave_type_id": leaveTypeId,
        "start_date": startDate,
        "end_date": endDate,
        "reason": reason,
        "start_time": startTime,
        "end_time": endTime,
        "user_id": userId,
        "status": status,
        "platform":  "TaskerApp",
      });

      String apiUrl = '';
      http.Response? response;
      if(id != null) {
        apiUrl = "${Str.GOPORTAL_BASE_URL}updateLeave/$id";
        debugPrint("getAssignedTo apiUrl: $apiUrl");
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }else{
        apiUrl = "${Str.GOPORTAL_BASE_URL}addLeave/$userId";
        debugPrint("getAssignedTo apiUrl: $apiUrl");
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }
      if (response != null) {

        LeaveManagementResponse leaveManagementResponse =
        LeaveManagementResponse.fromJson(json.decode(response.body));

        if (response.statusCode == 200) {

          return leaveManagementResponse;
        } else {

          return leaveManagementResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('createLeaveList.exception : ${error.toString()}');
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

  Future<LeaveManagementEmployeeListResponse?> getEmployeeList() async {
    try {
      String apiUrl = "${Str.GOPORTAL_BASE_URL}employeeList";
      debugPrint("getAssignedTo apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          LeaveManagementEmployeeListResponse leaveManagementEmployeeListResponse =
          LeaveManagementEmployeeListResponse.fromJson(json.decode(response.body));

          return leaveManagementEmployeeListResponse; // Return departmentResponse here
        } else {
          Utils.showNoResultFound();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('employeeList.exception : ${error.toString()}');
      return null;
    }
  }

  Future<LeaveTypeListResponse?> getLeaveTypeList() async {
    try {
      String apiUrl = "${Str.GOPORTAL_BASE_URL}leaveTypeList";
      debugPrint("getAssignedTo apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          LeaveTypeListResponse leaveTypeListResponse =
          LeaveTypeListResponse.fromJson(json.decode(response.body));

          return leaveTypeListResponse; // Return departmentResponse here
        } else {
          Utils.showNoResultFound();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('leaveTypeList.exception : ${error.toString()}');
      return null;
    }
  }


}
