import 'package:flutter/material.dart';

class BadgeChild extends StatelessWidget {
  final Widget child;
  final bool showBadge;
  final dynamic count;
  final Offset? offset;
  final Color? backgroundColor;
  final Color? textColor;
  const BadgeChild({super.key, required this.child, this.showBadge = false, required this.count, this.offset, this.backgroundColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Badge(
      backgroundColor: backgroundColor ?? Colors.red,
      offset: offset ?? const Offset(2, -0.5),
      textColor: textColor ?? Colors.white,
      isLabelVisible: showBadge,
      label: Text("$count"),
      child: child,
    );
  }
}
