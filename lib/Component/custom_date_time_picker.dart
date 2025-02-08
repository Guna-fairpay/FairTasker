import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';

class CustomDateTimePicker<T> extends StatelessWidget {
  final T? value;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final String? labelText;
  final Function(T value)? onChanged;
  final TextEditingController controller;

  CustomDateTimePicker(
      {super.key,
      this.labelText = "Select",
      this.value,
      required this.controller,
      this.textStyle,
      this.textAlign,
      this.onChanged}) {
    controller.text = valueLabel;
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
        if (result != null) onChanged?.call(result as T);
      },
      radius: Num.radiusButton,
      borderRadius: BorderRadius.circular(Num.radiusButton),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Num.radiusButton),
            shape: BoxShape.rectangle,
            border: Border.all(width: 0.5)),
        padding: const EdgeInsets.all(10),
        child: ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) => Text(
                  value.text.isEmpty ? (labelText ?? "") : value.text,
                  style: textStyle ?? context.textTheme.labelLarge,
                  textAlign: textAlign,
                )),
      ),
    );
  }

  Future<DateTime?> _pickDatePicker(BuildContext context) async {
    if ((T is! DateTime) || (value is! DateTime)) return null;
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
    if ((T is! TimeOfDay) || (value is! TimeOfDay)) return null;
    var result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );
    return result;
  }

  String get valueLabel {
    if (value is DateTime) {
      return (value as DateTime).toIso8601String();
    } else if (value is TimeOfDay) {
      var val = (value as TimeOfDay);
      return "${val.hour}:${val.minute}";
    } else {
      return "";
    }
  }
}
