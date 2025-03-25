
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';

class CustomDateTimePicker<T> extends StatelessWidget {
  final T? value;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final String? labelText;
  final String? format;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function(T value)? onChanged;
  final TextEditingController? controller;
  final bool use24HourFormat;
  final bool showAsExpanded;

  const CustomDateTimePicker(
      {super.key,
      this.labelText = "Select",
      this.format,
      this.value,
      required this.controller,
      this.prefixIcon,
      this.suffixIcon,
      this.textStyle,
      this.textAlign,
      this.onChanged,
      this.showAsExpanded = false,
      this.use24HourFormat = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        dynamic result;
        if (runtimeType == CustomDateTimePicker<DateTime>) {
          result = await _pickDatePicker(context);
        }
        else if (runtimeType == CustomDateTimePicker<TimeOfDay>) {
          result = use24HourFormat
              ? await _pick24hTimePicker(context)
              : await _pickTimePicker(context);
        }
        if (result != null) onChanged?.call(result);
        controller?.text = Utils.formatDateTime(format: format, input: result);
      },
      radius: Num.borderRadius,
      borderRadius: BorderRadius.circular(Num.borderRadius),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Num.borderRadius),
            shape: BoxShape.rectangle,
            border: Border.all(
                width: Num.borderWidthField, color: AppC.borderColor)),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 5,
          children: [
            if (prefixIcon != null) prefixIcon!,
            if (showAsExpanded)
            Expanded(
              child: Text(
                "${(value == null) ? labelText : Utils.formatDateTime(input: value, format: format)}",
                overflow: TextOverflow.ellipsis,
                style: textStyle ?? context.textTheme.labelLarge?.copyWith(color: AppC.text),
                textAlign: textAlign,
              ),
            ),
            if (!showAsExpanded)
              Text(
                "${(value == null) ? labelText : Utils.formatDateTime(input: value, format: format)}",
                overflow: TextOverflow.ellipsis,
                style: textStyle ?? context.textTheme.labelLarge?.copyWith(color: AppC.text),
                textAlign: textAlign,
              ),
            if (suffixIcon != null) suffixIcon!,
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _pickDatePicker(BuildContext context) async {
    if ((runtimeType != CustomDateTimePicker<DateTime>)) return null;
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
    if ((runtimeType != CustomDateTimePicker<TimeOfDay>)) return null;
    var result = await showTimePicker(
      context: context,
      initialTime: (value as TimeOfDay?) ?? TimeOfDay.fromDateTime(DateTime.now()),
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );
    return result;
  }

  Future<TimeOfDay?> _pick24hTimePicker(BuildContext context) async {
    if ((runtimeType != CustomDateTimePicker<TimeOfDay>)) return null;
    var result = await showTimePicker(
      context: context,
      initialTime: (value as TimeOfDay?) ?? TimeOfDay.fromDateTime(DateTime.now()),
      initialEntryMode: TimePickerEntryMode.dialOnly,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          child: child!);
      }
    );
    return result;
  }

}
