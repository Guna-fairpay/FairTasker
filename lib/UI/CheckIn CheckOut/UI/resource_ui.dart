

// working_hours_view_ui.dart
import 'package:collection/collection.dart';
import 'package:date_time/date_time.dart' show Time;
import 'package:fairpytasker/UI/CheckIn%20CheckOut/UI/task_components_settings_ui_rework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';
import '../../../Utilities/utils.dart';
import '../Bloc/workHoursBloc.dart';
import '../Event/workingHoursEvent.dart';
import '../State/workingHoursState.dart';
import 'task_components-setting_ui.dart';


class WorkHoursViewUI extends StatelessWidget {
  WorkHoursViewUI({super.key});
  List<Map<String, dynamic>> filteredData=[];
  List<Map<String, dynamic>> dropDownResource=[];
  Map<String, String> dates={};
  dynamic selectedName;
  DateRange? selectedDateRange;
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
    List<String> parts = totalHours.split(':');

    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    } else {
      throw FormatException("Invalid time format: $totalHours");
    }
  }

  String getFirstWord(String fullName) {
    return fullName.split(' ').first;
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkingHoursBloc()..add(const WorkingHoursInitialEvent('','')),
      child: BlocListener<WorkingHoursBloc, WorkingHoursState>(
        listener: (context, state) {
          if (state.isLoading) {
            EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            filteredData = state.combinedData!;
            dropDownResource = [{'id':'','full_name':'All'}, ...state.resources!];
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
                      child: Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: Utils.getText('User', weight: FontWeight.bold)),
                          Expanded(
                              flex: 3,
                              child: Utils.getText('CheckIn', weight: FontWeight.bold)),
                          Expanded(
                              flex: 3,
                              child: Utils.getText('CheckOut', weight: FontWeight.bold)),
                          Expanded(
                              flex: 2,
                              child: Utils.getText('Active', weight: FontWeight.bold)),
                          Expanded(
                              flex: 2,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Utils.getText('Total', weight: FontWeight.bold)
                              )),
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
                      child: Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: Utils.getText('IA', weight: FontWeight.bold)),
                          Expanded(
                              flex: 3,
                              child: Utils.getText('05:09 AM', weight: FontWeight.bold)),
                          Expanded(
                              flex: 3,
                              child: Utils.getText('', weight: FontWeight.bold)),
                          Expanded(
                              flex: 2,
                              child: Utils.getText('00:00', weight: FontWeight.bold)),
                          Expanded(
                              flex: 2,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Utils.getText('00:00', weight: FontWeight.bold))),
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
                          height: 35,
                          width: MediaQuery.of(context).size.width * 1, // Responsive width
                          child:
                          DefaultTextStyle(
                            style: const TextStyle(color: AppC.black, fontSize: 12),
                            textAlign: TextAlign.center,
                            child:
                            DateRangeField(
                              decoration: InputDecoration(
                                contentPadding:
                                const EdgeInsets.only(left: 0,top: 0,right: 0,bottom: 0),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppC.fieldBase, width: Num.borderWidthField),
                                  borderRadius:
                                  BorderRadius.circular(Num.subradiusButton),
                                ),
                                hintStyle: Utils.getTextStyle(color: AppC.grey),
                                hintText: 'Select date range',
                              ),
                              onDateRangeSelected: (DateRange? value) {
                                  selectedDateRange = value;
                                  startDate = DateFormat('yyyy-MM-dd').format(selectedDateRange!.start);
                                  endDate = DateFormat('yyyy-MM-dd').format(selectedDateRange!.end);
                                  print("startDate ${startDate} endDate ${endDate}");
                                  context.read<WorkingHoursBloc>().add(WorkingHoursInitialEvent(startDate, endDate));
                                  dates = generateDateList(startDate, endDate);
                              },
                              selectedDateRange: selectedDateRange,
                              pickerBuilder: (context, onDateRangeChanged) => datePickerBuilder(context, onDateRangeChanged),
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
                        final dataList = state.dropDownData.isNotEmpty
                            ? state.dropDownData.where((dropdownItem) {
                          return state.combinedData?.any((combinedItem) =>
                          dropdownItem['full_name'] == combinedItem['name']) ?? false;
                        }).toList()
                            : state.combinedData;
                        return ListView.builder(
                          itemCount: dataList?.length,
                          itemBuilder: (context, index) {
                            final employee = dataList?[index];
                            final activeHours = (index < state.activeHours.length)
                                ? state.activeHours[index]
                                : '';
                            if (activeHours.toString() != '00:00' && employee?['task_count'].toString() != '0') {
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
                                      Expanded(flex: 5, child: Utils.getText(getFirstWord(employee!['first_name']))),
                                      Expanded(flex: 3, child: Utils.getText(activeHours)),
                                      Expanded(
                                        flex: 3,
                                        child: GestureDetector(
                                          onTap: () {
                                            // Handle tap event
                                          },
                                          child: Utils.getText(removeSeconds(employee!['total_working_hours'])),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: GestureDetector(
                                          onTap: () {
                                            // Handle tap event
                                          },
                                          child: Utils.getText(employee!['task_count'].toString()),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: GestureDetector(
                                            onTap: () {
                                              // Handle tap event
                                            },
                                            child: Utils.getText(state.totalHoursValue.isNotEmpty
                                                ? state.totalHoursValue[index].toString()
                                                : ''),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink(); // Avoid null return
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
    return DateRangePickerWidget(
      doubleMonth: doubleMonth,
      initialDateRange: selectedDateRange,
      disabledDates: const [],
      initialDisplayedDate: selectedDateRange?.start ?? DateTime.now(),
      onDateRangeChanged: onDateRangeChanged,
      height: 338,
      displayMonthsSeparator: true,
    );
  }
}
