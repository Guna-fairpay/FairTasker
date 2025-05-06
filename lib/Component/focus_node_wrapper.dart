import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';

class FocusNodeWrapper extends StatefulWidget {
  final Widget Function(FocusNode focusNode) builder;

  const FocusNodeWrapper({super.key, required this.builder});

  @override
  State<FocusNodeWrapper> createState() => _FocusNodeWrapperState();
}

class _FocusNodeWrapperState extends State<FocusNodeWrapper> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    Console.of.log("initState");
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_focusNode);
  }
}
