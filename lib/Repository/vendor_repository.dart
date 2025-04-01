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

class VendorDataRepo {
  ApiClient apiClient = ApiClient();

  Future<bool?> createVendor(
    int? id,
    String name,
    String vendorTypeid,
    String address,
    String phone,
    String expertise,
    String description,
    List<File> images,
  ) async {
    try {
      String apiUrl = '';
      if (id != null) {
        apiUrl = "${Str.LIST_BASE_URL}vendors/$id";
      } else {
        apiUrl = "${Str.LIST_BASE_URL}vendors";
      }

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add form fields
      request.fields['name'] = name;
      request.fields['type_id'] = vendorTypeid;
      request.fields['address'] = address;
      request.fields['phone'] = phone;
      request.fields['expertise'] = expertise;
      request.fields['description'] = description;
      request.fields['platform'] = 'TaskerApp';
      request.fields['status'] = '1';

      // Add images to the request
      for (File image in images) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images[]', // Match your API field name for images
            image.path,
            contentType:
                MediaType('image', 'jpeg'), // Change based on the file type
          ),
        );
      }

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response body
        var responseBody = await http.Response.fromStream(response);
        GeneralResponse generalResponse =
            GeneralResponse.fromJson(json.decode(responseBody.body));

        Utils.showMobileToast(generalResponse.message!);
        return true;
      } else {
        Utils.showSomethingWentWrong();
        return null;
      }
    } catch (error) {
      log('createVendor.exception : ${error.toString()}');
      return null;
    }
  }
  // Future<bool?> createVendor(
  //     int? id,
  //     String name,
  //     String vendor_typeId,
  //     String address,
  //     String phone,
  //     String expertise,
  //     String description,
  //     List<File> images,
  //     ) async {
  //   try {
  //     String apiUrl = id != null
  //         ? "${Str.LIST_BASE_URL}vendors/$id"
  //         : "${Str.LIST_BASE_URL}vendors";
  //
  //     var request = http.MultipartRequest("POST", Utils.getUri(apiUrl));
  //     request.headers.addAll(Utils.getHeaders());
  //
  //     // Add fields to the request
  //     request.fields['name'] = name;
  //     request.fields['type_id'] = vendor_typeId;
  //     request.fields['address'] = address;
  //     request.fields['phone'] = phone;
  //     request.fields['expertise'] = expertise;
  //     request.fields['description'] = description;
  //     request.fields['platform'] = 'TaskerApp';
  //     request.fields['status'] = '1';
  //
  //     // Add files to the request
  //     for (int i = 0; i < images.length; i++) {
  //       var file = images[i];
  //       var multipartFile = http.MultipartFile.fromBytes(
  //         'files[$i]',
  //         await file.readAsBytes(),
  //         filename: file.path.split('/').last,
  //       );
  //       request.files.add(multipartFile);
  //     }
  //
  //     var streamedResponse = await request.send();
  //     var response = await http.Response.fromStream(streamedResponse);
  //     debugPrint('createVendor.statusCode: ${response.statusCode}');
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       GeneralResponse generalResponse = GeneralResponse.fromJson(json.decode(response.body));
  //       return response.data;
  //     } else {
  //       Utils.showSomethingWentWrong();
  //       return null;
  //     }
  //   } catch (error) {
  //     log('createVendor.exception : ${error.toString()}');
  //     return null;
  //   }
  // }

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
