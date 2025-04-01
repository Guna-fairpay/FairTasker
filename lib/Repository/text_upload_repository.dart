import 'dart:convert';
import 'dart:developer';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:fairpytasker/Response/general_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class TaskUploadRepository {
  ApiClient apiClient = ApiClient();

  Future<bool?> uploadTask(int? id, String text) async {
    try {
      String apiUrl = '';
        apiUrl = "${Str.BASE_URL}upload-todo";

      String body = jsonEncode({

        "reservation": text
      });

      final http.Response? response = await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
         print(apiUrl);
          debugPrint('createTextUpload api.response.body: ${response.body}');
          debugPrint('createVendor api.statusCode: ${response.statusCode}');

          GeneralResponse generalResponse = GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          Utils.showMobileToast(generalResponse.message!);
          return true;
          // }else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          // Utils.showSomethingWentWrong();
          // return false;
          // }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('textUpload.exception : ${error.toString()}');
      return null;
    }
  }


}
