import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateSwitcherView extends StatelessWidget {
  final String format;
  final DateTime? selectedDate;
  final VoidCallback? onPreviousDay, onNextDay, onCurrentDay;
  const DateSwitcherView({super.key, this.format = 'MMM d', this.selectedDate, this.onPreviousDay, this.onNextDay, this.onCurrentDay});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const SizedBox.shrink(),
      IconButton(
          onPressed: onPreviousDay, icon: const Icon(Icons.chevron_left_rounded)),
      GestureDetector(
        onTap: onCurrentDay,
        child: Text(
          (selectedDate ?? DateTime.now()).toFormat(format: format) ?? "",
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
        ),
      ),
      IconButton(
          onPressed: onNextDay, icon: const Icon(Icons.chevron_right_rounded)),
      const SizedBox.shrink(),
    ]);
  }
}
