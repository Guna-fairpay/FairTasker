import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fairpytasker/Response/vendor_type_response.dart';
import 'package:http_parser/http_parser.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/data/api_client.dart';
import 'package:fairpytasker/Response/general_response.dart';
import 'package:flutter/cupertino.dart';

import '../../../Response/vendor_response.dart';

class VendorDataRepo {
  ApiClient apiClient = ApiClient();

  Future<VendorResponse?> getVendor() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}vendors";
      debugPrint("getAssignedTo apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        // if (response.statusCode == 200) {
        //   debugPrint('getAssignedTo api.response.body3: ${response.body}');
        //   debugPrint('getAssignedTo api.statusCode: ${response.statusCode}');

        VendorResponse assignedToResponse =
        VendorResponse.fromJson(json.decode(response.body));
        if (assignedToResponse.data != null) {
          return assignedToResponse;
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

  Future<Map<String, dynamic>?> getAndCreateVendor({
    int? id,
    String? name,
    String? vendorTypeId,
    String? address,
    String? phone,
    String? expertise,
    String? description,
    String? latitude,
    String? longitude,
    String? website,
    List<File>? images,
  }) async {
    try {
      String apiUrl = '';
      if (id != null) {
        apiUrl = "${Str.LIST_BASE_URL}vendors/$id";
      } else {
        apiUrl = "${Str.LIST_BASE_URL}vendors";
      }
      Map<String, String> reqMap ={
        "name": name??'',
        "type_id": vendorTypeId??'',
        "address": address??'',
        "phone": phone??'',
        "expertise": expertise??'',
        "description": description??'',
        "latitude": latitude??'',
        "longitude": longitude??'',
        "website": website??'',
        "platform": "TaskerApp",
        "status": "1",
      };
      var request = http.MultipartRequest("POST", Utils.getUri(apiUrl));
      request.headers.addAll(Utils.getHeaders());
      request.fields.addAll(reqMap);

      for (int i = 0; i < (images?.length ?? 0); i++) {
        var file = images![i];
        var multipartFile = http.MultipartFile.fromBytes(
          'images[$i]',
          (await file.readAsBytes()).toList(),
          filename: file.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      http.StreamedResponse streamedResponse = await request.send();

      if(streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201){
        final http.Response response =
        await http.Response.fromStream(streamedResponse);
        return json.decode(response.body);
      }
       else {
        Utils.showSomethingWentWrong();
        return null;
      }
    } catch (error) {
      log('createVendor.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> deleteVendor(int? vendorId) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}vendors/$vendorId";

      final http.Response? response = await apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          debugPrint('deleteVendor api.response.body: ${response.body}');
          debugPrint('deleteVendor api.statusCode: ${response.statusCode}');

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
      log('deleteVendor.exception : ${error.toString()}');
      return null;
    }
  }

  Future<VendorTypeResponse?> getVendorType() async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}vendor-types";
      debugPrint("getVendorType apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callGetMethod(
        apiUrl,
      );
      if (response != null) {
        // if (response.statusCode == 200) {
        // debugPrint('getAssignedTo api.response.body3: ${response.body}');
        // debugPrint('getAssignedTo api.statusCode: ${response.statusCode}');
        VendorTypeResponse assignedToResponse =
            VendorTypeResponse.fromJson(json.decode(response.body));
        if (assignedToResponse.data != null) {
          return assignedToResponse;
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

  Future<bool?> createVendorType(int? id, String? name) async {
    try {
      String body =
          jsonEncode({"name": name, "platform": "TaskerApp", "status": "1"});
      String apiUrl = '';
      http.Response? response;
      if (id != null) {
        apiUrl = "${Str.LIST_BASE_URL}vendor-types/$id";
        response = await apiClient.callPutMethod(apiUrl, body: body);
      } else {
        apiUrl = "${Str.LIST_BASE_URL}vendor-types";
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }

      debugPrint("createVendorTypeData apiUrl: $apiUrl");
      debugPrint("createVendorTypeData body: $body");
      if (response != null) {
        debugPrint('createVendorTypeData api.response.body: ${response.body}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint(
              'createVendorTypeData api.statusCode: ${response.statusCode}');

          GeneralResponse generalResponse =
              GeneralResponse.fromJson(json.decode(response.body));
          // if (generalResponse.status == 200 || generalResponse.status == 201) {
          Utils.showMobileToast(generalResponse.message!);
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
      log('createVendorTypeData.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> deleteVendorType(int? Id) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}vendor-types/$Id";

      final http.Response? response = await apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          debugPrint('deleteVendor api.response.body: ${response.body}');
          debugPrint('deleteVendor api.statusCode: ${response.statusCode}');

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
      log('deleteVendor.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> deleteImages(int? id) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}vendor-image-delete/$id";
      debugPrint("deleteExpenseImages apiUrl: $apiUrl");
      final http.Response? response = await apiClient.callDelete(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint('deleteExpenseImages api.response.body: ${response.body}');
          debugPrint(
              'deleteExpenseImages api.statusCode: ${response.statusCode}');

          // GeneralResponse generalResponse =
          // GeneralResponse.fromJson(json.decode(response.body));
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
      log('deleteExpenseImages.exception : ${error.toString()}');
      return null;
    }
  }
}
