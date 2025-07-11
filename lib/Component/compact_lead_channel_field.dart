import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:flutter/material.dart';

class CompactSingleChannelField<T extends Object> extends StatelessWidget {
  final List<T> items;
  final T? selected;
  final String labelText;
  final ItemAsString<T> itemAsString;
  final TextEditingController? controller;
  final ItemAsString<T>? itemAsStringSearch;
  final ValueChanged<T>? onSelected, onCleared;
  final Function(TapDownDetails details)? onEmptyTapDetails;
  const CompactSingleChannelField({super.key, required this.items, this.selected, this.controller, this.itemAsStringSearch, required this.itemAsString, this.onEmptyTapDetails, this.labelText = "Type here...", this.onSelected, this.onCleared});

  @override
  Widget build(BuildContext context) {
    return SearchViewField<T>(
        controller: controller ?? TextEditingController(),
        autoClear: true,
        showEmpty: true,
        suggestions: items,
        labelText: labelText,
        onCleared: onCleared,
        alwayShowSuffix: true,
        onSelected: onSelected,
        selectedItem: selected,
        itemAsString: itemAsString,
        onEmptyTapDetails: onEmptyTapDetails,
        itemAsStringSearch: itemAsStringSearch);
  }
}
