import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompactExpansionTile extends StatelessWidget {
  final Widget? child;
  final Widget? title;
  final ShapeBorder? shape, collapsedShape;
  final Color? iconColor, collapsedIconColor;
  final Color? backgroundColor, collapsedBackgroundColor;
  const CompactExpansionTile({super.key, this.title, this.child, this.shape, this.collapsedShape, this.backgroundColor = AppC.lightBlue, this.collapsedBackgroundColor = AppC.lightBlue, this.collapsedIconColor = AppC.appColor, this.iconColor = AppC.appColor});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      iconColor: iconColor,
      backgroundColor: backgroundColor,
      collapsedIconColor: collapsedIconColor,
      title: title ?? const SizedBox.shrink(),
      collapsedBackgroundColor: collapsedBackgroundColor,
      minTileHeight: 40.sp,
      collapsedShape: collapsedShape ?? RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(5.sp)),
      shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(5.sp), side: const BorderSide(width: Num.borderWidthThinField, color: AppC.borderColor)),
      children: [
        Container(
          width: double.maxFinite,
          color: AppC.white,
          padding: 10.sp.padding,
          child: child,
        ),
      ],
    );
  }
}
