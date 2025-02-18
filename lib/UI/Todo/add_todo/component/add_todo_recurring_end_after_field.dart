import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTodoRecurringEndAfterField extends StatelessWidget {
  final bool? isEndDateEnabled;
  final DateTime? endDate;
  final void Function(DateTime value)? onDateChange;
  final ValueChanged<bool>? onChanged;
  final TextEditingController? dateController;
  final TextEditingController occurrenceController;

  const AddTodoRecurringEndAfterField(
      {super.key,
      this.isEndDateEnabled,
      this.endDate,
      this.onDateChange,
      this.onChanged,
      this.dateController,
      required this.occurrenceController});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, spacing: 10, children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.scale(
              scale: 0.7,
              alignment: Alignment.centerLeft,
              child: Switch(
                value: isEndDateEnabled ?? false,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: onChanged,
              )),
          Text("End Date",
              style: context.textTheme.labelLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          10.width
        ],
      ),
      Expanded(
        flex: 2,
        child: (isEndDateEnabled == false)
            ? Utils.getTextFormField(
                null,
                occurrenceController,
                hintText: "No of occurrences",
                textType: TextInputType.number,
                inputAction: TextInputAction.done,
                isDense: true,
                style: context.textTheme.labelLarge,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                validator: (val) =>
                    (val?.isEmpty ?? false) ? "Required Field" : null,
              )
            : CustomDateTimePicker<DateTime>(
                controller: dateController,
                format: "dd-MM-yyyy",
                labelText: "dd-MM-yyyy",
                onChanged: onDateChange,
                value: endDate,
                suffixIcon: Icon(Icons.calendar_month_rounded,
                    size: 18, color: context.theme.hintColor),
                textAlign: TextAlign.center),
      ),
    ]);
  }
}
