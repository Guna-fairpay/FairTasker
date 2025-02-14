
import 'dart:convert';
import 'dart:developer';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


class LocationDataRepo {
  ApiClient apiClient = ApiClient();

  Future<bool?> createLocation(
      {int? id,  String? name, List<dynamic>? address}) async {
    try {
      String body = '';
      String apiUrl = '';
      if(address != null) {
        apiUrl = "${Str.LIST_BASE_URL}location_address";
        body = jsonEncode({
          "location_id":id,
          "address":address,
          "platform":'TaskerApp',
        });
      }else if(id != null) {
        apiUrl = "${Str.LIST_BASE_URL}locations/$id";
        body = jsonEncode({
          "name":name,
          "platform":'TaskerApp',
          "status":"1"
        });
      }else{
        apiUrl = "${Str.LIST_BASE_URL}locations";
        body = jsonEncode({
          "address":address,
          "name":name,
          "platform":'TaskerApp',
          "status":"1"
        });
      }
      final http.Response? response = await apiClient.callPostMethod(apiUrl, body: body);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          return true;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('createLocation.exception : ${error.toString()}');
      return null;
    }
  }

/*  Future<LocationResponse?> createLocation(
      int? id,
      String name,
      List<dynamic>? address) async {
    try {
      String body = jsonEncode({
        "address":address,
        "name":name,
        "platform":'TaskerApp',
        "status":"1"
      });
      String apiUrl = '';
      http.Response? response;
      if(id != null) {
        apiUrl = "${Str.LIST_BASE_URL}location_address";
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }else{
        apiUrl = "${Str.LIST_BASE_URL}locations";
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }
      log("${body}",name: "updatedLocation");
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          LocationResponse locationResponse =
          LocationResponse.fromJson(json.decode(response.body));
          log("${response.body}",name: "updatedLocation");
          return locationResponse;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('createLocation.exception : ${error.toString()}');
      return null;
    }
  }*/

  Future<bool?> deleteLocation(int? id) async {
    try {
      String apiUrl = '';
        apiUrl = "${Str.LIST_BASE_URL}location_address/$id";
      final http.Response? response = await apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          return true;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('deleteLocation.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> delete(int? id) async {
    try {
      String apiUrl;
      apiUrl = '${Str.LIST_BASE_URL}locations/$id';
      debugPrint("delete-locations apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          return true;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      debugPrint('delete Location For Item.exception : ${error.toString()}');
      return null;
    }
  }

}
