import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../../Utilities/appC.dart';
import '../../../../Utilities/num.dart';
import '../../../../Component/custom_search_field.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';

typedef ItemAsString<T> = String Function(T item);

class ListDropDown<T extends Object> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String? labelText, hintText;
  final ItemAsString<T>? itemAsString;
  final ValueChanged<T?>? onChanged;
  final EdgeInsetsGeometry? contentPadding;

  const ListDropDown({
    super.key,
    required this.items,
    this.value,
    this.labelText = "Select",
    this.hintText,
    this.contentPadding,
    this.itemAsString,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: const BorderSide(
        color: AppC.grey,
        width: Num.borderWidthField,
      ),
      borderRadius: BorderRadius.circular(Num.borderRadius),
    );

    return
      DropdownButtonFormField2<T>(
      isExpanded: true,
      value: value,
      decoration:
      InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: context.textTheme.labelLarge,
        hintStyle: context.textTheme.labelLarge,
        isDense: true,
        border: border,
        enabledBorder: border,
        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
        constraints: const BoxConstraints(maxHeight: 40),
      ),
      hint: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          hintText ?? "",
          style: TextStyle(color: AppC.grey),
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 300,
        elevation: 4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Num.borderRadius),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        offset: const Offset(0, 2),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
      style: context.textTheme.labelLarge,
      items: items.map((e) {
        return DropdownMenuItem<T>(
          value: e,
          child: Text(
            itemAsString?.call(e) ?? e.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
