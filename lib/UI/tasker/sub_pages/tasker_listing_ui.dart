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
      builder: (context, state) => Expanded(
        child: RefreshIndicator(
            child: (context.watch<ToDoTaskerBloc>().toDos.isEmpty &&
                    (state is! ToDoTaskerLoadingState))
                ? const EmptyWidget(withExpand: false)
                : ReorderableListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: context.watch<ToDoTaskerBloc>().toDos.length,
                itemBuilder: (context, index) {
                  var model = context.read<ToDoTaskerBloc>().toDos[index];
                  return TodoTaskItemCard(
                    model: model,
                    key: Key(model['id'].toString()),
                    onTap: () => context
                        .read<ToDoTaskerBloc>()
                        .add(ToDoTaskerEditEvent(model['id'].toString())),
                    onVendorInfo: () => context
                        .read<ToDoTaskerBloc>()
                        .add(ToDoTaskerVendorInfoEvent(model)),
                    onNotes: (details) => context
                        .read<ToDoTaskerBloc>()
                        .add(ToDoTaskerViewNotesEvent(model)),
                    onVehicleOrPerson: (details) => context
                        .read<ToDoTaskerBloc>()
                        .add(ToDoTaskerVehiclePersonTapEvent(model)),
                    onResource: (details) => context
                        .read<ToDoTaskerBloc>()
                        .add(ToDoTaskerResourceTapEvent(model)),
                    onAddress: (details) => context
                        .read<ToDoTaskerBloc>()
                        .add(ToDoTaskerAddressTapEvent(model)),
                    onParts: (details) => context
                        .read<ToDoTaskerBloc>()
                        .add(ToDoTaskerPartsTapEvent(model)),
                    onSupplies: (details) => context
                        .read<ToDoTaskerBloc>()
                        .add(ToDoTaskerSuppliesTapEvent(model)),
                    onComplete: () async {
                      context
                          .read<ToDoTaskerBloc>()
                          .add(ToDoTaskerCompleteEvent(model));
                      return false;
                    },
                    onPrevious: () async {
                      context
                          .read<ToDoTaskerBloc>()
                          .add(ToDoTaskerPreviousEvent(model));
                      return false;
                    },
                    onInProgress: () async {
                      context
                          .read<ToDoTaskerBloc>()
                          .add(ToDoTaskerUndoCompleteEvent(model));
                      return false;
                    },
                    onDateChange: () => context
                        .read<ToDoTaskerBloc>()
                        .add(ToDoTaskerDateChangeTapEvent(model)),
                    onCompletedTimeChange: () => context
                        .read<ToDoTaskerBloc>()
                        .add(ToDoTaskerCompletedTimeTapEvent(model)),
                    onTimeChange: () => context
                        .read<ToDoTaskerBloc>()
                        .add(ToDoTaskerTimePickerTapEvent(model)),
                    onVendorOrLocation: (details) => context
                        .read<ToDoTaskerBloc>()
                        .add(ToDoTaskerVendorLocationTapEvent(model)),
                    onVehicleGroup: (details) => context
                        .read<ToDoTaskerBloc>()
                        .add(ToDoTaskerVehicleGroupTapEvent(model)),
                    onVehicleHistory: () => context
                        .read<ToDoTaskerBloc>()
                        .add(ToDoTaskerVehicleHistoryTapEvent(model)),
                    onPlateNumTap: () => context
                        .read<ToDoTaskerBloc>()
                        .add(ToDoTaskerViewVehicleEvent(model)),
                    onCustomLink: () => context
                        .read<ToDoTaskerBloc>()
                        .add(ToDoTaskerViewCustomLinkEvent(model)),
                    onViewAttachment: () => context
                        .read<ToDoTaskerBloc>()
                        .add(ToDoTaskerViewAttachmentEvent(model)),
                    onReasonAttachmentView: () => context
                        .read<ToDoTaskerBloc>()
                        .add(ToDoTaskerViewReasonAttachmentEvent(model)),
                    onBouncie: () => context
                        .read<ToDoTaskerBloc>()
                        .add(ToDoTaskerViewBouncieEvent(model)),
                  );
                },
                onReorder: (oldIndex, newIndex) {
                  var currentTask =
                      context.read<ToDoTaskerBloc>().toDos[oldIndex];
                  var newTask =
                      context.read<ToDoTaskerBloc>().toDos[newIndex];
                  context.read<ToDoTaskerBloc>().add(ToDoTaskerSwapTaskEvent(
                      currentTask['id'], newTask['id']));
                },
                                ),
            onRefresh: () async =>
                context.read<ToDoTaskerBloc>().add(ToDoTaskerRefreshEvent())),
      ),
    );
  }
}
