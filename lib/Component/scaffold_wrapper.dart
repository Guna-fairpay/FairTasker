import 'package:flutter/material.dart';

class ScaffoldWrapper extends StatelessWidget {
  final Widget body;
  final bool withScaffold;
  final PreferredSizeWidget? appBar;
  const ScaffoldWrapper({super.key, required this.body, this.withScaffold = true, this.appBar});

  @override
  Widget build(BuildContext context) {
    Widget child = body;
    if (withScaffold) {
      child = Scaffold(
        appBar: appBar,
        body: child,
      );
    }
    return child;
  }
}
