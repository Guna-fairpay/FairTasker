import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Repository/authentication_repository.dart';
import 'package:fairpytasker/Event/authentication_event.dart';
import 'package:fairpytasker/Response/authentication_response.dart';
import 'package:fairpytasker/State/authentication_state.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationRepo authenticationRepo = AuthenticationRepo();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AuthenticationBloc() : super(AuthenticationLoading()) {
    on<DoLoginEvent>(_onLoginEvent);
  }

  void _onLoginEvent(DoLoginEvent event, Emitter<AuthenticationState> emit) async {
    try {
      if (formKey.currentState?.validate() == false) return emit(AuthenticationError("Please enter valid email and password"));
      if (emailController.text.isNullOrEmpty || (emailController.text.isValidEmail() == false) || (passwordController.text.isNullOrEmpty) || (passwordController.text.isValidPassword() == false)) {
        var message = "Please enter valid email and password";
        if (emailController.text.isNullOrEmpty || (emailController.text.isValidEmail() == false)) message = Str.emailEmptyValidAlertText;
        if (passwordController.text.isNullOrEmpty || (passwordController.text.isValidPassword() == false)) message = Str.passwordEmptyValidAlertText;
        emit(AuthenticationError(message));
        return;
      }
      emit(AuthenticationLoading());
      var response = await authenticationRepo.callLoginAPI(emailController.text, passwordController.text);
      if (response != null) {
        var branches = await getIt<CommonService>().getBranches();
        if (response.user?.branchId != null) {
          String? branchName = branches.firstWhereOrNull((element) => element['id'] == response.user?.branchId)?['city'];
          Session.of.set(Str.branchNamePrefText, branchName);
        }
        User? user = response.user;
        if ( (user != null) && (user.token.isNotNullOrEmpty ?? false)) {
          Utils.saveUserData(
              user.id ?? 0,
              user.name ?? "",
              user.role ?? [],
              user.token ?? "",
              user.password ?? "",
              user.email ?? "",
              (response.userPermissions ?? []),
              user.branchId ?? 1,
              user.hrmId ?? 0);

          await getIt<CommonService>().clearAll();
          await getIt<CommonService>().initialFetch();
          Utils.setBoolPreference(Str.loginPrefText, true);
          emit(AuthenticationNavigateState());
        } else {
          emit(AuthenticationError(response.message ?? "Failed to login"));
        }
        // emit(AuthenticationLoaded(authenticationData: response.user, userPermissions: response.userPermissions));
      } else {
        emit(AuthenticationError("Failed to login"));
      }
    } catch (e) {
      Console.of.error("Error", error: e);
      emit(AuthenticationError(e));
    }
  }
}
