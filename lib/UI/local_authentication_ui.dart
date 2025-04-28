import 'dart:io';
import 'package:fairpytasker/Bloc/local_authentication_bloc.dart';
import 'package:fairpytasker/Event/local_authentication_event.dart';
import 'package:fairpytasker/State/local_authentication_state.dart';
import 'package:fairpytasker/UI/authentication_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Component/bottom_nav_for_task.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthenticationUI extends StatefulWidget {
  const LocalAuthenticationUI({super.key});

  @override
  State<LocalAuthenticationUI> createState() => _LocalAuthenticationUIState();
}

class _LocalAuthenticationUIState extends State<LocalAuthenticationUI> {
  // LocalAuthenticationBloc? authenticationBloc;

  @override
  void initState() {
    super.initState();
    // authenticationBloc = LocalAuthenticationBloc();
    // getIt<CommonService>().initialFetch();
    // checkBiometric();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => LocalAuthenticationBloc()..add(LocalAuthenticationInitialEvent()),
      child: BlocListener<LocalAuthenticationBloc, LocalAuthenticationState>(
          listener: (context, state) {
            switch(state) {
              case LocalAuthenticationSuccessState(): context.pushReplacement(const BottomNavigationForTaskView(selectedIndex: 0)); break;
              case LocalAuthenticationFailureState(): if (state.message.toString().isNotNullOrEmpty) { Toaster.showError(state.message); } break;
            }
          },
          child: BlocBuilder<LocalAuthenticationBloc, LocalAuthenticationState>(builder: (context, state) => SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      repeat: ImageRepeat.repeat,
                      opacity: 0.35,
                      image: AssetImage(Assets.splashBg),
                      fit: BoxFit.contain)),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Image.asset(
                      Assets.taskManagerLogo,
                      fit: BoxFit.contain,
                      width: context.width * 0.5,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(50),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 10,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor:
                              AppC.appColor.withValues(alpha: 0.5),
                              child: Padding(
                                padding: const EdgeInsets.all(1),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: AppC.lightGrey,
                                  child: Utils.getText(
                                      (Session.of.getString("name") ?? "")[0],
                                      color: AppC.appColor,
                                      size: 28,
                                      weight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Utils.getText((Session.of.getString("name") ?? ""),
                                align: TextAlign.center,
                                weight: FontWeight.normal,
                                size: 16),
                            if (context.watch<LocalAuthenticationBloc>().showButton)
                            ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor:
                                WidgetStatePropertyAll(AppC().base),
                                iconColor:
                                const WidgetStatePropertyAll(Colors.white),
                                textStyle: const WidgetStatePropertyAll(
                                    TextStyle(
                                        fontFamily: "Lato",
                                        color: Colors.white)),
                                shape: WidgetStatePropertyAll(
                                    ContinuousRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            Num.borderRadiusLarge))),
                              ),
                              onPressed: () => context.read<LocalAuthenticationBloc>().add(LocalAuthenticationCheckEvent()),
                              label: Utils.getText("Login with biometric",
                                  color: Colors.white,
                                  size: 14,
                                  weight: FontWeight.w500),
                              icon: const Icon(
                                Icons.fingerprint_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  /*if (kDebugMode)
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(AppC.blue50),
                          iconColor: const WidgetStatePropertyAll(Colors.white),
                          textStyle: const WidgetStatePropertyAll(TextStyle(
                              fontFamily: "Lato", color: Colors.white)),
                        ),
                        onPressed: logout,
                        label: Utils.getText("Logout",
                            color: AppC.appColor,
                            size: 14,
                            weight: FontWeight.w500),
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: AppC.appColor,
                        ),
                      ),
                    ),*/
                ],
              ),
            ),
          ))),
    ));
  }

  final LocalAuthentication auth = LocalAuthentication();
  String msg = "You are not authorized.";

  void logout() {
    Session.of.clear();
    Utils.deletePreferences(key: Str.loginPrefText);
    Utils.deletePreferences(key: Str.accessTokenPrefText);
    Utils.deletePreferences(key: Str.userIdPrefText);
    context.pushAndRemoveUntil(const AuthenticationUI());
  }

  Future<void> checkBiometric() async {
    try {
      bool hasBiometrics =
          await auth.canCheckBiometrics; //check if there is authencation,
      if (hasBiometrics) {
        List<BiometricType> availableBiometrics =
            await auth.getAvailableBiometrics();
        debugPrint('availableBiometrics: $availableBiometrics');
        if (availableBiometrics.isNotEmpty) {
          if (Platform.isIOS) {
            if (availableBiometrics.contains(BiometricType.face)) {
              bool pass = await auth.authenticate(
                  localizedReason: 'Authenticate with fingerprint');
              if (pass) {
                msg = "You are Autenciated.";
                navigateToNextScreen();
              }
            }
          } else {
            if (availableBiometrics.contains(BiometricType.fingerprint) ||
                availableBiometrics.contains(BiometricType.face)) {
              bool pass = await auth.authenticate(
                  localizedReason: 'Authenticate with fingerprint/face');
              if (pass) {
                msg = "You are Authenicated.";
                debugPrint('msg22 $msg');
                navigateToNextScreen();
              } else {
                msg = "You are not Authenicated.";
                debugPrint('msg33 $msg');
              }
            } else {
              msg = "bio not contain finger prints";
              debugPrint('msg44 $msg');
              bool pass = await auth.authenticate(
                  localizedReason: 'Authenticate with pattern/pin/passcode');
              if (pass) {
                msg = "You are Authenticated.";
                debugPrint('msg1 $msg');
                navigateToNextScreen();
                // setState(() {});
              }
            }
          }
        } else {
          checkOtherPasswords();
        }
      } else {
        msg = "You are not allowed to access biometrics.";
        debugPrint('msg2 $msg');
        checkOtherPasswords();
      }
      // debugPrint('msg3 $msg');
    } on PlatformException catch (e) {
      msg = "Error while opening fingerprint/face scanner";
      if (e.code == "auth_in_progress") return;
      checkOtherPasswords();
    }
  }

  Future<void> checkOtherPasswords() async {
    try {
      bool isAuthorized = false;
      if (Platform.isAndroid) {
        isAuthorized = await auth.authenticate(
            localizedReason: 'Authenticate with pattern/pin/passcode');
      }

      if (isAuthorized) {
        debugPrint('pass: $isAuthorized');
        msg = "You are Authenticated.";
        navigateToNextScreen();
      } else {
        debugPrint('pass: $isAuthorized');
      }
      debugPrint('pass: $msg');
    } on PlatformException catch (e) {
      debugPrint('pass: exception: $e');
      msg = "Error while opening fingerprint/face scanner";
      debugPrint('pass: $msg');
      Utils.showMobileToast('Mobile phone is not protected with any password.');
      navigateToNextScreen();
    }
  }

  Future<void> navigateToNextScreen() async {
    await context.pushReplacement(const BottomNavigationForTaskView(
      selectedIndex: 0,
      message: '',
    ));
  }
}
