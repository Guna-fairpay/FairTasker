import 'dart:async';
import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';

class CustomAutoSearchField<T extends Object> extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController controller;
  final ItemAsString<T>? itemAsString;
  final bool showEmptyWidget; // Should be comes from optionsViewBuilder builder when there's no options left
  final ValueChanged<T>? onSelected;
  final Function(T value, {FocusNode? focusNode})? onSelectedFocus;
  final ValueChanged<String>? onChanged;
  final FutureOr<Iterable<T>> Function(TextEditingValue textEditingValue)
      optionsBuilder;
  final VoidCallback? onEmptyWidgetTap;
  final GestureTapDownCallback? onEmptyWidgetTapDown;
  final bool autoClear;
  final Function(FocusNode focusNode)? onFieldFocusCreated;

  const CustomAutoSearchField(
      {super.key,
      this.labelText,
      this.hintText,
      this.onFieldFocusCreated,
      required this.controller,
      this.itemAsString,
      this.onSelected,
      this.onSelectedFocus,
      this.onChanged,
      this.showEmptyWidget = false,
      this.autoClear = false,
      required this.optionsBuilder,
      this.onEmptyWidgetTap,
      this.onEmptyWidgetTapDown,
      });

  @override
  State<CustomAutoSearchField<T>> createState() => _CustomAutoSearchFieldState<T>();
}

class _CustomAutoSearchFieldState<T extends Object> extends State<CustomAutoSearchField<T>> {
  final GlobalKey _textFieldKey = GlobalKey();
  FocusNode? _focusNode; // Store the FocusNode persistently
  double? fieldWidth;

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Num.borderRadius),
      borderSide: const BorderSide(color: AppC.borderColor),
    );
    return IntrinsicHeight(
      child: Autocomplete<T>(
        initialValue: widget.controller.value,
        onSelected: (option) {
          widget.onSelected?.call(option);
          widget.onSelectedFocus?.call(option, focusNode: _focusNode);
          if (widget.autoClear) {
            widget.controller.clear();
          }
          _focusNode?.requestFocus();
          Utils.dismissKeyboard(context);
        },
        optionsViewBuilder: (context, onSelected, options) {
          try {
            final RenderBox? renderBox = _textFieldKey.currentContext
                ?.findRenderObject() as RenderBox?;
            final size = renderBox?.size;
            fieldWidth = size?.width ?? 0;
          } catch (e) {
            fieldWidth = (context.width - 40);
          }
          return Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: fieldWidth,
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
                    contentPadding: 10.padding,
                    titleTextStyle: context.textTheme.labelLarge?.copyWith(fontFamily: "Lato"),
                    title: Text(
                        widget.itemAsString?.call(options.elementAt(index)) ?? ""),
                  ),
                  separatorBuilder: (context, index) => const Divider(
                    thickness: 0.5,
                    height: 0.5,
                  ),
                  itemCount: options.length),
            ),
          );
        },
        optionsViewOpenDirection: OptionsViewOpenDirection.down,
        fieldViewBuilder:
            (context, textEditingController, focusNode, onFieldSubmitted) {
          if ((textEditingController.text.contains("id:") && !widget.controller.text.contains("id:"))
          || ( (widget.controller.text.isNotEmpty) && (textEditingController.text.isEmpty) ) || (textEditingController.text != widget.controller.text)) {
            textEditingController.value = widget.controller.value;
            Console.of.log("Resetting value");
          }
          widget.controller.value = textEditingController.value;
          widget.controller.value.copyWith(selection: TextSelection.collapsed(offset: widget.controller.text.length - 1));
          if (widget.controller.text.contains("id:")) widget.controller.clear();
          widget.onFieldFocusCreated?.call(focusNode);
          // _focusNode = focusNode;
          return TextField(
            key: _textFieldKey,
            controller: widget.controller,
            focusNode: focusNode,
            onSubmitted: (value) => onFieldSubmitted(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            onChanged: (value) {
              focusNode.requestFocus();
              _focusNode?.requestFocus();
              textEditingController.value = widget.controller.value;
              widget.onChanged?.call(value);
            },
            onTapUpOutside: (event) {
              focusNode.unfocus();
              Utils.dismissKeyboard(context);
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
                hintStyle: context.textTheme.labelMedium?.copyWith(color: context.theme.hintColor),
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
        optionsBuilder: widget.optionsBuilder,
      ),
    );
  }
}
