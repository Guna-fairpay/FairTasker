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
        return Column(
          children: [
            Row(
              spacing: 20,
              children: [
                Expanded(
                  child: DateRangePicker(
                      padding: 10.padding,
                      selectedDateRange: context.watch<ArchivedBloc>().selectedDateRange,
                      onDateRangeSelected: (value)=> context.read<ArchivedBloc>().add(DateRangePickerEvent(value)),),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     CompactText(
                      "Selected: ${context.watch<ArchivedBloc>().selectedIds.length}",
                      fontWeight: FontWeight.bold,
                    ),
                    CustomCheckboxListTile(
                      title: const Text('Select All'),
                      isCheckboxOnRight: true,
                      value: context.watch<ArchivedBloc>().isSelectAll,
                      onChanged: (v)=> context.read<ArchivedBloc>().add(SelectAllEvent()),
                      padding: 0.padding,
                      borderColor: AppC.appColor,
                      radius: 14.spMin,
                      useExpand: false,
                    )
                  ],
                ),
                if(context.watch<ArchivedBloc>().selectedIds.isNotEmpty)
                InkWell(
                  onTap: context.watch<ArchivedBloc>().selectedIds.isNotEmpty ? ()=> context.read<ArchivedBloc>().add(UnArchiveEvent()) : null,
                    child: const CompactText('UNARCHIVE', color: AppC.appColor, fontWeight: FontWeight.bold,))
              ],
            ),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (context, index) => const Divider(height: 0.5),
                itemCount: context.watch<ArchivedBloc>().archivedList.length,
                itemBuilder: (context, index) {
                  var item = context.watch<ArchivedBloc>().archivedList[index];
                  return SafeArea(
                    minimum: 10.verticalPadding,
                    child: Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CompactText(item['title'] ?? '', fontWeight: FontWeight.bold, color: AppC.appColor,overflow: TextOverflow.ellipsis,),
                                CompactText(getIt<CommonService>().findVehicle(vin: item['vin'],vehicleLis: List.from(item['vehicles'] ?? []), vehicleGroupId: item['vehicle_group_id'],),overflow: TextOverflow.ellipsis,),
                                if (item['notes'].toString().isNotNullOrEmpty)
                                InkWell(
                                  onTap: ()=> NotesDialog.show(context, message: item['notes']),
                                    child: CompactText("(${(item['notes'] ?? '').toString().replaceAll("\n", "")})", color: AppC.grey, overflow: TextOverflow.ellipsis, maxLines: 1,)),
                              ]),
                        ),
                        Expanded(
                          child: Column(
                              spacing: 5,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text.rich(TextSpan(
                                  children: [
                                    TextSpan(
                                      text: item?['todo_date'].toString().toFormat(format: "MM-yy") ?? "",
                                    ),
                                    WidgetSpan(child: 5.width),
                                    TextSpan(
                                      text: item?['todo_time'].toString().toFormat(inputFormat: 'HH:mm:ss', format: "hh:mm a") ?? "",
                                    )
                                  ],
                                )),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  spacing: 10,
                                  children: [
                                    Flexible(child: CompactText(getIt<CommonService>().findUsersAsString(userGroupId: item?['user_group_id'].toString().toNumeric.toInt(), userId: item?['user_id'].toString().toNumeric.toInt()), fontWeight: FontWeight.bold, color: AppC.black, overflow: TextOverflow.ellipsis,)),
                                    FittedBox(
                                      child: SizedBox.fromSize(
                                        size:  Size.fromRadius(14.spMin),
                                        child:  Checkbox(
                                          activeColor: AppC.appColor,
                                          value: item['isChecked'] == 1,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          side: const BorderSide(width: 0.8, color: AppC.appColor),
                                          onChanged: (v)=> context.read<ArchivedBloc>().add((ArchiveStatusEvent(item))),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        );
      }
    );
  }
}
