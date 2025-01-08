import 'dart:async';

import 'package:fairpytasker/UI/authentication_ui.dart';
import 'package:fairpytasker/UI/local_authentication_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/main.dart';
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
    Utils.getStringPreference(Str.accessTokenPrefText).then((value) {
      Utils.getStringPreference(Str.userIdPrefText).then((valueUserId) {
        userIdGlobal = valueUserId;
      });
      Utils.getStringListPreference(Str.userPermissionPrefText)
          .then((valueUserPermission) {
        userPermissionsGlobal = valueUserPermission;
      });
      // Utils.getStringListPreference(Str.rolePrefText).then((roleList) {
      //   userRole = roleList;
      // });
      accessTokenGlobal = /*"199|qdDKXEzbgIfYykw3HKNN4tqZ47eyEQQhq22Fva5t06ef4437"*/
          value;
      Timer(const Duration(seconds: 2), () {
        Utils.getBoolPreference(Str.loginPrefText).then((value) {
          if (!value) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const AuthenticationUI()));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const LocalAuthenticationUI()));
          }
        });
      });
    });
    // Check availability
    // bool isAvailable =  NfcManager.instance.isAvailable() as bool;

// Start Session
    /*NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        // Do something with an NfcTag instance.
        Utils.showMobileToast('tag found. onDiscovered, splash screen');
      },
    );*/

// Stop Session
//     NfcManager.instance.stopSession();
  }

/*  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      body:
      SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          // width: MediaQuery.of(context).size.width/1.7,
          // alignment: Alignment.center,
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/5,
            right: MediaQuery.of(context).size.width/5, bottom: 15),
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(Assets.splashBg), fit: BoxFit.fitHeight)
          ),
          child: Image.asset(
            Assets.logoWithoutWatermarkBg,
            // fit: BoxFit.cover,
          ),
        // ),
    ),
      )
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppC.white,
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            // width: MediaQuery.of(context).size.width/1.7,
            // alignment: Alignment.center,
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 5,
                right: MediaQuery.of(context).size.width / 5,
                bottom: 15),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Assets.splashBg), fit: BoxFit.fitHeight)),
            child: Image.asset(
              Assets.logoWithoutWatermarkBg,
              // fit: BoxFit.cover,
            ),
            // ),
          ),
        ));
  }
}
