import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/utilities/utils.dart';
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double get height => MediaQuery.sizeOf(this).height;
  double get width => MediaQuery.sizeOf(this).width;
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  Future<void> push<T>(Widget page, {bool fullscreenDialog = false}) async {
    try {
      Utils.dismissKeyboard(this);
      await Navigator.push(this, MaterialPageRoute(builder: (context) => page, fullscreenDialog: fullscreenDialog));
      Utils.dismissKeyboard(this);
    } catch (e) {
      Console.of.error("Error", error: e);
    }
  }
  Future<T> pushReplacement<T>(Widget page, {bool fullscreenDialog = false}) async => await Navigator.pushReplacement(this, MaterialPageRoute(builder: (context) => page, fullscreenDialog: fullscreenDialog));
  Future<T> pushAndRemoveUntil<T>(Widget page, { bool maintainRoute = false, bool fullscreenDialog = false }) async => await Navigator.pushAndRemoveUntil(this, MaterialPageRoute(builder: (context) => page, fullscreenDialog: fullscreenDialog), (route) => maintainRoute);
  Future<T?> pushNamed<T>(String routeName) async => await Navigator.pushNamed(this, routeName);
  Future<T?> pushNamedAndRemoveUntil<T>(String routeName, { bool maintainRoute = false}) async => await Navigator.pushNamedAndRemoveUntil(this, routeName, (route) => maintainRoute);
  Future<T?> pushReplacementNamed<T>(String routeName) async => await Navigator.pushReplacementNamed(this, routeName);
  void pop() {
    Utils.dismissKeyboard(this);
    Navigator.pop(this);
    Utils.dismissKeyboard(this);
  }
  void popDialog() {
    Navigator.pop(this, "dialog");
    Utils.dismissKeyboard(this);
  }


}