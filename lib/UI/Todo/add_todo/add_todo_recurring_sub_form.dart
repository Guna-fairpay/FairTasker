import 'package:fairpytasker/Component/custom_weekdays_gridview.dart';
import 'package:fairpytasker/UI/Todo/add_todo/add_todo_const.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_bloc.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_events.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_state.dart';
import 'package:fairpytasker/UI/Todo/add_todo/component/add_todo_recurring_end_after_field.dart';
import 'package:fairpytasker/UI/Todo/add_todo/component/add_todo_recurring_monthly_field.dart';
import 'package:fairpytasker/UI/Todo/add_todo/component/add_todo_recurring_yearly_field.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTodoRecurringSubForm extends StatelessWidget {
  const AddTodoRecurringSubForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddToDoBloc, AddToDoState>(
      builder: (context, state) => (state.selectedRecurring?['label']
                  .toString()
                  .isDoesNotRepeat ==
              false)
          ? Column(
              children: [
                if (state.selectedRecurring?['label']
                        .toString()
                        .isDailyOrWeekly ??
                    false)
                  ListTile(
                    dense: true,
                    leading: const Text("Occur every"),
                    contentPadding: 5.horizontalPadding,
                    leadingAndTrailingTextStyle: context.textTheme.titleMedium,
                    title: Utils.getTextFormField(null, context.read<AddToDoBloc>().recurringEveryDayWeekController,
                        isDense: true,
                        hintText: "e.g: 1/2/3",
                        validator: (value) =>
                            (value?.isEmpty ?? false) ? "Required Field" : null,
                        textType: TextInputType.number,
                        textInputFormatter: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        style: context.textTheme.labelLarge,
                        labelStyle: context.textTheme.labelMedium),
                    trailing: Text((['daily'].contains(state
                            .selectedRecurring?['label']
                            .toString()
                            .toLowerCase()))
                        ? "days"
                        : "weeks"),
                  ),
                if (state.selectedRecurring?['label'].toString().isWeekly ??
                    false)
                  CustomWeekdaysGridview<String>(
                      items: AddToDoConfig.days,
                      selectedItems: List.from(state.selectedRecurringDays),
                      onChanged: (value) => context
                          .read<AddToDoBloc>()
                          .add(AddToDoRecurringWeekDaysEvent(value))),
                if (state.selectedRecurring?['label'].toString().isWeekly ??
                    false)
                  10.height,
                if (state.selectedRecurring?['label'].toString().isMonthly ??
                    false)
                  AddTodoRecurringMonthlyField(
                    isRecurringMonthOccurrence: state.isRecurringMonthOccurrence,
                      dateController: context
                          .read<AddToDoBloc>()
                          .recurringMonthDateController,
                      monthController: context
                          .read<AddToDoBloc>()
                          .recurringMonthMonthController,
                      onChanged: (value) => context.read<AddToDoBloc>().add(AddToDoRecurringMonthOccurrenceEvent(value))),
                if (state.selectedRecurring?['label'].toString().isYearly ??
                    false)
                  AddTodoRecurringYearlyField(
                    selectedMonth: state.recurringYearlySelectedMonth,
                    dayController: context.read<AddToDoBloc>().recurringYearDateController,
                    onChanged: (value) => context.read<AddToDoBloc>().add(AddToDoRecurringYearlySelectedMonthEvent(value)),
                  ),
                AddTodoRecurringEndAfterField(
                  onChanged: (value) => context.read<AddToDoBloc>().add(AddToDoRecurringEndDateEvent(value)),
                  onDateChange: (value) => context.read<AddToDoBloc>().add(AddToDoRecurringEndDateSelectionEvent(value)),
                  isEndDateEnabled: state.isRecurringEndDate,
                  endDate: state.selectedRecurringEndDate,
                  dateController: context.read<AddToDoBloc>().recurringEndDateController,
                  occurrenceController: context.read<AddToDoBloc>().recurringNoOccurrenceController,
                )
              ],
            )
          : Container(),
    );
  }
}
