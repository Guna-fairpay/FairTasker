import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fairpytasker/Response/assigned_to_response.dart';
import 'package:fairpytasker/Response/general_response.dart';
import 'package:fairpytasker/Response/user_group_response.dart';
import 'package:fairpytasker/Response/vehicle_history_response.dart';
import 'package:fairpytasker/core/app/extension/response_extension.dart';
import 'package:fairpytasker/core/app/helper/file_saver.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../Utilities/Utils.dart';
import '../Utilities/str.dart' show Str;

class APiRepository {
  final ApiClient _apiClient = ApiClient();

  String get _searchHistoryApi => "get-vehicle-search-history";

  String get _getEditToDoApi => "edit-todo";

  String get _updateToDoApi => "update-todo";

  String get _resourcesApi => "getresources";

  String get _groupPersonApi => "group-person";

  String get _completeToDoApi => "complete-todo";

  String get _deleteToDoApi => "delete-todo";

  String get _generateInvoiceApi => "generate-invoice";

  Future<VehicleHistoryResponse?> getVehicleHistoryList(String vin,
      {int? currentPage, int itemsPerPage = 5, String? search}) async {
    try {
      String apiUrl = '${Str.BASE_URL}$_searchHistoryApi';
      final Map<String, dynamic> map = {};
      map['page'] = currentPage;
      map['vin'] = vin;
      if (search?.isNotEmpty ?? false) map['search'] = search;
      map['itemsPerPage'] = itemsPerPage;
      map.removeWhere((key, value) => value == null);
      final http.Response? response =
          await _apiClient.callGetMethod(apiUrl, params: map);
      var mapData = await response.mapData;
      return VehicleHistoryResponse.fromJson(mapData ?? {});
    } on Exception {
      rethrow;
    }
  }

  Future<AssignedToResponse?> getResourcesList() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_resourcesApi";
      final http.Response? response = await _apiClient.callGetMethod(
        apiUrl,
      );
      var mapData = await response.mapData;
      return (mapData != null) ? AssignedToResponse.fromJson(mapData) : null;
    } catch (error) {
      rethrow;
    }
  }

  Future<UserGroupResponse?> getGroupPersonList() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_groupPersonApi";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return (mapData != null) ? UserGroupResponse.fromJson(mapData) : null;
    } catch (error) {
      rethrow;
    }
  }

  Future<GeneralResponse?> completeToDo(dynamic todoId,
      {bool status = true}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_completeToDoApi/$todoId";
      final Map<String, dynamic> map = {};
      map['status'] = status;
      final http.Response? response =
          await _apiClient.callPostMethod(apiUrl, body: jsonEncode(map));
      var mapData = await response.mapData;
      return GeneralResponse.fromJson(mapData);
    } catch (error) {
      rethrow;
    }
  }

  Future<GeneralResponse?> deleteToDo(dynamic todoId, dynamic reason) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_deleteToDoApi/$todoId";
      final Map<String, dynamic> map = {};
      map['reason'] = reason;
      final http.Response? response =
          await _apiClient.callDelete(apiUrl, body: map);
      var mapData = await response.mapData;
      return GeneralResponse.fromJson(mapData);
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> editToDo(dynamic todoId) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_getEditToDoApi/$todoId";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

 /* Future<Map<String, dynamic>?> updateToDoApi(
      {required Map<String, dynamic> body, required List<File>? images,required String todoId}) async {
    var url = "${Str.BASE_URL}$_updateToDoApi/$todoId";
    var response = await _apiClient.callPostMethodWithBody(url,
        fieldName: "images",
        autoIncrement: true,
        files: images?.map((e) => e.path).toList(),
        body: body);
    log("${response?.body}", name: "response");
    return response.mapData;
  }*/

  Future<Map<String, dynamic>?> updateToDoApi({Map<String, dynamic>? body, List<File>? images,String? todoId }) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_updateToDoApi/$todoId";
      final http.Response? response =
      await _apiClient.callPostMethodWithBody(apiUrl, body: body?..putIfAbsent('type', () => "inline"),
          files: images?.map((e) => e.path).toList());
      if (response != null) {
        if (response.isSuccess) {
          var mapData = await response.mapData;
          Toaster.showSuccess( mapData?['message'] ??  "Todo Updated Successfully");
          return mapData;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('callLoginAPI.exception2 : ${error.toString()}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> generateInvoice({Map<String, String>? body}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_generateInvoiceApi";
      final http.Response? response =
      await _apiClient.callPostMethod(apiUrl, body: jsonEncode(body));
      if (response != null) {
        if (response.isSuccess) {
          var path = await FileSaver.instance.saveFile(response);
          Toaster.showSuccess( "Invoice Generated Successfully $path");
          return {'message' : path};
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('callInvoiceAPI.exception : ${error.toString()}');
      return null;
    }
  }


}
