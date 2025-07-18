import 'package:fairpytasker/Component/custom_checkbox.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/date_range_selection.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                            //if((item['vin'].toString().isNotNullOrEmpty) || List.from(item['vehicles'] ?? []).isNotEmpty)
                            CompactText(getIt<CommonService>().findVehicle(vin: item['vin'],vehicleLis: List.from(item['vehicles'] ?? []), vehicleGroupId: item['vehicle_group_id'],),overflow: TextOverflow.ellipsis,),
                              Row(
                                spacing: 5,
                                children: [
                                  if(item['lead_id'].toString().isNotNullOrEmpty || item['channel_id'].toString().isNotNullOrEmpty)
                                  CompactText(getIt<CommonService>().findLeadName(leadId: item?['lead_id'], channelId: item['channel_id'])),
                                  if(item['notes'].toString().isNotNullOrEmpty)
                                    Expanded(child: CompactText("(${(item['notes'] ?? '').toString().replaceAll("\n", "")})", color: AppC.grey, overflow: TextOverflow.ellipsis, maxLines: 1,)),
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
                                      value: item['isChecked'] == 1,
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
