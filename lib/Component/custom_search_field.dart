import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:searchfield/searchfield.dart';
import 'package:flutter/material.dart';

typedef ItemAsString<T> = String Function(T item);

class CustomSearchField<T> extends StatelessWidget {
  final TextEditingController? controller;
  final List<T> suggestions;
  final ItemAsString<T>? itemAsString;
  final VoidCallback? onEmptyTap;
  final Function(T val)? onSuggestionTap;
  final String? hintText, labelText, emptyText;
  final bool autoControllerClear;
  final Suggestion suggestionState;
  final Function(String val)? onSearchChanged;
  final FocusNode? focusNode;
  final List<SearchFieldListItem<T>>? Function(String)? onSearchTextChanged;
  final VoidCallback? onTap, onTapOutSide;
  const CustomSearchField({super.key, this.controller, required this.suggestions, this.itemAsString, this.onEmptyTap, this.onSuggestionTap, this.hintText = "Type here...", this.labelText, this.emptyText = "Create new", this.autoControllerClear = false, this.suggestionState = Suggestion.expand, this.onSearchChanged, this.onSearchTextChanged, this.focusNode, this.onTap, this.onTapOutSide});

  @override
  Widget build(BuildContext context) {
    return SearchField<T>(
      key: UniqueKey(),
      focusNode: focusNode,
      controller: controller,
      onTap: onTap,
      onTapOutside: (onTapOutSide != null) ? ((val) => onTapOutSide?.call()) : null,
      suggestions: suggestions
          .map((e) => SearchFieldListItem(
          (itemAsString?.call(e) ?? e.toString()),
          item: e))
          .toList(),
      onSearchTextChanged: onSearchTextChanged,
      onSuggestionTap: (val) {
        if (autoControllerClear) controller?.clear();
        var item = val.item;
        if (item != null) onSuggestionTap?.call(item);
      },
      suggestionDirection: SuggestionDirection.flex,
      suggestionState: suggestionState,
      textInputAction: TextInputAction.done,
      searchInputDecoration: SearchInputDecoration(
        searchStyle: context.textTheme.labelLarge?.copyWith(fontFamily: "Lato"),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5)),
        contentPadding: const EdgeInsets.all(10),
        labelText: labelText,
        hintText: hintText,
        hintStyle: context.textTheme.labelLarge
            ?.copyWith(color: context.theme.hintColor),
        labelStyle: context.textTheme.labelLarge
            ?.copyWith(color: context.theme.hintColor),
      ),
      suggestionAction: SuggestionAction.next,
      suggestionsDecoration: SuggestionDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(10)),
      ),
      emptyWidget: (emptyText != null) ? Center(
          child: TextButton.icon(
            onPressed: onEmptyTap,
            label: Utils.getText("$emptyText",
                align: TextAlign.center, color: Colors.red),
            icon: const Icon(
              Icons.add_rounded,
              color: Colors.red,
            ),
            style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                    ContinuousRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10)))),
          )) : const SizedBox.shrink(),
    );
  }
}
