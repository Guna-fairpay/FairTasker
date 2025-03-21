import 'dart:developer';
import 'package:fairpytasker/Repository/authentication_repository.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';

class Authenticator {
  Authenticator._();

  static final Authenticator instance = Authenticator._();

  final AuthenticationRepo _authenticationRepo = AuthenticationRepo();

  Future<void> logout() async {
    var response = await _authenticationRepo.logout();
    Console.of.debug("LogOut: $response");
  }

  Future<void> getBearerToken() async {
    var response = await _authenticationRepo.getBearerToken();
    Console.of.debug("BearerToken: $response");
    if (response != null && (response['status'] == 200) && response['data'].toString().isNotNullOrEmpty) {
      Session.of.set(Str.frBearerToken, (response['data'] ?? ""));
      Utils.setStringPreference(Str.frBearerToken, (response['data'] ?? ""));
    }
  }

}