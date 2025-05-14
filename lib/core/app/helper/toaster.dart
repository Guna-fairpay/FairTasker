import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart'
    show DelightSnackbarPosition;
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toaster {
  Toaster._();

  static showSuccess(dynamic message, {BuildContext? context, String title = "Success"}) {
    if (context != null) {
      _delightToast(context,
          title: title,
          message: "$message",
          color: Colors.green,
          textColor: Colors.white,
          type: 1);
      return;
    }
    _toast(message,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG);
  }

  static showError(dynamic message, {BuildContext? context, String title = "Error"}) {
    context ??= CommonHelper.instance.navigatorKey.currentContext;
    if (context != null) {
      _delightToast(context,
          title: title,
          message: "$message",
          color: AppC.redAccent,
          textColor: Colors.white,
          type: 2);
      return;
    }
    _toast(message,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_LONG);
  }

  static showWarning(dynamic message, {BuildContext? context, String title = "Warning"}) {
    if (context != null) {
      _delightToast(context,
          title: title,
          message: "$message",
          color: AppC.orange,
          textColor: Colors.white,
          type: 3);
      return;
    }
    _toast(message,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG);
  }

  static showInfo(dynamic message, {BuildContext? context, String title = "Info"}) {
    if (context != null) {
      _delightToast(context,
          title: title,
          message: "$message",
          color: AppC.lightGrey,
          textColor: AppC.text,
          type: 4);
      return;
    }
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

  static _delightToast(BuildContext context,
      {required dynamic title,
      required dynamic message,
      Color? color,
      Color? textColor,
      int type = 1}) {
    DelightToastBar(
        autoDismiss: true,
        animationCurve: Curves.easeInQuad,
        builder: (context) => ToastCard(
              title: Text(
                "$title",
                maxLines: 1,
                style: context.textTheme.labelLarge?.copyWith(
                  color: textColor,
                ),
              ),
              color: color,
              leading: Icon(
                  switch (type) {
                    1 => Icons.check_circle_outline_rounded,
                    2 => Icons.error_outline_rounded,
                    3 => Icons.warning_amber_rounded,
                    4 => Icons.info_outline_rounded,
                    _ => Icons.info_outline_rounded
                  },
                  color: textColor),
              subtitle: Text(
                "$message",
                maxLines: 5,
                style: context.textTheme.labelSmall?.copyWith(
                  color: textColor,
                ),
              ),
            )).show(context);
  }
}
