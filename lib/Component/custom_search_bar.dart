import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final void Function(String value)? onChanged;
  final void Function(String value)? onSearch;
  final EdgeInsets? padding;
  final bool readOnly;
  const CustomSearchBar({super.key, this.controller, this.hintText = "Search here...", this.onChanged, this.onSearch, this.padding, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        isDense: true,
        constraints: const BoxConstraints(),
        contentPadding: padding ?? 10.padding,
        filled: true,
        fillColor: context.theme.hintColor.withValues(alpha: 0.07),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(Num.borderRadius), borderSide: const BorderSide(width: 0.2)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Num.borderRadius), borderSide: const BorderSide(width: 0.2)),
        hintText: hintText,
        hintStyle: context.textTheme.labelLarge?.copyWith(
            color: context.theme.hintColor
        ),
        prefixIcon: const Icon(Icons.search_rounded),
        prefixIconConstraints: const BoxConstraints(
            minWidth: 40
        ),
        isCollapsed: true,
        alignLabelWithHint: true,
      ),
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.webSearch,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      mouseCursor: MouseCursor.defer,
      maxLines: 1,
      enableSuggestions: true,
      onSubmitted: onSearch,
      onChanged: onChanged,
    );
  }
}
