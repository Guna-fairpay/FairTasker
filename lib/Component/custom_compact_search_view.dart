import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';

class CompactSearchView extends StatelessWidget {
  final String? hintText, labelText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged, onSubmitted;
  const CompactSearchView({super.key, this.controller, this.onChanged, this.onSubmitted, this.hintText = "Search...", this.labelText});

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(borderRadius: BorderRadius.circular(Num.borderRadius), borderSide: const BorderSide(color: AppC.fieldBase, width: Num.borderWidthThinField));
    return TextField(
      key: key,
      controller: controller,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: TextInputType.text,
      maxLines: 1,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      style: context.textTheme.titleSmall?.copyWith(color: AppC.appColor),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        labelText: labelText,
        contentPadding: 7.padding,
        prefixIconConstraints: const BoxConstraints(),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        hintStyle: context.textTheme.titleSmall?.copyWith(color: AppC.text),
        prefixIcon: Padding(padding: 10.horizontalPadding, child: const Icon(Icons.search_rounded, color: AppC.text)),
      ),
    );
  }
}
