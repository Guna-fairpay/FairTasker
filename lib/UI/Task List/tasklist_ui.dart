
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:date_time/date_time.dart' hide DateRange;
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Component/custom_checkbox.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/date_range_selection.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:fairpytasker/UI/Task%20List/tasklist_bloc.dart';
import 'package:fairpytasker/UI/Task%20List/tasklist_event.dart';
import 'package:fairpytasker/UI/Task%20List/tasklist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Utilities/Utils.dart';
import '../../Utilities/appC.dart';
import 'Popup/text_Popup.dart';

class TasklistUi extends StatelessWidget {
  DateRange? selectedDateRange;
  TasklistUi({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) =>
    TaskListBloc()..add(TaskListInitial(
      selectedDateRange?.start.toString() ?? DateTime.now().subtract(const Duration(days: 7)).toString(),
      selectedDateRange?.end.toString() ?? DateTime.now().toString(),
    )),
    child: BlocListener<TaskListBloc, TaskListState>(listener: (context, state){
      if(state.isLoading){
        EasyLoading.show();
      } else {
        if (EasyLoading.isShow) EasyLoading.dismiss();
      }
    },
      child: BlocBuilder<TaskListBloc, TaskListState>(
        builder: (context, state) {
          return
            Scaffold(
              backgroundColor: Colors.white,
              appBar:
              AppBar(
                automaticallyImplyLeading: false,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                leadingWidth: 0,
                backgroundColor: AppC.appColor,
                title: const Text("Task List"),
                foregroundColor: AppC.white,
                actions: [
                  IconButton(onPressed: context.pop, icon: const Icon(Icons.close_rounded))
                ],
              ),
              body:
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 16.0),
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Row(
                        children: [
                          Expanded(
                            child:
                            DateRangePicker(
                              selectedDateRange: state.selectedDateRange,
                              onDateRangeSelected: (range) {
                                Console.of.log("DATE_RANGE ${range}");
                                context.read<TaskListBloc>().add(
                                    UpdateDateRangeEvent(selectedRange: range));

                                String startDate = range.start.toString();
                                String endDate = range.end.toString();

                                context.read<TaskListBloc>().add(
                                    TaskListInitial(
                                        startDate, endDate));
                              },
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child:
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomCheckboxListTile(title: Text("Hide Support"), value:  state.hideSupport,
                                  padding: 0.padding,
                                    onChanged: (bool? value){
                                      context.read<TaskListBloc>().add(HideSupportEvent(
                                        value: value ?? false,

                                      ));

                                    },),
                                CustomCheckboxListTile(title: Text("Extra Hours"), value:  state.extraHours,
                                  mainAxisSize: MainAxisSize.min,
                                  padding: 0.padding,
                                  onChanged: (bool? value){
                                    context.read<TaskListBloc>().add(ExtraHoursEvent(
                                      value: value ?? false,
                                    ));
                                  },),
                              ],
                            ),
                          ),
                          PopupMenuButton<int>(
                            elevation: 3,
                            padding: EdgeInsets.zero,
                            color: Colors.white,
                            onSelected: (int selectedValue) {
                              if (selectedValue == 1) {
                                context.read<TaskListBloc>().isAscending = !context.read<TaskListBloc>().isAscending;
                                context.read<TaskListBloc>().add(TaskIncompleteEvent(value: context.read<TaskListBloc>().isAscending
                                ));
                              } else if (selectedValue == 2) {
                                context.read<TaskListBloc>().offShore = !context.read<TaskListBloc>().offShore;
                                context.read<TaskListBloc>().add(OffShoreTeamEvent(value: context.read<TaskListBloc>().offShore
                                ));
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                value: 1,
                                child: Row(
                                  children: [
                                    Icon(
                                      state.isAscending
                                          ? Icons.arrow_upward
                                          : Icons.arrow_downward,
                                      size: 15,
                                      color: state.isAscending ? Colors.green : Colors.red,
                                    ),
                                    Utils.getText('Task InCompleted',
                                        weight: FontWeight.bold),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Row(
                                  children: [
                                    Icon(
                                      state.offShore
                                          ? Icons.arrow_upward
                                          : Icons.arrow_downward,
                                      size: 15,
                                      color: state.offShore ? Colors.green : Colors.red,
                                    ),
                                    Utils.getText('Offshore Team',
                                        weight: FontWeight.bold),
                                  ],
                                ),
                              ),
                            ],
                            icon: const Icon(
                              Icons.filter_alt_outlined,
                              color: AppC.appColor,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Expanded(
                        child:
                        ListView.separated(
                          itemCount: state.data.length,
                          itemBuilder: (context, index) {
                            final taskList = state.data[index];
                            final isApproved = taskList['complete_time_approved'] == 1;
                            final textColor = isApproved ? AppC.appColor : !isApproved && taskList['time_taken'] != "" ? AppC.red : AppC.appColor;
                            return
                              Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                color: AppC.white,
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Utils.getText(
                                          "${taskList['title']} ",
                                          color: textColor,
                                          weight: FontWeight.bold,
                                        ),
                                        Expanded(
                                          child: (taskList['complete_time_taken'] != '' &&
                                              taskList['complete_time_taken'] != null)
                                              ? Utils.getText(
                                            "(${taskList['complete_time_taken']})",
                                            color: textColor,
                                            weight: FontWeight.bold,
                                          )
                                              : const Text(""),
                                        ),
                                        Utils.getText(
                                          taskList['todo_date']?.substring(5) ?? '',
                                          color: textColor,
                                        ),
                                        const SizedBox(width: 5),
                                        Utils.getText(
                                          taskList['todo_time'].toString()
                                              .toDateTime(inputFormat: "HH:mm:ss")
                                              .toFormat(format: "hh:mm a")
                                              .toString(),
                                          color: textColor,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text.rich(TextSpan(
                                            children: [
                                              TextSpan(text: (taskList['vehicles'] != null &&
                                                  taskList['vehicles'] is List &&
                                                  taskList['vehicles'].isNotEmpty)
                                                  ? (taskList['vehicles'].length >= 2
                                                  ? "MV"
                                                  : (taskList['vehicles'][0]['vehicle_name'] ?? ''))
                                                  : taskList['vehicle_name'] ??
                                                  state.groupVehicle.firstWhereOrNull(
                                                          (element) => element['id'] == taskList['vehicle_group_id']
                                                  )?['name'] ?? taskList['person'] ?? '',),
                                              if(taskList['rental_status'] !=null && taskList['rental_status_color'] != null)
                                                ...[
                                                  WidgetSpan(child: 10.width),
                                                  TextSpan(text: "${taskList['rental_status'] ?? ""}", style: context.textTheme.labelMedium?.copyWith(color: taskList['rental_status_color']))
                                                ]
                                            ]
                                          ), style: context.textTheme.labelMedium?.copyWith(fontSize: 12.sp, fontWeight: (taskList['vehicles'] != null &&
                                              taskList['vehicles'].length >= 2)
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          overflow: TextOverflow.ellipsis),),
                                        ),
                                        /*Expanded(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Utils.getText(
                                                  (taskList['vehicles'] != null &&
                                                      taskList['vehicles'] is List &&
                                                      taskList['vehicles'].isNotEmpty)
                                                      ? (taskList['vehicles'].length >= 2
                                                      ? "MV"
                                                      : (taskList['vehicles'][0]['vehicle_name'] ?? ''))
                                                      : taskList['vehicle_name'] ??
                                                      state.groupVehicle.firstWhereOrNull(
                                                              (element) => element['id'] == taskList['vehicle_group_id']
                                                      )?['name'] ?? '',
                                                  size: 12,
                                                  weight: (taskList['vehicles'] != null &&
                                                      taskList['vehicles'].length >= 2)
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  overFlow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              if(taskList['rental_status'] !=null && taskList['rental_status_color'] != null)
                                                Expanded(child: Utils.getText("${taskList['rental_status'] ?? ""}", color: taskList['rental_status_color'] ?? '')),
                                            ],
                                          ),
                                        ),*/
                                        const SizedBox(width: 5),
                                        Utils.getText("${taskList['usersName'] ?? ""}",overFlow: TextOverflow.ellipsis),
                                        const SizedBox(width: 5),
                                        SizedBox(
                                          height: 15,
                                          child: Checkbox(
                                            value: isApproved,
                                            onChanged: (bool? value) {
                                              context.read<TaskListBloc>().add(
                                                individualCheckEvent(
                                                  value: value ?? false,
                                                  id: taskList['id'],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          //if (taskList["overtime"] != null && taskList["overtime"] != '')
                                          if(taskList["time_taken"] != null && taskList["time_taken"] != '')...[
                                            Utils.getText(
                                              "${taskList["time_taken"]} - ",
                                              color: AppC.red,
                                              weight: FontWeight.bold,
                                            ),
                                          ] else...[
                                            Utils.getText(
                                              "",
                                              color: textColor,
                                              weight: FontWeight.bold,
                                            ),
                                          ],
                                          if (taskList["notes_complete"] != null &&
                                              taskList["notes_complete"] != '')
                                            Expanded(
                                              child: taskList["notes_complete"].length > 17
                                                  ? GestureDetector(
                                                onTap: () {
                                                  TextPopupTask.show(
                                                    context,
                                                    taskList["notes_complete"],
                                                  );
                                                },
                                                child: Utils.getText(
                                                  "${taskList["notes_complete"].substring(0, 12)}...",
                                                  color: AppC.appColor,
                                                ),
                                              )
                                                  : Utils.getText(
                                                taskList["notes_complete"],
                                                color: AppC.appColor,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                ),
                              );
                          },
                          separatorBuilder: (context, index) => const SizedBox(height: 5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
        }
      ),
    ),
    );
  }
}
