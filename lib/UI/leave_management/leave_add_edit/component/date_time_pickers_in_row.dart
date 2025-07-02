
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateTimePickersInRow<T> extends StatelessWidget {
  final TextEditingController startController;
  final TextEditingController endController;
  final String format;
  final T? firstValue, secondValue;
  final ValueChanged<T>? onFirstChanged;
  final ValueChanged<T>? onSecondChanged;
  final String firstLabel;
  final String secondLabel;
  final Icon? icon;

  const DateTimePickersInRow({super.key,
    this.firstValue,
    this.secondValue,
    this.onFirstChanged,
    this.onSecondChanged,
    required this.startController,
    required this.endController,
    required this.format,
    required this.firstLabel,
    required this.secondLabel,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Utils.getText(firstLabel,weight: FontWeight.bold),
                5.spMin.height,
                CustomDateTimePicker<T>(
                  padding: 8.padding,
                  value: firstValue,
                  onChanged: onFirstChanged,
                  controller: startController,
                  format: format,
                  suffixIcon: icon,
                ),
              ]
          ),
        ),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Utils.getText(secondLabel,weight: FontWeight.bold),
                5.spMin.height,
                CustomDateTimePicker<T>(
                  padding: 8.padding,
                  value: secondValue,
                  onChanged:onSecondChanged,
                  controller: endController,
                  format: format,
                  suffixIcon: icon,
                ),
              ]
          ),
        ),
      ],
    );
  }
}
