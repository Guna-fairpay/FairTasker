part of 'notes_main_ui.dart';

class NotesBody extends StatelessWidget {
  const NotesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesStates>(
        builder: (context, state) => Expanded(
          child: AnimatedSwitcher(
              duration: Durations.long4,
              child: switch (context.watch<NotesBloc>().selectedPageIndex) {
                0 => const NotesBodyUi(),
                1 => const SharedNotesMainUI(),
                _ => Container(),
              }),
        ));
  }
}
