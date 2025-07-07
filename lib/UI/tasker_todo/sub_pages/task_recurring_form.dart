part of '../tasker_create_todo.dart';

class TaskRecurringForm extends StatelessWidget {
  const TaskRecurringForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddToDoBloc, AddToDoState>(builder: (context, state) => Column(
      children: (context.watch<AddToDoBloc>().selectedRecurring['label'].toString().isDoesNotRepeat) ? [] : [
        if (context.watch<AddToDoBloc>().selectedRecurring['label'].toString().isDailyOrWeekly)
        ListTile(
          dense: true,
          leading: const Text("Occur every"),
          contentPadding: 5.horizontalPadding,
          leadingAndTrailingTextStyle: context.textTheme.titleMedium,
          title: Utils.getTextFormField(null,
              context.read<AddToDoBloc>().recurringEveryDayWeekController,
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
              trailing: Text((['daily'].contains(context.watch<AddToDoBloc>().selectedRecurring['label'].toString().toLowerCase())) ? "days" : "weeks"),
        ),
        if (context.watch<AddToDoBloc>().selectedRecurring['label'].toString().isWeekly)
          CustomWeekdaysGridview<String>(
              items: AddToDoConfig.days,
              selectedItems: context.watch<AddToDoBloc>().selectedRecurringDays,
              onChanged: (value) => context.read<AddToDoBloc>().add(RecurringDaysEvent(value))),
        if (context.watch<AddToDoBloc>().selectedRecurring['label'].toString().isWeekly)
          10.height,
        if (context.watch<AddToDoBloc>().selectedRecurring['label'].toString().isMonthly)
          AddTodoRecurringMonthlyField(
              isRecurringMonthOccurrence: context.watch<AddToDoBloc>().isRecurringMonthOccurrence,
              dateController: context.read<AddToDoBloc>().recurringMonthDateController,
              monthController: context.read<AddToDoBloc>().recurringMonthMonthController,
              onChanged: (value) => context.read<AddToDoBloc>().add(RecurringMonthlyEvent(value))),
        if (context.watch<AddToDoBloc>().selectedRecurring['label'].toString().isYearly)
          AddTodoRecurringYearlyField(
            selectedMonth: context.watch<AddToDoBloc>().recurringYearlySelectedMonth,
            dayController: context.read<AddToDoBloc>().recurringYearDateController,
            onChanged: (value) => context.read<AddToDoBloc>().add(RecurringYearlyEvent(value)),
          ),
        AddTodoRecurringEndAfterField(
          onChanged: (value) => context.read<AddToDoBloc>().add(RecurringEndAfterEvent(value)),
          onDateChange: (value) => context.read<AddToDoBloc>().add(RecurringEndDateEvent(value)),
          isEndDateEnabled: context.watch<AddToDoBloc>().isRecurringEndDate,
          endDate: context.watch<AddToDoBloc>().selectedRecurringEndDate,
          dateController: context.read<AddToDoBloc>().recurringEndDateController,
          occurrenceController: context.read<AddToDoBloc>().recurringNoOccurrenceController,
        )
      ],
    ));
  }
}
