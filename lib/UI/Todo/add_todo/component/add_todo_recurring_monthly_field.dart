import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/formatter/day_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTodoRecurringMonthlyField extends StatelessWidget {
  final bool isRecurringMonthOccurrence;
  final ValueChanged<bool>? onChanged;
  final TextEditingController dateController, monthController;
  const AddTodoRecurringMonthlyField({super.key, required this.isRecurringMonthOccurrence, this.onChanged, required this.dateController, required this.monthController});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          dense: true,
          horizontalTitleGap: 0,
          minVerticalPadding: 0,
          minLeadingWidth: 0,
          contentPadding: EdgeInsets.zero,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Transform.scale(
                  scale: 0.7,
                  transformHitTests: false,
                  filterQuality: FilterQuality.low,
                  alignment: Alignment.centerLeft,
                  child: Switch(
                    value: isRecurringMonthOccurrence,
                    padding: EdgeInsets.zero,
                    splashRadius: 0,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: onChanged,
                  )),
              Text("Occurrence Date",
                  style: context.textTheme.labelMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              5.width
            ],
          ),
          title: Row(
            spacing: 5,
            children: [
              Flexible(
                child: Utils.getTextFormField(
                  null,
                  dateController,
                  hintText: isRecurringMonthOccurrence ? "date" : "eg: first, last",
                  textType: isRecurringMonthOccurrence ? TextInputType.number : TextInputType.text,
                  inputAction: TextInputAction.done,
                  textInputFormatter: isRecurringMonthOccurrence ? [
                    FilteringTextInputFormatter.digitsOnly,
                    DayInputFormatter()
                  ] : [],
                  isDense: true,
                  style: context.textTheme.labelLarge,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  validator: (val) =>
                  (val?.isEmpty ?? false) ? "Required Field" : null,
                ),
              ),
              if (!isRecurringMonthOccurrence)
              Flexible(
                child: Utils.getTextFormField(
                  null,
                  monthController,
                  hintText: "eg: month",
                  textType: TextInputType.text,
                  inputAction: TextInputAction.done,
                  isDense: true,
                  style: context.textTheme.labelLarge,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  validator: (val) =>
                  (val?.isEmpty ?? false) ? "Required Field" : null,
                ),
              ),
              const SizedBox.shrink()
            ],
          ),
          trailing: Text("of every month",
              style: context.textTheme.labelMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ),
        10.height,
      ],
    );
  }
}
