import 'dart:developer';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/authentication_repository.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';

class Authenticator {
  Authenticator._();

  static final Authenticator instance = Authenticator._();

  final AuthenticationRepo _authenticationRepo = AuthenticationRepo();

  Future<void> logout() async {
    var response = await _authenticationRepo.logout();
    Console.of.debug("LoggedOut: $response", name: "Authenticator");
  }

  Future<void> getBearerToken() async {
    var response = await _authenticationRepo.getBearerToken();
    Console.of.debug("BearerToken: $response");
    if (response != null && (response['status'] == 200) && response['data'].toString().isNotNullOrEmpty) {
      Session.of.set(Str.frBearerToken, (response['data'] ?? ""));
      Utils.setStringPreference(Str.frBearerToken, (response['data'] ?? ""));
    }
  }

  Future<void> getDepartmentId() async {
    Console.of.debug("Fetching DepartmentId");
    int currentUserId = int.tryParse(Session.of.getString(Str.userIdPrefText) ?? "") ?? 0;
    var response = await getIt<CommonService>().getUsers();
    if (response.isNotEmpty) {
      int departmentId = int.tryParse("${response.firstWhereOrNull((element) => element['id'] == currentUserId)?['department'] ?? ""}") ?? 0;
      Console.of.debug("DepartmentId: $departmentId");
      Session.of.set("departmentId", departmentId);
      Utils.setIntPreference("departmentId", departmentId);
    }
  }

}