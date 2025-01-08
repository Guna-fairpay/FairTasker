
import 'dart:convert';
import 'dart:developer';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:fairpytasker/Response/general_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class LocationDataRepo {
  ApiClient apiClient = ApiClient();

  Future<bool?> createLocation(int? id, String name, List<String>? address) async {
    try {
      String body = '';
      String apiUrl = '';
      if(id != null) {
        apiUrl = "${Str.LIST_BASE_URL}location_address";
        body = jsonEncode({
          "location_id":id,
          "address":address,
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

      

          // GeneralResponse generalResponse = GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          // Utils.showMobileToast(generalResponse.message!);
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
      log('createLocation.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> deleteLocation(int? vendorId, {bool? isLocationAddress}) async {
    try {
      String apiUrl = '';
      if(isLocationAddress != null && isLocationAddress) {
        apiUrl = "${Str.LIST_BASE_URL}location_address/$vendorId";
      }else{
        apiUrl = "${Str.LIST_BASE_URL}locations/$vendorId";
      }
     
      final http.Response? response = await apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          debugPrint('deleteLocation api.response.body: ${response.body}');
          debugPrint('deleteLocation api.statusCode: ${response.statusCode}');

          GeneralResponse generalResponse =
          GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          // Utils.showNoResultFound();
          return true;
          // }else {
          // debugPrint('---------------> ${TodoListResponse.status!}');
          return false;
          // }
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

}
