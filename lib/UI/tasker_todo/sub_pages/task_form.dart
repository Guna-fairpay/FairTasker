part of '../tasker_create_todo.dart';

class TaskForm extends StatelessWidget {
  const TaskForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddToDoBloc, AddToDoState>(builder: (context, state) => CompactTaskManager<Map<String, dynamic>>(
      validator: (value) => (value?.isEmpty ?? false) ? "Please select task manager" : null,
      label: "Task Manager",
      items: context.watch<AddToDoBloc>().persons,
      itemAsString: (item) => "${item['first_name'] ?? ""} ${item['last_name'] ?? ""}",
      autoValidateMode: AutovalidateMode.onUserInteraction,
      selectedItems: context.watch<AddToDoBloc>().selectedTaskManagers,
      onChanged: (isChecked, value) => context.read<AddToDoBloc>().add(TaskManagerEvent(isChecked, value)),
    ));
  }
}
