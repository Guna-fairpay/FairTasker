import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_events.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_state.dart';
import 'package:fairpytasker/UI/Todo/add_todo/bloc/add_todo_bloc.dart';
import 'package:fairpytasker/Component/compact_task_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class AddTodoTaskManagerForm extends StatelessWidget {
  const AddTodoTaskManagerForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddToDoBloc, AddToDoState>(
      builder: (context, state)  => CompactTaskManager<Map<String, dynamic>>(
        validator: (value) => (value?.isEmpty ?? false) ? "Please select task manager" : null,
        label: "Task Manager",
        items: context.watch<AddToDoBloc>().persons,
        itemAsString: (item) => "${item['first_name'] ?? ""} ${item['last_name'] ?? ""}",
        autoValidateMode: AutovalidateMode.onUserInteraction,
        selectedItems: List.from(state.selectedTaskPersons),
        onChanged: (isChecked, value) => context.read<AddToDoBloc>().add(AddToDoPersonTapEvent(value, isChecked)),
      )
    );
  }
}
