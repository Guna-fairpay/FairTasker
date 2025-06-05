import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DismissibleBackgroundText extends StatelessWidget {
  final String title;
  final Color color;
  final TextStyleType styleType;
  final AlignmentGeometry alignment;
  const DismissibleBackgroundText({super.key, required this.title, this.alignment = Alignment.centerRight, this.styleType = TextStyleType.titleMedium, this.color = AppC.appColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: 16.spMin.padding,
        child: Align(
            alignment: alignment,
            child: CompactText(
                title,
                styleType: styleType,
                color: color,
                fontWeight: FontWeight.bold)));
  }
}
