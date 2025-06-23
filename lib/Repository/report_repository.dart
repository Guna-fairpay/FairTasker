import 'package:fairpytasker/Remote/downloader.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
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
      /*String apiUrl = '${Str.BASE_URL}toll-export';
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
            return path;
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
      }*/
    } catch (e) {
      rethrow;
    }
  }


}