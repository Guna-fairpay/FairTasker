import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyWidget extends StatelessWidget {
  final bool withExpand;
  final VoidCallback? onRefresh;
  const EmptyWidget({super.key, this.withExpand = true, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return (withExpand) ? Expanded(
      child: getEmptyWidget(context),
    ) : getEmptyWidget(context);
  }

  Widget getEmptyWidget(BuildContext context) {
    return Column(
      spacing: 5.sp,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cached_rounded, size: context.width * 0.15, color: AppC.borderColor),
        Text("No record found!", style: context.textTheme.titleMedium?.copyWith(color: AppC.borderColor)),
        if (onRefresh != null)
        OutlinedButton(onPressed: onRefresh, style: ButtonStyle(
          side: const WidgetStatePropertyAll(BorderSide(width: Num.borderWidthThinField, color: AppC.appColor)),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.sp)))
        ), child: const Text("Refresh"),)
      ],
    );
  }
}
