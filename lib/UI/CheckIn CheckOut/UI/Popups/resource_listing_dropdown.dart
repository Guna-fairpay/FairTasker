import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../../../../Utilities/appC.dart';
import '../../../../Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';

typedef ItemAsString<T> = String Function(T item);

class ResourceListingDropdown<T extends Object> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String? labelText, hintText;
  final ItemAsString<T>? itemAsString;
  final ValueChanged<T?>? onChanged;
  final EdgeInsetsGeometry? contentPadding;

  const ResourceListingDropdown({
    super.key,
    required this.items,
    this.value,
    this.labelText = "",
    this.hintText = "Select",
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

    // Ensure value matches an item in items, default to null if not found
    final validValue = items.contains(value) ? value : (items.isNotEmpty ? items[0] : null);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppC.fieldBase,
        ),
        borderRadius: BorderRadius.circular(Num.borderRadius),
      ),
      child: DropdownButtonFormField2<T>(
        isExpanded: true,
        value: validValue,
        decoration:
        InputDecoration(
          labelText: labelText,
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Num.subradiusButton),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Num.subradiusButton),
            borderSide: const BorderSide(color: AppC.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Num.subradiusButton),
            borderSide: const BorderSide(color: AppC.grey),
          ),
          filled: true,
          constraints: const BoxConstraints(maxHeight: 40),
          isDense: true,
        ),
        hint: const Align(
          alignment: Alignment.centerLeft,
          child: Text("",
            style: TextStyle(color: AppC.grey),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 250, // Match reference menuHeight
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
          scrollPadding: const EdgeInsets.all(10),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          height: 40,
        ),
        style: context.textTheme.labelLarge,
        // Use DropdownMenuItem instead of DropdownMenuEntry
        items: items.isNotEmpty
            ? items.map<DropdownMenuItem<T>>((T e) {
          return DropdownMenuItem<T>(
            value: e,
            child: Text(
              itemAsString?.call(e) ?? e.toString(),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          );
        }).toList()
            : [DropdownMenuItem<T>(value: null, child: Text("$hintText", style: const TextStyle(color: AppC.grey),))],
        onChanged: onChanged,
      ),
    );
  }
}