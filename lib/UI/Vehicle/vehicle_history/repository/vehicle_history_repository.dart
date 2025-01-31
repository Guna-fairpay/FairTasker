import 'dart:convert';
import 'dart:developer';
import 'package:fairpytasker/Response/vehicle_history_response.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../../../Response/assigned_to_response.dart';
import '../../../../Utilities/Str.dart';
import '../../../../Utilities/Utils.dart';

class VehicleHistoryRepository{
  ApiClient apiClient =ApiClient();

  Future<VehicleHistoryResponse?> getVehicleHistoryList(
      String? pageNo,
      String? vin,
      ) async {
    try {
      String apiUrl = '';
      apiUrl = "${Str.BASE_URL}get-vehicle-history?page=$pageNo&vin=$vin&itemPerPage=10";
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          VehicleHistoryResponse vehicleHistoryResponse =
          VehicleHistoryResponse.fromJson(json.decode(response.body));
          debugPrint('getVehicleHistoryList api.statusCode: $vehicleHistoryResponse');
          return vehicleHistoryResponse;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getVehicleHistory.exception : ${error.toString()}');
      return null;
    }
  }

  Future<AssignedToResponse?> getResourcesList() async {
    try {
      String apiUrl = "${Str.BASE_URL}getresources";
      debugPrint("getAssignedTo apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        AssignedToResponse assignedToResponse =
        AssignedToResponse.fromJson(json.decode(response.body));
        if (assignedToResponse.status == 200 ||
            assignedToResponse.status == 201) {
          return assignedToResponse;
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

}