import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:fairpytasker/UI/notes/bloc/notes_events.dart';
import 'package:fairpytasker/UI/notes/bloc/notes_states.dart';
import 'package:fairpytasker/Component/notes_item_card.dart';
import 'package:fairpytasker/UI/notes/bloc/notes_bloc.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class NotesBodyUi extends StatelessWidget {
  const NotesBodyUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesStates>(
        builder: (context, state) => ((state is! NotesLoadingState) && (context.watch<NotesBloc>().apiResponse?.isEmpty ?? false)) ? const EmptyWidget() : Expanded(
              child: ReorderableListView.builder(
                key: UniqueKey(),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  var model = context.read<NotesBloc>().apiResponse?[index];
                  return NotesItemCard(
                    key: Key("${model?['id'] ?? 0}"),
                      model: model,
                      onConfirmDismiss: (direction) async {
                      context.read<NotesBloc>().add((direction == DismissDirection.endToStart) ? NotesSwipeCompleteEvent(model) : NotesSwipeTomorrowEvent(model));
                      return true;
                      },
                      onNotesComplete: (mod, value) => context.read<NotesBloc>().add(NotesCheckTapEvent(mod, isAll: true, status: value)),
                      onTaskComplete: (mod, value) => context.read<NotesBloc>().add(NotesCheckTapEvent(mod, isAll: false, status: value)),
                      onAddNotesPressed: ()=> context.read<NotesBloc>().add(NotesAddTaskTapEvent(model)),
                      onEditTakPressed: (value)=> context.read<NotesBloc>().add(NotesEditTaskTapEvent(value)),
                      onSwapNoteItems: (value)=> context.read<NotesBloc>().add(NotesSwapNoteItemsEvent(value)),
                      onEditPressed: () =>
                          context.read<NotesBloc>().add(NotesEditEvent(model)),
                      onDeletePressed: () => context
                          .read<NotesBloc>()
                          .add(NotesDeletePermissionEvent(model)));
                },
                itemCount: context.watch<NotesBloc>().apiResponse?.length ?? 0,
                onReorder: (oldIndex, newIndex) {
                  var list = context.read<NotesBloc>().apiResponse;
                  Console.of.log("Index $newIndex $oldIndex");
                  var nIndex = newIndex > ((list?.length ?? 0) - 1) ? newIndex - 1 : newIndex;
                  var newModel = list?[nIndex];
                  var oldModel = list?[oldIndex];
                  var body = {
                    "items" : [
                      {"id": oldModel?['id'], "notes_index": nIndex},
                      {"id": newModel?['id'], "notes_index": oldIndex},
                    ]
                  };
                  Console.of.log("Body $body");
                  context.read<NotesBloc>().add(NotesSwapNoteEvent(body));
                },
              ),
            ));
  }
}
