import 'package:fairpytasker/Component/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EasyLoadingConfig {
  EasyLoadingConfig._();

  static void config() {
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
}