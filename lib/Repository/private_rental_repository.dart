
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fairpytasker/Response/customer_response.dart';
import 'package:fairpytasker/Response/private_rental_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/data/api_client.dart';

class PrivateRentalRepository {

  ApiClient apiClient = ApiClient();
  Future<PrivateRentalResponse?> getPrivateRentalData() async {
    try {
      String apiUrl = '';
      apiUrl = "${Str.LIST_BASE_URL}private_rental_vehicles_list";
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          PrivateRentalResponse privateRentalResponse =
          PrivateRentalResponse.fromJson(json.decode(response.body));
          return privateRentalResponse;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getPrivateRentalData.exception : ${error.toString()}');
      return null;
    }
  }

  Future<PrivateRentalResponse?> createPrivateRental(
      int? id, String? vin, String? customerId,
      String? checkInDate, String? checkOutDate,
      String? checkInMileage, String? checkOutMileage,
      String? rentalStatus) async {
    try {
      String body = jsonEncode({
        "vin":vin,
        "customer_id": customerId,
        "check_in_date":checkInDate,
        "check_out_date":checkOutDate,
        "check_in_mileage":checkInMileage,
        "check_out_mileage":checkOutMileage,
        "rental_status":rentalStatus,
        "platform": "TaskerApp",
      });
      String apiUrl = '';
      http.Response? response;
      if(id != null) {
        apiUrl = "${Str.LIST_BASE_URL}private_rental_update/$id";
        debugPrint("getAssignedTo apiUrl: $apiUrl");
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }else{
        apiUrl = "${Str.LIST_BASE_URL}private_rental_assign";
        debugPrint("getAssignedTo apiUrl: $apiUrl");
        response = await apiClient.callPostMethod(apiUrl, body: body);
      }
      if (response != null) {
        PrivateRentalResponse privateRentalResponse =
        PrivateRentalResponse.fromJson(json.decode(response.body));
        if (response.statusCode == 200) {
          return privateRentalResponse;
        } else {
          return privateRentalResponse;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('createCustomer.exception : ${error.toString()}');
      return null;
    }
  }

  Future<CustomerResponse?> getCustomerData() async {
    try {
      String apiUrl = '';
      apiUrl = "${Str.LIST_BASE_URL}private_rental_customers_list";
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          CustomerResponse customerResponse =
          CustomerResponse.fromJson(json.decode(response.body));
          return customerResponse;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getCustomerData.exception : ${error.toString()}');
      return null;
    }
  }

  Future<CustomerResponse?> getEditCustomerData(int? id) async {
    try {
      String apiUrl = '';
      apiUrl = "${Str.LIST_BASE_URL}private_rental_edit_customer/$id";
      final http.Response? response = await apiClient.callGetMethod(apiUrl);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          CustomerResponse customerResponse =
          CustomerResponse.fromJson(json.decode(response.body));
          return customerResponse;
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      log('getEditCustomerData.exception : ${error.toString()}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> createCustomer(
      int? id,
      String firstName,
      String lastName,
      String phone,
      String address,
      String monthlyRental,
      String rentalStartDate,
      String securityDeposit,
      String note,
      List<File>? licenceAttach,
      List<File>? insuranceAttach
      ) async {
    try {
      String apiUrl = '';
      if(id != null) {
        apiUrl = "${Str.LIST_BASE_URL}private_rental_update_customer/$id";
      }else{
        apiUrl = "${Str.LIST_BASE_URL}private_rental_store_customer";
       }
      Map<String, String> reqMap={
        "first_name":firstName,
        "last_name": lastName,
        "phone":phone,
        "address":address,
        "monthly_rental":monthlyRental,
        "rental_start_date":rentalStartDate,
        "security_deposit":securityDeposit,
        "note":note,
        "platform": "TaskerApp",
      };
      var request = http.MultipartRequest("POST", Utils.getUri(apiUrl));
      request.headers.addAll(Utils.getHeaders());
      request.fields.addAll(reqMap);

      for (int i = 0; i < (licenceAttach?.length ?? 0); i++) {
        var file = licenceAttach![i];
        var multipartFile = http.MultipartFile.fromBytes(
          'licenseAttach[$i]',
          (await file.readAsBytes()).toList(),
          filename: file.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      for (int i = 0; i < (insuranceAttach?.length ?? 0); i++) {
        var file = insuranceAttach![i];
        var multipartFile = http.MultipartFile.fromBytes(
          'insuranceAttach[$i]',
          (await file.readAsBytes()).toList(),
          filename: file.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      http.StreamedResponse streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201) {
        final http.Response response =
        await http.Response.fromStream(streamedResponse);
        return json.decode(response.body);
      } else {
        Utils.showSomethingWentWrong();
        return null;
      }
    } catch (error) {
      log('createCustomer.exception : ${error.toString()}');
      return null;
    }
  }

  Future<bool?> deleteCustomer(int? id) async {
    try {
      String apiUrl = "${Str.LIST_BASE_URL}private_rental_delete_customer/$id";
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
      log('customer.exception : ${error.toString()}');
      return null;
    }
  }

}
