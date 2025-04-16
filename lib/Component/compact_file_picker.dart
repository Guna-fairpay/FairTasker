import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompactFilePicker extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onPressed;
  const CompactFilePicker({super.key, this.controller, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: AppC.borderColor, width: Num.borderWidthThinField),
          borderRadius: BorderRadius.circular(Num.borderRadius)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Row(
        spacing: 10,
        children: [
          InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(Num.borderRadiusLarge),
            child: Container(
              padding: 7.sp.horizontalPadding.copyWith(top: 9.sp, bottom: 9.sp),
              decoration: const BoxDecoration(
                  color: AppC.fileButtonColor,
                  borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(Num.borderRadius)),
                  border: BorderDirectional(
                      end: BorderSide(
                          width: Num.borderWidthThinField,
                          color: AppC.borderColor))),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Text("Choose File",
                  style: context.textTheme.labelMedium?.copyWith(
                      color: AppC.subText, fontWeight: FontWeight.bold)),
            ),
          ),
          ValueListenableBuilder(valueListenable: controller ?? TextEditingController(), builder: (context, value, child) => Expanded(
              child: Text( (value.text.trim().isNullOrEmpty) ? "No file chosen" : value.text,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelMedium
                      ?.copyWith(color: AppC.subText, fontWeight: FontWeight.w700))))
        ],
      ),
    );
  }
}
