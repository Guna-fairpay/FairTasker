part of 'shared_notes_main_ui.dart';

class SharedNotesHeaderUI extends StatelessWidget {
  const SharedNotesHeaderUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SharedNotesBloc, SharedNotesState>(
      builder: (context, state) {
        return Column(
          children: [
            SearchWithStatusAddView(
              selectedDate: context.watch<SharedNotesBloc>().selectedDate,
              controller: context.read<SharedNotesBloc>().searchController,
              onSearchChanged: (v)=> context.read<SharedNotesBloc>().add(SearchEvent(v)),
              onCurrentDay: ()=> context.read<SharedNotesBloc>().add(DatePickerEvent()),
            ),
          ],
        );
      }
    );
  }
}
