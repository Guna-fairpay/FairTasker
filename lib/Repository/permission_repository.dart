import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:flutter/cupertino.dart';
import '../Response/permission_response.dart';

class PermissionRepository {
  ApiClient apiClient = ApiClient();

  Future<PermissionListResponse?> getPermissions() async {
    try {
      String apiUrl = "${Str.BASE_URL}permissionList";
      // debugPrint("getAssignedTo apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          PermissionListResponse permissionListResponse =
              PermissionListResponse.fromJson(json.decode(response.body));

          return permissionListResponse; // Return departmentResponse here
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

  Future<PermissionResponse?> createPermissions(
    int? id,
    String? name,
  ) async {
    try {
      String body =
          jsonEncode({"name": name, "platform": "TaskerApp", "status": "1"});

      String apiUrl = '';
      http.Response? response;
      if (id != null) {
        apiUrl = "${Str.BASE_URL}updatePermission/$id";
        debugPrint("getAssignedTo apiUrl: $apiUrl");
        response = await apiClient.callPostMethod(apiUrl, body: body);
      } else {
        apiUrl = "${Str.BASE_URL}addPermission";
        debugPrint("getAssignedTo apiUrl: $apiUrl");
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }
      print('BODY$body');
      if (response != null) {
        PermissionResponse permissionResponse =
            PermissionResponse.fromJson(json.decode(response.body));
        print('BODY$permissionResponse');
        if (response.statusCode == 200) {
          return permissionResponse;
        } else {
          return permissionResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('Employee.exception : ${error.toString()}');
      return null;
    }
  }

  Future<PermissionResponse?> deletePermission(String? id) async {
    try {
      String apiUrl = "${Str.BASE_URL}deletePermission/$id";

      final http.Response? response = await apiClient.callDelete(apiUrl);

      if (response != null) {
        PermissionResponse permissionResponse =
            PermissionResponse.fromJson(json.decode(response.body));

        if (response.statusCode == 200) {
          return permissionResponse;
        } else {
          return permissionResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('Employee.exception : ${error.toString()}');
      return null;
    }
  }
}
