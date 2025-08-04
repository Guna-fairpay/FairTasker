import 'package:flutter/material.dart';
class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  final bool fullScreenDialog;
  ScaleRoute({required this.page, this.fullScreenDialog = false})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    fullscreenDialog: fullScreenDialog,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: child,
        ),
  );
}