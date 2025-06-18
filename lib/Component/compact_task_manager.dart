import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Component/custom_wrap_choice.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';

class CompactTaskManager<T extends Object> extends StatelessWidget {
  final String? label;
  final List<T>? items;
  final List<T>? selectedItems;
  final ItemAsString<T>? itemAsString;
  final AutovalidateMode? autoValidateMode;
  final FormFieldValidator<List<T>>? validator;
  final void Function(bool isChecked, T value)? onChanged;
  const CompactTaskManager({super.key, this.selectedItems, this.items, this.label, this.validator, this.autoValidateMode, this.itemAsString, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return FormField<List<T>>(
      validator: validator,
      initialValue: selectedItems,
      autovalidateMode: autoValidateMode,
        builder: (field) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (field.hasError) field.didChange(selectedItems);
          });
          return Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (label.isNotNullOrEmpty) CompactText(label ?? "", fontWeight: FontWeight.bold, styleType: TextStyleType.labelLarge),
              CustomWrapChoice<T>(
                items: items ?? [],
                itemAsString: itemAsString,
                selectedItems: selectedItems,
                onChanged: (isChecked, value) {
                  field.didChange(isChecked ? ((selectedItems ?? [])..add(value)) : ((selectedItems ?? [])..remove(value)));
                  onChanged?.call(isChecked, value);
                },
              ),
              if (field.hasError) CompactText(field.errorText ?? "", styleType: TextStyleType.labelSmall, color: AppC.redAccent, textAlign: TextAlign.start),
            ],
          );
        },
    );
  }
}
