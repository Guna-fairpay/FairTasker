import 'package:fairpytasker/Component/compact_scroll_wrapper.dart';
import 'package:fairpytasker/Component/custom_loader.dart';
import 'package:fairpytasker/UI/dialog/show_notes_dialog.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_events.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_states.dart';
import 'package:fairpytasker/UI/tasker/bloc/tasker_todo_bloc.dart';
import 'package:fairpytasker/Component/todo_task_item_card.dart';
import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TaskerListingUi extends StatelessWidget {
  const TaskerListingUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToDoTaskerBloc, ToDoTaskerState>(
      builder: (context, state) => Expanded(
        child: RefreshIndicator(
            child: (context.watch<ToDoTaskerBloc>().toDos.isEmpty &&
                    (state is! ToDoTaskerLoadingState))
                ? EmptyWidget(withExpand: false, onRefresh: () => context.read<ToDoTaskerBloc>().add(ToDoTaskerRefreshEvent()))
                : ((!EasyLoading.isShow) && (state is ToDoTaskerLoadingState)) ? const CustomLoading() : CompactScrollWrapper(child: ReorderableListView.builder(
              scrollController: context.read<ToDoTaskerBloc>().scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: context.watch<ToDoTaskerBloc>().toDos.length,
              itemBuilder: (context, index) {
                var list = context.read<ToDoTaskerBloc>().toDos;
                var model = context.read<ToDoTaskerBloc>().toDos[index];
                var scrollId = Session.of.getInt("scrollToIndex");
                if ((scrollId != null) && (scrollId.toString().isNotNullOrEmpty)) {
                  var indexOfId = list.indexWhere((element) => element['id'].toString() == scrollId.toString());
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<ToDoTaskerBloc>().debounce.call(() => _scrollToIndex(indexOfId, context.read<ToDoTaskerBloc>().scrollController));
                });
                }
                return TodoTaskItemCard(
                  model: model,
                  key: Key(model['id'].toString()),
                  onTap: () => context
                      .read<ToDoTaskerBloc>()
                      .add(ToDoTaskerEditEvent(model['id'].toString(), model: model)),
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
                  onMore: (value) => NotesDialog.show(context, message: value),
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
            )),
            onRefresh: () async =>
                context.read<ToDoTaskerBloc>().add(ToDoTaskerRefreshEvent())),
      ),
    );
  }

  void _scrollToIndex(value, ScrollController? controller) {
    try {
      final position = value * 80.0;
      controller?.animateTo(
        position,
        duration: Durations.short4,
        curve: Curves.easeInOut,
      );
    } catch (e) {
      Console.of.error("Error", error: e);
    } finally {
      Future.delayed(Durations.extralong4, () => Session.of.remove("scrollToIndex"));
    }
  }
}
