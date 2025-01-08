//
// import 'dart:convert';
// import 'dart:developer';
// import 'package:http/http.dart' as http;
// import 'package:fairpytasker/Utilities/str.dart';
// import 'package:fairpytasker/Utilities/utils.dart';
// import 'package:fairpytasker/data/api_client.dart';
// import 'package:flutter/cupertino.dart';
//
// import '../Response/cohorts_response.dart';
// import '../Response/payment_response.dart';
//
// class CohortsRepository {
//   ApiClient apiClient = ApiClient();
//
//   Future<CohortsResponse?> getCohorts() async{
//     try {
//       String apiUrl = '${Str.LIST_BASE_URL}getCohortsData';
//       debugPrint("fetchDropdownValues apiUrl: $apiUrl");
//
//       final http.Response? response =
//       await apiClient.callGetMethod(apiUrl);
//       if (response != null) {
//         if (response.statusCode == 200) {
//           CohortsResponse createExpenseFieldData =
//           CohortsResponse.fromJson(json.decode(response.body));
//
//           return createExpenseFieldData;
//         } else {
//           Utils.showSomethingWentWrong();
//           return null;
//         }
//       } else {
//         return null;
//       }
//     } catch (error) {
//       debugPrint('getProfileAPI.exception : ${error.toString()}');
//       return null;
//     }
//   }
//
//   Future<PaymentResponse?> getPayment() async {
//     try {
//       String apiUrl = "${Str.LIST_BASE_URL}payment-methods";
//       debugPrint("getPayment apiUrl: $apiUrl");
//
//       final http.Response? response = await apiClient.callGetMethod(apiUrl);
//       if (response != null) {
//         if (response.statusCode == 200) {
//           PaymentResponse paymentResponse =
//           PaymentResponse.fromJson(json.decode(response.body));
//
//           return paymentResponse; // Return departmentResponse here
//         } else {
//           Utils.showNoResultFound();
//           return null;
//         }
//       } else {
//         return null;
//       }
//     } catch (error) {
//       log('getPayment.exception : ${error.toString()}');
//       return null;
//     }
//   }
//
// }
