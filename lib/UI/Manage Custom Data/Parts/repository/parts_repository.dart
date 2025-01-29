
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../../../Response/parts_response.dart';
import '../../../../Utilities/Str.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../data/api_client.dart';

class PartsRepository {
  ApiClient apiClient = ApiClient();
  Future<PartsResponse?> getPartsData() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}vehicle-parts-list";
      debugPrint("getParts apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        PartsResponse partsResponse =
        PartsResponse.fromJson(json.decode(response.body));
        if (response.statusCode == 200 || response.statusCode == 201) {
          return partsResponse;
        } else {
          Utils.showNoResultFound();
          debugPrint('getParts response.statusCode: ${response.statusCode}');
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getParts.exception : ${error.toString()}');
      return null;
    }
  }
}

