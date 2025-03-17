import 'package:fairpytasker/UI/Todo/todo_view_components/todo_top_header.dart';
import 'package:fairpytasker/UI/Todo/todo_view_components/todo_top_hours_view.dart';
import 'package:fairpytasker/UI/Todo/todo_view_components/todo_top_search_bar.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_bloc.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_events.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_states.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskerHeader extends StatelessWidget {
  const TaskerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToDoTaskerBloc, ToDoTaskerState>(
      buildWhen: (previous, current) => current is ToDoTaskerCommonState,
      builder: (context, state) => Padding(
      padding: 10.padding,
      child: Column(
        spacing: 2,
        children: [
          TodoTopHeader(
            selectedDate: context.watch<ToDoTaskerBloc>().selectedDate,
            onDatePressed: () => context.read<ToDoTaskerBloc>().add(ToDoTaskerTapDateEvent()),
            onPreviousPressed: () => context.read<ToDoTaskerBloc>().add(ToDoTaskerPreviousDateEvent()),
            onNextPressed: () => context.read<ToDoTaskerBloc>().add(ToDoTaskerNextDateEvent()),
            onFilterPressed: (details) => Toaster.showInfo("FILTER PRESSED"),
            onSwitch: (val) => context.read<ToDoTaskerBloc>().add(ToDoTaskerShowCompleteEvent(val)),
            showCompleted: context.watch<ToDoTaskerBloc>().isCompleted,
            onUserTapDown: (details) => context.read<ToDoTaskerBloc>().add(ToDoTaskerTapUserFilterEvent(details)),
            onVehicleSearchPressed: (details) => context.read<ToDoTaskerBloc>().add(ToDoTaskerTapVehicleFilterEvent(details)),
            isUserSelected: true,
            isFilterSelected: true,
          ),
          TodoTopHoursView(model: context.watch<ToDoTaskerBloc>().processedWorkingHours),
          TodoTopSearchBar(
            controller: context.read<ToDoTaskerBloc>().searchController,
            onChanged: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerSearchEvent(value)),
            onAdd: () => context.read<ToDoTaskerBloc>().add(ToDoTaskerOnAddToDoEvent()),
            onMic: () => context.read<ToDoTaskerBloc>().add(ToDoTaskerOnMicEvent()),
          ),
        ],
      ),
    ),);
  }
}
