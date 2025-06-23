part of 'notes_main_ui.dart';

class NotesHeader extends StatelessWidget {
  const NotesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesStates>(builder: (context, state) => Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppC.borderColor)
        )
      ),
      child: Row(
        children: [
          CustomTabButton<int>(buttonText: "My Notes", value: 0, selectedValue: context.watch<NotesBloc>().selectedPageIndex, onPressed: (val) => context.read<NotesBloc>().add(ViewTabEvent(val))),
          CustomTabButton<int>(buttonText: "Shared Notes", value: 1, selectedValue: context.watch<NotesBloc>().selectedPageIndex, onPressed: (val) => context.read<NotesBloc>().add(ViewTabEvent(val))),
        ],
      ),
    ));
  }
}
