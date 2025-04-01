
import 'dart:convert';
import 'dart:developer';
import 'package:fairpytasker/Response/turo_reservation_response.dart';
import 'package:http/http.dart' as http;
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:flutter/cupertino.dart';

class TuroReservationRepository {
  ApiClient apiClient = ApiClient();

    Future<TuroResponse?> uploadTuroReservation(int? id,String? data) async {
    try {
      String body = jsonEncode({
        "data": data,
        "platform": "TaskerApp",
        "status": "1"
      });

      String apiUrl = '';
      http.Response? response;
      apiUrl = "${Str.BASE_URL}importTuroVehicles";
      debugPrint("getAssignedTo apiUrl: $apiUrl");
      response = await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {

        TuroResponse turoResponse =
        TuroResponse.fromJson(json.decode(response.body));

        if (response.statusCode == 200) {

          return turoResponse;
        } else {

          return turoResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('Turo.exception : ${error.toString()}');
      return null;
    }
  }
}
