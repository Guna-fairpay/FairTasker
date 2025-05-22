import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'custom_search_field.dart';

class CompactDropDown<T extends Object> extends StatelessWidget {
  final List<T>? items;
  final String? hintText;
  final String? helperText;
  final T? initialSelection;
  final ValueChanged<T?>? onChanged;
  final ItemAsString<T>? itemAsString;
  final TextEditingController? controller;

  const CompactDropDown(
      {super.key,
      this.controller,
      this.initialSelection,
      this.hintText,
      this.items,
      this.itemAsString,
      this.onChanged,
      this.helperText});

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Num.borderRadius),
      borderSide:
          const BorderSide(color: AppC.fieldBase, width: Num.borderWidthField),
    );
    Console.of.log(initialSelection, name: "CompactDropDown");
    return DropdownMenu<T>(
      key: key,
      initialSelection: initialSelection,
      hintText: hintText,
      helperText: helperText,
      enableSearch: (controller != null),
      textStyle: context.textTheme.labelLarge?.copyWith(overflow: TextOverflow.ellipsis),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: context.textTheme.labelMedium?.copyWith(color: AppC.grey),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.sp),
        enabledBorder: border,
        isCollapsed: true,
        border: border,
        isDense: true,
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
        visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity),
      ),
      keyboardType: TextInputType.text,
      requestFocusOnTap: (controller != null),
      controller: controller,
      searchCallback: (entries, query) => entries.indexWhere((element) => element.value.toString().toLowerCase().contains(query.toLowerCase())),
      expandedInsets: 0.padding,
      dropdownMenuEntries: items
              ?.map((item) => DropdownMenuEntry<T>(
                  value: item,
                  label: itemAsString?.call(item) ?? item.toString()))
              .toList() ??
          [],
      onSelected: onChanged,
    );
  }
}
