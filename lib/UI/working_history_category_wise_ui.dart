//
// import 'package:fairpytasker/Response/task_history_response.dart';
// import 'package:fairpytasker/Response/task_history_configuration_response.dart';
// import 'package:fairpytasker/UI/working_history_task_details_ui.dart';
// import 'package:fairpytasker/Response/working_history_count_response.dart';
// import 'package:fairpytasker/bloc/todo_view_bloc.dart';
// import 'package:fairpytasker/event/todo_view_event.dart';
// import 'package:fairpytasker/state/todo_view_state.dart';
// import 'package:fairpytasker/Utilities/appC.dart';
// import 'package:fairpytasker/Utilities/utils.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
//
// class WorkingHistoryCategoryWiseUI extends StatefulWidget {
//   final String? userId;
//   final String? title;
//   final DateTime? start;
//   final DateTime? end;
//   final String? taskCount;
//
//   const WorkingHistoryCategoryWiseUI(
//       {this.userId, this.title, this.start, this.end, this.taskCount, Key? key})
//       : super(key: key);
//
//   @override
//   state<WorkingHistoryCategoryWiseUI> createState() =>
//       _WorkingHistoryCategoryWiseUIState();
// }
//
// class _WorkingHistoryCategoryWiseUIState
//     extends state<WorkingHistoryCategoryWiseUI> {
//   late TodoViewBloc todoDataBloc;
//   TextEditingController dateController = TextEditingController();
//   List<Map<String,dynamic>> resourceList = [];
//   List<Map<String,dynamic>> workingHistoryDataWholeList = [];
//   List<Map<String,dynamic>> workingHistoryDataList = [];
//   Map<String,dynamic>? taskHistoryResponseMap;
//   WorkingHistoryCountResponse? workingHistoryCountResponse;
//   List<Map<String, dynamic>> historyCountList = [];
//   Map<String,dynamic>? selectedResource;
//   DateTime? selectedDate;
//   DateRange? selectedDateRange;
//   List<Map<String,dynamic>> taskHistoryConfigurationList = [];
//   int k = 0;
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     todoDataBloc = TodoViewBloc();
//     todoDataBloc.add(const GetTaskHistoryConfiguration());
//     // vendorDataBloc.add(const GetWorkingHistoryCount());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//             create: (context) => todoDataBloc
//               ..add(GetWorkingTaskHistoryList(
//                   userId: widget.userId,
//                   startDate: Utils.getStartOfMonth(val: widget.start),
//                   endDate: Utils.getStartOfMonth(val: widget.end))),
//             child: BlocConsumer<TodoViewBloc, TodoViewState>(
//                 listener: (context, state) async {
//                   if (state is TaskHistoryConfigurationLoaded) {
//                     // parseJson(state.taskHistoryConfigurationList??'');
//                     taskHistoryConfigurationList.clear();
//                       taskHistoryConfigurationList = state.taskHistoryConfigurationList ?? [];
//                     if(taskHistoryResponseMap!.isNotEmpty) {
//                       for (var element in taskHistoryConfigurationList) {
//                         taskHistoryResponseMap?.forEach((key, value) {
//                           if (element['id'] == key['id']) {
//                             element['total_amount'] = int.parse(element['amount'])*value.length;
//                             key['name'] = element['name'];
//                             key['amount'] = element['amount'];
//                           }
//                         } as void Function(Comparable<String> key, dynamic value));
//                       }
//                     }
//                     for (var element in taskHistoryConfigurationList) {
//                       k = k+element['total_amount']!;
//                     }
//                     debugPrint('total1: $k');
//                   } else if (state is GetWorkingTaskHistoryListLoaded) {
//                     taskHistoryResponseMap = (state.employeeTaskHistoryResponse??{}) as Map<String, dynamic>?;
//                     if(taskHistoryConfigurationList.isNotEmpty) {
//                       for (var element in taskHistoryConfigurationList) {
//                         taskHistoryResponseMap?.forEach((key, value) {
//                           if (element['id'] == key['id']) {
//                             /*taskHistoryConfigurationList . amount * list len*/
//                             element['total_amount'] = int.parse(element['amount'])*value.length;
//                             key['name'] = element['name'];
//                             key['amount'] = element['amount'];
//                           }
//                         });
//                       }
//                     }
//                     for (var element in taskHistoryConfigurationList) {
//                       k = k+element['total_Amount']!;
//                     }
//                     debugPrint('total: $k');
// /*              employeeTaskHistoryResponse = state.employeeTaskHistoryResponse
//                   if(employeeTaskHistoryResponse != null && employeeTaskHistoryResponse!.data != null && employeeTaskHistoryResponse!.data!.data != null) {
//                     workingHistoryDataWholeList.addAll(employeeTaskHistoryResponse!.data!.data!);
//                     workingHistoryDataList.addAll(employeeTaskHistoryResponse!.data!.data!);
//                     doAssignAssignTaskCount();
//                   }*/
//                   }
//                 }, builder: (context, state) {
//               return Scaffold(
//                 appBar: AppBar(
//                   centerTitle: true,
//                   elevation: 0,
//                   backgroundColor: AppC.trans,
//                   leading: IconButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       icon: const Icon(
//                         Icons.arrow_back_sharp,
//                         color: AppC.black,
//                       )),
//                   title: Utils.getText(widget.title??'',
//                       size: 18, weight: FontWeight.w700),
//                   actions: [
//                     Container(
//                       decoration: Utils.getBoxDecoration(),
//                       child: Utils.getText('  ${widget.taskCount??'0'}  ', weight: FontWeight.w500),
//                     ),
//                     const SizedBox(width: 8,),
//                     InkWell(
//                         onTap: () {
//                           getTaskCountAmountDialog(context);
//                         },
//                         child: Utils.getText(' \$$k ', weight: FontWeight.bold, size: 16)),
//                     const SizedBox(width: 8,)
//                   ],
//                 ),
//                 body: Stack(
//                   children: [
//                     SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ListView.builder(
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemCount: taskHistoryResponseMap.length,
//                               itemBuilder: (context, index) {
//                                 TaskHistoryConfigurationData key = taskHistoryResponseMap.keys.elementAt(index);
//                                 List<Task> tasks = taskHistoryResponseMap[key]??[];
//
//                                 return Column(
//                                   children: [
//                                     Visibility(
//                                       visible: key.name.contains('Drop') || key.name.contains('PickUp'),
//                                       child: ExpansionTile(
//                                         trailing: const Icon(
//                                           Icons.keyboard_arrow_down_rounded,
//                                           color: Colors.grey,
//                                           size: 22,
//                                         ),
//                                         title: Utils.getText('Drop/PickUp Task'),
//                                         children: [
//                                           if (key.name.contains('Drop'))
//                                             ExpansionTile(
//                                               trailing: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey, size: 22),
//                                               title: Utils.getText('Drop'),
//                                               children: [
//                                                 ListView.builder(
//                                                   physics: const NeverScrollableScrollPhysics(),
//                                                   shrinkWrap: true,
//                                                   itemCount: tasks.length,
//                                                   itemBuilder: (context, subIndex) {
//                                                     Task task = tasks[subIndex];
//                                                     return TaskListItem(task: task);
//                                                   },
//                                                 ),
//                                               ],
//                                             ),
//                                           if (key.name.contains('PickUp'))
//                                             ExpansionTile(
//                                               trailing: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey, size: 22),
//                                               title: Utils.getText('Pickup'),
//                                               children: [
//                                                 ListView.builder(
//                                                   physics: const NeverScrollableScrollPhysics(),
//                                                   shrinkWrap: true,
//                                                   itemCount: tasks.length,
//                                                   itemBuilder: (context, subIndex) {
//                                                     Task task = tasks[subIndex];
//                                                     return TaskListItem(task: task);
//                                                   },
//                                                 ),
//                                               ],
//                                             ),
//                                         ],
//                                       ),
//                                     ),
//                                     Visibility(
//                                       visible: !key.name.contains('Drop') && !key.name.contains('PickUp'),
//                                       child: ExpansionTile(
//                                         trailing: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey, size: 22),
//                                         title: Utils.getText(key.name),
//                                         children: [
//                                           ListView.builder(
//                                             physics: const NeverScrollableScrollPhysics(),
//                                             shrinkWrap: true,
//                                             itemCount: tasks.length,
//                                             itemBuilder: (context, subIndex) {
//                                               Task task = tasks[subIndex];
//                                               return TaskListItem(task: task);
//                                             },
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     Visibility(
//                         visible: state is TodoListLoading,
//                         child: Center(child: Utils.getProgressIndicator(context)))
//                   ],
//                 ),
//               );
//             }));
//   }
//
//   void doAssignAssignTaskCount() {
//     for (int i = 0; i < (workingHistoryDataList).length; i++) {
//       for (int j = 0; j < (historyCountList).length; j++) {
//         if (historyCountList[j]['user_id'] ==
//             (workingHistoryDataList[i]['user']?['employee_id'] ?? 0).toString()) {
//           workingHistoryDataList[i]['user']?.taskCount =
//           (historyCountList[j]['task_count']);
//         }
//       }
//     }
//   }
//
//   Widget calculatingHoursException(String? hours) {
//     if (hours != null) {
//       var hoursArr = hours.split(':');
//       int wHours = int.parse(hoursArr[0]);
//       if (wHours < 6 || wHours > 9) {
//         return Utils.getText('1');
//       }
//     }
//     return Container();
//   }
//
//   void getListOfHoursDialog(BuildContext context, String title, List<Map<String,dynamic>> list) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Utils.getText(title, size: 16),
//         contentPadding: EdgeInsets.zero,
//         insetPadding: EdgeInsets.zero,
//         content: Container(
//             margin: const EdgeInsets.symmetric(vertical: 15),
//             height: MediaQuery.of(context).size.height / 1.5,
//             width: MediaQuery.of(context).size.width / 1.1,
//             child: Column(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 12),
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                   decoration: BoxDecoration(
//                     border: Border(
//                       top: const BorderSide(color: AppC.white, width: 1),
//                       left: const BorderSide(color: AppC.white, width: 1),
//                       right: const BorderSide(color: AppC.white, width: 1),
//                       bottom: BorderSide(
//                           color: Colors.grey.withOpacity(0.1), width: 1),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.1),
//                         spreadRadius: 1,
//                         blurRadius: 1,
//                         offset: const Offset(0,
//                             5), // Adjust the offset for the side you want the shadow
//                       ),
//                     ],
//                     color: AppC.grey,
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(flex: 3, child: Utils.getText('Date')),
//                       Expanded(flex: 2, child: Utils.getText('In')),
//                       Expanded(flex: 2, child: Utils.getText('Out')),
//                       Expanded(flex: 2, child: Utils.getText('Total')),
//                       Expanded(flex: 1, child: Utils.getText('#')),
//                     ],
//                   ),
//                 ),
//                 ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: list.length,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 8),
//                       decoration: BoxDecoration(
//                         border: Border(
//                           top: const BorderSide(color: AppC.white, width: 1),
//                           left: const BorderSide(color: AppC.white, width: 1),
//                           right: const BorderSide(color: AppC.white, width: 1),
//                           bottom: BorderSide(
//                               color: Colors.grey.withOpacity(0.1), width: 1),
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.1),
//                             spreadRadius: 1,
//                             blurRadius: 1,
//                             offset: const Offset(0,
//                                 5), // Adjust the offset for the side you want the shadow
//                           ),
//                         ],
//                         color: AppC.white,
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                               flex: 3,
//                               child: Utils.getText(list[index]['date'] ?? '')),
//                           Expanded(
//                               flex: 2,
//                               child: Utils.getText(Utils.convertToHourMinutes(
//                                   list[index]['start_time'] ?? ''))),
//                           Expanded(
//                               flex: 2,
//                               child: Utils.getText(Utils.convertToHourMinutes(
//                                   list[index]['end_time'] ?? ''))),
//                           Expanded(
//                               flex: 2,
//                               child: Utils.getText(Utils.convertToHourMinutes(
//                                   list[index]['total_hours'] ?? ''))),
//                           Expanded(
//                               flex: 1,
//                               child: calculatingHoursException(
//                                   list[index]['total_hours'] ?? '')),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             )),
//         actions: [
//           Utils.getOutlinedButton('Close', () {
//             Navigator.of(context).pop();
//           }, verticalPadding: 5, borderColor: AppC().base),
//         ],
//       ),
//     );
//   }
//
//   void getTaskCountAmountDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         // title: Utils.getText(title, size: 16),
//         surfaceTintColor: AppC.white,
//         shadowColor: AppC.white,
//         backgroundColor: AppC.white,
//         contentPadding: EdgeInsets.zero,
//         insetPadding: EdgeInsets.zero,
//         content: Container(
//             margin: const EdgeInsets.symmetric(vertical: 15),
//             height: MediaQuery.of(context).size.height / 1.5,
//             width: MediaQuery.of(context).size.width / 1.1,
//             decoration: Utils.getBoxDecoration(borderColor: AppC.white, radius: 12),
//             child: Column(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 12),
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                   /*decoration: BoxDecoration(
//                     border: Border(
//                       top: const BorderSide(color: AppC.white, width: 1),
//                       left: const BorderSide(color: AppC.white, width: 1),
//                       right: const BorderSide(color: AppC.white, width: 1),
//                       bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.1),
//                         spreadRadius: 1,
//                         blurRadius: 1,
//                         offset: const Offset(0,
//                             5), // Adjust the offset for the side you want the shadow
//                       ),
//                     ],
//                     color: AppC.grey,
//                   ),*/
//                   child: Row(
//                     children: [
//                       Expanded(flex: 4, child: Utils.getText('Task Name')),
//                       Expanded(flex: 3, child: Utils.getText('Count')),
//                       Expanded(flex: 3, child: Utils.getText('Amount')),
//                     ],
//                   ),
//                 ),
//                 Container(height: 0.2, color: AppC.grey, width: MediaQuery.of(context).size.width,),
//                 ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: taskHistoryResponseMap.length,
//                   itemBuilder: (context, index) {
//                     TaskHistoryConfigurationData key = taskHistoryResponseMap.keys.elementAt(index);
//                     List<Task> value = taskHistoryResponseMap[key]!;
//
//                     return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//                       child: Row(
//                         children: [
//                           Expanded(
//                               flex: 4,
//                               child: Utils.getText(key.name)),
//                           Expanded(
//                               flex: 3,
//                               child: Utils.getText('    ${value.length}')),
//                           Expanded(
//                               flex: 3,
//                               child: Utils.getText('    ${key.amount??0}')),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//                 Container(height: 0.2, color: AppC.grey, width: MediaQuery.of(context).size.width,),
//                 const SizedBox(height: 12,),
//                 Row(
//                   children: [
//                     Expanded(
//                         flex: 4,
//                         child: Utils.getText('')),
//                     Expanded(
//                         flex: 3,
//                         child: Utils.getText('Total:', weight: FontWeight.w500)),
//                     Expanded(
//                         flex: 3,
//                         child: Utils.getText('$k', weight: FontWeight.w500)),
//                   ],
//                 ),
//                 const SizedBox(height: 12,),
//                 Container(height: 0.2, color: AppC.grey, width: MediaQuery.of(context).size.width,),
//               ],
//             )),
//         actions: [
//           Utils.getOutlinedButton('Close', () {
//             Navigator.of(context).pop();
//           }, verticalPadding: 5, borderColor: AppC().base),
//         ],
//       ),
//     );
//   }
//
//   Widget datePickerBuilder(
//       BuildContext context, dynamic Function(DateRange?) onDateRangeChanged,
//       [bool doubleMonth = false]) =>
//       DateRangePickerWidget(
//         doubleMonth: doubleMonth,
//         initialDateRange: selectedDateRange,
//         disabledDates: [],
//         initialDisplayedDate: selectedDateRange?.start ?? DateTime.now(),
//         onDateRangeChanged: onDateRangeChanged,
//       );
//
//   void doSetState() {
//     setState(() {});
//   }
// }
//
// class TaskListItem extends StatelessWidget {
//   final Task task;
//
//   const TaskListItem({Key? key, required this.task}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () async {
//         await Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => WorkingHistoryTaskDetailUI(title: '', id: task.id, subTitle: ''),
//         ));
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//         decoration: BoxDecoration(
//           border: Border(
//             top: const BorderSide(color: Colors.white, width: 1),
//             left: const BorderSide(color: Colors.white, width: 1),
//             right: const BorderSide(color: Colors.white, width: 1),
//             bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 1,
//               offset: const Offset(0, 5),
//             ),
//           ],
//           color: Colors.white,
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               flex: 7,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                  Utils.getText(task.title??''),
//                   const SizedBox(height: 2),
//                   Utils.getText(task.vehicleName??''),
//                 ],
//               ),
//             ),
//             // const Spacer(),
//             Expanded(
//                 flex: 3,
//                 child: Utils.getText(task.todoDate??'', align: TextAlign.end)),
//           ],
//         ),
//       ),
//     );
//   }
// }