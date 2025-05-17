
import 'dart:convert';
import 'dart:developer';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:fairpytasker/Response/general_response.dart';
import 'package:http/http.dart' as http;

class TaskUploadRepository {
  ApiClient apiClient = ApiClient();

  Future<bool?> uploadTask(String text) async {
    try {
      String apiUrl = '';
        apiUrl = "${Str.BASE_URL}upload-todo";
        Map<String, dynamic> bodyData = {
          "reservation": text
        };
      bodyData.putIfAbsent("platform_type", () => getIt<CommonService>().currentPlatform);
      String body = jsonEncode(bodyData);

      final http.Response? response = await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          GeneralResponse generalResponse = GeneralResponse.fromJson(json.decode(response.body));
          Utils.showMobileToast(generalResponse.message!);
          return true;
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

  Future<bool?> uploadTuroReservation(String? text) async {
    try {
      String apiUrl = '';
      apiUrl = "${Str.BASE_URL}importTuroVehicles";
      Map<String, dynamic> bodyData = {
        "data": text
      };
      bodyData.putIfAbsent("platform_type", () => getIt<CommonService>().currentPlatform);
      String body = jsonEncode(bodyData);

      final http.Response? response = await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          GeneralResponse generalResponse = GeneralResponse.fromJson(json.decode(response.body));
          Utils.showMobileToast(generalResponse.message??'');
          return true;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('uploadTuroReservation.exception : ${error.toString()}');
      return null;
    }
  }


}
