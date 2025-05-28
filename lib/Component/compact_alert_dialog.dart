import 'package:flutter/material.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';

class CompactAlertDialog extends StatelessWidget {
  final String? titleText;
  final Color? titleColor;
  final Widget? content;
  final FontWeight? titleFontWeight;
  final TextStyle? titleTextStyle;
  final TextDirection textDirection;
  final VoidCallback? onCloseDialog;
  final AlignmentGeometry? alignment;
  final bool withMaxWidth;
  final EdgeInsets? insetPadding;
  final EdgeInsets? contentPadding;
  final EdgeInsets? titlePadding;
  final Color? backgroundColor;
  final ShapeBorder? shape;
  final double? elevation;

  const CompactAlertDialog(
      {super.key,
      this.textDirection = TextDirection.ltr,
      this.titleFontWeight,
      this.titleTextStyle,
      this.onCloseDialog,
      this.titleText,
      this.titleColor,
      this.content,
      this.alignment,
      this.insetPadding,
      this.contentPadding,
      this.titlePadding,
      this.backgroundColor,
      this.shape,
      this.elevation,
      this.withMaxWidth = true});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: insetPadding ?? 16.sp.padding,
      contentPadding:
          contentPadding ?? 16.sp.horizontalPadding.copyWith(bottom: 16.sp),
      titlePadding: titlePadding ?? EdgeInsets.zero,
      backgroundColor: backgroundColor ?? Colors.white,
      shape: shape ??
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      title: Directionality(
        textDirection: textDirection,
        child: ListTile(
          title: (titleText.isNotNullOrEmpty) ? Text("$titleText") : null,
          titleTextStyle: titleTextStyle ??
              context.textTheme.titleMedium
                  ?.copyWith(color: titleColor, fontWeight: titleFontWeight),
          trailing: GestureDetector(
            onTap: () {
              onCloseDialog?.call();
              context.popDialog();
            },
            child: const Icon(Icons.close_rounded),
          ),
        ),
      ),
      alignment: alignment ?? Alignment.topCenter,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: elevation,
      content: (withMaxWidth)
          ? SizedBox(
              width: double.maxFinite,
              child: content,
            )
          : content,
    );
  }
}
