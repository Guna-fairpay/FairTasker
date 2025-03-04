import 'dart:async';
import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as d;

class CustomAutoSearchField<T extends Object> extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController controller;
  final ItemAsString<T>? itemAsString;
  final bool showEmptyWidget; // Should be comes from optionsViewBuilder builder when there's no options left
  final ValueChanged<T>? onSelected;
  final ValueChanged<String>? onChanged;
  final FutureOr<Iterable<T>> Function(TextEditingValue textEditingValue)
      optionsBuilder;
  final VoidCallback? onEmptyWidgetTap;
  final GestureTapDownCallback? onEmptyWidgetTapDown;
  final bool autoClear;

  const CustomAutoSearchField(
      {super.key,
      this.labelText,
      this.hintText,
      required this.controller,
      this.itemAsString,
      this.onSelected,
      this.onChanged,
      this.showEmptyWidget = false,
      this.autoClear = false,
      required this.optionsBuilder,
      this.onEmptyWidgetTap,
      this.onEmptyWidgetTapDown,
      });

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Num.borderRadius),
      borderSide: const BorderSide(color: AppC.borderColor),
    );
    return Autocomplete<T>(
      initialValue: controller.value,
      onSelected: (option) {
        onSelected?.call(option);
        if (autoClear) {
          controller.clear();
        }
      },
      optionsViewBuilder: (context, onSelected, options) => Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: context.width - 40,
          constraints: const BoxConstraints(maxHeight: 200),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(Num.borderRadius)),
              border: Border.all(width: 0.5, color: AppC.borderColor)),
          child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) => ListTile(
                    onTap: () => onSelected.call(options.elementAt(index)),
                    dense: true,
                    minTileHeight: 0,
                    contentPadding: 10.horizontalPadding,
                    title: Text(
                        itemAsString?.call(options.elementAt(index)) ?? ""),
                  ),
              separatorBuilder: (context, index) => const Divider(
                    thickness: 0.5,
                    height: 0.5,
                  ),
              itemCount: options.length),
        ),
      ),
      optionsViewOpenDirection: OptionsViewOpenDirection.down,
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        if ((textEditingController.text.contains("id:") && !controller.text.contains("id:"))
        || ( (controller.text.isNotEmpty) && (textEditingController.text.isEmpty) )) {
          textEditingController.value = controller.value;
        }
        controller.value = textEditingController.value;
        controller.value.copyWith(
            selection:
                TextSelection.collapsed(offset: controller.text.length - 1));
        if (controller.text.contains("id:")) controller.clear();
        return TextField(
          controller: controller,
          focusNode: focusNode,
          onEditingComplete: onFieldSubmitted,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          onChanged: (value) {
            textEditingController.value = controller.value;
            onChanged?.call(value);
          },
          style: context.textTheme.labelLarge?.copyWith(fontFamily: "Lato"),
          decoration: InputDecoration(
              border: border,
              enabledBorder: border,
              isDense: true,
              hintText: hintText ?? "Search here...",
              labelText: labelText ?? "Search",
              filled: false,
              fillColor: AppC.blue50,
              contentPadding: 10.padding,
              labelStyle: context.textTheme.labelMedium
                  ?.copyWith(color: context.theme.hintColor),
              hintStyle: context.textTheme.labelMedium?.copyWith(color: context.theme.hintColor),
              suffixIconConstraints: const BoxConstraints(),
              suffixIcon: ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, value, child) => (showEmptyWidget &&
                          value.text.isNotEmpty)
                      ? GestureDetector(
                          onTap: onEmptyWidgetTap,
                          onTapDown: onEmptyWidgetTapDown,
                          child: Container(
                            margin: 2.padding,
                            padding: 10.padding,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                                color: AppC.blue50,
                                borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(Num.borderRadius))),
                            constraints: const BoxConstraints(),
                            child: const Icon(
                              Icons.add,
                              color: AppC.appColor,
                            ),
                          ),
                        )
                      : const SizedBox.shrink())),
        );
      },
      optionsBuilder: optionsBuilder,
    );
  }
}
