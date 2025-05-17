import 'dart:developer';

import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';
import '../../Bloc/workHoursBloc.dart';
import '../../Event/workingHoursEvent.dart';
import '../../State/workingHoursState.dart';
import '../extended_details_day.dart';

bool loading = false;
String fromDate = '';
String toDate = '';

class HoursPopup {
  static void show(
      BuildContext context, {
        required List<dynamic> dataList,
        required String userName,
        required String selectedDateRange,
        required int empID,
        required int hrmID,
        required String fromDate,
        required String toDate,
      }) {
    _showTopNotification(context, dataList, userName, selectedDateRange, empID, hrmID, fromDate, toDate);
  }

  static void _showTopNotification(
      BuildContext context,
      List<dynamic> dataList,
      String userName,
      String selectedDateRange,
      int empID,
      int hrmID,
      String fromDate,
      String toDate,
      ) {
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
        return "$formattedStartDate - $formattedEndDate";
      } catch (e) {
        return "Invalid date format";
      }
    }

    final ScrollController tableScrollController = ScrollController();

    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return BlocProvider(
          create: (context) => WorkingHoursBloc()
            ..add(HoursPopupEvent(
              hrmId: hrmID,
              fromDate: fromDate,
              toDate: toDate,
              dataList: dataList,
              userName: userName,
              HoursPopupSelectedDateRange: selectedDateRange,
              empID: empID,
            )),
          child: BlocListener<WorkingHoursBloc, WorkingHoursState>(
            listener: (context, state) {
              if (state.isLoading) {
                EasyLoading.show();
              } else {
                if (EasyLoading.isShow) EasyLoading.dismiss();
                log("${state.hoursData1}", name: "hoursData1");
              }
            },
            child:
            BlocBuilder<WorkingHoursBloc, WorkingHoursState>(
              builder: (context, state) {
                final maxTableHeight = MediaQuery.of(context).size.height * 0.8 - 200;
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
                                        1: FlexColumnWidth(2), // In
                                        2: FlexColumnWidth(2), // Out
                                        3: FlexColumnWidth(2), // Total
                                        4: FlexColumnWidth(1), // #
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
                                                "In",
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 8.0),
                                              child: Text(
                                                "Out",
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
                                                "#",
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
                                              1: FlexColumnWidth(2), // In
                                              2: FlexColumnWidth(2), // Out
                                              3: FlexColumnWidth(2), // Total
                                              4: FlexColumnWidth(1), // #
                                            },
                                            children: List.generate(state.hoursData1.length, (index) {
                                              final entry = state.hoursData1[index];
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
                                                      entry['date'],
                                                      align: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                    child: Utils.getText(
                                                      entry['start_time'] != '' ? entry['start_time'].toString().substring(0, 5) : '',
                                                      align: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                    child: Utils.getText(
                                                      entry['end_time'] != '' ? entry['end_time'].toString().substring(0, 5) : '',
                                                      align: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                    child: Utils.getText(
                                                      formatDurationToHM(entry['total_hours']),
                                                      align: TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                    child: GestureDetector(
                                                      onTap: () => context.push(ExtendedDetailsDay(userName: userName ,fromDate: fromDate, toDate: toDate, userId: empID, data: entry,), fullscreenDialog: true),
                                                      child: Utils.getText(
                                                        entry['task_count'],
                                                        align: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
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