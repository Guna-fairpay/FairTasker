import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'UI/Splash/splash_ui.dart';

List<int> requestFrom = [0, 1];
String accessTokenGlobal = '';
String userIdGlobal = '';
List<String>? userPermissionsGlobal;
// List<String>? userRole;
String? filterDate;
String? formattedDate;
DateTime selectedDate = DateTime.now();

Future<bool> verifySSL(String url) async {
  // Create an HttpClient instance
  HttpClient client = HttpClient();
  // Disable the certificate verification
/*  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;*/

  // Try to establish a connection to the API endpoint
  try {
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    // Check if the connection was successful
    if (response.statusCode == 200) {
      // SSL certificate is valid
      print('SSL certificate validation failed: true');
      return true;
    }
  } catch (e) {
    // Connection error or SSL certificate validation failed
    print('SSL certificate validation failed: $e');
  }
  // SSL certificate is not valid
  return false;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for the line below
  runApp(const MyApp());
  // selectedDate = DateTime.now();
  filterDate = DateFormat('yyyy-MM-dd').format(selectedDate);
  // formattedDate = DateFormat('yyyy-MMM-dd').format(selectedDate!);
  formattedDate = DateFormat('MMM dd').format(selectedDate);
  // String apiUrl = Str.BASE_URL; // Replace with your API endpoint
  // String apiUrl = 'https://dev.fairreturns.in/api/login'; // Replace with your API endpoint
  // bool sslValid = await verifySSL(apiUrl);
  // print('SSL certificate validation result: $sslValid');
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
