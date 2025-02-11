import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';

class CustomDateTimePicker<T> extends StatelessWidget {
  final T? value;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final String? labelText;
  final String? format;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Function(T value)? onChanged;
  final TextEditingController controller;

  CustomDateTimePicker({super.key,
    this.labelText = "Select",
    this.format,
    this.value,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.textStyle,
    this.textAlign,
    this.onChanged}) {
    controller.text = Utils.formatDateTime(format: format, input: value);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        dynamic result;
        if (value is DateTime) {
          result = await _pickDatePicker(context);
        } else if (value is TimeOfDay) {
          result = await _pickTimePicker(context);
        }
        controller.text = Utils.formatDateTime(format: format, input: result);
        controller.notifyListeners();
        if (result != null) onChanged?.call(result);
      },
      radius: Num.borderRadius,
      borderRadius: BorderRadius.circular(Num.borderRadius),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Num.borderRadius),
            shape: BoxShape.rectangle,
            border: Border.all(width: Num.borderWidthField, color: AppC.borderColor)),
        padding: const EdgeInsets.all(10),
        child: ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) =>
                Text.rich(
                  TextSpan(
                      children: [
                        if (prefixIcon != null) WidgetSpan(child: prefixIcon!),
                        if (prefixIcon != null) WidgetSpan(child: 5.width),
                        TextSpan(
                            text: value.text.isEmpty ? Utils.formatDateTime(
                                input: value, format: format) : value.text),
                        if (suffixIcon != null) WidgetSpan(child: 5.width),
                        if (suffixIcon != null) WidgetSpan(child: suffixIcon!),
                      ]
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  textWidthBasis: TextWidthBasis.longestLine,
                  style: textStyle ?? context.textTheme.labelLarge?.copyWith(color: AppC.text),
                  textAlign: textAlign,
                )),
      ),
    );
  }

  Future<DateTime?> _pickDatePicker(BuildContext context) async {
    if ((value is! DateTime)) return null;
    var result = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(const Duration(days: 180)),
        currentDate: DateTime.now(),
        initialDate: value as DateTime?,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        lastDate: DateTime.now().add(const Duration(days: 1825000)));
    return result;
  }

  Future<TimeOfDay?> _pickTimePicker(BuildContext context) async {
    if ((value is! TimeOfDay)) return null;
    var result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );
    return result;
  }
}
