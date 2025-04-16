

import 'dart:convert';
import 'dart:developer';

import 'package:fairpytasker/core/app/extension/response_extension.dart';
import 'package:http/http.dart' as http;
import '../../../Utilities/Str.dart';
import '../../../Utilities/Utils.dart';
import '../../../data/api_client.dart';
import 'odometer_response.dart';

class OdometerRepo {

  ApiClient apiClient = ApiClient();
  String get _addTodoOdometer => "addTodoOdometer";
  String get _getTodoOdometer => "getTodoOdometer";

  Future<OdometerResponse?> getPreviousOdometer(String? todoDate, int? identifierId, String? vin) async {
    try {
      String apiUrl = "${Str.BASE_URL}getPreviousOdometer?todo_date=$todoDate&identifier_id=$identifierId&vin=$vin";
      log("getPreviousOdometer apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        log('getPreviousOdometer api.response.body: ${response.body}');
        log('getPreviousOdometer api.statusCode: ${response.statusCode}');
        OdometerResponse odometerResponse = OdometerResponse.fromJson(json.decode(response.body));
        if (response.statusCode == 200 || response.statusCode == 201) {
          return odometerResponse;
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

  Future<Map<String, dynamic>?> addToDoOdometer({required dynamic toDoId, required dynamic currentOdometer, required dynamic nextOdometer, required dynamic nextMilesCheck}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_addTodoOdometer";
      Map<String, dynamic> body = {
        "current_odometer" : currentOdometer,
        "next_miles_check" : nextMilesCheck,
        "next_odometer" : nextOdometer,
        "todo_id" : toDoId
      };
      body.putIfAbsent("type", () => "inline");
      final http.Response? response = await apiClient.callPostMethodWithRawBody(apiUrl, body: body);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getTodoOdometer({required dynamic toDoId}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getTodoOdometer/$toDoId";
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      var mapData = await response?.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }



  // Future<Map<String, dynamic>?> getTodoOdometer({required dynamic toDoId}) async {
  //   try {
  //     String apiUrl = "${Str.BASE_URL}$getTodoOdometer/$toDoId";
  //     final http.Response? response = await apiClient.callGetMethod(apiUrl);
  //     return json.decode(response!.body);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}