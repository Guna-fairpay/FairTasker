import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/api_repository.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
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

  List<Map<String, dynamic>> usersList = [];
  List<Map<String, dynamic>> cohortsList = [];
  List<Map<String, dynamic>> vendorsList = [];
  List<Map<String, dynamic>> locationsList = [];
  List<Map<String, dynamic>> groupVehicleList = [];
  List<Map<String, dynamic>> activeVehicleList = [];
  List<Map<String, dynamic>> bouncieVehicles = [];
  List<Map<String, dynamic>> groupPersonList = [];
  List<Map<String, dynamic>> taskExpenseDataList = [];
  List<Map<String, dynamic>> expenseCategoriesList = [];

  Iterable<String>? get roles => Session.of.getStringList(Str.rolePrefText)?.map((e) => e.toString().toLowerCase());
  bool get isAdmin => (roles?.contains("admin") ?? false);

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

  Future<List<Map<String, dynamic>>> getActiveVehicles({bool reset = false}) async {
    if (reset) activeVehicleList.clear();
    if (activeVehicleList.isNotEmpty) return activeVehicleList;
    try {
      var response = await _apiRepository.getActiveVehicles();
      activeVehicleList =
      List<Map<String, dynamic>>.from(response?['data'] ?? []);
      return activeVehicleList;
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

}