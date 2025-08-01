part of 'unarchive_task_main_ui.dart';

class UnarchiveTaskListingUI extends StatelessWidget {
  const UnarchiveTaskListingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnarchivedBloc, UnarchivedState>(
        builder: (context, state) {
          return ArchiveTaskListItem(
            archivedList: context.watch<UnarchivedBloc>().filteredList,
            archiveStatusEvent: (data)=> context.read<UnarchivedBloc>().add(ArchiveStatusEvent(data)),
            isSelectedAll: context.watch<UnarchivedBloc>().isSelectAll,
            selectedDateRange: context.watch<UnarchivedBloc>().selectedDateRange,
            selectedTask: context.watch<UnarchivedBloc>().selectedIds,
            selectAllEvent: ()=> context.read<UnarchivedBloc>().add(SelectAllEvent()),
            unArchiveEvent: ()=> context.read<UnarchivedBloc>().add(UnArchiveEvent()),
            onDateRangeSelected: (value)=> context.read<UnarchivedBloc>().add(DateRangePickerEvent(value)),
            title: 'ARCHIVE',
            searchController: context.read<UnarchivedBloc>().searchController,
            onSearch: (query)=> context.read<UnarchivedBloc>().add(SearchEvent(query)),
            filterDialog: ()=> TaskFilterDialogView.show(context,
              isAll: context.read<UnarchivedBloc>().isTaskAll,
              onChanged: (v)=> context.read<UnarchivedBloc>().add(TaskFilterEvent(v)),
              taskFilterList: context.read<UnarchivedBloc>().taskFilterList,
            ),
          );
        }
    );
  }
}
