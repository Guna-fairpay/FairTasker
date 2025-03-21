

import 'dart:developer';

import 'package:fairpytasker/UI/CheckIn%20CheckOut/UI/Popups/text_popup.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';


bool loading=false;
String fromDate='';
String toDate='';
List<Map<String, dynamic>> combinedData=[];


class ReasonTopNotificationPopup {
  static void show(
      BuildContext context, {
        required List<dynamic> dataList,
        required String userName,
        required String selectedDateRange,
        required int hrmID,
        required List<Map<String, dynamic>> taskComments,
      }) {
    _showReasonTopNotification(context, dataList, userName, selectedDateRange, hrmID, taskComments);
  }
  static void _showReasonTopNotification(
      BuildContext context,
      List<dynamic> dataList,
      String userName,
      String selectedDateRange,
      int hrmID,
      List<Map<String, dynamic>> taskComments,
      ) {
    print("employee $dataList");
    print("Comments $taskComments");

    String convertDateToCustomFormat(String inputDate) {
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
        log("$formattedStartDate - $formattedEndDate",name:"convertDateToCustomFormat");
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

    String formatDateMMDDYYYY(String dateString) {
      try {
        DateTime dateTime = DateTime.parse(dateString);
        String formattedDate = DateFormat('MM-dd-yyyy').format(dateTime);
        log("$formattedDate",name:"formatDateMMDDYYYY");
        return formattedDate;
      } catch (e) {
        print('Error formatting date: $e');
        return 'Invalid Date';
      }
    }

    List<Map<String, dynamic>> combineData(List<dynamic> dataList, List<Map<String, dynamic>> taskCounts) {
      List<Map<String, dynamic>> combinedList = [];
      Map<String, List<Map<String, dynamic>>> taskCountsMap = {};
      for (var task in taskCounts) {
        final String? date = task['date'] != null
            ? DateFormat('yyyy-MM-dd').format(DateTime.parse(task['date']))
            : null;

        if (date != null) {
          taskCountsMap.putIfAbsent(date, () => []).add(task);
        }
      }
      for (var item in dataList) {
        final String? date = item['date']?.toString();
        if (date == null) {
          continue;
        }
        final List<Map<String, dynamic>>? taskDataList = taskCountsMap[date];

        String reason = '';
        String comments = '';
        if (taskDataList != null && taskDataList.isNotEmpty) {
          reason = taskDataList.map((task) => task['reason']?.toString() ?? '').join(', ');
          comments = taskDataList.map((task) => task['comments']?.toString() ?? '').join(', ');
        }
        combinedList.add({
          'date': formatDateMMDDYYYY(date),
          'total_hours': item['total_hours'] ?? '',
          'start_time': item['start_time'] ?? '',
          'end_time': item['end_time'] ?? '',
          'reason': reason,
          'comments': comments,
        });
      }
      return combinedList;
    }

    combinedData = combineData(dataList, taskComments);
    log("$combinedData",name:"combinedData");

    // String calculateTotalHours(String startTime, String endTime) {
    //   if (startTime != '' && endTime != '') {
    //     DateTime start = DateFormat('HH:mm:ss').parse(startTime);
    //     DateTime end = DateFormat('HH:mm:ss').parse(endTime);
    //     if (end.isBefore(start)) {
    //       end = end.add(Duration(days: 1));
    //     }
    //     Duration duration = end.difference(start);
    //     int hours = duration.inHours;
    //     int minutes = duration.inMinutes % 60;
    //     log("$hours $minutes",name:"calculateTotalHours");
    //     return '${hours}h ${minutes}m';
    //   }
    //   return '0h 0m';
    // }

    String formatTime(String timeString) {
      print("timeString $timeString");
      try {
        List<String> parts = timeString.split(':');
        if (parts.length != 3) {
          throw Exception("Invalid time format. Expected format: 'HH:mm:ss'");
        }
        int hours = int.parse(parts[0]);
        int minutes = int.parse(parts[1]);
        return '${hours}h ${minutes}m';
      } catch (e) {
        print("Error formatting time: $e");
        return "Invalid Time";
      }
    }

    Widget buildTotalHoursWidget(String totalHours) {
      try {
        // Regular expression to match the "Xh Ym" format
        final regex = RegExp(r'(\d+)h\s*(\d+)m');
        final match = regex.firstMatch(totalHours);

        if (match != null) {
          // Extract hours and minutes from the matched groups
          final hours = int.parse(match.group(1)!);
          final minutes = int.parse(match.group(2)!);

          // Calculate total minutes for comparison
          final totalMinutes = (hours * 60) + minutes;

          // Return a Text widget with conditional styling
          return Text(
            totalHours,
            style: TextStyle(
              color: totalMinutes < (6 * 60) ? AppC.red : Colors.black,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          );
        } else {
          // Handle invalid format (e.g., if the string doesn't match the expected pattern)
          return const Text(
            'Invalid Format',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black, // Default color for invalid format
            ),
          );
        }
      } catch (e) {
        // Handle parsing errors
        print('Error parsing total hours: $e');
        return const Text(
          'Invalid Format',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black, // Default color for invalid format
          ),
        );
      }
    }

    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
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
                      Utils.getText(convertDateToCustomFormat(selectedDateRange)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Table for Header and Data
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Column(
                      children: [
                        // Header Row
                        Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(240, 240, 240, 1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          child:
                          Table(
                            columnWidths: const {
                              0: FlexColumnWidth(3), // Date
                              1: FlexColumnWidth(2), // Total
                              2: FlexColumnWidth(3), // Reason
                              3: FlexColumnWidth(3), // Comments
                            },
                            children: const [
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      "Date",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      "Total",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      "Reason",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      "Comments",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, thickness: 1),
                        // Data Rows
                        SizedBox(
                          height: 200,
                          child: SingleChildScrollView(
                            child: Table(
                              columnWidths: const {
                                0: FlexColumnWidth(3), // Date
                                1: FlexColumnWidth(2), // Total
                                2: FlexColumnWidth(3), // Reason
                                3: FlexColumnWidth(3), // Comments
                              },
                              children: List.generate(combinedData.length, (index) {
                                final item = combinedData[index];
                                return TableRow(
                                  decoration: BoxDecoration(
                                    color: AppC.white,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Utils.getText(
                                        item['date'],
                                        align: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: buildTotalHoursWidget(formatTime(item['total_hours'].toString()),),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                      child: item['reason'].toString().length > 7
                                          ? GestureDetector(
                                        onTap: () {
                                          TextPopup.show(context, item['reason']);
                                        },
                                        child: Utils.getText(
                                          "${item['reason']}",
                                          overFlow: TextOverflow.ellipsis,
                                          align: TextAlign.center,
                                        ),
                                      )
                                          : Utils.getText(
                                        "${item['reason']}",
                                        align: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                      child: item['comments'].toString().length > 7
                                          ? GestureDetector(
                                        onTap: () {
                                          TextPopup.show(context, item['comments']);
                                        },
                                        child: Utils.getText(
                                          "${item['comments']}",
                                          overFlow: TextOverflow.ellipsis,
                                          align: TextAlign.center,
                                        ),
                                      )
                                          : Utils.getText(
                                        "${item['comments']}",
                                        align: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
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