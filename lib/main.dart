import 'package:flutter/material.dart';
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
  runApp(const MyApp());
  filterDate = DateFormat('yyyy-MM-dd').format(selectedDate);
  formattedDate = DateFormat('MMM dd').format(selectedDate);
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
      home: const SplashScreen(),
    );
  }
}
