//
// import 'package:fairpytasker/UI/task_component_ui.dart';
// import 'package:fairpytasker/UI/working_history_category_wise_ui.dart';
// import 'package:fairpytasker/Response/working_history_count_response.dart';
// import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
// import 'package:fairpytasker/Event/todo_view_event.dart';
// import 'package:fairpytasker/State/todo_view_state.dart';
// import 'package:fairpytasker/Utilities/appC.dart';
// import 'package:fairpytasker/Utilities/num.dart';
// import 'package:fairpytasker/Utilities/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
//
// import '../Response/working_history_response.dart';
//
// class WorkingHistoryUI extends StatefulWidget {
//   const WorkingHistoryUI({Key? key}) : super(key: key);
//
//   @override
//   State<WorkingHistoryUI> createState() => _WorkingHistoryUIState();
// }
//
// class _WorkingHistoryUIState extends State<WorkingHistoryUI> {
//   late TodoViewBloc vendorDataBloc;
//   TextEditingController dateController = TextEditingController();
//   List<Map<String,dynamic>> resourceList = [];
//   List<Map<String, dynamic>> workingHistoryDataWholeList = [];
//   List<Map<String, dynamic>> workingHistoryDataList = [];
//   List<Map<String, dynamic>> workingHistoryResponse=[];
//   Map<String, dynamic>? workingHistoryCountResponse;
//   List<History> historyCountList = [];
//   Map<String,dynamic>? selectedResource;
//   DateTime? selectedDate;
//   DateRange? selectedDateRange;
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     vendorDataBloc = TodoViewBloc();
//
//     DateTime now = DateTime.now();
//     DateTime startOfWeek = now.subtract(const Duration(days: 7));
//     // DateTime endOfWeek = DateTime.now();
//     selectedDateRange = DateRange(startOfWeek, now);
//
//     vendorDataBloc.add(GetWorkingHistoryList(
//         startDate: Utils.getStartOfMonth(val: startOfWeek),
//         endDate: Utils.getStartOfMonth(val: now)));
//     vendorDataBloc.add(GetWorkingHistoryCount(
//         startDate: Utils.getStartOfMonth(val: startOfWeek),
//         endDate: Utils.getStartOfMonth(val: now)));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: AppC.white,
//         appBar: AppBar(
//             centerTitle: true,
//             elevation: 0,
//             backgroundColor: AppC.trans,
//             actions: [
//               InkWell(
//                   onTap: () async {
//                     await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const TaskComponentUI(),
//                       ),
//                     );
//                   },
//                   child: const Icon(
//                     Icons.settings,
//                   )),
//               const SizedBox(
//                 width: 15,
//               )
//             ],
//             // leading: IconButton(
//             //     onPressed: () {
//             //       Navigator.of(context).pop();
//             //     },
//             //     icon: const Icon(
//             //       Icons.arrow_back_sharp,
//             //       color: AppC.black,
//             //     )),
//             title: Utils.getText('Working Hours',
//                 size: 18, weight: FontWeight.w700)),
//         body: BlocProvider(
//             create: (context) => vendorDataBloc..add(const GetAssignedToList()),
//             child: BlocConsumer<TodoViewBloc, TodoViewState>(
//                 listener: (context, state) async {
//               if (state is AssignedToLoaded) {
//                 resourceList = state.resource ?? [];
//                 if (resourceList.isNotEmpty) {
//                   resourceList[0] = ({
//                       'id': -1,
//                       'isSelected': true,
//                       'first_name': 'All',
//                       'last_name': ''});
//                   selectedResource = resourceList[0];
//                 }
//               } else if (state is WorkingHistoryLoaded) {
//                 workingHistoryResponse = state.workingHistoryResponse!;
//                 workingHistoryDataWholeList.clear();
//                 workingHistoryDataList.clear();
//                 if (workingHistoryResponse != null &&
//                     workingHistoryResponse['data'] != null &&
//                     workingHistoryResponse!['data']!['data'] != null) {
//                   workingHistoryDataWholeList
//                       .addAll(workingHistoryResponse['data']['data']!);
//                   workingHistoryDataList
//                       .addAll(workingHistoryResponse!.data!.data!);
//                   doAssignAssignTaskCount();
//                 }
//               } else if (state is WorkingHistoryCountLoaded) {
//                 workingHistoryCountResponse = state.workingHistoryCountResponse;
//                 historyCountList.clear();
//                 if (workingHistoryCountResponse != null &&
//                     workingHistoryCountResponse!.history != null) {
//                   historyCountList = workingHistoryCountResponse!.history ?? [];
//                   doAssignAssignTaskCount();
//                 }
//               }
//             }, builder: (context, state) {
//               return Stack(
//                 children: [
//                   SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Column(
//                             children: [
//                               Container(
//                                 decoration: BoxDecoration(
//                                     border: Border.all(
//                                       color: AppC.fieldBase,
//                                       width: Num.borderWidthField,
//                                     ),
//                                     borderRadius: const BorderRadius.all(
//                                         Radius.circular(Num.subradiusButton))),height: 40,
//                                 child: DropdownButton<Map<String,dynamic>>(
//                                   hint: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 10.0),
//                                     child: Utils.getText('Select Resource',
//                                         color: AppC.grey),
//                                   ),
//                                   value: selectedResource,
//                                   isExpanded: true,
//                                   icon: const Icon(Icons.arrow_drop_down),
//                                   elevation: 0,
//                                   underline: Container(
//                                     height: 0,
//                                     color: Colors.transparent,
//                                   ),
//                                   onChanged: (Map<String,dynamic>? value) {
//                                     selectedResource = value;
//                                     if (selectedResource!['id']! != -1) {
//                                       workingHistoryDataList.clear();
//                                       workingHistoryDataList =
//                                           workingHistoryDataWholeList
//                                               .where((item) =>
//                                                   item.user?.name ==
//                                                   selectedResource!['first_name'])
//                                               .toList();
//                                     } else {
//                                       workingHistoryDataList.clear();
//                                       workingHistoryDataList
//                                           .addAll(workingHistoryDataWholeList);
//                                     }
//                                     setState(() {});
//                                   },
//                                   items: resourceList
//                                       .map<DropdownMenuItem<Map<String,dynamic>>>(
//                                           (Map<String,dynamic> value) {
//                                     return DropdownMenuItem<Map<String,dynamic>>(
//                                       value: value,
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 10.0),
//                                         child: Utils.getText(
//                                             '${value['first_name']} ${value['last_name']}'),
//                                       ),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               SizedBox(height: 40,
//                                 child: DateRangeField(
//                                   decoration: InputDecoration(
//                                     contentPadding: const EdgeInsets.symmetric(
//                                         horizontal: 12),
//                                     border: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                             color: AppC.fieldBase,
//                                             width: Num.borderWidthField),
//                                         borderRadius: BorderRadius.circular(
//                                             Num.subradiusButton)),
//                                     // label: const Text("Date range picker"),
//                                     hintStyle:
//                                         Utils.getTextStyle(color: AppC.grey),
//                                     hintText: 'Please select a date range',
//                                   ),
//                                   onDateRangeSelected: (DateRange? value) {
//                                     setState(() {
//                                       selectedDateRange = value;
//                                       vendorDataBloc.add(GetWorkingHistoryList(
//                                           startDate: Utils.getStartOfMonth(
//                                               val: selectedDateRange?.start),
//                                           endDate: Utils.getStartOfMonth(
//                                               val: selectedDateRange?.end)));
//                                       vendorDataBloc.add(GetWorkingHistoryCount(
//                                           startDate: Utils.getStartOfMonth(
//                                               val: selectedDateRange?.start),
//                                           endDate: Utils.getStartOfMonth(
//                                               val: selectedDateRange?.end)));
//                                     });
//                                   },
//                                   selectedDateRange: selectedDateRange,
//                                   pickerBuilder: datePickerBuilder,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(
//                             height: 15,
//                           ),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 8),
//                             decoration: BoxDecoration(
//                               border: Border(
//                                 top: const BorderSide(
//                                     color: AppC.white, width: 1),
//                                 left: const BorderSide(
//                                     color: AppC.white, width: 1),
//                                 right: const BorderSide(
//                                     color: AppC.white, width: 1),
//                                 bottom: BorderSide(
//                                     color: Colors.grey.withOpacity(0.1),
//                                     width: 1),
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.1),
//                                   spreadRadius: 1,
//                                   blurRadius: 1,
//                                   offset: const Offset(0,
//                                       5), // Adjust the offset for the side you want the shadow
//                                 ),
//                               ],
//                               color: AppC.appbgColor,
//                             ),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                     flex: 6,
//                                     child: Utils.getText('Employee',
//                                         weight: FontWeight.bold)),
//                                 Expanded(
//                                     flex: 2,
//                                     child: Utils.getText('Hours',
//                                         weight: FontWeight.bold)),
//                                 Expanded(
//                                     flex: 1,
//                                     child: Utils.getText('Task',
//                                         weight: FontWeight.bold)),
//                                 Expanded(
//                                     flex: 1,
//                                     child: Utils.getText('#',
//                                         weight: FontWeight.bold)),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           ListView.builder(
//                             physics: const NeverScrollableScrollPhysics(),
//                             shrinkWrap: true,
//                             itemCount: workingHistoryDataList.length,
//                             itemBuilder: (context, index) {
//                               return Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 8, vertical: 8),
//                                 decoration: BoxDecoration(
//                                   border: Border(
//                                     top: const BorderSide(
//                                         color: AppC.white, width: 1),
//                                     left: const BorderSide(
//                                         color: AppC.white, width: 1),
//                                     right: const BorderSide(
//                                         color: AppC.white, width: 1),
//                                     bottom: BorderSide(
//                                         color: Colors.grey.withOpacity(0.1),
//                                         width: 1),
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.grey.withOpacity(0.1),
//                                       spreadRadius: 1,
//                                       blurRadius: 1,
//                                       offset: const Offset(0,
//                                           5), // Adjust the offset for the side you want the shadow
//                                     ),
//                                   ],
//                                   color: AppC.white,
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                         flex: 6,
//                                         child: Utils.getText(
//                                             workingHistoryDataList[index]
//                                                     .user
//                                                     ?.name ??
//                                                 '')),
//                                     Expanded(
//                                         flex: 2,
//                                         child: InkWell(
//                                             onTap: () {
//                                               getListOfHoursDialog(
//                                                   context,
//                                                   workingHistoryDataList[index]
//                                                           .user
//                                                           ?.name ??
//                                                       '',
//                                                   workingHistoryDataList[index]
//                                                           .user
//                                                           ?.list ??
//                                                       []);
//                                             },
//                                             child: Utils.getText(
//                                                 Utils.convertToHourMinutes(
//                                                     workingHistoryDataList[
//                                                                 index]
//                                                             .user
//                                                             ?.totalWorkingHours ??
//                                                         '')))),
//                                     Expanded(
//                                         flex: 1,
//                                         child: InkWell(
//                                             onTap: () async {
//                                               await Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) => WorkingHistoryCategoryWiseUI(
//                                                       title:
//                                                           workingHistoryDataList[
//                                                                   index]
//                                                               .user
//                                                               ?.name,
//                                                       userId: workingHistoryDataList[
//                                                               index]
//                                                           .user
//                                                           ?.idToGetTaskHistory
//                                                           .toString(),
//                                                       start: selectedDateRange
//                                                           ?.start,
//                                                       end: selectedDateRange
//                                                           ?.end,
//                                                       taskCount:
//                                                           (workingHistoryDataList[
//                                                                           index]
//                                                                       .user
//                                                                       ?.taskCount ??
//                                                                   0)
//                                                               .toString()),
//                                                 ),
//                                               );
//                                             },
//                                             child: Utils.getText(
//                                                 (workingHistoryDataList[index]
//                                                             .user
//                                                             ?.taskCount ??
//                                                         0)
//                                                     .toString()))),
//                                     Expanded(
//                                         flex: 1,
//                                         child: calculatingHoursException(
//                                             workingHistoryDataList[index]
//                                                 .user
//                                                 ?.totalWorkingHours)),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                           const SizedBox(
//                             height: 15,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Visibility(
//                       visible: state is TodoListLoading,
//                       child: Center(child: Utils.getProgressIndicator(context)))
//                 ],
//               );
//             })));
//   }
//
// /*
//   DateTime getPreviousSunday(DateTime date) {
//     int daysToSunday = date.weekday % 7;
//     return date.subtract(Duration(days: daysToSunday));
//   }
//
//   DateTime getNextMonday(DateTime date) {
//     int daysToMonday = 8 - date.weekday;
//     return date.add(Duration(days: daysToMonday));
//   }
// */
//
//   void doAssignAssignTaskCount() {
//     for (int i = 0; i < (workingHistoryDataList).length; i++) {
//       for (int j = 0; j < (historyCountList).length; j++) {
//         if ((historyCountList[j].users!.hrmId).toString() ==
//             (workingHistoryDataList[i].user?.id ?? 0).toString()) {
//           workingHistoryDataList[i].user?.taskCount =
//               (historyCountList[j].taskCount);
//           workingHistoryDataList[i].user?.idToGetTaskHistory =
//               (historyCountList[j].users?.id ?? 0).toString();
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
//   void getListOfHoursDialog(
//       BuildContext context, String title, List<HoursList> list) {
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
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
//                               child: Utils.getText(list[index].date ?? '')),
//                           Expanded(
//                               flex: 2,
//                               child: Utils.getText(Utils.convertToHourMinutes(
//                                   list[index].startTime ?? ''))),
//                           Expanded(
//                               flex: 2,
//                               child: Utils.getText(Utils.convertToHourMinutes(
//                                   list[index].endTime ?? ''))),
//                           Expanded(
//                               flex: 2,
//                               child: Utils.getText(Utils.convertToHourMinutes(
//                                   list[index].totalHours ?? ''))),
//                           Expanded(
//                               flex: 1,
//                               child: calculatingHoursException(
//                                   list[index].totalHours ?? '')),
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
//   Widget datePickerBuilder(
//           BuildContext context, dynamic Function(DateRange?) onDateRangeChanged,
//           [bool doubleMonth = false]) =>
//       DateRangePickerWidget(
//         doubleMonth: doubleMonth,
//         initialDateRange: selectedDateRange,
//         disabledDates: const [],
//         initialDisplayedDate: selectedDateRange?.start ?? DateTime.now(),
//         onDateRangeChanged: onDateRangeChanged,
//       );
//
//   void doSetState() {
//     setState(() {});
//   }
// }
