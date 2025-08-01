import 'package:fairpytasker/Component/custom_checkbox.dart';
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/date_range_selection.dart';
import 'package:fairpytasker/UI/dialog/show_notes_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remixicon/remixicon.dart';

class ArchiveTaskListItem extends StatelessWidget {
  final dynamic selectedDateRange;
  final Function(dynamic date) onDateRangeSelected;
  final List<dynamic> selectedTask;
  final bool isSelectedAll;
  final void Function() selectAllEvent;
  final void Function() unArchiveEvent;
  final List<dynamic> archivedList;
  final void Function(dynamic data) archiveStatusEvent;
  final String title;
  final TextEditingController searchController;
  final void Function(dynamic query) onSearch;
  final Function() filterDialog;

  const ArchiveTaskListItem({super.key,
    required this.selectedDateRange,
    required this.onDateRangeSelected,
    required this.selectedTask,
    required this.isSelectedAll,
    required this.selectAllEvent,
    required this.unArchiveEvent,
    required this.archivedList,
    required this.archiveStatusEvent,
    required this.title,
    required this.searchController,
    required this.onSearch,
    required this.filterDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: 20,
          children: [
            Expanded(
              child: DateRangePicker(
                padding: 10.padding,
                selectedDateRange: selectedDateRange,
                onDateRangeSelected: (value)=> onDateRangeSelected(value),
            ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CompactText(
                  "Selected: ${selectedTask.length}",
                  fontWeight: FontWeight.bold,
                ),
                CustomCheckboxListTile(
                  title: const Text('Select All'),
                  isCheckboxOnRight: true,
                  value: isSelectedAll,
                  onChanged: (v)=> selectAllEvent(),
                  padding: 0.padding,
                  borderColor: AppC.appColor,
                  radius: 14.spMin,
                  useExpand: false,
                )
              ],
            ),
            if(selectedTask.isNotEmpty)
              InkWell(
                  onTap: ()=> unArchiveEvent(),
                  child: CompactText(title, color: AppC.appColor, fontWeight: FontWeight.bold,))
          ],
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: CompactSearchView(
                controller: searchController,
                onChanged: (value)=> onSearch(value),
              ),
            ),
            IconButton(onPressed: ()=> filterDialog(), icon: const Icon(Remix.filter_line,))
          ],
        ),
        archivedList.isEmpty ? const EmptyWidget():
        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (context, index) => const Divider(height: 0.5),
            itemCount: archivedList.length,
            itemBuilder: (context, index) {
              var item = archivedList[index];
              return SafeArea(
                minimum: 10.verticalPadding,
                child: Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CompactText(item['title'] ?? '', fontWeight: FontWeight.bold, color: AppC.appColor,overflow: TextOverflow.ellipsis,),
                            CompactText(
                              getIt<CommonService>().findVehicle(vin: item['vin'],vehicleLis: List.from(item['vehicles'] ?? []),
                              vehicleGroupId: item['vehicle_group_id'],),
                              overflow: TextOverflow.ellipsis,
                              fontWeight: getIt<CommonService>().findVehicle(vin: item['vin'],vehicleLis: List.from(item['vehicles'] ?? [])) == 'MV' ? FontWeight.w900 : FontWeight.normal,
                            ),
                              Row(
                                spacing: 5,
                                children: [
                                  if(item['lead_id'].toString().isNotNullOrEmpty || item['channel_id'].toString().isNotNullOrEmpty)
                                  CompactText(getIt<CommonService>().findLeadName(leadId: item?['lead_id'], channelId: item['channel_id'])),
                                  if(item['notes'].toString().isNotNullOrEmpty)
                                    Expanded(
                                        child: InkWell(
                                          onTap:()=> NotesDialog.show(context, message: item['notes'] ?? '',),
                                        child: CompactText("(${(item['notes'] ?? '').toString().replaceAll("\n", "")})", color: AppC.grey, overflow: TextOverflow.ellipsis, maxLines: 1,))),
                                ]),
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
                                    size:  Size.fromRadius(10.spMin),
                                    child:  Checkbox(
                                      activeColor: AppC.appColor,
                                      value: selectedTask.contains(item['id']),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      side: const BorderSide(width: 0.8, color: AppC.appColor),
                                      onChanged: (v)=> archiveStatusEvent(item),
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
}
