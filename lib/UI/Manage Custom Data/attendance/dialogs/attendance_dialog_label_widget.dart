import 'package:flutter/material.dart';

class AttendanceDialogLabelWidget extends StatelessWidget {
  final String label;
  final dynamic value;
  const AttendanceDialogLabelWidget({super.key, required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(
        text: "$label ",
        children: (value == null) ? [] : [
          TextSpan(text: "$value", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600))
        ]
    ), style: Theme.of(context).textTheme.labelLarge);
  }
}
