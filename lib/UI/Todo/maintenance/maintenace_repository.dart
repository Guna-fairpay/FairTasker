
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as http;
import 'package:flutter/cupertino.dart';
import '../../../Utilities/Str.dart';
import '../../../data/api_client.dart';
import 'maintenance_check_list_response.dart';

class MaintenanceRepo {
  ApiClient apiClient = ApiClient();

  // Future<MaintenanceCheckListResponse?> getMaintenanceCheckList() async {
  //   try {
  //     String apiUrl = "${Str.BASE_URL}getMaintanceCheckList";
  //     debugPrint("getMaintenanceCheckList apiUrl: $apiUrl");
  //     final http.Response? response = await apiClient.callGetMethod(apiUrl);
  //     if (response != null) {
  //       MaintenanceCheckListResponse maintenanceCheckListResponse =
  //       MaintenanceCheckListResponse.fromJson(json.decode(response.body));
  //       return maintenanceCheckListResponse;
  //     } else {
  //       return null;
  //     }
  //   } catch (error) {
  //     log('getMaintenanceCheckList.exception : ${error.toString()}');
  //     return null;
  //   }
  // }
}