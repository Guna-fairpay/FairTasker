
import 'dart:convert';
import 'dart:developer';
import 'package:fairpytasker/Response/users_response.dart';
import 'package:http/http.dart' as http;
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:flutter/cupertino.dart';

class UsersRepository {
  ApiClient apiClient = ApiClient();

  Future<UsersListResponse?> getUsers() async {
    try {
      String apiUrl = "${Str.BASE_URL}userList";
      debugPrint("getAssignedTo apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          UsersListResponse usersListResponse =
          UsersListResponse.fromJson(json.decode(response.body));

          return usersListResponse; // Return departmentResponse here
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

  Future<UsersResponse?> createUsers(int? id,String? name) async {
    try {
      String body = jsonEncode({
        "name": name,
        "platform": "TaskerApp",
        "status": "1"
      });

      String apiUrl = '';
      http.Response? response;
      if(id != null) {
        apiUrl = "${Str.BASE_URL}updateUser/$id";
        debugPrint("getAssignedTo apiUrl: $apiUrl");
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }else{
        apiUrl = "${Str.BASE_URL}addUser";
        debugPrint("getAssignedTo apiUrl: $apiUrl");
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }
      if (response != null) {

        UsersResponse usersResponse =
        UsersResponse.fromJson(json.decode(response.body));

        if (response.statusCode == 200) {

          return usersResponse;
        } else {

          return usersResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('department.exception : ${error.toString()}');
      return null;
    }
  }

  Future<UsersResponse?> deleteUsers(String? id) async {
    try {
      String apiUrl = "${Str.BASE_URL}deleteDepartment/$id";

      final http.Response? response = await apiClient.callDelete(apiUrl);

      if (response != null) {
        UsersResponse usersResponse =
        UsersResponse.fromJson(json.decode(response.body));

        if (response.statusCode == 200) {
          return usersResponse;
        } else {
          return usersResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('feedback.exception : ${error.toString()}');
      return null;
    }
  }

}
