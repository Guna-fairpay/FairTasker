import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';

class AddTodoRecurringEndAfterField extends StatelessWidget {
  const AddTodoRecurringEndAfterField({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Flexible(
        flex: 2,
        child: SwitchListTile.adaptive(
          value: false,
          dense: true,
          contentPadding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (value) {},
          title: Text("End Date"),
        ),
      ),
      Expanded(
        flex: 2,
        child: CustomDateTimePicker<DateTime>(
            controller: TextEditingController(),
            format: "dd-MM-yyyy",
            labelText: "dd-MM-yyyy",
            suffixIcon: Icon(Icons.calendar_month_rounded,
                size: 18, color: context.theme.hintColor),
            textAlign: TextAlign.center),
      ),
    ]);
  }
}
