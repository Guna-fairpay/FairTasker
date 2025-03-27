

// working_hours_view_ui.dart
import 'dart:developer';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/UI/task_components_settings_ui_rework.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/UI/working_hours_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';
import '../../../Utilities/utils.dart';
import '../Bloc/workHoursBloc.dart';
import '../Event/workingHoursEvent.dart';
import '../State/workingHoursState.dart';
import 'Popups/hours_top_notification_popup.dart';
import 'Popups/reason_top_notification_popup.dart';


class WorkHoursViewUI extends StatelessWidget {
  WorkHoursViewUI({super.key});
  List<Map<String, dynamic>> filteredData=[];
  List<Map<String, dynamic>> dropDownResource=[];
  Map<String, String> dates={};
  dynamic selectedName;
  DateRange? selectedDateRange;
  DateRange? temporarySelectedDateRange;
  String startDate='';
  String endDate='';

  Map<String, String> generateDateList(String startDate, String endDate) {
    try {
      DateFormat format = DateFormat("yyyy-MM-dd");
      DateTime start = format.parse(startDate);
      DateTime end = format.parse(endDate);
      DateFormat outputFormat = DateFormat("yyyy-MM-dd");
      String formattedStart = outputFormat.format(start);
      String formattedEnd = outputFormat.format(end);
      return {
        'from': formattedStart,
        'to':formattedEnd
      };
    } catch (e) {
      print("Error generating date list: $e");
      return {};
    }
  }

  //needed function in UI
  String removeSeconds(String totalHours) {
    if(totalHours != '' && totalHours != null)
      {
        List<String> parts = totalHours.split(':');
        if (parts.length >= 2) {
          return '${parts[0]}:${parts[1]}';
        } else {
          throw FormatException("Invalid time format: $totalHours");
        }
      }else {
      return '';
    }
  }
  String getFirstWord(String fullName) {
    return fullName.split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkingHoursBloc()..add(WorkingHoursInitialEvent(
        DateFormat('yyyy-MM-dd').format(selectedDateRange?.start ?? DateTime.now().subtract(const Duration(days: 7))),
        DateFormat('yyyy-MM-dd').format(selectedDateRange?.end ?? DateTime.now()),
      )),
      child: BlocListener<WorkingHoursBloc, WorkingHoursState>(
        listener: (context, state) {
          if (state.isLoading) {
            EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            filteredData = state?.combinedData ?? [];
            dropDownResource = [{'id':'','full_name':'All'}, ...state?.resources ?? []];
          }
        },
        child:
        BlocBuilder<WorkingHoursBloc, WorkingHoursState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                children: [
                  const SizedBox(height: 7),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4)
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 0.2,
                          blurRadius: 0.5,
                          offset: Offset(0, 1),
                        ),
                      ],
                      color: Color.fromRGBO(240, 240, 240, 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child:
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(2),
                        },
                        children: const [
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "User",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "CheckIn",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "CheckOut",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "Active",
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4)
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 0.2,
                          blurRadius: 0.5,
                          offset: Offset(0, 1),
                        ),
                      ],
                      color: AppC.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child:
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(2),
                        },
                        children: const [
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child:
                                Text(
                                  "HM",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "08:19 AM",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  " ",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "02:30",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "02:54",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: const Color.fromRGBO(189, 201, 232, 1),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 0.2,
                          blurRadius: 0.5,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Utils.getText('Working Hours History',
                                  size: 15, weight: FontWeight.bold)),
                          SizedBox(
                            height: 30,
                            child: Material(
                              color: AppC.trans,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const TaskComponentsSettingsUI()));
                                },
                                icon: const Icon(Icons.settings),
                                iconSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 42,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppC.fieldBase, width: Num.borderWidthField),
                              borderRadius: BorderRadius.circular(Num.subradiusButton),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child:
                                  DateRangeField(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(right: 10),
                                      border: InputBorder.none, // Remove inner borders
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      hintStyle: Utils.getTextStyle(color: AppC.grey),
                                      isDense: true,
                                      // Reduce space
                                    ),
                                    childBuilder: (context, value)
                                    {
                                      return Row(
                                        children: [
                                          Expanded(child: Utils.getText("${selectedDateRange ?? state.selectedDateRange}",overFlow: TextOverflow.ellipsis,)),
                                        ]
                                      );
                                    },
                                    onDateRangeSelected: (DateRange? value) {
                                      if (value != null) {
                                        selectedDateRange = value; // Only update confirmed selection
                                        startDate = DateFormat('yyyy-MM-dd').format(selectedDateRange!.start);
                                        endDate = DateFormat('yyyy-MM-dd').format(selectedDateRange!.end);
                                        print("startDate $startDate endDate $endDate");

                                        log("${startDate} ${endDate}", name: "startDateEndDate");
                                        log("${selectedDateRange}", name: "selectedDateRange");

                                        // Notify the Bloc
                                        context.read<WorkingHoursBloc>().add(WorkingHoursInitialEvent(startDate, endDate));
                                        dates = generateDateList(startDate, endDate);
                                      }
                                    },
                                    pickerBuilder: (context, onDateRangeChanged) => datePickerBuilder(context, (newRange) {
                                      temporarySelectedDateRange = newRange; // Track temporary changes
                                      onDateRangeChanged(newRange);
                                    },),
                                  ),
                                ),
                                Icon(Icons.calendar_today, color: AppC.grey, size: 18), // Keep icon inline
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child:
                        Utils.dropdownBox('All',dropDownResource,
                                (value) {
                                selectedName = value!;
                                print("selectedName ${selectedName}");
                                context.read<WorkingHoursBloc>().add(ResourceDropDownEvent(selectedName));
                            },
                            labelKey: 'full_name'
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 0.2,
                          blurRadius: 0.5,
                          offset: Offset(0, 1),
                        ),
                      ],
                      color: const Color.fromRGBO(240, 240, 240, 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: Utils.getText('Employee', weight: FontWeight.bold)),
                          Expanded(
                              flex: 3,
                              child: Utils.getText('Active', weight: FontWeight.bold)),
                          Expanded(
                              flex: 3,
                              child: Utils.getText('Hours', weight: FontWeight.bold)),
                          Expanded(
                              flex: 2,
                              child: Utils.getText('Task', weight: FontWeight.bold)),
                          Expanded(
                              flex: 2,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Utils.getText('#', weight: FontWeight.bold))),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                    Builder(
                      builder: (context) {
                        // If dropdown has a selection, filter data, otherwise load state.combinedData
                        final dataList = (selectedName == null || selectedName['full_name'] == 'All')
                            ? state.combinedData
                            : state.combinedData?.where((item) {
                          return getFirstWord(item['first_name']) ==
                              getFirstWord(selectedName['full_name']);
                        }).toList() ?? [];

                        log("${state.dropDownData}", name: "dropDownData");
                        log("${state.combinedData}", name: "combinedData");

                        if (dataList!.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return ListView.builder(
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            final employee = dataList[index];

                            final activeHours = (index < (state.activeHours?.length ?? 0))
                                ? state.activeHours[index]
                                : '00:00';
                            final totalHours = (index < (state.totalHoursValue?.length ?? 0))
                                ? state.totalHoursValue[index]
                                : '';

                            if (activeHours.toString() != '00:00' &&
                                employee?['task_count'].toString() != '0') {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Container(
                                  key: ValueKey(employee?['id']),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  decoration: const BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 0.1,
                                        blurRadius: 0.1,
                                        offset: Offset(0, 1),
                                      )
                                    ],
                                    color: AppC.white,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: Utils.getText(getFirstWord(employee?['first_name'] ?? '')),
                                      ), // Employee
                                      Expanded(
                                        flex: 3,
                                        child: Utils.getText(activeHours),
                                      ), // Active
                                      Expanded(
                                        flex: 3,
                                        child: GestureDetector(
                                          onTap: () {
                                            HoursPopup.show(
                                              context,
                                              hrmId: employee?['hrmID'],
                                              dataList: employee?['list'],
                                              userName: employee?['first_name'],
                                              selectedDateRange: selectedDateRange.toString(),
                                              empID: employee?['empID'],
                                              hrmID: employee?['hrmID'],
                                              fromDate: startDate,
                                              toDate: endDate,
                                            );
                                          },
                                          child: Utils.getText(removeSeconds(employee?['total_working_hours'] ?? '')),
                                        ), // Hours
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => WorkingHoursTaskUI(
                                                      workingHoursData: dataList[index],
                                                      dateRange: dates,
                                                    )));
                                          },
                                          child: Utils.getText(employee?['task_count'].toString() ?? ''),
                                        ), // Task
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: GestureDetector(
                                            onTap: () {
                                              ReasonTopNotificationPopup.show(
                                                context,
                                                dataList: employee?['list'],
                                                userName: employee?['first_name'],
                                                taskComments: state.comments,
                                                selectedDateRange: selectedDateRange.toString(),
                                                hrmId: employee?['hrmID'],
                                                startDate: startDate,
                                                endDate: endDate,
                                              );
                                            },
                                            child: Utils.getText(totalHours.toString()),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink(); // ✅ Hide empty data
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        )

      ),
    );
  }
  Widget datePickerBuilder(
      BuildContext context, dynamic Function(DateRange?) onDateRangeChanged,
      [bool doubleMonth = false]) {
    temporarySelectedDateRange = selectedDateRange;
    return DateRangePickerWidget(
      doubleMonth: doubleMonth,
      initialDateRange: selectedDateRange,
      disabledDates: const [],
      initialDisplayedDate: selectedDateRange?.start ?? DateTime.now(),
      onDateRangeChanged: (newRange) {
        temporarySelectedDateRange = newRange; // Store temporary selection
        onDateRangeChanged(newRange);
      },
      height: 338,
      displayMonthsSeparator: true,
    );
  }
}
