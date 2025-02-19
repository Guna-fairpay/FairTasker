
import 'package:fairpytasker/Remote/downloader.dart';
import 'package:fairpytasker/Utilities/str.dart';

class ReportRepository {

  String _url(path) => "${Str.BASE_URL}$path";
  String _phase1Url(path) => "${Str.LIST_BASE_URL}$path";

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

}