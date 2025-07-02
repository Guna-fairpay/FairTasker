import 'package:collection/collection.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'custom_search_field.dart';

class CompactDropDown<T extends Object> extends StatelessWidget {
  final List<T>? items;
  final String? hintText;
  final String? helperText;
  final T? initialSelection;
  final FocusNode? focusNode;
  final ValueChanged<T?>? onChanged;
  final ItemAsString<T>? itemAsString;
  final TextEditingController? controller;
  final AutovalidateMode? autoValidateMode;
  final FormFieldValidator<T>? validator;

  const CompactDropDown(
      {super.key,
      this.controller,
      this.initialSelection,
      this.hintText,
      this.items,
      this.itemAsString,
      this.onChanged,
        this.focusNode,
      this.helperText,
        this.autoValidateMode,
        this.validator
      });

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Num.subradiusButton),
      borderSide: const BorderSide(color:  AppC.fieldBase, width: Num.borderWidthButton),
    );
    return (validator != null) ? FormField<T>(
      initialValue: initialSelection,
      autovalidateMode: autoValidateMode,
      validator: validator,
        builder: (field) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if ((initialSelection != null) && (field.hasError && (field.value == null))) field.didChange(initialSelection);
          });
          var border = OutlineInputBorder(
            borderRadius: BorderRadius.circular(Num.subradiusButton),
            borderSide: BorderSide(color: (field.hasError) ? AppC.errorTextColor : AppC.fieldBase, width: Num.borderWidthButton),
          );
          return Column(
            spacing: 3,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownMenu<T>(
                key: key,
                focusNode: focusNode,
                initialSelection: items?.firstWhereOrNull((element) => const DeepCollectionEquality().equals(initialSelection, element)),
                hintText: hintText,
                helperText: helperText,
                enableSearch: (controller != null),
                textStyle: context.textTheme.labelLarge?.copyWith(overflow: TextOverflow.ellipsis),
                menuHeight: context.height * 0.3,
                inputDecorationTheme: InputDecorationTheme(
                    hintStyle: context.textTheme.labelMedium?.copyWith(color: AppC.grey),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.spMin),
                    enabledBorder: border,
                    isCollapsed: true,
                    border: border,
                    isDense: true,
                    constraints: BoxConstraints(maxHeight: 35.spMin)
                ),
                menuStyle: MenuStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                  visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity),
                ),
                requestFocusOnTap: (controller != null),
                keyboardType: TextInputType.text,
                controller: controller,
                searchCallback: (entries, query) => entries.indexWhere((element) => element.value.toString().toLowerCase().contains(query.toLowerCase())),
                expandedInsets: 0.padding,
                dropdownMenuEntries: items
                    ?.map((item) => DropdownMenuEntry<T>(
                    value: item,
                    label: itemAsString?.call(item) ?? item.toString()))
                    .toList() ??
                    [],
                onSelected: (value) {
                  onChanged?.call(value);
                  field.didChange(value);
                  focusNode?.unfocus();
                },
              ),
              if (field.hasError)
                Row(
                  spacing: 8,
                  children: [
                    const SizedBox.shrink(),
                    Text(field.errorText ?? "", style: CommonHelper.instance.navigatorKey.currentContext?.textTheme.labelMedium?.copyWith(color: AppC.errorTextColor, fontWeight: FontWeight.w100))
                  ],
                )
            ],
          );
        }) : DropdownMenu<T>(
      // key: key,
      initialSelection: items?.firstWhereOrNull((element) => const DeepCollectionEquality().equals(initialSelection, element)),
      hintText: hintText,
      helperText: helperText,
      enableSearch: (controller != null),
      textStyle: context.textTheme.labelLarge?.copyWith(overflow: TextOverflow.ellipsis),
      menuHeight: context.height * 0.3,
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: context.textTheme.labelMedium?.copyWith(color: AppC.grey),
          contentPadding: EdgeInsets.symmetric(horizontal: 10.spMin),
          enabledBorder: border,
          isCollapsed: true,
          border: border,
          isDense: true,
          constraints: BoxConstraints(maxHeight: 38.spMin),
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
        visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity),
      ),
      keyboardType: TextInputType.text,
      controller: controller,
      searchCallback: (entries, query) => entries.indexWhere((element) => element.value.toString().toLowerCase().contains(query.toLowerCase())),
      expandedInsets: 0.padding,
      requestFocusOnTap: (controller != null),
      dropdownMenuEntries: items
          ?.map((item) => DropdownMenuEntry<T>(
          value: item,
          label: itemAsString?.call(item) ?? item.toString()))
          .toList() ??
          [],
      onSelected: (value) {
        onChanged?.call(value);
        focusNode?.unfocus();
      },
    );
  }
}
