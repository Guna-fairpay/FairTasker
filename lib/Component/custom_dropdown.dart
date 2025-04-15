import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';

class CustomDropdown<T extends Object> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String? labelText, hintText;
  final FormFieldValidator<T>? validator;
  final ItemAsString<T>? itemAsString;
  final ValueChanged<T?>? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final AutovalidateMode? autoValidateMode;

  const CustomDropdown(
      {super.key,
      required this.items,
      this.value,
      this.labelText = "Select",
      this.hintText,
      this.contentPadding,
      this.itemAsString,
      this.onChanged});
  const CustomDropdown({super.key,
    required this.items,
    this.value,
    this.validator,
    this.autoValidateMode,
    this.labelText = "Select",
    this.hintText,
    this.contentPadding,
    this.itemAsString,
    this.onChanged});

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
        borderSide:
            const BorderSide(color: AppC.borderColor, width: Num.borderWidthField),
        borderRadius: BorderRadius.circular(Num.borderRadius)
    );
    return
      DropdownButtonFormField<T>(
        borderSide: const BorderSide(
            color: AppC.borderColor, width: Num.borderWidthField),
        borderRadius: BorderRadius.circular(Num.borderRadius));
    return DropdownButtonFormField<T>(
        decoration: InputDecoration(
          isCollapsed: true,
            labelStyle: context.textTheme.labelLarge,
            constraints: const BoxConstraints(),
            contentPadding: contentPadding ?? const EdgeInsets.all(10),
            isDense: true,
            border: border,
            hintText: hintText,
            enabledBorder: border,
            labelText: labelText),
            labelText: labelText,
            hintText: hintText),
        borderRadius: BorderRadius.circular(Num.borderRadius),
        padding: contentPadding ?? const EdgeInsets.all(5),
        autovalidateMode: autoValidateMode,
        validator: validator,
        isDense: true,
        isExpanded: false,
        menuMaxHeight: context.height * 0.3,
        style: context.textTheme.labelLarge,
        value: value,
        items: items
            .map((e) =>
            DropdownMenuItem(
                value: e,
                child: Text(
                  (itemAsString != null)
                      ? (itemAsString?.call(e).toString() ?? "")
                      : e.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelLarge?.copyWith(color: (e == value) ? AppC.appColor : null, fontWeight: (e == value) ? FontWeight.w700 : null),
                )))
            .toList(),
        onChanged: onChanged
      );
  }
}
