import 'package:fairpytasker/Component/custom_loader.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'UI/Splash/splash_ui.dart';
import 'package:intl/intl.dart';

String accessTokenGlobal = '';
String userIdGlobal = '';
List<String>? userPermissionsGlobal;
String? filterDate;
String? formattedDate;
DateTime selectedDate = DateTime.now();


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for the line below
  await Session.of.init();
  runApp(const MyApp());
  configEasyLoading();
  filterDate = DateFormat('yyyy-MM-dd').format(selectedDate);
  formattedDate = DateFormat('MMM dd').format(selectedDate);
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
    ..maskColor = Colors.transparent
    ..maskType = EasyLoadingMaskType.clear
    ..loadingStyle = EasyLoadingStyle.custom
    ..userInteractions = true
    ..dismissOnTap = true
    ..boxShadow = [];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fair Returns',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Lato',
      ),
      builder: EasyLoading.init(),
      home: const SplashScreen(),
    );
  }
}
