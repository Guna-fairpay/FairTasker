//
// import 'package:fairpytasker/UI/CheckIn%20CheckOut/Event/workingHoursEvent.dart';
// import 'package:fairpytasker/UI/CheckIn%20CheckOut/State/workingHoursState.dart';
// import 'package:fairpytasker/UI/CheckIn%20CheckOut/Bloc/workHoursBloc.dart';
// import 'package:fairpytasker/UI/CheckIn%20CheckOut/UI/Popups/text_popup.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import '../../../../Utilities/Utils.dart';
// import '../../../../Utilities/appC.dart';
//
//
// late TaskBloc getTaskCountBloc;
// bool loading=false;
// String fromDate='';
// String toDate='';
// List<Map<String, dynamic>> combinedData=[];
// List<Map<String, dynamic>> taskComments=[];
//
// class ReasonTopNotificationPopup {
//
//   static void show(
//       BuildContext context, {
//         required List<dynamic> dataList,
//         required String userName,
//         required String selectedDateRange,
//         required int hrmID,
//       }) {
//     _showReasonTopNotification(context, dataList, userName, selectedDateRange, hrmID);
//   }
//   static void _showReasonTopNotification(
//       BuildContext context,
//       List<dynamic> dataList,
//       String userName,
//       String selectedDateRange, int hrmID,
//       )
//   {
//     String convertDateToCustomFormat(String inputDate)
//     {
//       try {
//         List<String> dates = inputDate.split(" - ");
//         if (dates.length != 2) return "Invalid range";
//         String startDate = dates[0];
//         String endDate = dates[1];
//         String formattedStartDate = DateFormat("dd MMM yyyy").format(
//           DateFormat("dd/MM/yyyy").parse(startDate),
//         ).toUpperCase();
//         String formattedEndDate = DateFormat("dd MMM yyyy").format(
//           DateFormat("dd/MM/yyyy").parse(endDate),
//         ).toUpperCase();
//         return "$formattedStartDate - $formattedEndDate";
//       } catch (e) {
//         return "Invalid date format";
//       }
//     }
//
//     List<String> getFromDateAndToDate(String dateRange)
//     {
//       try {
//
//         List<String> dates = dateRange.split(" - ");
//         if (dates.length != 2) {
//           throw Exception("Invalid date range format.");
//         }
//         DateTime fromDateParsed = DateFormat("dd/MM/yyyy").parse(dates[0]);
//         DateTime toDateParsed = DateFormat("dd/MM/yyyy").parse(dates[1]);
//         String fromDate = DateFormat("yyyy-MM-dd").format(fromDateParsed);
//         String toDate = DateFormat("yyyy-MM-dd").format(toDateParsed);
//         return [fromDate, toDate];
//       } catch (e) {
//         throw Exception("Error parsing date range: ${e.toString()}");
//       }
//     }
//     List<String> result = getFromDateAndToDate(selectedDateRange);
//
//     String formatDateMMDDYYYY(String dateString) {
//       try {
//         DateTime dateTime = DateTime.parse(dateString);
//         String formattedDate = DateFormat('MM-dd-yyyy').format(dateTime);
//         return formattedDate;
//       } catch (e) {
//         print('Error formatting date: $e');
//         return 'Invalid Date'; // Or handle the error as needed
//       }
//     }
//
//     List<Map<String, dynamic>> combineData(List<dynamic> dataList, List<Map<String, dynamic>> taskCounts,)
//     {
//       List<Map<String, dynamic>> combinedList = [];
//       Map<String, List<Map<String, dynamic>>> taskCountsMap = {};
//       for (var task in taskCounts) {
//         final String? date = task['date'] != null
//             ? DateFormat('yyyy-MM-dd').format(DateTime.parse(task['date']))
//             : null;
//
//         if (date != null) {
//           taskCountsMap.putIfAbsent(date, () => []).add(task);
//         }
//       }
//       for (var item in dataList) {
//         final String? date = item['date']?.toString();
//         if (date == null)
//         {
//           continue; // Skip invalid entries
//         }
//         final List<Map<String, dynamic>>? taskDataList = taskCountsMap[date];
//
//         String reason = '';
//         String comments = '';
//         if (taskDataList != null && taskDataList.isNotEmpty)
//         {
//           reason = taskDataList.map((task) => task['reason']?.toString() ?? '').join(', ');
//           comments = taskDataList.map((task) => task['comments']?.toString() ?? '').join(', ');
//         }
//         combinedList.add({
//           'date': formatDateMMDDYYYY(date),
//           'start_time': item['start_time'] ?? '',
//           'end_time': item['end_time'] ?? '',
//           'reason': reason,
//           'comments': comments,
//         });
//       }
//       return combinedList;
//     }
//
//     String calculateTotalHours(String startTime, String endTime) {
//       if(startTime!='' && endTime!='')
//         {
//           DateTime start = DateFormat('HH:mm:ss').parse(startTime);
//           DateTime end = DateFormat('HH:mm:ss').parse(endTime);
//           if (end.isBefore(start)) {
//             end = end.add(Duration(days: 1));
//           }
//           Duration duration = end.difference(start);
//           int hours = duration.inHours;
//           int minutes = duration.inMinutes % 60;
//
//           return '${hours}h ${minutes}m';
//         }
//       return '0h 0m';
//     }
//
//     buildTotalHoursWidget(String totalHours) {
//       try {
//         // Regular expression to parse hours and minutes
//         final regex = RegExp(r'(\d+)h\s*(\d+)m');
//         final match = regex.firstMatch(totalHours);
//
//         if (match != null) {
//           final hours = int.parse(match.group(1)!);
//           final minutes = int.parse(match.group(2)!);
//
//           // Calculate total minutes for easier comparison
//           final totalMinutes = (hours * 60) + minutes;
//
//           return Text(
//             totalHours,
//             style: TextStyle(
//               color: totalMinutes < (6 * 60) ? AppC.red : null,
//               fontSize: 12,
//             ),
//           );
//         } else {
//           // Handle invalid format (e.g., if the string doesn't match the expected pattern)
//           return const Text('Invalid Format');
//         }
//       } catch (e) {
//         // Handle parsing errors
//         print('Error parsing total hours: $e');
//         return const Text('Invalid Format');
//       }
//     }
//
//
//
//     showGeneralDialog(
//       context: context,
//       pageBuilder: (context, animation, secondaryAnimation) {
//
//         final taskBloc= TaskBloc();
//         return BlocProvider(
//           create: (_) => taskBloc..add(fetchEmployeeComment(hrmId: hrmID, fromDate: result[0].toString(), toDate: result[1].toString())),
//           child: BlocConsumer<TaskBloc, TaskState>(
//             listener: (context, state) {
//               if (state is TaskLoadingState)
//               {
//                 loading=true;
//               }
//               else if(state is CommentLoadedState)
//               {
//                 loading=false;
//                 taskComments.clear();
//                 taskComments= state.comment.comments!;
//               }
//               else{
//                 loading=true;
//               }
//               combinedData=combineData(dataList,taskComments);
//             },
//             builder: (context, state) {
//               return Align(
//                 alignment: Alignment.topCenter,
//                 child: Material(
//                   type: MaterialType.transparency,
//                   child: Container(
//                     margin: const EdgeInsets.only(top: 50.0),
//                     padding: const EdgeInsets.all(20.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Header Section
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               userName,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                               ),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.close),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Utils.getText(
//                                 convertDateToCustomFormat(selectedDateRange)),
//                           ],
//                         ),
//                         const SizedBox(height: 5),
//                         // Column Titles
//                         Container(
//                             decoration: const BoxDecoration(
//                               color: Color.fromRGBO(240, 240, 240, 1),
//                             ),
//                           padding: const EdgeInsets.only(top: 8, bottom: 8),
//                           child: const Row(
//                             children: [
//                               SizedBox(width: 10,),
//                               Expanded(
//                                   flex: 1,
//                                   child: Text("Date",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold))),
//                               Expanded(
//                                   flex: 1,
//                                   child: Text("Total",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold))),
//                               Expanded(
//                                   flex: 1,
//                                   child: Text("Reason",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold))),
//                               Expanded(
//                                   flex: 1,
//                                   child: Text("Comments",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold))),
//                             ],
//                           ),
//                         ),
//                         const Divider(height: 1, thickness: 1),
//                         // Data Rows in ListView.builder
//                         SizedBox(
//                           height: 200,
//                           child: ListView.builder(
//                             padding: EdgeInsets.zero,
//                             itemCount: combinedData.length,
//                             itemBuilder: (context, index) {
//                               final entry = combinedData[index];
//                               buildTotalHoursWidget(calculateTotalHours(entry['start_time'],entry['end_time']));
//                               return Padding(
//                                 padding: const EdgeInsets.only(bottom: 5),
//                                 child: Container(
//                                   decoration: const BoxDecoration(
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.grey,
//                                         spreadRadius: 0.1,
//                                         blurRadius: 0.1,
//                                         offset: Offset(0, 1),
//                                       ),
//                                     ],
//                                     color: AppC.white,
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(
//                                         left: 0, top: 3),
//                                     child: Row(
//                                       children: [
//                                         SizedBox(width: 10,),
//                                         Expanded(
//                                             flex: 1,
//                                             child:
//                                             Utils.getText(entry['date'])),
//                                         Expanded(
//                                             flex: 1,
//                                             child:  (buildTotalHoursWidget(calculateTotalHours(entry['start_time'],entry['end_time']))),
//                                         ),
//                                         Expanded(
//                                             flex: 1,
//                                             child: entry['reason'].toString().length>7 ?
//                                             GestureDetector(
//                                                 onTap: (){
//                                                   TextPopup.show(context, entry['reason']);
//                                                 },
//                                                 child: Utils.getText("${entry['reason']}",overFlow: TextOverflow.ellipsis)
//                                             )
//                                                 : Utils.getText("${entry['reason']}")
//                                         ),
//                                         SizedBox(width: 20,),
//                                         Expanded(
//                                             flex: 1,
//                                             child: entry['comments'].toString().length>7 ?
//                                             GestureDetector(
//                                                 onTap: (){
//                                                   TextPopup.show(context, entry['comments']);
//                                                 },
//                                                 child: Utils.getText("${entry['comments']}",overFlow: TextOverflow.ellipsis)
//                                             )
//                                                 : Utils.getText("${entry['comments']}")
//                                         ),
//                                         SizedBox(width: 10,),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return FadeTransition(
//           opacity: CurvedAnimation(
//             parent: animation,
//             curve: Curves.easeOut,
//           ),
//           child: child,
//         );
//       },
//       transitionDuration: const Duration(milliseconds: 200),
//     );
//   }
// }