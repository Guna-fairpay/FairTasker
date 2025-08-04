import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Label extends StatelessWidget {
  final String? labelText;
  final Widget? label;
  final EdgeInsets? padding;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor, foregroundColor;
  const Label({super.key, this.label, this.backgroundColor, this.foregroundColor, this.borderRadius, this.padding, this.labelText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(16.spMin)
      ),
      padding: padding ?? 10.spMin.horizontalPadding.copyWith(top: 3.spMin, bottom: 3.spMin),
      child: label ?? CompactText(labelText ?? "", color: foregroundColor, fontWeight: FontWeight.bold),
    );
  }
}
