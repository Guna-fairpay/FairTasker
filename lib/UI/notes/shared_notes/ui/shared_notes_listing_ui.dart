part of 'shared_notes_main_ui.dart';

class SharedNotesListingUI extends StatelessWidget {
  const SharedNotesListingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SharedNotesBloc, SharedNotesState>(
      builder: (context, state) => Expanded(
        child: Column(
          children: [
            ((state is! LoadingState) && (context.watch<SharedNotesBloc>().apiResponse?.isEmpty ?? false))
                ? const EmptyWidget()
                : Expanded(
              child: ReorderableListView.builder(
                key: UniqueKey(),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: 10.sp.horizontalPadding,
                itemBuilder: (context, index) {
                  var allData = context.read<SharedNotesBloc>().apiResponse;
                  var model = allData?[index];
                  return NotesItemCard(
                    isSharedNotes: true,
                      key: Key("${model?['id'] ?? 0}"),
                      model: model,
                      totalItems: allData,
                      onConfirmDismiss: (direction) async {
                        context.read<SharedNotesBloc>().add((direction == DismissDirection.endToStart) ? MoveCompleteEvent(model) : MoveTomorrowEvent(model));
                        return true;
                      },
                      onAddNotesPressed: ()=> context.read<SharedNotesBloc>().add(AddTaskTapEvent(list: allData)),
                       onNotesComplete: (mod, value) => context.read<SharedNotesBloc>().add(CheckAllDialogEvent(mod, isAll: true, status: value)),
                       onTaskComplete: (mod, value) => context.read<SharedNotesBloc>().add(CheckAllEvent(mod, isAll: false, status: value)),
                       onSwapNoteItems: (value)=> context.read<SharedNotesBloc>().add(SwapNoteItemsEvent(value)),
                       onEditTakPressed: (value)=> context.read<SharedNotesBloc>().add(EditTaskTapEvent(data: value, list: allData)),
                       onEditPressed: () => context.push(EditShareNotesMainUI(data: model,)),
                       onDeletePressed: () => context
                          .read<SharedNotesBloc>()
                          .add(DeletePermissionEvent(model))
                  );
                },
                itemCount: context.watch<SharedNotesBloc>().apiResponse?.length ?? 0,
                onReorder: (oldIndex, newIndex) {
                  var list = context.read<SharedNotesBloc>().apiResponse;
                  Console.of.log("Index $newIndex $oldIndex");
                  var nIndex = newIndex > ((list?.length ?? 0) - 1) ? newIndex - 1 : newIndex;
                  var newModel = list?[nIndex];
                  var oldModel = list?[oldIndex];
                  var body = {
                    "items" : [
                      {"id": oldModel?['id'], "products_index": nIndex},
                      {"id": newModel?['id'], "products_index": oldIndex},
                    ]
                  };
                  Console.of.log("Body $body");
                  context.read<SharedNotesBloc>().add(SwapProducts(body));
                },
              ),
            )
          ],
        ),
      ),);
  }
}
