import 'package:flutter/material.dart';

class RowTile extends StatelessWidget {
  final double spacing;
  final bool expandTitle;
  final VoidCallback? onTap;
  final MainAxisSize mainAxisSize;
  final Widget? title, leading, trailing;
  final GestureTapDownCallback? onTapDown;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  const RowTile({super.key, this.mainAxisSize = MainAxisSize.max, this.mainAxisAlignment = MainAxisAlignment.start, this.crossAxisAlignment = CrossAxisAlignment.center, this.title, this.leading, this.trailing, this.onTap, this.onTapDown, this.spacing = 4.0, this.expandTitle = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onTapDown: onTapDown,
      child: Row(
        spacing: spacing,
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          if (leading != null) leading ?? const SizedBox.shrink(),
          if (title != null) (expandTitle ? Expanded(child: title ?? const SizedBox.shrink()) : title ?? const SizedBox.shrink()),
          if (trailing != null) trailing ?? const SizedBox.shrink()
        ],
      ),
    );
  }
}
