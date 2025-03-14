import 'package:fairpytasker/Component/custom_auto_search_field.dart';
import 'package:fairpytasker/Component/custom_search_field.dart';
import 'package:flutter/material.dart';


class CustomSingleSelectionField<T extends Object> extends StatelessWidget {
  final List<T> suggestionsList;
  final T? selected;
  final void Function(T val)? onSelected;
  final ItemAsString<T> itemAsString;
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;

  CustomSingleSelectionField(
      {super.key,
      required this.suggestionsList,
      this.selected,
      this.onSelected,
      this.labelText,
      this.hintText,
      required this.itemAsString,
      required this.controller});

  ValueNotifier<bool> showEmptyNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: showEmptyNotifier,
      builder: (context, value, child) => CustomAutoSearchField<T>(
          controller: controller,
          labelText: labelText,
          hintText: hintText,
          onSelected: _onSuggested,
          showEmptyWidget: value,
          onEmptyWidgetTapDown: (details) {},
          itemAsString: itemAsString,
          optionsBuilder: (textEditingValue) => onSearch(textEditingValue)),
    );
  }

  Future<Iterable<T>> onSearch(TextEditingValue textEditingValue) async {
    var val = textEditingValue.text.toLowerCase();
    if (val.isEmpty) {
      return [];
    }
    var omitted = (selected != null)
        ? ((itemAsString(selected!)) == textEditingValue.text)
            ? selected
            : null
        : null;
    var list = suggestionsList
        .where((element) => element != omitted)
        .where((element) =>
            (itemAsString(element)).toString().toLowerCase().contains(val))
        .toList();
    showEmptyNotifier.value = list.isEmpty &&
        (omitted != null) &&
        (((itemAsString(omitted)) != textEditingValue.text));
    return list;
  }

  void _onSuggested(T val) {
    var data = val;
    controller.text = itemAsString.call(data);
    onSelected?.call(val);
  }
}
