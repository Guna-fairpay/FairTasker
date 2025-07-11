import 'package:fairpytasker/UI/Todo/todo_view_components/todo_top_header.dart';
import 'package:fairpytasker/UI/Todo/todo_view_components/todo_top_hours_view.dart';
import 'package:fairpytasker/UI/Todo/todo_view_components/todo_top_search_bar.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_bloc.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
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
            onFilterPressed: (details) => context.read<ToDoTaskerBloc>().add(ToDoTaskerFilterTaskEvent()),
            onSwitch: (val) => context.read<ToDoTaskerBloc>().add(ToDoTaskerShowCompleteEvent(val)),
            showCompleted: context.watch<ToDoTaskerBloc>().isCompleted,
            onUserTapDown: (details) => context.read<ToDoTaskerBloc>().add(ToDoTaskerTapUserFilterEvent(details)),
            onVehicleSearchPressed: (details) => context.read<ToDoTaskerBloc>().add(ToDoTaskerTapVehicleFilterEvent(details)),
            isUserSelected: context.watch<ToDoTaskerBloc>().isUserSelected,
            isFilterSelected: context.watch<ToDoTaskerBloc>().isFilterSelected,
            isTimeSensitive: context.watch<ToDoTaskerBloc>().isTimeSensitive,
            onChangeTimeSensitive: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerTimeSensitiveEvent(value)),
          ),
          TodoTopHoursView(model: context.watch<ToDoTaskerBloc>().processedWorkingHours),
          TodoTopSearchBar(
            focusNode: context.read<ToDoTaskerBloc>().searchFocusNode,
            controller: context.read<ToDoTaskerBloc>().searchController,
            onChanged: (value) => context.read<ToDoTaskerBloc>().add(ToDoTaskerSearchEvent(value)),
            onAdd: (details) => context.read<ToDoTaskerBloc>().add(ToDoTaskerOnAddToDoEvent(offset: details.globalPosition)),
            onMic: () => context.read<ToDoTaskerBloc>().add(ToDoTaskerOnMicEvent()),
          ),
        ],
      ),
    ),);
  }
}
