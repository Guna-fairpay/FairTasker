import 'package:fairpytasker/UI/Splash/splash_ui.dart';
import 'package:fairpytasker/core/app/config/theme_config.dart';
import 'package:fairpytasker/core/app/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FairTaskerApp extends StatelessWidget {
  const FairTaskerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        navigatorKey: CommonHelper.instance.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'FairTasker',
        theme: ThemeConfig.themeData,
        builder: EasyLoading.init(),
        home: const SplashScreen(),
      ),
    );
  }
}
