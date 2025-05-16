import 'dart:developer';
import 'dart:io';
import 'dart:ui' show VoidCallback;
import 'package:date_time/date_time.dart';
import 'package:fairpytasker/core/initializer/receive_intent.dart';
import 'package:fairpytasker/core/initializer/todo_supporter.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/authenticator.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/utilities/utils.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class Initializer {

  Initializer._();

  static final Initializer of = Initializer._();

  void init() async {
    tz.initializeTimeZones();
    getIt.registerSingleton<CommonService>(CommonService());
    getIt.registerSingleton<ToDoSupport>(ToDoSupport());
    getIt.registerSingleton<ReceiveIntent>(ReceiveIntent());
  }
}

class CommonService {
  final _apiRepository = APiRepository();

  final _chicagoTime = tz.getLocation("America/Chicago");
  final FBroadcast _broadcast = FBroadcast.instance();
  List<Map<String, dynamic>> usersList = [];
  List<Map<String, dynamic>> cohortsList = [];
  List<Map<String, dynamic>> vendorsList = [];
  List<Map<String, dynamic>> vendorsTypeList = [];
  List<Map<String, dynamic>> locationsList = [];
  List<Map<String, dynamic>> partsList = [];
  List<Map<String, dynamic>> suppliesList = [];
  List<Map<String, dynamic>> groupVehicleList = [];
  List<Map<String, dynamic>> activeVehicleList = [];
  List<Map<String, dynamic>> activeVehicleCountList = [];
  List<Map<String, dynamic>> bouncieVehicles = [];
  List<Map<String, dynamic>> groupPersonList = [];
  List<Map<String, dynamic>> taskExpenseDataList = [];
  List<Map<String, dynamic>> expenseCategoriesList = [];
  List<Map<String, dynamic>> paymentTypesList = [];
  List<Map<String, dynamic>> resourcesList = [];
  List<Map<String, dynamic>> branchList = [];
  List<Map<String, dynamic>> vehicleStatusList = [];
  List<Map<String, dynamic>> _toDoList = [];
  List<Map<String, dynamic>> _privateRentalVehicleList = [];
  List<Map<String, dynamic>> _privateRentalCustomersList = [];
  List<Map<String, dynamic>> _maintenanceCheckList = [];
  List<Map<String, dynamic>> _checkList = [];
  Map<String, dynamic> employeesList = {};
  List<Map<String, dynamic>> taskCategoryGroupList = [];
  Map<String, dynamic>? _vehicleStatus;
  List<Map<String, dynamic>> _leavelistType = [];


  final ValueNotifier<bool> updateBranch = ValueNotifier(false);
  int get userId => int.tryParse(Session.of.getString(Str.userIdPrefText) ?? "0") ?? 0;
  Iterable<String>? get roles => Session.of.getStringList(Str.rolePrefText)?.map((e) => e.toString().toLowerCase());
  bool get isAdmin => (roles?.contains("admin") ?? false) || (userId == 3);
  bool get showExpense => ((roles?.contains("admin") ?? false) || ([3, 22, 1, 28, 21, ].contains(userId)));

  int get departmentId => Session.of.getInt("departmentId") ?? 0;
  int? get branchId => Session.of.getInt(Str.branchIdPrefText);
  int? get hrmId => Session.of.getInt(Str.hrmIdPrefText);

  String get currentPlatform => Platform.isAndroid ? "android" : "ios";

  List<String>? get userPermissions => Session.of.getStringList(Str.userPermissionPrefText);

  bool get showBranchSelection {
    var hasDepartmentId = [6,7,8].contains(departmentId);
    var hasHrmId = Session.of.getInt(Str.hrmIdPrefText) != 0;
    return ((isAdmin || hasDepartmentId) && hasHrmId) && (![21].contains(userId));
  }

  void branchUpdate({VoidCallback? callback}) {
    _broadcast.register(Str.branchChange, (value, _) => callback?.call());
  }

  List<dynamic> get currentBranchHrmIds {
    var userList = List.from(usersList);
    userList.removeWhere((element) => (element['deleted_at'].toString().isNotNullOrEmpty) || (element['hrm_id'].toString().isNullOrEmpty));
    return userList.where((element) => element['branch_id'] == branchId).map((e) => e['hrm_id'] ?? 0).toList();
  }

  String? get timeNow {
    var now = tz.TZDateTime.now(_chicagoTime);
    return now.toFormat(format: "HH:mm:ss");
  }

  Time? get usTimeNow {
    var now = tz.TZDateTime.now(_chicagoTime);
    return now.time;
  }

  DateTime get usNow {
    var now = tz.TZDateTime.now(_chicagoTime);
    return now;
  }

  Future<void> initialFetch() async {
    await Future.wait([
      getUsers(),
      getCohorts(),
      getBranches(),
      Authenticator.instance.getBearerToken(),
      Authenticator.instance.getDepartmentId(),
    ]);
    Console.of.log("$timeNow", name: "TIME_NOW_IN_AMERICA");
  }

  Future<Map<String, dynamic>?> getCurrentLocation() async {
    if (await Geolocator.isLocationServiceEnabled()) {
      if ([LocationPermission.denied, LocationPermission.deniedForever].contains(await Geolocator.checkPermission())) {
        if ([LocationPermission.denied, LocationPermission.deniedForever].contains(await Geolocator.requestPermission())) {
          await Geolocator.openLocationSettings();
          return null;
        } else {
          return await getCurrentLocation();
        }
      } else {
        Position position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.bestForNavigation));
        var location = (await placemarkFromCoordinates(position.latitude, position.longitude)).firstOrNull;
        List<String> address = {
          location?.name ?? "",
          location?.street ?? "",
          location?.thoroughfare ?? "",
          location?.subLocality ?? "",
          location?.locality ?? "",
          location?.administrativeArea ?? "",
          location?.postalCode ?? "",
          location?.country ?? "",
        }.toList().unique((element) => element)..removeWhere((element) => element.isNullOrEmpty);
        Console.of.log(address.join(", "), name: "ADDRESS");
        return {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'name': location?.name,
          'subLocality': location?.subLocality,
          'locality': location?.locality,
          'postalCode': location?.postalCode,
          'country': location?.country,
          'address': address.join(", "),
        };
      }
    } else {
      await Geolocator.openLocationSettings();
      return null;
    }
  }

  int get getUserId {
    if (isAdmin) {
      var userId = usersList.firstWhereOrNull((element) => ((element['first_name'].toString().toLowerCase() == "product") && (element['last_name'].toString().toLowerCase() == "owner")))?['id'] ?? 0;
      return userId;
    } else {
      return int.tryParse(Session.of.getString(Str.userIdPrefText) ?? "0") ?? 0;
    }
  }

  Map<String, dynamic>? get user {
    var userId = getUserId;
    return usersList.firstWhereOrNull((element) => element['id'] == userId);
  }

  Future<List<Map<String, dynamic>>> getUsers({bool reset = false}) async {
    if (reset) usersList.clear();
    if (usersList.isNotEmpty) return List.from(usersList);
    try {
      var response = await _apiRepository.getUsers();
      usersList = List<Map<String, dynamic>>.from(response?['usersList'] ?? []);
      return List.from(usersList);
    } catch (e) {
      Toaster.showError(e.toString());
      return [];
    }
  }

  Future<Map<String, dynamic>?> _getCohortsAll() async {
    var response = await _apiRepository.getCohorts();
    return response;
  }

  Future<List<Map<String, dynamic>>> getCohorts({bool reset = false}) async {
    if (reset) cohortsList.clear();
    if (cohortsList.isNotEmpty) return cohortsList;
    try {
      var response = await _getCohortsAll();
      cohortsList = List<Map<String, dynamic>>.from(response?['cohortsData'] ?? []);
      expenseCategoriesList = List<Map<String, dynamic>>.from(response?['expenseCategories'] ?? []);
      return cohortsList;
    } catch (e) {
      Toaster.showError(e.toString());
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getExpenseCategories({bool reset = false}) async {
    if (reset) expenseCategoriesList.clear();
    if (expenseCategoriesList.isNotEmpty) return List.from(expenseCategoriesList);
    try {
      var response = await _getCohortsAll();
      cohortsList = List<Map<String, dynamic>>.from(response?['cohortsData'] ?? []);
      expenseCategoriesList = List<Map<String, dynamic>>.from(response?['expenseCategories'] ?? []);
      return List.from(expenseCategoriesList);
    } catch (e) {
      Toaster.showError(e.toString());
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> groupVehicles({bool reset = false}) async {
    if (reset) groupVehicleList.clear();
    if (groupVehicleList.isNotEmpty) return groupVehicleList;
    try {
      var response = await _apiRepository.getGroupVehicle();
      groupVehicleList = List<Map<String, dynamic>>.from(response?['data'] ?? []);
      return groupVehicleList;
    } catch (e) {
      Toaster.showError(e.toString());
      return [];
    }
  }

  Future<Map<String, dynamic>?> _getActiveVehicles({bool reset = false}) async {
    if (reset) _vehicleStatus?.clear();
    if ((_vehicleStatus != null) && (_vehicleStatus?.isNotEmpty ?? false)) return _vehicleStatus;
    try {
      var response = await _apiRepository.getActiveVehicles();
      _vehicleStatus = response;
      return _vehicleStatus;
    } catch (e) {
      Toaster.showError(e.toString());
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getActiveVehicles({bool reset = false}) async {
    if (reset) activeVehicleList.clear();
    if (activeVehicleList.isNotEmpty) return activeVehicleList;
    try {
      var response = await _getActiveVehicles(reset: reset);
      activeVehicleList = List<Map<String, dynamic>>.from(response?['data'] ?? []);
      return activeVehicleList;
    } catch (e) {
      Toaster.showError(e.toString());
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getActiveVehiclesCount({bool reset = false}) async {
    if (reset) activeVehicleCountList.clear();
    if (activeVehicleCountList.isNotEmpty) return activeVehicleCountList;
    try {
      var response = await _apiRepository.getVehicleCategories();
      activeVehicleCountList = List<Map<String, dynamic>>.from(response?['data'] ?? []);
      Console.of.log(activeVehicleCountList);
      return activeVehicleCountList;
    } catch (e) {
      Toaster.showError(e.toString());
      return [];

    }
  }

  Future<List<Map<String, dynamic>>> getBouncieVehicles({bool reset = false}) async {
    if (reset) bouncieVehicles.clear();
    if (bouncieVehicles.isNotEmpty) return bouncieVehicles;
    try {
      var response = await _apiRepository.getBouncieVehicles();
      bouncieVehicles =
      List<Map<String, dynamic>>.from(response?['data'] ?? []);
      return bouncieVehicles;
    } catch (e) {
      Toaster.showError(e.toString());
      return [];

    }
  }

  Future<List<Map<String, dynamic>>> getGroupPersons() async {
    try {
      var response = await _apiRepository.getGroupPersonList();
      groupPersonList = response?.data ?? [];
      return groupPersonList;
    } catch (e) {
      Toaster.showError(e.toString());
      return [];

    }
  }

  Future<List<Map<String, dynamic>>> getTaskExpenseData({bool reset = false}) async {
    if (reset) taskExpenseDataList.clear();
    if (taskExpenseDataList.isNotEmpty) return taskExpenseDataList;
    try {
      var response = await _apiRepository.getTaskExpenseData();
      taskExpenseDataList =
      List<Map<String, dynamic>>.from(response?['data'] ?? []);
      return taskExpenseDataList;
    } catch (e) {
      Toaster.showError(e.toString());
      return [];

    }
  }

  Future<List<Map<String, dynamic>>?> getWorkingHourByUser() async {
    try {
      var response = await _apiRepository.getWorkingHoursByUser();
      return response;
    } catch (e) {
      Toaster.showError(e.toString());
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getUserPunchList() async {
    try {
      var response = await _apiRepository.getUserPunchList();
      return response;
    } catch (e) {
      Toaster.showError(e.toString());
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getVendorsList({bool reset = false}) async {
    if (reset) vendorsList.clear();
    if (vendorsList.isNotEmpty) return List.from(vendorsList);
    try {
      var response = await _apiRepository.getVendors();
      vendorsList = List<Map<String, dynamic>>.from(response?['data'] ?? []);
      return List.from(vendorsList);
    } catch (e) {
      Toaster.showError(e.toString());
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getVendorTypeList({bool reset = false}) async {
    if (reset) {
      vendorsTypeList.clear();
    }
    if (vendorsTypeList.isNotEmpty) {
      return vendorsTypeList;
    }

    try {
      final response = await _apiRepository.getVendorsType();

      if (response != null && response is List) {
        vendorsTypeList = List<Map<String, dynamic>>.from(
          response.whereType<Map<String, dynamic>>(),
        );
      } else {
        vendorsTypeList = [];
      }

      return vendorsTypeList;
    } catch (e) {
      Toaster.showError(e.toString());
      log("${e.toString()}", name: "getVendorTypeList");
      return [];
    }
  }


  Future<List<Map<String, dynamic>>> getPaymentTypes({bool reset = false}) async {
    if (reset) paymentTypesList.clear();
    if (paymentTypesList.isNotEmpty) return paymentTypesList;
    try {
      var response = await _apiRepository.getPaymentType();
      paymentTypesList = List<Map<String, dynamic>>.from(response?['data'] ?? []);
      return paymentTypesList;
    } catch (e) {
      Toaster.showError(e.toString());
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getLocationsList({bool reset = false}) async {
    if (reset) locationsList.clear();
    if (locationsList.isNotEmpty) return locationsList;
    try {
      var response = await _apiRepository.getLocations();
      locationsList = List<Map<String, dynamic>>.from(response?['data'] ?? []);
      return locationsList;
    } catch (e) {
      Toaster.showError(e.toString());
      return [];
    }
  }



  Future<List<Map<String, dynamic>>> getPartsList({bool reset = false}) async {
    if (reset) partsList.clear();
    if (partsList.isNotEmpty) return partsList;
    try {
      var response = await _apiRepository.getParts();
      partsList = List<Map<String, dynamic>>.from(response?['data'] ?? []);
      return partsList;
    } catch (e) {
      Toaster.showError(e.toString());
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getSuppliesList({bool reset = false}) async {
    if (reset) suppliesList.clear();
    if (suppliesList.isNotEmpty) return suppliesList;
    try {
      var response = await _apiRepository.getSupplies();
      suppliesList = List<Map<String, dynamic>>.from(response?['data'] ?? []);
      return suppliesList;
    } catch (e) {
      Toaster.showError(e.toString());
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTaskCategoryGroupList({bool reset = false}) async {
    if (reset) taskCategoryGroupList.clear();
    if (taskCategoryGroupList.isNotEmpty) return taskCategoryGroupList;
    try {
      var response = await _apiRepository.getTaskCategoryGroup();
      taskCategoryGroupList = List<Map<String, dynamic>>.from(response?['data'] ?? []);
      return taskCategoryGroupList;
    } catch (e) {
      Toaster.showError(e.toString());
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getResources({bool reset = false}) async {
    if (reset) resourcesList.clear();
    if (resourcesList.isNotEmpty) return List.from(resourcesList);
    try {
      var response = await _apiRepository.getResourcesList();
      resourcesList = List.from(response?.resource ?? []);
      return List.from(resourcesList);
    } catch (e) {
      Toaster.showError(e.toString());
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getBranches() async {
    if (branchList.isNotEmpty) return branchList;
    try {
      var response = await _apiRepository.getBranch();
      branchList = List<Map<String, dynamic>>.from(response?['data'] ?? []);
      return branchList;
    }catch (e) {
      Toaster.showError(e.toString());
      return [];
    }
  }

  /// CURRENT DATE TODO LIST
  Future<List<Map<String, dynamic>>> getToDos({bool reset = false}) async {
    if (reset) _toDoList.clear();
    if (_toDoList.isNotEmpty) return _toDoList;
    try {
      var response = await _apiRepository.getToDoList(selectedDate: DateTime.now().toFormat(format: "yyyy-MM-dd"));
      _toDoList = List<Map<String, dynamic>>.from(response?['todos'] ?? []);
      return _toDoList;
    }catch (e) {
      Toaster.showError(e.toString());
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getPrivateRentalVehicleList({bool reset = false}) async {
    if (reset) _privateRentalVehicleList.clear();
    if (_privateRentalVehicleList.isNotEmpty) return _privateRentalVehicleList;
    try {
      var response = await _apiRepository.getPrivateRentalVehicleList();
      _privateRentalVehicleList = List<Map<String, dynamic>>.from(response?['vehicles'] ?? []);
      return _privateRentalVehicleList;
    }catch (e) {
      Toaster.showError(e.toString());
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getPrivateRentalCustomersList({bool reset = false}) async {
    if (reset) _privateRentalCustomersList.clear();
    if (_privateRentalCustomersList.isNotEmpty) return _privateRentalCustomersList;
    try {
      var response = await _apiRepository.getPrivateRentalCustomersList();
      _privateRentalCustomersList = List<Map<String, dynamic>>.from(response?['customers'] ?? []);
      return _privateRentalCustomersList;
    }catch (e) {
      Toaster.showError(e.toString());
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getMaintenanceCheckList({bool reset = false}) async {
    if (reset) _maintenanceCheckList.clear();
    if (_maintenanceCheckList.isNotEmpty) return List.from(_maintenanceCheckList);
    try {
      var response = await _apiRepository.getMaintenanceCheckList();
      _maintenanceCheckList = List<Map<String, dynamic>>.from(response?['data'] ?? []);
      return List.from(_maintenanceCheckList);
    }catch (e) {
      Toaster.showError(e.toString());
      return [];
    }
  }

  Future<Map<String, dynamic>?> findVehicleReservation({required String vin}) async {
    try {
      var response = await _apiRepository.getVehicleHistory(vin: vin);
      var _vehileHisory = List<Map<String, dynamic>>.from(response?['todo']?['data'] ?? []);
      return _vehileHisory.where((element) => element['todo_date'] == (DateTime.now().toFormat())).firstOrNull;
    }catch (e) {
      Toaster.showError(e.toString());
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getCheckList({bool reset = false}) async {
    if (reset) _checkList.clear();
    if (_checkList.isNotEmpty) return List.from(_checkList);
    try {
      var response = await _apiRepository.getCheckList();
      _checkList = List<Map<String, dynamic>>.from(response?['data'] ?? []);
      return List.from(_checkList);
    }catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getLeaveListType({bool reset = false}) async {
    if (reset) _leavelistType.clear();
    if (_leavelistType.isNotEmpty) return List.from(_leavelistType);
    try {
      var response = await _apiRepository.getLeaveTypeList();
      _leavelistType = List<Map<String, dynamic>>.from(response?['data'] ?? []);
      return List.from(_leavelistType);
    }catch (e) {
      return [];
    }
  }

  Future<void> clearAll() async {
    usersList.clear();
    cohortsList.clear();
    vendorsList.clear();
    locationsList.clear();
    partsList.clear();
    suppliesList.clear();
    groupVehicleList.clear();
    activeVehicleList.clear();
    activeVehicleCountList.clear();
    bouncieVehicles.clear();
    groupPersonList.clear();
    taskExpenseDataList.clear();
    expenseCategoriesList.clear();
    paymentTypesList.clear();
    resourcesList.clear();
    _vehicleStatus?.clear();
    branchList.clear();
    _toDoList.clear();
    _maintenanceCheckList.clear();
    _checkList.clear();
  }

}