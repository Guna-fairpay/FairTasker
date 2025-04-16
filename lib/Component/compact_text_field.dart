import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompactTextField extends StatelessWidget {
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autoValidateMode;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? hintText, labelText;
  final IconData? prefixIcon;
  final Color? borderColor;
  final int? maxLines;
  final int? minLines;
  const CompactTextField({super.key, this.controller, this.hintText = "Type here", this.labelText, this.prefixIcon, this.autoValidateMode, this.textInputAction, this.keyboardType, this.validator, this.maxLines = 1, this.minLines, this.inputFormatters, this.borderColor = AppC.fieldBase});

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(borderRadius: BorderRadius.circular(Num.borderRadius), borderSide: BorderSide(color: borderColor ?? AppC.borderColor, width: Num.borderWidthThinField));
    return TextFormField(
      key: key,
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      minLines: minLines,
      inputFormatters: inputFormatters,
      spellCheckConfiguration: const SpellCheckConfiguration(),
      autovalidateMode: autoValidateMode,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      style: context.textTheme.titleSmall?.copyWith(color: AppC.text),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        labelText: labelText,
        contentPadding: 7.sp.padding.copyWith(left: 10.sp, right: 10.sp),
        prefixIconConstraints: const BoxConstraints(),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        hintStyle: context.textTheme.titleSmall?.copyWith(color: AppC.fieldBase),
        prefixIcon: (prefixIcon == null) ? null : Padding(padding: 10.horizontalPadding, child: const Icon(Icons.search_rounded, color: AppC.text)),
      ),
    );
  }
}
