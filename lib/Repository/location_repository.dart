
import 'dart:convert';
import 'dart:developer';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


class LocationDataRepo {
  ApiClient apiClient = ApiClient();

  Future<bool?> createLocation({int? id, String? name, List<dynamic>? address}) async {
    try {
      log(" id - ${id} name - ${name} address - ${address}");
      Map<String, dynamic> body = {
        "platform": 'TaskerApp',
        "status": "1",
      };

      if (id != null && address != null) {
        log("Block 1");
        final newAddresses = address.where((addr) =>
        addr is Map && !addr.containsKey('id')).toList();

        for (final addr in newAddresses) {
          final response = await apiClient.callPostMethod(
            "${Str.LIST_BASE_URL}location_address",
            body: jsonEncode({
              "location_id": id,
              "address": addr['address'] is List ? addr['address'] : [addr['address']],
              "platform": addr['platform'] ?? 'TaskerApp',
            }),
          );

          if (response?.statusCode != 200) {
            log("Failed to create address: ${addr['address']}");
            return false;
          }
        }
        final addressWithId = address.where((addr) => addr is Map && addr.containsKey('id')).toList();
        for (final addr in addressWithId){
          final response = await apiClient.callPostMethod("${Str.LIST_BASE_URL}location_address/${addr['id']}",
          body: jsonEncode({
            'address':addr['address'],
            'platform':'TaskerApp',
            'location_id':id,
          })
          );

          if (response?.statusCode != 200) {
            log("Failed to create address: ${addr['address']}");
            return false;
          }
        }
      }

      String apiUrl;
      if (id != null && name != null) {
        log("Block 2");
        apiUrl = "${Str.LIST_BASE_URL}locations/$id";
        body["name"] = name;

        if (address != null) {
          log("Block 3");
          body["address"] = address.where((addr) =>
          addr is Map && addr.containsKey('id')).toList();
        }
      } else {
        log("Block 4");
        apiUrl = "${Str.LIST_BASE_URL}locations";
        body["name"] = name;
        body["address"] = address?.map((a) =>
        a is Map ? a['address'] : a).toList() ?? [];
      }

      final response = await apiClient.callPostMethod(
        apiUrl,
        body: jsonEncode(body),
      );

      return response?.statusCode == 200 || response?.statusCode == 201;
    } catch (error) {
      log('Error: $error');
      return null;
    }
  }

  // Future<bool?> createLocation({int? id, String? name, List<dynamic>? address}) async {
  //   try {
  //     log("id - ${id}, name - ${name}, address - ${address}");
  //     Map<String, dynamic> body = {
  //       "platform": 'TaskerApp',
  //       "status": "1",
  //       "name": name,
  //       "address": address ?? [], // Default to empty list if address is null
  //     };
  //
  //     String apiUrl = id != null ? "${Str.LIST_BASE_URL}locations/$id" : "${Str.LIST_BASE_URL}locations";
  //
  //     final response = await apiClient.callPostMethod(
  //       apiUrl,
  //       body: jsonEncode(body),
  //     );
  //
  //     return response?.statusCode == 200 || response?.statusCode == 201;
  //   } catch (error) {
  //     log('Error: $error');
  //     return null;
  //   }
  // }

  /*Future<bool?> createLocation({int? id,  String? name, List<dynamic>? address}) async {
    try {
      String body = '';
      String apiUrl = '';
      if(id != null && address != null) {
        apiUrl = "${Str.LIST_BASE_URL}location_address";
        body = jsonEncode({
          "location_id":id,
          "address":address,
          "platform":'TaskerApp',
        });
      }if(id != null) {
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
  }*/

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
