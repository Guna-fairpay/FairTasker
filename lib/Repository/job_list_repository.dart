import 'dart:convert';
import 'dart:developer';

import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:fairpytasker/main.dart';
import 'package:fairpytasker/Response/assigned_to_response.dart';
import 'package:fairpytasker/Response/create_job_params.dart';
import 'package:fairpytasker/Response/general_response.dart';
import 'package:fairpytasker/Response/job_list_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class JobListRepo {
  ApiClient apiClient = ApiClient();
  String? selectedHours;
  String? chosenDateTimeString;
  DateTime? chosenDateTime;
  // DateTime? chosenStartingDateTime;
  String? endTimeString;
  String? startTimeTFString;
  String? endTimeTFString;

  Future<JobListResponse?> callJobListAPI(String? selectedDate) async {
    try {
      String apiUrl =
          "${Str.BASE_URL}task-data?resource=${getIt<CommonService>().userId}&date=${selectedDate ?? DateTime.now()}";
      debugPrint("callJobListAPI apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        if (response.statusCode == 200) {
          debugPrint('callJobListAPI api.response.body: ${response.body}');
          debugPrint('callJobListAPI api.statusCode: ${response.statusCode}');

          JobListResponse jobListResponse =
              JobListResponse.fromJson(json.decode(response.body));
          if (jobListResponse.status != 200 && jobListResponse.status != 201) {
            Utils.showNoResultFound();
            return null;
          } else {
            debugPrint('---------------> ${jobListResponse.status!}');
            return jobListResponse;
          }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('callLoginAPI.exception6 : ${error.toString()}');
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

  Future<bool?> createAJob(CreateJobParams createJobParams) async {
    try {
      String apiUrl = "${Str.BASE_URL}addTask";
      String body = jsonEncode({
        "task_name": createJobParams.taskName,
        "description": createJobParams.taskDescription,
        "task_date": createJobParams.taskDate,
        "start_time": '${createJobParams.taskStartTime}',
        "end_time": '${createJobParams.taskEndTime}',
        "duration": createJobParams.taskDuration,
        "priority": createJobParams.priority,
        "Assigned_to": createJobParams.taskAssignedTo
      });
      debugPrint("createAJob apiUrl: $apiUrl");
      debugPrint("createAJob body: $body");
      final http.Response? response =
          await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        /*if (response.statusCode == 200 || response.statusCode == 201) {*/

        debugPrint('createAJob api.response.body: ${response.body}');
        debugPrint('createAJob api.statusCode: ${response.statusCode}');

        GeneralResponse generalResponse =
            GeneralResponse.fromJson(json.decode(response.body));
        if (generalResponse.status == 200 || generalResponse.status == 201) {
          Utils.showMobileToast(generalResponse.message!);
          return true;
        } else {
          // debugPrint('---------------> ${jobListResponse.status!}');
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
      log('callLoginAPI.exception7 : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> editAJob(CreateJobParams createJobParams) async {
    try {
      String apiUrl = "${Str.BASE_URL}addTask/${createJobParams.jobId}";
      String body = jsonEncode({
        // "id":createJobParams.jobId,
        "task_name": createJobParams.taskName,
        "description": createJobParams.taskDescription,
        "task_date": createJobParams.taskDate,
        "start_time": '${createJobParams.taskStartTime}',
        "end_time": '${createJobParams.taskEndTime}',
        "duration": createJobParams.taskDuration,
        "priority": createJobParams.priority,
        "Assigned_to": createJobParams.taskAssignedTo
      });
      debugPrint("createAJob apiUrl: $apiUrl");
      debugPrint("createAJob body: $body");
      final http.Response? response =
          await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        /*if (response.statusCode == 200 || response.statusCode == 201) {*/

        debugPrint('createAJob api.response.body: ${response.body}');
        debugPrint('createAJob api.statusCode: ${response.statusCode}');

        GeneralResponse generalResponse =
            GeneralResponse.fromJson(json.decode(response.body));
        if (generalResponse.status == 200 || generalResponse.status == 201) {
          Utils.showMobileToast(generalResponse.message!);
          return true;
        } else {
          // debugPrint('---------------> ${jobListResponse.status!}');
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
      log('callLoginAPI.exception8 : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> deleteAJob(String taskId) async {
    try {
      String apiUrl = "${Str.BASE_URL}deleteTask/$taskId";
      debugPrint("deleteAJob apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          debugPrint('deleteAJob api.response.body: ${response.body}');
          debugPrint('deleteAJob api.statusCode: ${response.statusCode}');

          GeneralResponse generalResponse =
              GeneralResponse.fromJson(json.decode(response.body));
          if (generalResponse.status == 200 || generalResponse.status == 201) {
            // Utils.showNoResultFound();
            return true;
          } else {
            // debugPrint('---------------> ${jobListResponse.status!}');
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
      log('callLoginAPI.exception9 : ${error.toString()}');
      return null;
    }
  }
}
