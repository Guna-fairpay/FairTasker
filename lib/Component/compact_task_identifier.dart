import 'dart:collection';

import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SegmentedAutocomplete<T extends Object> extends StatefulWidget {
  final List<List<T>> segmentedSuggestions;
  final AutocompleteOptionToString<T> itemAsString;
  final dynamic Function(T) itemAsSearchString;
  final InputDecoration? decoration;
  final void Function(List<T>)? onChanged;
  final String separator;
  final String? hintText;
  final List<T>? selectedValues;

  const SegmentedAutocomplete({
    super.key,
    required this.segmentedSuggestions,
    required this.itemAsString,
    required this.itemAsSearchString,
    this.decoration,
    this.onChanged,
    this.hintText,
    this.separator = '-',
    this.selectedValues,
  });

  @override
  State<SegmentedAutocomplete<T>> createState() => _SegmentedAutocompleteState<T>();
}

class _SegmentedAutocompleteState<T extends Object> extends State<SegmentedAutocomplete<T>> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  late List<T> selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItems = List<T>.from(widget.selectedValues ?? []);
    _controller = TextEditingController(
      text: selectedItems.map(widget.itemAsString).join(widget.separator),
    );
  }

  int get currentSegmentIndex {
    final text = _controller.text;
    final cursorPos = _controller.selection.baseOffset;
    if (cursorPos < 0 || cursorPos > text.length) return 0;
    final beforeCursor = text.substring(0, cursorPos);
    final segments = beforeCursor.split(widget.separator);
    return segments.isEmpty ? 0 : segments.length - 1;
  }

  String get currentSegmentText {
    final text = _controller.text;
    final parts = text.split(widget.separator);
    final index = currentSegmentIndex;
    if (index < parts.length) {
      return parts[index].trim();
    }
    return '';
  }

  void replaceSegment(int index, String newText) {
    final parts = _controller.text.split(widget.separator);
    if (index >= parts.length) {
      parts.add(newText);
    } else {
      parts[index] = newText;
    }
    final newTextValue = parts.join(widget.separator);
    _controller.text = newTextValue;

    final newCursorOffset = parts.sublist(0, index + 1).join(widget.separator).length;
    _controller.selection = TextSelection.collapsed(offset: newCursorOffset);
  }

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.spMin),
      borderSide: const BorderSide(color: AppC.borderColor)
    );
    return RawAutocomplete<T>(
      textEditingController: _controller,
      focusNode: _focusNode,
      optionsBuilder: (textEditingValue) {
        final index = currentSegmentIndex;
        if (index >= widget.segmentedSuggestions.length) return const Iterable.empty();

        final currentSearch = currentSegmentText.toLowerCase();
        return widget.segmentedSuggestions[index].where((item) {
          final searchField = widget.itemAsSearchString(item);
          if (searchField is List) {
            return searchField.any((val) => val.toString().toLowerCase().contains(currentSearch));
          }
          return searchField.toString().toLowerCase().contains(currentSearch);
          });
      },
      displayStringForOption: widget.itemAsString,
      optionsViewBuilder: (context, onSelected, options) => Align(
        alignment: Alignment.topLeft,
        child: Material(
          elevation: 4.0,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: _buildGroupedOptions(options, onSelected),
            ),
          ),
        ),
      ),
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) => TextField(
        controller: controller,
        focusNode: focusNode,
        onTapOutside: (event) => _focusNode.unfocus(),
        style: context.textTheme.labelLarge,
        decoration: (widget.decoration ?? const InputDecoration(hintText: 'Enter segmented values')).copyWith(
          isDense: true,
          border: border,
          enabledBorder: border,
          hintText: widget.hintText ?? "Task Identifier",
          hintStyle: context.textTheme.labelMedium?.copyWith(color: context.theme.hintColor),
          contentPadding: 10.spMin.padding
        ),
      ),
    );
  }

  List<Widget> _buildGroupedOptions(Iterable<T> options, AutocompleteOnSelected<T> onSelected) {
    final grouped = SplayTreeMap<String, List<T>>();

    for (final option in options) {
      if (option is Map && option.containsKey('user_type')) {
        final groupKey = '${option['user_type']}';
        grouped.putIfAbsent(groupKey, () => []).add(option);
      } else {
        grouped.putIfAbsent('', () => []).add(option);
      }
    }

    return grouped.entries.expand((entry) {
      return [
        if (entry.key.isNotNullOrEmpty)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey[300],
          child: Text(
            entry.key,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ...entry.value.map((option) => ListTile(
          dense: true,
          minVerticalPadding: 0,
          title: Text(widget.itemAsString(option)),
          onTap: () {
            final index = currentSegmentIndex;
            replaceSegment(index, widget.itemAsString(option));
            if (selectedItems.length <= index) {
              selectedItems.add(option);
            } else {
              selectedItems[index] = option;
            }
            widget.onChanged?.call(selectedItems);
            FocusScope.of(context).requestFocus(FocusNode());
            Future.delayed(const Duration(milliseconds: 100), () => _focusNode.requestFocus());
          },
        ))
      ];
    }).toList();
  }
}
