part of 'archived_task_main_ui.dart';

class ArchivedTaskListingUI extends StatelessWidget {
  const ArchivedTaskListingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArchivedBloc, ArchivedState>(
      builder: (context, state) {
        return ArchiveTaskListItem(
          archivedList: context.watch<ArchivedBloc>().archivedList,
          archiveStatusEvent: (data)=> context.read<ArchivedBloc>().add(ArchiveStatusEvent(data)),
          isSelectedAll: context.watch<ArchivedBloc>().isSelectAll,
          selectedDateRange: context.watch<ArchivedBloc>().selectedDateRange,
          selectedTask: context.watch<ArchivedBloc>().selectedIds,
          selectAllEvent: ()=> context.read<ArchivedBloc>().add(SelectAllEvent()),
          unArchiveEvent: ()=> context.read<ArchivedBloc>().add(UnArchiveEvent()),
          onDateRangeSelected: (value)=> context.read<ArchivedBloc>().add(DateRangePickerEvent(value)),
          title: 'UNARCHIVE',
        );
      }
    );
  }
}
