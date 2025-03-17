import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_events.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_states.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_bloc.dart';
import 'package:fairpytasker/Component/todo_task_item_card.dart';
import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class TaskerListingUi extends StatelessWidget {
  const TaskerListingUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToDoTaskerBloc, ToDoTaskerState>(
      builder: (context, state) => (context.watch<ToDoTaskerBloc>().toDos.isEmpty) ? const EmptyWidget() :  Expanded(
        child: ReorderableListView.builder(
          itemCount: context.watch<ToDoTaskerBloc>().toDos.length,
          itemBuilder: (context, index) {
            var model = context.read<ToDoTaskerBloc>().toDos[index];
            return TodoTaskItemCard(
              model: model,
              key: Key(model['id'].toString()),
              onTap: () => context.read<ToDoTaskerBloc>().add(ToDoTaskerEditEvent(model['id'].toString())),
              onVendorInfo: () => context.read<ToDoTaskerBloc>().add(ToDoTaskerVendorInfoEvent(model)),
              onNotes: (details) => context.read<ToDoTaskerBloc>().add(ToDoTaskerViewNotesEvent(model)),
              onVehicleOrPerson: (details) => context.read<ToDoTaskerBloc>().add(ToDoTaskerVehiclePersonTapEvent(model)),
              onComplete: () async {
                return false;
              },
              onPrevious: () async => false,
            );
          },
          onReorder: (oldIndex, newIndex) {},
        ),
      ),
    );
  }
}
