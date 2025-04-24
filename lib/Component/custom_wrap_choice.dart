import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomWrapChoice<T extends Object> extends StatelessWidget {
  final List<T> items;
  final List<T>? selectedItems;
  final ItemAsString<T>? itemAsString;
  final ItemAsString<T>? selectionItemAsString;
  final void Function(bool isChecked, T value)? onChanged;

  const CustomWrapChoice(
      {super.key,
      required this.items,
      this.itemAsString,
      this.selectedItems,
      this.onChanged,
      this.selectionItemAsString});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 3.sp,
      runSpacing: 3.sp,
      children: List<Widget>.generate(
        items.length,
        (int idx) {
          var model = items[idx];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2),
            child: ChoiceChip(
              color: WidgetStateColor.resolveWith((states) => states.contains(WidgetState.selected) ? AppC.appColor : AppC.chipBackgroundUnselected),
              side: const BorderSide(color: AppC.chipBackgroundUnselectedBorder),
              shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
              showCheckmark: false,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              label: Utils.getText(
                itemAsString?.call(model) ?? "$model",
                color: ((selectionItemAsString != null)
                    ? ((selectedItems
                                ?.map((e) => selectionItemAsString?.call(e)))
                            ?.contains(selectionItemAsString?.call(model)) ??
                        false)
                    : selectedItems?.contains(model) ?? false)
                        ? AppC.white
                        : AppC.text,
                weight: ((selectionItemAsString != null)
                    ? ((selectedItems
                    ?.map((e) => selectionItemAsString?.call(e)))
                    ?.contains(selectionItemAsString?.call(model)) ??
                    false)
                    : selectedItems?.contains(model) ?? false)
                    ? FontWeight.bold
                    : FontWeight.normal,
                size: 11.sp,
              ),
              selected: ((selectionItemAsString != null)
                  ? ((selectedItems
                  ?.map((e) => selectionItemAsString?.call(e)))
                  ?.contains(selectionItemAsString?.call(model)) ??
                  false)
                  : selectedItems?.contains(model) ?? false),
              onSelected: (bool selected) {
                onChanged?.call(selected, model);
              },
            ),
          );
        },
      ).toList(),
    );
  }
}
