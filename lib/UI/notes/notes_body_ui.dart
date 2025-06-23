part of 'notes_main_ui.dart';

class NotesBodyUi extends StatelessWidget {
  const NotesBodyUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesStates>(
        builder: (context, state) => Column(
          children: [
            SearchWithStatusAddView(
              selectedDate: context.watch<NotesBloc>().selectedDate,
              controller: context.read<NotesBloc>().searchController,
              value: context.watch<NotesBloc>().showCompletedStates,
              onCurrentDay: () => context.read<NotesBloc>().add(NotesDatePickerEvent()),
              onAddPressed: () => context.read<NotesBloc>().add(NotesAddNewEvent()),
              onChanged: (value) => context.read<NotesBloc>().add(NotesFilterEvent(value)),
              onSearchChanged: (value) => context.read<NotesBloc>().add(NotesSearchEvent(value)),
            ),
            ((state is! NotesLoadingState) && (context.watch<NotesBloc>().apiResponse?.isEmpty ?? false)) ? const EmptyWidget() : Expanded(
              child: ReorderableListView.builder(
                key: UniqueKey(),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: 16.sp.horizontalPadding,
                itemBuilder: (context, index) {
                  var allData = context.read<NotesBloc>().apiResponse;
                  var model = allData?[index];
                  return NotesItemCard(
                      key: Key("${model?['id'] ?? 0}"),
                      model: model,
                      totalItems: allData,
                      onConfirmDismiss: (direction) async {
                        context.read<NotesBloc>().add((direction == DismissDirection.endToStart) ? NotesSwipeCompleteEvent(model) : NotesSwipeTomorrowEvent(model));
                        return true;
                      },
                      onTimePicker: (value) => context.read<NotesBloc>().add(TimePickerEvent(value)),
                      onNotesComplete: (mod, value) => context.read<NotesBloc>().add(NotesCheckTapEvent(mod, isAll: true, status: value)),
                      onTaskComplete: (mod, value) => context.read<NotesBloc>().add(NotesCheckTapEvent(mod, isAll: false, status: value)),
                      onAddNotesPressed: ()=> context.read<NotesBloc>().add(NotesAddTaskTapEvent(model)),
                      onEditTakPressed: (value)=> context.read<NotesBloc>().add(NotesEditTaskTapEvent(value)),
                      onSwapNoteItems: (value)=> context.read<NotesBloc>().add(NotesSwapNoteItemsEvent(value)),
                      onEditPressed: () => context.read<NotesBloc>().add(NotesEditEvent(model)),
                      onDeletePressed: () => context.read<NotesBloc>().add(NotesDeletePermissionEvent(model))

                  );
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
            )
          ],
        ));
  }
}
