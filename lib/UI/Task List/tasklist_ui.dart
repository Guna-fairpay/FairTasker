
import 'dart:developer';

import 'package:date_time/date_time.dart' hide DateRange;
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:fairpytasker/UI/Task%20List/tasklist_bloc.dart';
import 'package:fairpytasker/UI/Task%20List/tasklist_event.dart';
import 'package:fairpytasker/UI/Task%20List/tasklist_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import '../../Component/header.dart';
import '../../Utilities/Utils.dart';
import '../../Utilities/appC.dart';
import '../../Utilities/num.dart';
import 'Popup/text_Popup.dart';

class TasklistUi extends StatelessWidget {
  DateRange? selectedDateRange;
  TasklistUi({super.key});


  String formatTimeToAmPm(String? time) {
    if (time == null || time.isEmpty) {
      return '';
    }
    try {
      DateTime dateTime = DateFormat('HH:mm').parse(time);
      return DateFormat('h:mm a').format(dateTime);
    } catch (e) {
      return time;
    }
  }

  // List<String> getUserInitials(
  //     int groupId,
  //     List<Map<String, dynamic>> groupList,
  //     List<Map<String, dynamic>> resource,
  //     )
  // {
  //   log("groupId---->$groupId");
  //   List<String> userInitials = [];
  //
  //   // Find matching group
  //   final matchingGroup = groupList.firstWhere(
  //         (item) => item['id'] == groupId,
  //     orElse: () => {'userId': []},
  //   );
  //   log("matchingGroup---->$matchingGroup");
  //
  //   // Extract ID
  //   var userIdData = matchingGroup['userId'];
  //   log("userIdData---->$userIdData");
  //
  //   List<int> userIds;
  //   if (userIdData is List) {
  //     userIds = userIdData.whereType<int>().toList();
  //     if (userIds.isEmpty) {
  //       userIds = userIdData
  //           .map((e) => int.tryParse(e.toString().trim()) ?? 0)
  //           .where((e) => e != 0)
  //           .toList();
  //     }
  //   } else if (userIdData is String) {
  //     userIds = userIdData
  //         .split(',')
  //         .map((e) => int.tryParse(e.trim()) ?? 0)
  //         .where((e) => e != 0)
  //         .toList();
  //   } else {
  //     userIds = [];
  //   }
  //   log("userIds---->$userIds");
  //
  //   for (int userId in userIds) {
  //     Map<String, dynamic>? user = resource.firstWhere(
  //           (res) => res['id'] == userId,
  //       orElse: () => {},
  //     );
  //
  //     if (user.isNotEmpty) {
  //       String firstInitial = user['first_name']?.isNotEmpty == true ? user['first_name'][0] : "";
  //       String lastInitial = user['last_name']?.isNotEmpty == true ? user['last_name'][0] : "";
  //       userInitials.add("$firstInitial$lastInitial");
  //     }
  //   }
  //   log("userInitials---->$userInitials");
  //   return userInitials;
  // }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    selectedDateRange = DateRange(
      now.subtract(const Duration(days: 7)),
      now,
    );
    bool isAscending = true;
    bool offShore = true;
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
              appBar: const PreferredSize(
              preferredSize: Size.fromHeight(35.0),
              child: HeaderView(),
              ),
              body:
              Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'Task List',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child:
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DateRangeField(
                                decoration: const InputDecoration(
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                                ),
                                childBuilder: (context, value){
                                  return Row(
                                      children: [
                                        Expanded(child: Utils.getText("${selectedDateRange}",overFlow: TextOverflow.ellipsis,)),
                                      ]
                                  );
                                },
                                selectedDateRange: selectedDateRange,
                                onDateRangeSelected: (DateRange? value) {
                                    selectedDateRange = value;
                                    String startDate =
                                    selectedDateRange!.start.toString();
                                    String endDate =
                                    selectedDateRange!.end.toString();
                                    context.read<TaskListBloc>().add(TaskListInitial(startDate, endDate));
                                },
                                pickerBuilder: datePickerBuilder,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 15,
                                  child: Checkbox(
                                    value: state.hideSupport,
                                    onChanged: (bool? value) {
                                      context.read<TaskListBloc>().add(HideSupportEvent(
                                        value: value ?? false,
                                      ));
                                    },
                                  ),
                                ),
                                Utils.getText('Hide Support'),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: 15,
                                  child: Checkbox(
                                    value: state.extraHours,
                                    onChanged: (bool? value) {
                                      context.read<TaskListBloc>().add(ExtraHoursEvent(
                                        value: value ?? false,
                                      ));
                                    },
                                  ),
                                ),
                                Utils.getText('Extra Hours'),
                              ],
                            ),
                          ],
                        ),
                        PopupMenuButton<int>(
                          elevation: 3,
                          padding: EdgeInsets.zero,
                          color: Colors.white,
                          onSelected: (int selectedValue) {
                            if (selectedValue == 1) {
                              isAscending = !isAscending;
                              context.read<TaskListBloc>().add(TaskIncompleteEvent(value: isAscending
                              ));
                            } else if (selectedValue == 2) {
                              offShore = !offShore;
                              context.read<TaskListBloc>().add(OffShoreTeamEvent(value: offShore
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
                            Icons.filter_alt_sharp,
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
                          bool isChecked = taskList['complete_time_approved'] == 1;
                          return
                            Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              color: AppC.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Utils.getText(
                                            "${taskList['title'] ?? ''} ",
                                            color: !isChecked
                                                ? AppC.red
                                                : AppC.appColor,
                                            weight: FontWeight.bold),
                                        Expanded(
                                          child: (taskList[
                                          'complete_time_taken'] !=
                                              '' &&
                                              taskList[
                                              'complete_time_taken'] !=
                                                  null)
                                              ? Utils.getText(
                                              "(${taskList['complete_time_taken']})",
                                              color: !isChecked
                                                  ? AppC.red
                                                  : AppC.appColor,
                                              weight: FontWeight.bold)
                                              : const Text(""),
                                        ),
                                        Utils.getText(
                                            taskList['todo_date']?.substring(5) ??
                                                '',
                                            color: !isChecked
                                                ? AppC.red
                                                : AppC.appColor),
                                        const SizedBox(width: 5),
                                        Utils.getText(
                                            formatTimeToAmPm(
                                                taskList['todo_time']),
                                            color: !isChecked
                                                ? AppC.red
                                                : AppC.appColor),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                            child:
                                            Utils.getText(
                                              (taskList['vehicles'] != null && taskList['vehicles'] is List && taskList['vehicles'].isNotEmpty)
                                                  ? (taskList['vehicles'].length >= 2
                                                  ? "MV"
                                                  : (taskList['vehicles'][0]['vehicle_name'] ?? '')
                                              )
                                                  : '',
                                              size: 12,
                                              weight: (taskList['vehicles'] != null && taskList['vehicles'].length >= 2)
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),

                                        ),
                                          const SizedBox(width: 5),
                                        Utils.getText("${taskList?['usersName'] ?? ""}"),
                                          const SizedBox(width: 5),
                                          SizedBox(
                                          height: 15,
                                          child: Checkbox(
                                            value: isChecked,
                                            onChanged: (bool? value) {
                                              context.read<TaskListBloc>().add(individualCheckEvent(
                                                  value: value?? false,
                                                  id: taskList['id'],
                                              ));
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          if (taskList["overtime"] != null && taskList["overtime"] != '')
                                            Utils.getText(
                                              "${taskList["overtime"]} - ",
                                              color: !isChecked
                                                  ? AppC.red
                                                  : AppC.appColor,
                                              weight: FontWeight.bold,
                                            ),
                                          if (taskList["notes_complete"] != null && taskList["notes_complete"] != '')
                                            Expanded(
                                              child: taskList["notes_complete"].length > 17 ? GestureDetector(
                                                onTap: () {
                                                  TextPopupTask.show(
                                                      context,
                                                      taskList["notes_complete"]);
                                                },
                                                child: Utils.getText(
                                                    "${taskList["notes_complete"].substring(0, 12)}..."),
                                              )
                                                  : Utils.getText(
                                                  taskList["notes_complete"]),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),),
                            );
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 5,),
                      ),
                    ),
                  ],
                ),
              ),
            );
        }
      ),
    ),
    );
  }
  Widget datePickerBuilder(
      BuildContext context, dynamic Function(DateRange?) onDateRangeChanged,
      [bool doubleMonth = false]) {
    return DateRangePickerWidget(
      doubleMonth: doubleMonth,
      initialDateRange: selectedDateRange,
      initialDisplayedDate: selectedDateRange?.start ?? DateTime.now(),
      onDateRangeChanged: onDateRangeChanged,
      height: 340,
      displayMonthsSeparator: true,
    );
  }
}
