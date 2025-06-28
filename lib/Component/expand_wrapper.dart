import 'package:flutter/material.dart';

class ExpandWrapper extends StatelessWidget {
  final Widget child;
  final bool asExpand;
  final bool asFlexible;
  final int flex;

  const ExpandWrapper(
      {super.key,
      required this.child,
      this.asExpand = false,
      this.asFlexible = false,
      this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return (asExpand)
        ? Expanded(flex: flex, child: child)
        : (asFlexible)
            ? Flexible(flex: flex, child: child)
            : child;
  }
}
