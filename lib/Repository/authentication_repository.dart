import 'dart:convert';
import 'dart:developer';

import 'package:fairpytasker/Response/authentication_response.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/response_extension.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:http/http.dart' as http;

class AuthenticationRepo {
  ApiClient apiClient = ApiClient();

  Future<AuthenticationResponse?> callLoginAPI(
      String email, String password) async {
    try {
      String apiUrl = "${Str.BASE_URL}login";

      String body;
      body =
          jsonEncode({"email": email, "password": password, "remember": true});

      final http.Response? response =
          await apiClient.callPostMethod(apiUrl, body: body, tokenNoNeed: true);
      if (response != null) {
        if (response.statusCode == 200) {
          AuthenticationResponse loginResponse =
              AuthenticationResponse.fromJson(json.decode(response.body));
          if (loginResponse.status != 200 && loginResponse.status != 201) {
            Utils.showInvalidInputs();
          } else {
            loginResponse.user?.password = password;
            loginResponse.user?.email = email;
            return loginResponse;
          }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('callLoginAPI.exception5 : ${error.toString()}');
      return null;
    }
    return null;
  }

  Future<Map<String, dynamic>?> logout() async {
    String apiUrl = "${Str.BASE_URL}logout";
    try {
      var response = await apiClient.callPostMethod(apiUrl);
      if (response.isSuccess) {
        return response.mapData;
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('logout.exception : ${e.toString()}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getBearerToken() async {
    String apiUrl = "${Str.BASE_URL}getBearerToken";
    try {
      var response = await apiClient.callPostMethod(apiUrl);
      if (response.isSuccess) {
        return response.mapData;
      } else {
        return null;
      }
    } on Exception catch (e) {
      log('getBearerToken.exception : ${e.toString()}');
      return null;
    }
  }
}
