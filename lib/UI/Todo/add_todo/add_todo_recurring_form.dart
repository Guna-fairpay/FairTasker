import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/custom_dropdown.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';

class AddTodoRecurringForm extends StatelessWidget {
  const AddTodoRecurringForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 10,
      children: [
        Utils.getText('Task Date/Time', weight: FontWeight.w500),
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: CustomDateTimePicker<DateTime>(controller: TextEditingController(), value: DateTime.now(),)),
            Expanded(child: CustomDateTimePicker<TimeOfDay>(controller: TextEditingController(), value: TimeOfDay.now(),)),
            Expanded(child: CustomDropdown(items: [])),
          ],
        )
      ],
    );
  }
}
