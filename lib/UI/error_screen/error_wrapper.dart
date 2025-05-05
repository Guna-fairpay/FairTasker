import 'package:fairpytasker/UI/error_screen/error_screen.dart';
import 'package:flutter/material.dart';

class FlutterErrorWidgetWrapper extends StatelessWidget {
  final Widget? child;

  const FlutterErrorWidgetWrapper({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (errorDetails) => ErrorScreen(errorDetails);
    return child!;
  }
}