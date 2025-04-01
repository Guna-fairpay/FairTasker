import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';

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
      children: List<Widget>.generate(
        items.length,
        (int idx) {
          var model = items[idx];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2),
            child: ChoiceChip(
              showCheckmark: false,
              padding: EdgeInsets.symmetric(horizontal: 5),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              selectedColor: AppC.appColor,
              backgroundColor: const Color(0xfff3f6f9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              side: const BorderSide(color: AppC.appColor),
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
                size: 12,
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
