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
  final String pickerName;
  const CompactFilePicker({super.key, this.controller, this.onPressed, this.pickerName = "Choose File"});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(Num.borderRadiusLarge),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: AppC.borderColor, width: Num.borderWidthThinField),
            borderRadius: BorderRadius.circular(Num.borderRadius)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          spacing: 10,
          children: [
            Container(
              padding: 7.spMin.horizontalPadding.copyWith(top: 9.spMin, bottom: 9.spMin),
              decoration: const BoxDecoration(
                  color: AppC.fileButtonColor,
                  borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(Num.borderRadius)),
                  border: BorderDirectional(
                      end: BorderSide(
                          width: Num.borderWidthThinField,
                          color: AppC.borderColor))),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Text(pickerName,
                  style: context.textTheme.labelMedium?.copyWith(
                      color: AppC.subText, fontWeight: FontWeight.bold)),
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
      ),
    );
  }
}
