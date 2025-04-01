
import 'dart:convert';
import 'dart:developer';
import 'package:fairpytasker/Response/category_config_response.dart';
import 'package:http/http.dart' as http;
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:flutter/cupertino.dart';

class CategoryConfigRepository {
  ApiClient apiClient = ApiClient();

  Future<CategoryConfigResponse?> getCategoryConfig() async {
    try {
      String apiUrl = "${Str.BASE_URL}taskCategory";
      debugPrint("getAssignedTo apiUrl: $apiUrl");

      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {

        if (response.statusCode == 200) {

          CategoryConfigResponse categoryConfigResponse =
          CategoryConfigResponse.fromJson(json.decode(response.body));
          return categoryConfigResponse; // Return departmentResponse here
        } else {
          Utils.showNoResultFound();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getCategoryConfig.exception : ${error.toString()}');
      return null;
    }
  }

  Future<CategoryConfigResponse?> createCategoryConfig(int? id,String? name,String? parentId,String? userType) async {
    try {
      String body = jsonEncode({
        "name": name,
        "parent_id":parentId,
        "todo_user_type":userType,
        "platform": "TaskerApp",
        "status": "1"
      });

      String apiUrl = '';
      http.Response? response;
      if(id != null) {
        apiUrl = "${Str.BASE_URL}updateTaskCategory/$id";
        debugPrint("getAssignedTo apiUrl: $apiUrl");
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }else{
        apiUrl = "${Str.BASE_URL}addTaskCategory";
        debugPrint("getAssignedTo apiUrl: $apiUrl");
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }
      if (response != null) {

        CategoryConfigResponse categoryConfigResponse =
        CategoryConfigResponse.fromJson(json.decode(response.body));

        if (response.statusCode == 200) {

          return categoryConfigResponse;
        } else {

          return categoryConfigResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('categoryConfig.exception : ${error.toString()}');
      return null;
    }
  }

  Future<CategoryConfigResponse?> deleteCategoryConfig(String? id) async {
    try {
      String apiUrl = "${Str.BASE_URL}deleteTaskCategory/$id";

      final http.Response? response = await apiClient.callDelete(apiUrl);

      if (response != null) {
        CategoryConfigResponse categoryConfigResponse =
        CategoryConfigResponse.fromJson(json.decode(response.body));

        if (response.statusCode == 200) {
          return categoryConfigResponse;
        } else {
          return categoryConfigResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('categoryConfig.exception : ${error.toString()}');
      return null;
    }
  }
}
