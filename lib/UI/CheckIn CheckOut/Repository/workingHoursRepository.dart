import 'dart:convert';
import 'dart:developer';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Response/workingHoursResponse.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Response/workingReasonResponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../../Utilities/Str.dart';
import '../../../data/api_client.dart';
import '../Response/checkInOutResponse.dart';
import '../Response/taskCategoryGroupResponse.dart';
import '../Response/workingGetConfiguration.dart';
import '../Response/workingTaskResponse.dart';

class TaskRepository {
  final ApiClient apiClient = ApiClient();

  //need
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
        //print("Api response ${response.body}");
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
    required String to,
    required String from,
    required int? userId,
  }) async {
    try {
      print("Request parameters - from: $from, to: $to, userId: $userId");
      final String apiUrl = '${Str.BASE_URL}employeeTaskHistory?to=$to&user_id=$userId&from=$from';
      final http.Response? response = await apiClient.callGetMethod(apiUrl);

      print("API URL: $apiUrl");
      if (response != null) {
        print("Response body: ${response.body}");
        if (response.statusCode == 200) {
          WorkingTaskResponse workingTaskResponse = WorkingTaskResponse.fromJson(jsonDecode(response.body));
          return workingTaskResponse;
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

  Future<TaskCategoryGroupResponse?> fetchCategoryGroup() async {
    try{
      final String apiUrl = '${Str.BASE_URL}taskCategoryGroup';
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      print("Api URL $apiUrl");
      if(response != null){
        //debugPrint("Response body ${response.body}");
        if (response.statusCode == 200) {
          TaskCategoryGroupResponse taskCategoryGroupResponse = TaskCategoryGroupResponse.fromJson(jsonDecode(response.body));
          return taskCategoryGroupResponse;
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
}

