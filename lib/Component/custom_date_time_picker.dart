import 'package:fairpytasker/Component/custom_time_picker.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart' hide showTimePicker;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDateTimePicker<T> extends StatelessWidget {
  final T? value;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final String? labelText;
  final String? format;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? neutralText;
  final String? confirmText;
  final void Function(T value)? onChanged;
  final void Function(TimeOfDay value)? onNeutral;
  final TextEditingController? controller;
  final bool use24HourFormat;
  final bool showAsExpanded;
  final EdgeInsets? padding;
  final DateTime? firstDate;
  final FormFieldValidator<T>? validator;
  final AutovalidateMode? autovalidateMode;

  const CustomDateTimePicker({
    super.key,
    this.labelText = "Select",
    this.neutralText,
    this.confirmText,
    this.format,
    this.value,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.textStyle,
    this.textAlign,
    this.onChanged,
    this.onNeutral,
    this.showAsExpanded = false,
    this.use24HourFormat = true,
    this.padding,
    this.validator,
    this.autovalidateMode,
    this.firstDate
  });

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      key: key,
      validator: validator,
      autovalidateMode: autovalidateMode,
      initialValue: value,
      builder: (field) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (value != null && field.hasError) field.didChange(value);
        });
        return Column(
          spacing: 3,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Num.subradiusButton),
                  shape: BoxShape.rectangle,
                  border: Border.all(
                      width: Num.borderWidthButton, color: (field.hasError) ? AppC.errorTextColor : AppC.borderColor)),
              padding: padding ?? EdgeInsets.all(8.spMin),
              child: InkWell(
                onTap: () async {
                  dynamic result;
                  if (runtimeType == CustomDateTimePicker<DateTime>) {
                    result = await _pickDatePicker(context);
                  } else if (runtimeType == CustomDateTimePicker<TimeOfDay>) {
                    result = await _pick24hTimePicker(context, onNeutral: onNeutral);
                  }
                  controller?.text =
                      Utils.formatDateTime(format: format, input: result);
                  field.didChange(result ?? value);
                  if (result != null) onChanged?.call(result);
                  Utils.dismissKeyboard(context);
                },
                radius: Num.borderRadius,
                borderRadius: BorderRadius.circular(Num.borderRadius),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 5,
                  children: [
                    if (prefixIcon != null) prefixIcon!,
                    if (showAsExpanded)
                      Expanded(
                        child: Text(
                          "${(value == null) ? labelText : Utils.formatDateTime(input: value, format: format)}",
                          overflow: TextOverflow.ellipsis,
                          style: textStyle ??
                              context.textTheme.labelLarge?.copyWith(
                                  color: (value == null) ? AppC.grey : AppC.text),
                          textAlign: textAlign,
                        ),
                      ),
                    if (!showAsExpanded)
                      Text(
                        "${(value == null) ? labelText : Utils.formatDateTime(input: value, format: format)}",
                        overflow: TextOverflow.ellipsis,
                        style: textStyle ??
                            context.textTheme.labelLarge?.copyWith(
                                color: (value == null) ? AppC.grey : AppC.text),
                        textAlign: textAlign,
                      ),
                    if (suffixIcon != null) suffixIcon!,
                  ],
                ),
              ),
            ),
            if (field.hasError)
              Row(
                spacing: 8,
                children: [
                  const SizedBox.shrink(),
                  Text(field.errorText ?? "", style: context.textTheme.labelMedium?.copyWith(color: AppC.errorTextColor, fontWeight: FontWeight.w100))
                ],
              )
          ],
        );
      },
    );
  }

  Future<DateTime?> _pickDatePicker(BuildContext context) async {
    if ((runtimeType != CustomDateTimePicker<DateTime>)) return null;
    var result = await showDatePicker(
        context: context,
        // firstDate: firstDate ?? DateTime.now().subtract(const Duration(days: 180)),
        firstDate: firstDate ?? DateTime(2000),
        currentDate: DateTime.now(),
        initialDate: value as DateTime?,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        lastDate: DateTime.now().add(const Duration(days: 1825000)));
    return result;
  }

  Future<TimeOfDay?> _pickTimePicker(BuildContext context,
      {ValueChanged<TimeOfDay>? onNeutral}) async {
    if ((runtimeType != CustomDateTimePicker<TimeOfDay>)) return null;
    var result = await showTimerPicker(
      confirmText: confirmText,
      neutralText: neutralText,
      context: context,
      onNeutral: onNeutral,
      initialTime:
          (value as TimeOfDay?) ?? TimeOfDay.fromDateTime(DateTime.now()),
      initialEntryMode: TimerPickerEntryMode.dialOnly,
    );
    return result;
  }

  Future<TimeOfDay?> _pick24hTimePicker(BuildContext context,
      {ValueChanged<TimeOfDay>? onNeutral}) async {
    if ((runtimeType != CustomDateTimePicker<TimeOfDay>)) return null;
    var result = await showTimerPicker(
        context: context,
        confirmText: confirmText,
        neutralText: neutralText,
        onNeutral: onNeutral,
        initialTime:
            (value as TimeOfDay?) ?? TimeOfDay.fromDateTime(DateTime.now()),
        initialEntryMode: TimerPickerEntryMode.dialOnly,
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: true,
              ),
              child: child!);
        });
    return result;
  }
}
