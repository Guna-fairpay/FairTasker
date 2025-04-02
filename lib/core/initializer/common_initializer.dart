import 'dart:developer';
import 'dart:ui' show VoidCallback;

import 'package:collection/collection.dart';
import 'package:date_time/date_time.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/Repository/authentication_repository.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/helper/authenticator.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class Initializer {

  Initializer._();

  static final Initializer of = Initializer._();

  void init() {
    getIt.registerSingleton<CommonService>(CommonService());
  }
}

class CommonService {
  final _apiRepository = APiRepository();

  final FBroadcast _broadcast = FBroadcast.instance();
  List<Map<String, dynamic>> usersList = [];
  List<Map<String, dynamic>> cohortsList = [];
  List<Map<String, dynamic>> vendorsList = [];
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
  Map<String, dynamic> employeesList = {};
  List<Map<String, dynamic>> taskCategoryGroupList = [];
  Map<String, dynamic>? _vehicleStatus;

  final ValueNotifier<bool> updateBranch = ValueNotifier(false);
  Iterable<String>? get roles => Session.of.getStringList(Str.rolePrefText)?.map((e) => e.toString().toLowerCase());
  bool get isAdmin => (roles?.contains("admin") ?? false);

  void branchUpdate({VoidCallback? callback}) {
    _broadcast.register(Str.branchChange, (value, _) => callback?.call());
  }

  Future<void> initialFetch() async {
    await Future.wait([
      getUsers(),
      getCohorts(),
      getBranches(),
      Authenticator.instance.getBearerToken()
    ]);
  }

  int get getUserId {
    if (isAdmin) {
      var userId = usersList.firstWhereOrNull((element) => ((element['first_name'].toString().toLowerCase() == "product") && (element['last_name'].toString().toLowerCase() == "owner")))?['id'] ?? 0;
      return userId;
    } else {
      return int.tryParse(Session.of.getString(Str.userIdPrefText) ?? "0") ?? 0;
    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    if (usersList.isNotEmpty) return usersList;
    try {
      var response = await _apiRepository.getUsers();
      usersList = List<Map<String, dynamic>>.from(response?['usersList'] ?? []);
      return usersList;
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
    if (expenseCategoriesList.isNotEmpty) return expenseCategoriesList;
    try {
      var response = await _getCohortsAll();
      cohortsList = List<Map<String, dynamic>>.from(response?['cohortsData'] ?? []);
      expenseCategoriesList = List<Map<String, dynamic>>.from(response?['expenseCategories'] ?? []);
      return expenseCategoriesList;
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
      var response = await _getActiveVehicles(reset: reset);
      activeVehicleCountList = List<Map<String, dynamic>>.from(response?['vehiclesCount'] ?? []);
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
    if (vendorsList.isNotEmpty) return vendorsList;
    try {
      var response = await _apiRepository.getVendors();
      vendorsList = List<Map<String, dynamic>>.from(response?['data'] ?? []);
      return vendorsList;
    } catch (e) {
      Toaster.showError(e.toString());
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
    if (resourcesList.isNotEmpty) return resourcesList;
    try {
      var response = await _apiRepository.getResourcesList();
      resourcesList = List.from(response?.resource ?? []);
      return resourcesList;
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

  Future<List<Map<String, dynamic>>> getToDos() async {
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
  }

}