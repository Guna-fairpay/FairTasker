import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompactIconButton extends StatelessWidget {
  final IconData icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final VoidCallback? onPressed;
  final GestureTapDownCallback? onTapDown;
  final WidgetStatePropertyAll<OutlinedBorder?>? shape;
  final double? iconSize;

  const CompactIconButton(
      {super.key,
      this.icon = Icons.add_rounded,
      this.backgroundColor = AppC.appColor,
      this.foregroundColor = AppC.white,
      this.elevation = 0,
      this.onTapDown,
      this.onPressed, this.shape, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: shape?.value,
      elevation: elevation ?? 0,
      color: ((elevation ?? 0) > 0) ? backgroundColor : null,
      child: GestureDetector(
        onTapDown: onTapDown,
        child: IconButton.filledTonal(
          onPressed: onPressed,
          icon: Icon(icon, size: iconSize),
          constraints: const BoxConstraints.tightFor(),
          visualDensity: VisualDensity.compact,
          style: ButtonStyle(
              shape: shape ?? WidgetStatePropertyAll(ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(Num.borderRadiusLarge))),
              padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 12.spMin, horizontal: 6.spMin)),
              iconSize: WidgetStatePropertyAll(12.spMin),
              minimumSize: WidgetStatePropertyAll(Size.fromRadius(18.spMin)),
              foregroundColor: WidgetStatePropertyAll(foregroundColor),
              backgroundColor: WidgetStatePropertyAll(backgroundColor),
              elevation: WidgetStatePropertyAll(elevation)),
        ),
      ),
    );
  }
}
