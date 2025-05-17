import 'dart:async';
import 'package:fairpytasker/UI/authentication_ui.dart';
import 'package:fairpytasker/UI/local_authentication_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // userIdGlobal = Session.of.getString(Str.userIdPrefText) ?? "";
    // userPermissionsGlobal = Session.of.getStringList(Str.userPermissionPrefText) ?? [];
    // accessTokenGlobal = Session.of.getString(Str.accessTokenPrefText) ?? "";
    var isLoggedIn = Session.of.getBool(Str.loginPrefText) ?? false;
    Timer(const Duration(seconds: 2), () => context.pushReplacement(( isLoggedIn ? const LocalAuthenticationUI() : const AuthenticationUI() )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppC.white,
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 5,
                right: MediaQuery.of(context).size.width / 5,
                bottom: 15),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    repeat: ImageRepeat.repeat,
                    opacity: 0.35,
                    image: AssetImage(Assets.splashBg),
                    fit: BoxFit.contain)),
            child: Image.asset(
              Assets.logoWithoutWatermarkBg,
              fit: BoxFit.scaleDown,
            ),
          ),
        ));
  }
}
