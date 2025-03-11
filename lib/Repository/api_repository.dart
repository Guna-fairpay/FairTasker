import 'dart:convert';
import 'package:fairpytasker/Response/assigned_to_response.dart';
import 'package:fairpytasker/Response/general_response.dart';
import 'package:fairpytasker/Response/user_group_response.dart';
import 'package:fairpytasker/Response/vehicle_history_response.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/response_extension.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:http/http.dart' as http;
import '../Utilities/str.dart' show Str;

class APiRepository {
  final ApiClient _apiClient = ApiClient();

  String get _searchHistoryApi => "get-vehicle-search-history";

  String get _editToDoApi => "edit-todo";

  String get _resourcesApi => "getresources";

  String get _groupPersonApi => "group-person";

  String get _completeToDoApi => "complete-todo";

  String get _deleteToDoApi => "delete-todo";

  String get _vehicleCategoriesApi => "vehicle_status/categories";

  String get _vehicleStatusApi => "vehicleStatusApi";

  String get _getCohortsApi => "getCohortsData";

  String get _turoVehiclesList => "getTuroVehiclesList";

  Future<VehicleHistoryResponse?> getVehicleHistoryList(String vin, {int? currentPage, int itemsPerPage = 5, String? search}) async {
    try {
      String apiUrl = '${Str.BASE_URL}$_searchHistoryApi';
      final Map<String, dynamic> map = {};
      map['page'] = currentPage;
      map['vin'] = vin;
      if (search?.isNotEmpty ?? false) map['search'] = search;
      map['itemsPerPage'] = itemsPerPage;
      map.removeWhere((key, value) => value == null);
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: map);
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

  Future<GeneralResponse?> completeToDo(dynamic todoId, {bool status = true}) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_completeToDoApi/$todoId";
      final Map<String, dynamic> map = {};
      map['status'] = status;
      final http.Response? response = await _apiClient.callPostMethod(apiUrl, body: jsonEncode(map));
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
      final http.Response? response = await _apiClient.callDelete(apiUrl, body: map);
      var mapData = await response.mapData;
      return GeneralResponse.fromJson(mapData);
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> editToDo(dynamic todoId) async {
    try {
      String apiUrl = "${Str.BASE_URL}$_editToDoApi/$todoId";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getVehicleCategories() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vehicleCategoriesApi";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getVehicleStatus(dynamic statusId) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_vehicleStatusApi";
      Map<String, dynamic> params = {};
      if (statusId != null && statusId != 0 && statusId != "0") params['vehicle_status'] = statusId;
      params['branch_code'] = Session.of.getInt(Str.branchIdPrefText);
      final http.Response? response = await _apiClient.callGetMethod(apiUrl, params: params);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getCohorts() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}$_getCohortsApi";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getTuroVehiclesList() async {
    try {
      String apiUrl = "${Str.BASE_URL}$_turoVehiclesList";
      final http.Response? response = await _apiClient.callGetMethod(apiUrl);
      var mapData = await response.mapData;
      return mapData;
    } catch (e) {
      rethrow;
    }
  }
}
