import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompactChipsWrapBuilder<T extends Object> extends StatelessWidget {
  final String? label;
  final T? value;
  final List<T>? items;
  final ItemAsString<T>? itemAsString;
  final ValueChanged<T>? onChanged;
  final Color? backgroundColor, disabledColor, selectedColor;

  const CompactChipsWrapBuilder(
      {super.key,
      this.label,
      this.value,
      this.items,
      this.itemAsString,
      this.onChanged,
      this.backgroundColor,
      this.disabledColor,
      this.selectedColor});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5.sp,
        children: [
          const SizedBox.shrink(),
          if (label.isNotNullOrEmpty) CompactText(label ?? ""),
          Wrap(
            spacing: 10.sp,
            runSpacing: 2.sp,
            crossAxisAlignment: WrapCrossAlignment.center,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            children: items
                    ?.map((e) => ChoiceChip(
                          label: CompactText(
                              itemAsString?.call(e) ?? e.toString(),
                              color: (value == e) ? AppC.white : (selectedColor ?? AppC.appColor), fontWeight: (value == e) ? FontWeight.bold : FontWeight.normal),
                          selected: value == e,
                          labelPadding: EdgeInsets.zero,
                          selectedColor: selectedColor ?? AppC.appColor,
                          disabledColor: disabledColor ?? Colors.blue[50],
                          showCheckmark: false,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            side: const BorderSide(
                              color: AppC.appColor,
                              width: Num.borderWidthThinField,
                            ),
                          ),
                          backgroundColor: backgroundColor ?? Colors.blue[40],
                          onSelected: (value) => onChanged?.call(e),
                        ))
                    .toList() ??
                [],
          ),
        ]);
  }
}
