import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/custom_dropdown.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_bloc.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_events.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_state.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTodoRecurringForm extends StatelessWidget {
  const AddTodoRecurringForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddToDoBloc, AddToDoState>(
        builder: (context, state) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 10,
              children: [
                Utils.getText('Task Date/Time', weight: FontWeight.w500),
                Row(
                  spacing: 5,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomDateTimePicker<DateTime>(
                      controller: context.read<AddToDoBloc>().dateController,
                      format: "dd-MM-yyyy",
                      value: state.selectedDate,
                      onChanged: (value) => context
                          .read<AddToDoBloc>()
                          .add(AddToDoDateChangeEvent(value)),
                    ),
                    Flexible(
                        child: CustomDateTimePicker<TimeOfDay>(
                      controller: context.read<AddToDoBloc>().timeController,
                      value: state.selectedTime,
                      format: "HH:mm",
                      onChanged: (value) => context
                          .read<AddToDoBloc>()
                          .add(AddToDoTimeChangeEvent(value)),
                    )),
                    Flexible(
                        flex: 2,
                        child: CustomDropdown<dynamic>(
                            items: state.recurringTypes,
                            value: state.selectedRecurring,
                            itemAsString: (item) => item['label'].toString(),
                            onChanged: (val) => context
                                .read<AddToDoBloc>()
                                .add(AddToDoRecurringTypeEvent(val)))),
                  ],
                )
              ],
            ));
  }
}
