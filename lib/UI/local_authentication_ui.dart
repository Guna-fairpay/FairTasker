import 'dart:io';
import 'package:fairpytasker/Bloc/local_authentication_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Component/bottom_nav_for_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthenticationUI extends StatefulWidget {
  const LocalAuthenticationUI({super.key});

  @override
  State<LocalAuthenticationUI> createState() => _LocalAuthenticationUIState();
}

class _LocalAuthenticationUIState extends State<LocalAuthenticationUI> {
  LocalAuthenticationBloc? authenticationBloc;

  @override
  void initState() {
    super.initState();
    authenticationBloc = LocalAuthenticationBloc();
    checkBiometric();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppC().base,
          title: Utils.getAppBarText('Authenticate Yourself',
              color: AppC.white, size: 18),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: SizedBox(
              height: 50,
              // width: 80,
              child: Utils.getFilledButton('Authenticate Yourself', () {
                checkBiometric();
              }),
            ),
          ),
        )
        /*BlocProvider(
          create: (context) => authenticationBloc!..add(AuthenticationInitialEvent()),
          child: BlocConsumer<WriteTagOperationBloc, WriteTagOperationState>(
            listener: (context, state) {
            },
            builder: (context, state) {
              return Container();
            },
          ),
        )*/
        );
  }

  final LocalAuthentication auth = LocalAuthentication();
  String msg = "You are not authorized.";
  Future<void> checkBiometric() async {
    try {
      debugPrint('msg11 $msg');
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
    } on PlatformException {
      msg = "Error while opening fingerprint/face scanner";
      debugPrint('msg4 $msg');
      checkOtherPasswords();
    }
  }

  Future<void> checkOtherPasswords() async {
    try {
      bool isAuthorized = false;
      // if (Platform.isIOS) {
      //   isAuthorized = await auth.authenticate(
      //       localizedReason: 'Authenticate with pattern/pin/passcode',
      //       options: const AuthenticationOptions(
      //         stickyAuth: true,
      //         biometricOnly: false,
      //       ));
      // }
      if (Platform.isAndroid) {
        isAuthorized = await auth.authenticate(
            localizedReason: 'Authenticate with pattern/pin/passcode');
      }

      if (isAuthorized) {
        debugPrint('pass: $isAuthorized');
        msg = "You are Authenticated.";
        navigateToNextScreen();
        // setState(() {});
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
    // Utils.showMobileToast('message');
    await Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const BottomNavigationForTaskView(
        selectedIndex: 0,
        message: '',
      ),
    ));
  }
}
