
import 'dart:convert';
import 'dart:developer';
import 'dart:io';


import 'package:fairpytasker/Remote/downloader.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Utilities/Utils.dart';
import '../data/api_client.dart';

class ReportRepository {

  ApiClient apiClient = ApiClient();
  String _url(path) => "${Str.BASE_URL}$path";
  String _phase1Url(path) => "${Str.LIST_BASE_URL}$path";
  String _phase2Url(path) => "${Str.BASE_URL}$path";

  Future downloadMaintenanceReport({Function(String? val)? onError}) async {
    var url = _url("getMaintanceCheckSheet");
    return await Downloader.instance.start(url, onError: onError);
  }

  Future downloadVehicleReport({Function(String? val)? onError}) async {
    var url = _url("getOdometerSheet");
    return await Downloader.instance.start(url, onError: onError);
  }

  Future downloadEarningSummary({Function(String? val)? onError}) async {
    var url = _url("getVehicleExpenseSheet");
    return await Downloader.instance.start(url, onError: onError);
  }

  Future downloadVehicleInventoryData({Function(String? val)? onError}) async {
    var url = _phase1Url("vehicle-inventory-data");
    return await Downloader.instance.start(url, onError: onError);
  }

  Future customDownload(String url, {Function(String? val)? onError}) async {
    return await Downloader.instance.start(url, onError: onError);
  }


  Future<bool?> uploadFile(String filePath) async {
    try {
      String apiUrl = '${Str.BASE_URL}toll-export';
      final http.Response? response = await apiClient.callPostMethodWithBodyDynamic(apiUrl, infusedFiles: {"toll": filePath});
      log("${response?.body}");

      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Parse the JSON response
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          String? downloadUrl = responseData['url'];

          if (downloadUrl != null) {
            // Download the file
            String path = await customDownload(downloadUrl);
            Toaster.showSuccess("File downloaded successfully $path");
            return true;
          } else {
            Utils.showSomethingWentWrong();
            return null;
          }
        } else {
          Utils.showSomethingWentWrong();
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      log("Error in upload file: $e");
      return null;
    }
  }


}