import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TypeHeadSearchView<T extends Object> extends StatefulWidget {
  final ItemAsString<T>? itemAsString;
  final String? labelText;
  final String? hintText;
  final bool
      showEmptyWidget; // Should be comes from optionsViewBuilder builder when there's no options left
  final ValueChanged<T>? onSelected;
  final VoidCallback? onEmptyWidgetTap;
  final ValueChanged<String>? onChanged;
  final TextEditingController controller;
  final GestureTapDownCallback? onEmptyWidgetTapDown;
  final Future<List<T>> Function(String value) optionsBuilder;
  final Function(FocusNode focusNode)? onFieldFocusCreated;

  const TypeHeadSearchView(
      {super.key,
      this.itemAsString,
      this.labelText,
      this.hintText,
      required this.optionsBuilder,
      this.showEmptyWidget = false,
      this.onSelected,
      this.onChanged,
      required this.controller,
      this.onEmptyWidgetTap,
      this.onEmptyWidgetTapDown,
      this.onFieldFocusCreated,
      });

  @override
  State<TypeHeadSearchView<T>> createState() => _TypeHeadSearchViewState<T>();
}

class _TypeHeadSearchViewState<T extends Object> extends State<TypeHeadSearchView<T>> {
  FocusNode? _focusNode;
  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Num.borderRadius),
      borderSide: const BorderSide(color: AppC.borderColor),
    );
    return TypeAheadField<T>(
      builder: (context, textEditingController, focusNode) {
        if ((textEditingController.text.contains("id:") &&
                !widget.controller.text.contains("id:")) ||
            ((widget.controller.text.isNotEmpty) &&
                (textEditingController.text.isEmpty))) {
          textEditingController.value = widget.controller.value;
        }
        widget.controller.value = textEditingController.value;
        widget.controller.value.copyWith(
            selection:
                TextSelection.collapsed(offset: widget.controller.text.length - 1));
        if (widget.controller.text.contains("id:")) widget.controller.clear();
        widget.onFieldFocusCreated?.call(focusNode);
        _focusNode = focusNode;
        return TextField(
          controller: widget.controller,
          focusNode: focusNode,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          onChanged: (value) {
            textEditingController.value = widget.controller.value;
            widget.onChanged?.call(value);
          },
          textInputAction: TextInputAction.done,
          style: context.textTheme.labelLarge?.copyWith(fontFamily: "Lato"),
          decoration: InputDecoration(
              border: border,
              enabledBorder: border,
              isDense: true,
              hintText: widget.hintText ?? "Search here...",
              labelText: widget.labelText ?? "Search",
              filled: false,
              fillColor: AppC.blue50,
              contentPadding: 10.padding,
              labelStyle: context.textTheme.labelMedium
                  ?.copyWith(color: context.theme.hintColor),
              hintStyle: context.textTheme.labelMedium
                  ?.copyWith(color: context.theme.hintColor),
              suffixIconConstraints: const BoxConstraints(),
              suffixIcon: ValueListenableBuilder(
                  valueListenable: widget.controller,
                  builder: (context, value, child) => (widget.showEmptyWidget &&
                          value.text.isNotEmpty)
                      ? GestureDetector(
                          onTap: widget.onEmptyWidgetTap,
                          onTapDown: widget.onEmptyWidgetTapDown,
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
      onSelected: (value) {
        widget.onSelected?.call(value);
        Console.of.debug("Has Focus ${_focusNode != null} ${_focusNode?.canRequestFocus}");
        _focusNode?.requestFocus();
      },
      suggestionsCallback: widget.optionsBuilder,
      itemBuilder: (context, value) => ListTile(
        dense: true,
        minTileHeight: 0,
        contentPadding: 10.padding,
        titleTextStyle:
            context.textTheme.labelLarge?.copyWith(fontFamily: "Lato"),
        title: Text(widget.itemAsString?.call(value) ?? ""),
      ),
    );
  }

  void _checkData() {}
}
