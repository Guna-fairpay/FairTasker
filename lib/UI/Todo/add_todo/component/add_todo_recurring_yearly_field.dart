import 'package:fairpytasker/core/app/formatter/day_input_formatter.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_const.dart';
import 'package:fairpytasker/Component/custom_dropdown.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTodoRecurringYearlyField extends StatelessWidget {
  final dynamic selectedMonth;
  final ValueChanged<dynamic>? onChanged;
  final TextEditingController dayController;
  const AddTodoRecurringYearlyField({super.key, this.selectedMonth, this.onChanged, required this.dayController});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          spacing: 20,
          children: [
            Expanded(
              child: ListTile(
                dense: true,
                horizontalTitleGap: 20,
                minVerticalPadding: 0,
                minLeadingWidth: 0,
                contentPadding: EdgeInsets.zero,
                leading: Text("Date",
                    style: context.textTheme.labelLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                title: Utils.getTextFormField(
                  null,
                  dayController,
                  hintText: "Date",
                  textType: TextInputType.number,
                  inputAction: TextInputAction.done,
                  isDense: true,
                  style: context.textTheme.labelLarge,
                  textInputFormatter: [ FilteringTextInputFormatter.digitsOnly, DayInputFormatter()],
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  validator: (val) =>
                  (val?.isEmpty ?? false) ? "Required Field" : null,
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                dense: true,
                horizontalTitleGap: 5,
                minVerticalPadding: 0,
                minLeadingWidth: 0,
                contentPadding: EdgeInsets.zero,
                leading: Text("Month",
                    style: context.textTheme.labelLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                title: CustomDropdown<dynamic>(items: AddToDoConfig.months,
                  itemAsString: (item) => item['month'].toString(),
                  value: selectedMonth,
                  onChanged: onChanged,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
              ),
            ),
          ],
        ),
        10.height,
      ],
    );
  }
}
