import 'package:fairpytasker/Component/focus_node_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompactSearchView extends StatelessWidget {
  final bool? filled;
  final bool readOnly;
  final Color? fillColor;
  final Widget? prefixIcon;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final String? hintText, labelText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged, onSubmitted;
  const CompactSearchView({super.key,  this.readOnly = false, this.controller, this.onChanged, this.onSubmitted, this.hintText = "Search...", this.labelText, this.filled = false, this.fillColor = AppC.white, this.padding, this.borderRadius = const BorderRadius.all(Radius.circular(Num.borderRadius)), this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(borderRadius: borderRadius ?? BorderRadius.circular(Num.borderRadius), borderSide: (filled ?? false) ? BorderSide.none : const BorderSide(color: AppC.fieldBase, width: Num.borderWidthThinField));
    return FocusNodeWrapper(
      builder: (focusNode) => TextField(
        key: key,
        controller: controller,
        readOnly: readOnly,
        focusNode: focusNode,
        textInputAction: TextInputAction.search,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        keyboardType: TextInputType.text,
        maxLines: 1,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        style: context.textTheme.labelLarge?..copyWith(color: AppC.appColor),
        onTapOutside: (event) => focusNode.unfocus(),
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          labelText: labelText,
          contentPadding: padding ?? 7.sp.padding,
          fillColor: fillColor,
          filled: filled,
          prefixIconConstraints: const BoxConstraints(),
          border: border,
          enabledBorder: border,
          focusedBorder: border,
          hintStyle: context.textTheme.labelLarge?..copyWith(color: AppC.text),
          prefixIcon: prefixIcon ?? Padding(padding: 10.horizontalPadding, child: const Icon(Icons.search_rounded, color: AppC.text)),
        ),
      ),
    );
  }
}
