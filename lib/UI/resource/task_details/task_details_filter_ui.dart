import 'package:fairpytasker/UI/resource/task_details/bloc/task_details_bloc.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskDetailsFilterUi extends StatelessWidget {
  const TaskDetailsFilterUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskDetailsBloc, TaskDetailsState>(builder: (context, state) => ListTile(
      title: Text(context.watch<TaskDetailsBloc>().dateRange?.toFormat() ?? ""),
      trailing: GestureDetector(
        child: const Icon(Icons.filter_alt_rounded),
        onTap: () => context.read<TaskDetailsBloc>().add(ViewFilterEvent()),
      ),
    ));
  }
}
