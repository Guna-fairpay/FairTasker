import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final ItemAsString<T>? itemAsString;
  final ValueChanged<T?>? onChanged;

  const CustomDropdown(
      {super.key, required this.items, this.itemAsString, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Num.radiusButton),
            ),
            labelText: "Select"),
        borderRadius: BorderRadius.circular(Num.radiusButton),
        padding: const EdgeInsets.all(5),
        isDense: true,
        style: context.textTheme.labelLarge,
        items: items
            .map((e) => DropdownMenuItem(
                value: e,
                child: Text((itemAsString != null)
                    ? (itemAsString?.call(e).toString() ?? "")
                    : e.toString())))
            .toList(),
        onChanged: onChanged);
  }
}
