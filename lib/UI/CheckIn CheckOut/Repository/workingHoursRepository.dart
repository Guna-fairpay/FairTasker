import 'dart:convert';
import 'dart:developer';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Response/workingHoursResponse.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Response/workingReasonResponse.dart';
import 'package:http/http.dart' as http;

import '../../../Utilities/Str.dart';
import '../../../data/api_client.dart';
import '../Response/checkInOutResponse.dart';

class TaskRepository {
  final ApiClient apiClient = ApiClient();

  Future<CheckInOutReasonResponse?> fetchCheckInoutReason({
    required int hrmId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final String apiUrl =
          '${Str.BASE_URL}checkinout-reason?hrm_id=$hrmId&from=$fromDate&to=$toDate';
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
    } catch (e)
    {
      log('Exception in fetchCheckInoutReason: $e');
      return null;
    }
  }

  Future<WorkingReasonResponse?> fetchEmployeeComments({
    required int hrmId,
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
    } catch (e)
    {
      log('Exception in fetchEmployeeComments: $e');
      return null;
    }
  }

  Future<WorkingHoursResponse?> fetchEmployeeTaskCount({
    required int userId,
    required String fromDate,
    required String toDate,
  }) async
  {
    try {
      final String apiUrl =
          '${Str.BASE_URL}employeeTaskCount?user_id=$userId&from=$fromDate&to=$toDate';
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
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
}

