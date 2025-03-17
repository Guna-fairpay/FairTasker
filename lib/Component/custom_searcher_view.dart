import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Component/custom_auto_search_field.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';

class SearchViewField<T extends Object> extends StatelessWidget {
  final List<T> suggestions;
  final T? selectedItem;
  final ValueChanged<T>? onSelected;
  final ItemAsString<T> itemAsString;
  final TextEditingController controller;
  final bool showEmpty;
  final ValueNotifier<bool> _showEmptyWidget = ValueNotifier(false);

  SearchViewField(
      {super.key,
      required this.controller,
      required this.suggestions,
      required this.itemAsString,
      this.selectedItem,
      this.showEmpty = false,
      this.onSelected}) {
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
              optionsBuilder: _optionsBuilder,
              itemAsString: itemAsString,
              onSelected: onSelected,
              showEmptyWidget: value,
            ));
  }

  FutureOr<Iterable<T>> _optionsBuilder(TextEditingValue textEditingValue) {
    var searchQuery = textEditingValue.text.toLowerCase();
    if (searchQuery.isNullOrEmpty) return [];
    var omitted = ((selectedItem == null)) ? null : (itemAsString(selectedItem!) == controller.text) ? selectedItem : null;
    var result = suggestions
        .where((element) => element != omitted)
        .where((element) => "$element".toLowerCase().contains(searchQuery));
    if (showEmpty) _showEmptyWidget.value = result.isEmpty;
    return result;
  }
}
