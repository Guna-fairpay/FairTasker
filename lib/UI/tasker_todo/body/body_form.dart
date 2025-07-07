part of '../tasker_create_todo.dart';

class BodyForm extends StatelessWidget {
  const BodyForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddToDoBloc, AddToDoState>(
        builder: (context, state) => Form(
          key: context.read<AddToDoBloc>().formKey,
          child: Column(
            children: [
              const MainForm(),
              if (!context.watch<AddToDoBloc>().isMeeting)
              const MoreForm(),
              if (!context.watch<AddToDoBloc>().isMeeting)
              const CustomForm(),
              const TaskForm(),
              const TaskTimeForm(),
              const TaskRecurringForm(),
              const SubmitVehicleForm(),
            ]
          )));
  }
}
