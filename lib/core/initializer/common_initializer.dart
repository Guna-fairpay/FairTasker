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

  Future<List<Map<String, dynamic>>> getCohorts() async {
    if (cohortsList.isNotEmpty) return cohortsList;
    try {
      var response = await _apiRepository.getCohorts();
      cohortsList =
      List<Map<String, dynamic>>.from(response?['cohortsData'] ?? []);
      return cohortsList;
    } catch (e) {
      Toaster.showError(e.toString());
      return [];
    }
  }

}