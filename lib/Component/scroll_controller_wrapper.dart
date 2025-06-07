import 'package:flutter/material.dart';

class ScrollControllerWrapper extends StatefulWidget {
  final Widget Function(ScrollController controller) builder;
  const ScrollControllerWrapper({super.key, required this.builder});

  @override
  State<ScrollControllerWrapper> createState() => _ScrollControllerWrapperState();
}

class _ScrollControllerWrapperState extends State<ScrollControllerWrapper> {
  final ScrollController _controller = ScrollController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) => widget.builder(_controller);
}
