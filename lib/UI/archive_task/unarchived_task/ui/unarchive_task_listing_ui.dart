part of 'unarchive_task_main_ui.dart';

class UnarchiveTaskListingUI extends StatelessWidget {
  const UnarchiveTaskListingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnarchivedBloc, UnarchivedState>(
        builder: (context, state) {
          return ArchiveTaskListItem(
            archivedList: context.watch<UnarchivedBloc>().archivedList,
            archiveStatusEvent: (data)=> context.read<UnarchivedBloc>().add(ArchiveStatusEvent(data)),
            isSelectedAll: context.watch<UnarchivedBloc>().isSelectAll,
            selectedDateRange: context.watch<UnarchivedBloc>().selectedDateRange,
            selectedTask: context.watch<UnarchivedBloc>().selectedIds,
            selectAllEvent: ()=> context.read<UnarchivedBloc>().add(SelectAllEvent()),
            unArchiveEvent: ()=> context.read<UnarchivedBloc>().add(UnArchiveEvent()),
            onDateRangeSelected: (value)=> context.read<UnarchivedBloc>().add(DateRangePickerEvent(value)),
            title: 'ARCHIVE',
          );
          return Column(
            children: [
              Row(
                spacing: 20,
                children: [
                  Expanded(
                    child: DateRangePicker(
                      padding: 10.padding,
                      selectedDateRange: context.watch<UnarchivedBloc>().selectedDateRange,
                      onDateRangeSelected: (value)=> context.read<UnarchivedBloc>().add(DateRangePickerEvent(value)),),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CompactText(
                        "Selected: ${context.watch<UnarchivedBloc>().selectedIds.length}",
                        fontWeight: FontWeight.bold,
                      ),
                      CustomCheckboxListTile(
                        title: const Text('Select All'),
                        isCheckboxOnRight: true,
                        value: context.watch<UnarchivedBloc>().isSelectAll,
                        onChanged: (v)=> context.read<UnarchivedBloc>().add(SelectAllEvent()),
                        padding: 0.padding,
                        borderColor: AppC.appColor,
                        radius: 14.spMin,
                        useExpand: false,
                      )
                    ],
                  ),
                  if(context.watch<UnarchivedBloc>().selectedIds.isNotEmpty)
                    InkWell(
                        onTap: context.watch<UnarchivedBloc>().selectedIds.isNotEmpty ? ()=> context.read<UnarchivedBloc>().add(UnArchiveEvent()) : null,
                        child: const CompactText('UNARCHIVE', color: AppC.appColor, fontWeight: FontWeight.bold,))
                ],
              ),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => const Divider(height: 0.5),
                  itemCount: context.watch<UnarchivedBloc>().archivedList.length,
                  itemBuilder: (context, index) {
                    var item = context.watch<UnarchivedBloc>().archivedList[index];
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
                                            onChanged: (v)=> context.read<UnarchivedBloc>().add((ArchiveStatusEvent(item))),
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
