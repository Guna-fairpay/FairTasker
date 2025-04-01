
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:flutter/cupertino.dart';

import '../Response/roles_response.dart';

class RolesRepository {
  ApiClient apiClient = ApiClient();

  Future<RolesListResponse?> getRoles() async {
    try {
      String apiUrl = "${Str.BASE_URL}roleList";
      debugPrint("getAssignedTo apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          RolesListResponse rolesListResponse =
          RolesListResponse.fromJson(json.decode(response.body));

          return rolesListResponse; // Return departmentResponse here
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

  Future<EditRoleResponse?> getEditRoles({int? id}) async {
    try {
      String apiUrl = "${Str.BASE_URL}editRole/$id";
      debugPrint("getEditRoles apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          EditRoleResponse editRoleResponse =
          EditRoleResponse.fromJson(json.decode(response.body));
          return editRoleResponse;
        } else {
          Utils.showNoResultFound();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getEditRoles.exception : ${error.toString()}');
      return null;
    }
  }

  Future<RolesResponse?> createRole(
      {int? id, String? name, List<dynamic>? permission}) async {
    try {
      String body = jsonEncode({
        "name":name,
        "permission": permission,
        "platform": "TaskerApp",
        "status": "1"
      });

      String apiUrl = '';
      http.Response? response;
      if(id != null) {
        apiUrl = "${Str.BASE_URL}updateRole/$id";
        debugPrint("getAssignedTo apiUrl: $apiUrl");
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }else{
        apiUrl = "${Str.BASE_URL}addRole";
        debugPrint("getAssignedTo apiUrl: $apiUrl");
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }
      if (response != null) {

        RolesResponse rolesResponse =
        RolesResponse.fromJson(json.decode(response.body));

        if (response.statusCode == 200) {

          return rolesResponse;
        } else {

          return rolesResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('department.exception : ${error.toString()}');
      return null;
    }
  }

  Future<RolesResponse?> deleteRole(int? id) async {
    try {
      String apiUrl = "${Str.BASE_URL}deleteRole/$id";

      final http.Response? response = await apiClient.callDelete(apiUrl);

      if (response != null) {
        RolesResponse rolesResponse =
        RolesResponse.fromJson(json.decode(response.body));

        if (response.statusCode == 200) {
          return rolesResponse;
        } else {
          return rolesResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('deleteRole.exception : ${error.toString()}');
      return null;
    }
  }

}