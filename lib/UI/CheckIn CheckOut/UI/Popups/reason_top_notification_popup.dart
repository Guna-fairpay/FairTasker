

import 'dart:developer';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/UI/Popups/text_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';
import '../../Bloc/workHoursBloc.dart';
import '../../Event/workingHoursEvent.dart';
import '../../State/workingHoursState.dart';


bool loading=false;
String fromDate='';
String toDate='';
List<Map<String, dynamic>> combinedData=[];


class ReasonTopNotificationPopup {
  static void show(
      BuildContext context, {
        required String userName,
        required List<Map<String, dynamic>> taskComments,
        required String selectedDateRange,
        required int hrmId,
        required String startDate,
        required String endDate, required List<dynamic> dataList,
      }) {
      _showReasonTopNotification(context, userName, taskComments, selectedDateRange, hrmId, startDate, endDate, dataList);
  }
  static void _showReasonTopNotification(
      BuildContext context,
      String userName,
      List<Map<String, dynamic>> taskComments,
      String selectedDateRange, int hrmId, String startDate, String endDate, List dataList,
      ) {
    print("Comments.... $taskComments");


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
        final regex = RegExp(r'(\d+)h\s*(\d+)m');
        final match = regex.firstMatch(totalHours);

        if (match != null) {
          final hours = int.parse(match.group(1)!);
          final minutes = int.parse(match.group(2)!);
          final totalMinutes = (hours * 60) + minutes;
          return Text(
            totalHours,
            style: TextStyle(
              color: totalMinutes < (6 * 60) ? AppC.red : Colors.black,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'Invalid Format',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          );
        }
      } catch (e) {
        print('Error parsing total hours: $e');
        return const Text(
          'Invalid Format',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        );
      }
    }
    final ScrollController tableScrollController = ScrollController();
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return BlocProvider(
          create: (context) => WorkingHoursBloc()
            ..add(
              fetchEmployeeCommentEvent(
                hrmId: hrmId,
                fromDate: startDate,
                toDate: endDate,
                dataList: dataList,
                ReasonPopupSelectedDateRange: selectedDateRange,
              ),
            ),
          child: BlocListener<WorkingHoursBloc, WorkingHoursState>(
            listener: (context, state) {
              if (state.isLoading) {
                EasyLoading.show();
              } else {
                if (EasyLoading.isShow) EasyLoading.dismiss();
              }
            },
            child: BlocBuilder<WorkingHoursBloc, WorkingHoursState>(
              builder: (context, state) {
                final maxTableHeight = MediaQuery.of(context).size.height * 0.8 - 200;

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
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.9,
                      ),
                      child: SingleChildScrollView(
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
                                    child: Table(
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
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: maxTableHeight,
                                    ),
                                    child: ScrollbarTheme(
                                      data: ScrollbarThemeData(
                                        thumbColor: WidgetStateProperty.all(AppC.grey),
                                        trackColor: WidgetStateProperty.all(const Color.fromRGBO(240, 240, 240, 1)),
                                        minThumbLength: 5.0,
                                        interactive: true,
                                      ),
                                      child: Scrollbar(
                                        controller: tableScrollController,
                                        thumbVisibility: true,
                                        trackVisibility: true,
                                        thickness: 10.0,
                                        interactive: true,
                                        radius: const Radius.circular(3.0),
                                        child: SingleChildScrollView(
                                          controller: tableScrollController,
                                          child: Table(
                                            columnWidths: const {
                                              0: FlexColumnWidth(3), // Date
                                              1: FlexColumnWidth(2), // Total
                                              2: FlexColumnWidth(3), // Reason
                                              3: FlexColumnWidth(3), // Comments
                                            },
                                            children: List.generate(state.comments.length, (index) {
                                              final item = state.comments[index];
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
                                                    child: buildTotalHoursWidget(formatTime(item['total_hours'].toString())),
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
                                            }
                                            ),
                                          ),
                                        ),
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
                  ),
                );
              },
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