import 'package:collection/collection.dart';
import 'package:date_time/date_time.dart' show Time;
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';

import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Bloc/workHoursBloc.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/UI/Popups/reason_top_notification_popup.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/UI/working_hours_task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';
import '../../../Utilities/utils.dart';
import 'package:intl/intl.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import '../../dialog/tasker_check_in_out_completed_dialog.dart';
import 'task_components-setting_ui.dart';
import 'Popups/hours_top_notification_popup.dart';




class WorkingHoursViewUI extends StatefulWidget {
  const WorkingHoursViewUI({super.key});

  @override
  State<WorkingHoursViewUI> createState() => _WorkingHoursViewUIState();
}

class _WorkingHoursViewUIState extends State<WorkingHoursViewUI> {
  late TodoViewBloc workingHistoryBloc;
  late TodoViewBloc workingHoursBloc;
  late TodoViewBloc workingActiveBloc;
  //late TaskBloc getTaskCountBloc;
  late Map<String, String> result={};
  DateTime? selectedDate;
  DateRange? selectedDateRange;
  TextEditingController dateController = TextEditingController();
  List<Map<String, String>> employees = [];
  List<Map<String, String>> filteredEmployees = [];
  bool loading=false;
  List<String> names = [];
  String? selectName = 'All';
  String activeHours='';
  List<Map<String, dynamic>> resources=[];
  List<Map<String, dynamic>> workingHistory=[];
  List<Map<String, dynamic>> workHours = [];
  List<Map<String, dynamic>> workActiveHours = [];
  List<Map<String, dynamic>> updatedData=[];
  List<Map<String, dynamic>> matchedData = [];
  List<Map<String, dynamic>> combinedData=[];
  List<Map<String, dynamic>> formattedResources=[];
  List<Map<String, dynamic>> dropDownResource=[];
  List<Map<String, dynamic>> filteredData=[];
  Map<String, String> dates={};
  dynamic selectedName;
  dynamic selectedPerson;
  dynamic selectedUserId;
  dynamic selectedBase1;
  String startDate='';
  String endDate='';


  @override
  void initState() {
    DateTime now = DateTime.now();
    selectedDateRange = DateRange(
      now.subtract(const Duration(days: 7)),
      now,
    );
    super.initState();
    workingHoursBloc=TodoViewBloc();
    //getTaskCountBloc=TaskBloc();
    workingHoursBloc.add(const GetWorkingHistoryCount());
    workingHoursBloc.add(const GetAssignedToList());
  }

  int timeStringToMinutes(String time) {
    final minutes = Time.fromStr(time)?.inMins;
    return minutes!;
  }
  String minutesToTimeString(int minutes) {
    final hours = minutes ~/ 60; // Integer division for hours
    final remainingMinutes = minutes % 60; // Modulus for remaining minutes
    return '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}';
  }

  String calculateActiveHours(
      List<Map<String, dynamic>> employeeActiveTotalHours, Map<String, dynamic> item) {
    final relevantHours = employeeActiveTotalHours.where(
          (activeHour) => activeHour['hrm_id']?.toString() == item['id']?.toString(),
    );
    final int totalMinutes = relevantHours.fold(
      0, (total, current) => total + timeStringToMinutes(current['active_hours']),
    );
    return minutesToTimeString(totalMinutes);
  }

  String getFirstWord(String fullName) {
    return fullName.split(' ').first;
  }
  String removeSeconds(String totalHours) {
    List<String> parts = totalHours.split(':');

    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    } else {
      throw FormatException("Invalid time format: $totalHours");
    }
  }


  List<Map<String, dynamic>> combineData(
      List<Map<String, dynamic>> workhours,
      List<Map<String, dynamic>> workhistory,
      List<Map<String, dynamic>> workActivehours,
      List<Map<String, dynamic>> formattedResource,
      )
  {
    List<Map<String, dynamic>> combinedList = [];
    Map<String, dynamic> combinedItem={};
    combinedList.clear();
    for (var workhour in workhours)
    {
      final userId = workhour['user']['id'];
      final userName = workhour['user']['name'];
      if(userId==null)
      {
        continue;
      }
      Map<String, dynamic>? historyItem; // Initialize to null
      for (var item in workhistory) {
        if (item['users'] != null && item['users']['hrm_id'] == userId) {
          historyItem = item; // Assign the matching item
          break;
        }
      }
      Map<String, dynamic>? activeHoursItem;
      for (var item in workActivehours) {
        if (item['active_hours'] != "00:00" && item['hrm_id'] == userId) {
          activeHoursItem = item; // Assign the matching item
          break;
        }
      }
      Map<String, dynamic>? empID;
      for (var item in formattedResource) {
        if (getFirstWord(item['full_name']) == getFirstWord(userName)) {
          empID = item;
          break;
        }
      }
      final taskCount = historyItem?['task_count'] ?? 0;
      final activeHours = activeHoursItem?['active_hours'] ?? "00:00";
      if (taskCount == 0 && activeHours == "00:00") {
        continue;
      }
      combinedItem = {
        'id': userId,
        'empID':historyItem?['users']['id'],
        'hrmID': historyItem?['users']['hrm_id'] ?? 0,
        'total_working_hours': workhour['user']['total_working_hours'],
        'list': workhour['user']['list'],
        'task_count': historyItem?['task_count'] ?? 0, // Default to 0 if not found
        'first_name': workhour['user']['name'] ?? '', // Default to empty string
      };
      combinedList.add(combinedItem);
    }
    return combinedList;
  }

  Map<String, String> generateDateList(String startDate, String endDate) {
    try {
      DateFormat format = DateFormat("yyyy-MM-dd");
      DateTime start = format.parse(startDate);
      DateTime end = format.parse(endDate);
      DateFormat outputFormat = DateFormat("yyyy-MM-dd"); // Output format (same as input in this case)
      String formattedStart = outputFormat.format(start);
      String formattedEnd = outputFormat.format(end);
      return {
        'from': formattedStart,
        'to':formattedEnd
      };
    } catch (e) {
      print("Error generating date list: $e");
      return {}; // Or throw an exception if you prefer
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: Padding(
          padding: EdgeInsets.all(0),

        ),
      ),
      body:BlocProvider(
        create: (context) => workingHoursBloc..add(const GetWorkingHoursData(minDate: '', maxDate: '')),
        child: BlocConsumer<TodoViewBloc,TodoViewState>(listener: (context, state)
        {
          if (state is TodoListLoading)
          {
            setState(() {
              loading=true;
            });
          }
          else if(state is WorkingHoursLoaded)
          {
            loading=false;
            workHours.clear();
            workHours.addAll(state.data);
          }
          else if(state is GetWorkingHistoryLoaded)
          {
            loading = false;
            setState(() {
              workingHistory.clear();
              workingHistory = state.history;
            });
          }
          else if(state is GetActiveHoursLoaded)
          {
            loading = false;
            // workActiveHours.addAll(state.data); // COMMENTED DUE TO ACTIVE HOURS INCREASED [D.B]
              workActiveHours.clear();
              workActiveHours = state.data;
          }
          else if(state is AssignedToLoaded)
          {
              loading = false;
              resources.clear();
              resources=state.resource!;
              formattedResources = resources.map((resource) {
                return {
                  'id': resource['id'],
                  'full_name': "${resource['first_name']} ${resource['last_name']}",
                };
              }).toList();
          }
          else {
            setState(() {
              loading = true;
            });
          }
          combinedData.clear();
          combinedData = combineData(workHours, workingHistory, workActiveHours, formattedResources);
          filteredData = combinedData;
          dropDownResource = [{'id':'','full_name':'All'}, ...formattedResources];
        },
            builder: (context, state)
            {
              return
                Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child:
                    Column(
                      children: [
                        //const Color.fromRGBO(189, 201, 232, 1),
                        const SizedBox(height: 7,),
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
                          child:
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child:
                            Row(
                              children: [
                                Expanded(
                                    flex: 5,
                                    child:
                                    Utils.getText('User', weight: FontWeight.bold)),
                                Expanded(
                                    flex: 3,
                                    child:
                                    Utils.getText('CheckIn', weight: FontWeight.bold)),
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
                                        child:
                                        Utils.getText('Total', weight: FontWeight.bold))),
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
                          child:
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child:
                            Row(   //Static values
                              children: [
                                Expanded(
                                    flex: 5,
                                    child:
                                    Utils.getText('IA', weight: FontWeight.bold)),
                                Expanded(
                                    flex: 3,
                                    child:
                                    Utils.getText('05:09 AM', weight: FontWeight.bold)),
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
                                        child:
                                        Utils.getText('00:00', weight: FontWeight.bold))),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
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
                                                builder: (context) => const TaskComponentsSettingUI()));
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
                                      hintText: 'Please select a date range',
                                    ),
                                    onDateRangeSelected: (DateRange? value) {
                                      setState(() {
                                        selectedDateRange = value;
                                        startDate = DateFormat('yyyy-MM-dd').format(selectedDateRange!.start);
                                        endDate = DateFormat('yyyy-MM-dd').format(selectedDateRange!.end);
                                        workingHoursBloc.add(GetWorkingHistoryCount(startDate: startDate,endDate: endDate));
                                        workingHoursBloc.add(GetWorkingHoursData(minDate: startDate, maxDate: endDate));
                                        workingHoursBloc.add(GetActiveHoursData(minDate: startDate, maxDate: endDate));
                                        dates = generateDateList(startDate, endDate);
                                      });
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
                              Utils.dropdownBox('All'
                                  ,dropDownResource,
                                      (value) {
                                    setState(() {
                                      selectedName = value!;
                                              filteredData = selectedName['full_name'] == 'All'
                                                  ? combinedData
                                                  : combinedData.where((item) {
                                                return getFirstWord(item['first_name']) == getFirstWord(selectedName['full_name']);
                                              }).toList();
                                    });
                                  } ,
                                  labelKey: 'full_name'),
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
                                    child:
                                    Utils.getText('Employee', weight: FontWeight.bold)),
                                Expanded(
                                    flex: 3,
                                    child:
                                    Utils.getText('Active', weight: FontWeight.bold)),
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
                                        child:
                                        Utils.getText('#', weight: FontWeight.bold))),
                                const SizedBox(height: 5,),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              final employee = filteredData[index];
                              int lessCount = 0;
                              int greaterCount = 0;
                              if (employee['list'] != null)
                              {
                                for (var task in employee['list'])
                                {
                                  final taskTotalHours = task['total_hours']?.split(':') ?? ['0', '0'];
                                  final int taskHours = int.tryParse(taskTotalHours[0]) ?? 0;
                                  final int taskMinutes = int.tryParse(taskTotalHours[1]) ?? 0;
                                  final int totalMinutes = taskHours * 60 + taskMinutes;
                                  if (totalMinutes < 420) {
                                    lessCount++;
                                  } else if (totalMinutes > 540) {
                                    greaterCount++;
                                  }
                                }
                              }
                              int totalHoursValue = lessCount + greaterCount;
                              final String activeHours = calculateActiveHours(workActiveHours, employee);
                              if(activeHours.toString() !='00:00' && employee['task_count'].toString() != '0')
                              {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child:
                                  Container(
                                    key: ValueKey(employee['id']),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    decoration: const BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 0.1,
                                          blurRadius: 0.1,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                      color: AppC.white,
                                    ),
                                    child:
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 5,
                                            child: Utils.getText(getFirstWord(employee['first_name']))
                                        ),
                                        Expanded(
                                            flex: 3,
                                            child: Utils.getText(activeHours ?? '')
                                        ),
                                      Expanded(
                                        flex: 3,
                                        child: GestureDetector(
                                          onTap: () {
                                            // TopNotificationPopup.show(context, dataList: employee['list'],
                                            //     userName: employee['first_name'], selectedDateRange: selectedDateRange.toString(),
                                            //     empID: employee['empID'], hrmID: employee['hrmID']);
                                          },
                                          child: Utils.getText(removeSeconds(employee['total_working_hours'])),
                                        ),
                                      ),
                                        Expanded(
                                            flex: 2,
                                            child: GestureDetector(
                                                onTap: () {
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) => WorkingHoursTaskUI(workingHoursData: filteredData[index], dateRange: dates,)));
                                                },
                                                child:
                                                Utils.getText(employee['task_count'].toString() ?? '',)
                                            )
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: GestureDetector(
                                                    onTap: () {
                                                      // ReasonTopNotificationPopup.show(context, dataList: employee['list'],
                                                      //     userName: employee['first_name'],
                                                      //     selectedDateRange: selectedDateRange.toString(), hrmID: employee['hrmID']);
                                                    },
                                                    child:
                                                    Utils.getText("$totalHoursValue" ?? '',)
                                                ),
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: loading,
                      child: Center(child: Utils.getProgressIndicator(context)))
                ],
              );
            }
        ),
      ),
      drawer: const DrawerView(),
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
