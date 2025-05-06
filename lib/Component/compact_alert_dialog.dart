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
  final TextDirection textDirection;
  final VoidCallback? onCloseDialog;

  const CompactAlertDialog(
      {super.key,
      this.textDirection = TextDirection.ltr,
      this.onCloseDialog,
      this.titleText,
      this.titleColor,
      this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: 16.sp.padding,
      contentPadding: 16.sp.horizontalPadding.copyWith(bottom: 16.sp),
      titlePadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      title: Directionality(
        textDirection: textDirection,
        child: ListTile(
          title: (titleText.isNotNullOrEmpty) ? Text("$titleText") : null,
          titleTextStyle:
              context.textTheme.titleMedium?.copyWith(color: titleColor),
          trailing: GestureDetector(
            onTap: () {
              onCloseDialog?.call();
              context.popDialog();
            },
            child: const Icon(Icons.close_rounded),
          ),
        ),
      ),
      alignment: Alignment.topCenter,
      content: SizedBox(
        width: double.maxFinite,
        child: content,
      ),
    );
  }
}
