import 'package:fairpytasker/Remote/downloader.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import '../data/api_client.dart';

class ReportRepository {

  ApiClient apiClient = ApiClient();
  String _url(path) => "${Str.BASE_URL}$path";
  String _phase1Url(path) => "${Str.LIST_BASE_URL}$path";
  final APiRepository _apiRepository = APiRepository();

  Future<String?> downloadMaintenanceReport({Function(String? val)? onError}) async {
    var url = _url("getMaintanceCheckSheet");
    return await Downloader.instance.start(url, onError: onError);
  }

  Future<String?> downloadVehicleReport({Function(String? val)? onError}) async {
    var url = _url("getOdometerSheet");
    return await Downloader.instance.start(url, onError: onError);
  }

  Future<String?> downloadEarningSummary({Function(String? val)? onError}) async {
    var url = _url("getVehicleExpenseSheet");
    return await Downloader.instance.start(url, onError: onError);
  }

  Future<String?> downloadVehicleInventoryData({Function(String? val)? onError}) async {
    var url = _phase1Url("vehicle-inventory-data");
    return await Downloader.instance.start(url, onError: onError);
  }

  Future<String?> customDownload(String url, {Function(String? val)? onError}) async {
    return await Downloader.instance.start(url, onError: onError);
  }


  Future<Map<String, dynamic>?> uploadFile(String filePath) async {
    try {
      var response = await _apiRepository.tollExport(infusedFile: {"toll": filePath});
      if (response?['url'].toString().isNotNullOrEmpty ?? false) await customDownload(response?['url'].toString() ?? "");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> downloadTaskReport(DateRange? dateRange) async {
    try {
      var response = await _apiRepository.taskExport(fromDate: dateRange?.start, toDate: dateRange?.end);
      if (response?['url'].toString().isNotNullOrEmpty ?? false) response?['download'] = await customDownload(response['url'].toString() ?? "");
      return response;
    } catch (e) {
      rethrow;
    }
  }


}