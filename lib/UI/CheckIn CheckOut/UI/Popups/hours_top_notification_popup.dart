
import 'dart:developer';

import 'package:fairpytasker/UI/CheckIn%20CheckOut/Event/workingHoursEvent.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/State/workingHoursState.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Bloc/workHoursBloc.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/UI/Popups/text_reason_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';


bool loading=false;
String fromDate='';
String toDate='';
List<Map<String, dynamic>> combinedData=[];
List<Map<String, dynamic>> taskCounts=[];
List<Map<String, dynamic>> checkInoutReason=[];


class HoursPopup {

  static void show(
      BuildContext context, {
        required List<dynamic> dataList,
        required String userName,
        required String selectedDateRange,
        required int empID,
        required hrmID,
        required List<Map<String, dynamic>> taskCounts,
        required List<Map<String, dynamic>> checkInoutReason,
      }) {
    _showTopNotification(context, dataList, userName, selectedDateRange, empID, hrmID, taskCounts, checkInoutReason);
  }

  static void _showTopNotification(
      BuildContext context,
      List<dynamic> dataList,
      String userName,
      String selectedDateRange, int empID,int hrmID, List<Map<String, dynamic>> taskCounts, List<Map<String, dynamic>> checkInoutReason,
      )
  {
    String formatDurationToHM(String durationString) {
      try {
        List<String> parts = durationString.split(':');
        if (parts.length == 3) {
          int hours = int.parse(parts[0]);
          int minutes = int.parse(parts[1]);
          return '${hours}h ${minutes}m';
        } else {
          return 'Invalid format';
        }
      } catch (e) {
        return 'Invalid format';
      }
    }

    String convertDateToCustomFormat(String inputDate)
    {
      try {
        List<String> dates = inputDate.split(" - ");
        if (dates.length != 2) return "Invalid range";
        String startDate = dates[0];
        String endDate = dates[1];
        String formattedStartDate = DateFormat("dd MMM yyyy").format(
          DateFormat("dd/MM/yyyy").parse(startDate),
        ).toUpperCase();
        String formattedEndDate = DateFormat("dd MMM yyyy").format(
          DateFormat("dd/MM/yyyy").parse(endDate),
        ).toUpperCase();
        return "$formattedStartDate - $formattedEndDate";
      } catch (e) {
        return "Invalid date format";
      }
    }
    List<String> getFromDateAndToDate(String dateRange) {
      try {
        dateRange = dateRange.trim();
        if (!dateRange.contains(" - ")) {
          throw Exception("Invalid date range format. Expected format: 'dd/MM/yyyy - dd/MM/yyyy'");
        }
        List<String> dates = dateRange.split(" - ").map((d) => d.trim()).toList();

        if (dates.length != 2) {
          throw Exception("Invalid date range format. Expected format: 'dd/MM/yyyy - dd/MM/yyyy'");
        }
        String normalizeDate(String dateStr) {
          try {
            if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateStr)) {
              DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(dateStr);
              return DateFormat("dd/MM/yyyy").format(parsedDate);
            } else if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(dateStr)) {
              return dateStr;
            } else {
              throw Exception("Unrecognized date format: $dateStr");
            }
          } catch (e) {
            throw Exception("Invalid date format: $dateStr");
          }
        }

        String fromDateStr = normalizeDate(dates[0]);
        String toDateStr = normalizeDate(dates[1]);
        DateTime fromDateParsed = DateFormat("dd/MM/yyyy").parse(fromDateStr);
        DateTime toDateParsed = DateFormat("dd/MM/yyyy").parse(toDateStr);
        String fromDate = DateFormat("yyyy-MM-dd").format(fromDateParsed);
        String toDate = DateFormat("yyyy-MM-dd").format(toDateParsed);
        log("$fromDate $toDate",name:"fromDateToDate");
        return [fromDate, toDate];
      } catch (e) {
        print("Error parsing date range: $e");
        throw Exception("Error parsing date range: ${e.toString()}");
      }
    }

    List<String> result;
    try {
      result = getFromDateAndToDate(selectedDateRange);
    } catch (e) {
      print("Error parsing date range: $e");
      result = [DateFormat("yyyy-MM-dd").format(DateTime.now()), DateFormat("yyyy-MM-dd").format(DateTime.now())];
    }


    List<Map<String, dynamic>> combineData(
        List<dynamic> dataList,
        List<Map<String, dynamic>> taskCounts,
        List<Map<String, dynamic>> checkInout) {
      List<Map<String, dynamic>> combinedList = [];

      // Map to organize task counts by date
      Map<String, int> taskCountsMap = {};
      for (var task in taskCounts) {
        final date = DateFormat('yyyy-MM-dd')
            .format(DateFormat('yyyy-MM-dd').parse(task['todo_date'].toString()));

        taskCountsMap[date] = (taskCountsMap[date] ?? 0) +
            (int.tryParse(task['task_count'].toString()) ?? 0);
      }
      // Map to organize check-in/out reasons by date
      Map<String, List<dynamic>> checkinReasonsMap = {};
      Map<String, List<dynamic>> checkoutReasonsMap = {};
      for (var entry in checkInout) {
        final date = DateFormat('yyyy-MM-dd')
            .format(DateFormat('yyyy-MM-dd').parse(entry['date'].toString()));

        checkinReasonsMap.putIfAbsent(date, () => []);
        checkoutReasonsMap.putIfAbsent(date, () => []);

        checkinReasonsMap[date]?.add(entry['checkin_reason']);
        checkoutReasonsMap[date]?.add(entry['checkout_reason']);
      }
      // Combine data
      for (var item in dataList) {
        final String? date = item['date']?.toString();
        if (date == null) continue;

        final taskCount = taskCountsMap[date] ?? 0;
        final List<dynamic> checkinReason = checkinReasonsMap[date] ?? [];
        final List<dynamic> checkoutReason = checkoutReasonsMap[date] ?? [];

        checkinReason.removeWhere((element) => ((element.toString().isEmpty) || (element == null)));
        checkoutReason.removeWhere((element) => ((element.toString().isEmpty) || (element == null)));
        // Combine into a single map
        combinedList.add({
          'date': DateFormat('MM-dd-yyyy').format(DateTime.parse(date)),
          'total_hours': item['total_hours'],
          'start_time': item['start_time'] ?? '',
          'end_time': item['end_time'] ?? '',
          'task_count': taskCount.toString(),
          'checkin_reason': checkinReason,
          'checkout_reason': checkoutReason,
        });
      }
      return combinedList;
    }
    combinedData=combineData(dataList,taskCounts,checkInoutReason);

    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation)
      {
        return
          Align(
            alignment: Alignment.topCenter,
            child: Material(
            type: MaterialType.transparency,
            child: Container(
              margin: const EdgeInsets.only(top: 50.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Utils.getText(
                          convertDateToCustomFormat(selectedDateRange)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  //Column Titles
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: const Color.fromRGBO(240, 240, 240, 1),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Row(
                      children: [
                        Expanded(flex: 3, child: Text("Date",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
                        Expanded(flex: 2, child: Text("In",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
                        Expanded(flex: 2, child: Text("Out",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
                        Expanded(flex: 2, child: Text("Total",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
                        Expanded(flex: 1, child: Text("#",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
                      ],
                    ),
                  ),
                  // ListView.builder to show combined data
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    height: combinedData.length * 60.0 > 400 ? 400 : combinedData.length * 60.0,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: combinedData.length,
                      itemBuilder: (context, index) {
                        final entry = combinedData[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 0.2,
                                  blurRadius: 0.1,
                                  offset: Offset(0, 1),
                                ),
                              ],
                              color: AppC.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 2, top: 5,bottom: 5),
                              child:
                              Row(
                                children: [
                                  Utils.getText(entry['date']),
                                  const SizedBox(width: 4,),
                                  (((entry['checkin_reason'] is List) && (entry['checkin_reason'] as List).isNotEmpty)) ||
                                      (((entry['checkout_reason'] is List) && (entry['checkout_reason'] as List).isNotEmpty))
                                      ? GestureDetector(
                                    onTap: () {
                                      TextPopupReason.show(context, {
                                        'date': entry['date'],
                                        'checkin_reason': entry['checkin_reason'],
                                        'checkout_reason': entry['checkout_reason'],
                                      });
                                    },
                                    child: const Icon(
                                      Icons.message_outlined,
                                      color: AppC.red,
                                      size: 12,
                                    ),
                                  )
                                      : const SizedBox(width: 12),
                                  SizedBox(width: 15,),
                                  Expanded(
                                      flex: 2,
                                      child: Utils.getText(entry['start_time'] != '' ? entry['start_time'].substring(0, 5) : '')
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Utils.getText(entry['end_time'] != '' ? entry['end_time'].substring(0, 5) : '')
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Utils.getText(
                                          formatDurationToHM(
                                              entry['total_hours']))),
                                  Expanded(
                                      flex: 1, child: Utils.getText(entry['task_count'])
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
    );
  }
}
