part of '../tasker_create_todo.dart';

class TaskTimeForm extends StatelessWidget {
  const TaskTimeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddToDoBloc, AddToDoState>(builder: (context, state) => Column(
      spacing: 10.spMin,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox.shrink(),
        const CompactText('Task Date/Time', fontWeight: FontWeight.w600),
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomDateTimePicker<DateTime>(
              controller: context.read<AddToDoBloc>().dateController,
              format: "MM-dd-yyyy",
              suffixIcon: Icon(Icons.calendar_month_rounded,
                  size: 18, color: context.theme.hintColor),
              textAlign: TextAlign.center,
              value: context.watch<AddToDoBloc>().selectedDate,
              onChanged: (value) => context.read<AddToDoBloc>().add(DateSelectEvent(value)),
            ),
            CustomDateTimePicker<TimeOfDay>(
              controller: context.read<AddToDoBloc>().timeController,
              value: context.watch<AddToDoBloc>().selectedTime,
              format: "HH:mm",
              suffixIcon: Icon(Icons.access_time_rounded,
                  size: 18, color: context.theme.hintColor),
              onChanged: (value) => context.read<AddToDoBloc>().add(TimeSelectEvent(value)),
            ),
            Expanded(child: CompactDropDown<Map<String, dynamic>>(
              hintText: "Select Recurring Type",
              items: ToDoConfig.recurringOptions,
              initialSelection: context.watch<AddToDoBloc>().selectedRecurring,
              itemAsString: (item) => item['label'].toString(),
              onChanged: (value) => context.read<AddToDoBloc>().add(RecurringEvent(value)),
            )),
          ],
        ),
        const SizedBox.shrink(),
      ],
    ));
  }
}
