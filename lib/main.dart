import 'dart:async';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/color_extension.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fairpytasker/Component/custom_loader.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:flutter/material.dart';
import 'UI/Splash/splash_ui.dart';
import 'package:intl/intl.dart';


String accessTokenGlobal = '';
String userIdGlobal = '';
List<String>? userPermissionsGlobal;
String? filterDate;
String? formattedDate;
DateTime selectedDate = DateTime.now();


void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized(); // Required for the line below
    await Firebase.initializeApp();
    await Session.of.init();
    Initializer.of.init(); // GET_IT INITIALIZATION
    if (kDebugMode) await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    runApp(const MyApp());
    configEasyLoading();
    filterDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    formattedDate = DateFormat('MMM dd').format(selectedDate);
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack, printDetails: true, fatal: true));
}

void configEasyLoading() {
  EasyLoading.instance
    ..backgroundColor = Colors.transparent
    ..progressColor = Colors.transparent
    ..indicatorWidget = const CustomLoading()
    ..progressWidth = 0
    ..radius = 5.0
    ..indicatorColor = Colors.white
    ..loadingStyle = EasyLoadingStyle.custom
    ..textColor = Colors.transparent
    ..indicatorColor = Colors.transparent
    ..maskColor = Colors.black26
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = false
    ..dismissOnTap = false
    ..boxShadow = [];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fair Returns',
        theme: ThemeData(
          cardColor: Colors.white,
          dialogBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white, elevation: 5, scrolledUnderElevation: 0),
          dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          searchBarTheme: SearchBarThemeData(
            backgroundColor: WidgetStatePropertyAll(Colors.grey.shade100),
            textStyle: const WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.normal, fontFamily: "Lato", color: Colors.grey)),
            padding: const WidgetStatePropertyAll(EdgeInsets.all(5)),
            shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(16))),
            elevation: const WidgetStatePropertyAll(0),
            side: const WidgetStatePropertyAll(BorderSide.none),
          ),
          chipTheme: ChipThemeData(
            color: WidgetStateColor.resolveWith((states) => states.contains(WidgetState.selected) ? AppC.appColor : AppC.lightGrey),
            checkmarkColor: AppC.white,
            side: BorderSide.none,
            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
            padding: 5.sp.horizontalPadding,
          ),
          switchTheme: SwitchThemeData(
            // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            trackColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? AppC.green : AppC.grey),
            thumbColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? AppC.white : AppC.lightGrey),
          ),
          dividerTheme: const DividerThemeData(
              color: AppC.grey,
              thickness: Num.borderWidthThinField
          ),
          primarySwatch: AppC.appColor.toMaterialColor,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: AppC.appColor.toMaterialColor),
          textTheme: GoogleFonts.poppinsTextTheme(
              Typography.blackCupertino.copyWith()
          ),
        ),
        builder: EasyLoading.init(),
        home: const SplashScreen(),
      ),
    );
  }
}
