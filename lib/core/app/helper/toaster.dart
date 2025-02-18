import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toaster {
  Toaster._();

  static showSuccess(dynamic message) {
    _toast(message,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG);
  }

  static showError(dynamic message) {
    _toast(message,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_LONG);
  }

  static showWarning(dynamic message) {
    _toast(message,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG);
  }

  static showInfo(dynamic message) {
    _toast(message,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG);
  }

  static _toast(dynamic message,
      {Color backgroundColor = Colors.black87,
      Color textColor = Colors.white,
      ToastGravity gravity = ToastGravity.BOTTOM,
      Toast toastLength = Toast.LENGTH_LONG,
      double fontSize = 15.0}) async {
    await Fluttertoast.showToast(
      msg: "$message",
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: 4,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
      webShowClose: true,
    );
  }
}
