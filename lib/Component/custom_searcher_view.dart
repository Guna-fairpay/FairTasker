import 'dart:async';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Component/custom_auto_search_field.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';

class SearchViewField<T extends Object> extends StatelessWidget {
  final List<T> suggestions;
  final T? selectedItem;
  final ValueChanged<T>? onSelected, onCleared;
  final ItemAsString<T> itemAsString;
  final ItemAsString<T>? itemAsStringSearch;
  final TextEditingController controller;
  final bool showEmpty;
  final String? labelText, hintText;
  final ValueNotifier<bool> _showEmptyWidget = ValueNotifier(false);
  final VoidCallback? onEmptyTap;
  final bool autoClear;
  final Function(FocusNode focusNode)? onFieldFocusCreated;
  final Function(TapDownDetails details)? onEmptyTapDetails;
  final Function(T value, {FocusNode? focusNode})? onSelectedFocus;

  SearchViewField(
      {super.key,
      required this.controller,
      required this.suggestions,
      required this.itemAsString,
      this.itemAsStringSearch,
      this.labelText,
      this.hintText,
      this.selectedItem,
      this.onFieldFocusCreated,
      this.showEmpty = false,
      this.autoClear = false,
      this.onEmptyTap,
      this.onEmptyTapDetails,
      this.onCleared,
      this.onSelected,
      this.onSelectedFocus}) {
    if (selectedItem != null) {
      controller.text = itemAsString(selectedItem!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _showEmptyWidget,
        builder: (context, value, child) => CustomAutoSearchField<T>(
              controller: controller,
              labelText: labelText,
              hintText: hintText,
              autoClear: autoClear,
              onSelectedFocus: onSelectedFocus,
              onFieldFocusCreated: onFieldFocusCreated,
              optionsBuilder: _optionsBuilder,
              onChanged: (value) => (value.isNullOrEmpty && (selectedItem != null)) ? onCleared?.call(selectedItem!) : null,
              itemAsString: itemAsString,
              onSelected: onSelected,
              showEmptyWidget: value,
              onEmptyWidgetTap: onEmptyTap,
          onEmptyWidgetTapDown: onEmptyTapDetails,

            ));
  }

  FutureOr<Iterable<T>> _optionsBuilder(TextEditingValue textEditingValue) {
    var searchQuery = textEditingValue.text.toLowerCase();
    if (searchQuery.isNullOrEmpty) return [];
    var omitted = ((selectedItem == null))
        ? null
        : (itemAsString(selectedItem!) == controller.text)
            ? selectedItem
            : null;
    // Console.of.log("omitted: $omitted ${itemAsString(selectedItem!)} ${controller.text}");
    var omitting = suggestions.where((element) => element == omitted);
    var result = suggestions
        .where((element) => element != omitted)
        .where((element) => "${(itemAsStringSearch?.call(element)) ?? element}".toLowerCase().contains(searchQuery));
    Console.of.log("result: ${result.isEmpty} ${omitting.isEmpty} ${omitted == null}");
    if (showEmpty) _showEmptyWidget.value = (result.isEmpty) && ((omitting.isEmpty) && (omitted == null));
    return result;
  }
}
