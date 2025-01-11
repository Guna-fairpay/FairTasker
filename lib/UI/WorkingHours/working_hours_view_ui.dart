
import 'package:collection/collection.dart';
import 'package:date_time/date_time.dart' show Time;
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../Component/drawer_ui.dart';
import '../../Utilities/appC.dart';
import '../../Utilities/num.dart';
import '../../Utilities/utils.dart';
import 'package:intl/intl.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import '../CheckIn CheckOut/task_components-setting_ui.dart';
import 'houre_top_notification_popup.dart';


class WorkingHoursViewUI extends StatefulWidget {
  const WorkingHoursViewUI({super.key});

  @override
  State<WorkingHoursViewUI> createState() => _WorkingHoursViewUIState();
}

class _WorkingHoursViewUIState extends State<WorkingHoursViewUI> {
  late TodoViewBloc workingHistoryBloc;
  late TodoViewBloc workingHoursBloc;
  late TodoViewBloc workingActiveBloc;
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
  dynamic selectedPerson;
  dynamic selectedUserId;
  dynamic selectedBase1;


  @override
  void initState() {
    DateTime now = DateTime.now();
    selectedDateRange = DateRange(
      now.subtract(const Duration(days: 7)),
      now,
    );
    super.initState();
    workingHoursBloc=TodoViewBloc();
    workingHoursBloc.add(const GetWorkingHistoryCount());
    workingHoursBloc.add(const GetAssignedToList());

  }
  void _showTopNotification(BuildContext context, List<dynamic> dataList, String userName) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with title and close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Utils.getText(userName,weight: FontWeight.bold, size: 18),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () {
                        overlayEntry.remove(); // Remove overlay on close
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Utils.getText(selectedDateRange.toString(),size: 14),
                const SizedBox(height: 10),
                // Table Header
                Container(
                  color: Colors.grey.shade200,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text("Date", textAlign: TextAlign.center)),
                      Expanded(child: Text("In", textAlign: TextAlign.center)),
                      Expanded(child: Text("Out", textAlign: TextAlign.center)),
                      Expanded(child: Text("Total", textAlign: TextAlign.center)),
                    ],
                  ),
                ),
                // Dynamic Table Rows
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    final data = dataList[index];
                    return _buildTableRow(
                      data['date'] ?? '',
                      data['start_time'] ?? '',
                      data['end_time'] ?? '',
                      data['total_hours'] ?? '',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Automatically remove notification after 10 minutes
    Future.delayed(const Duration(minutes: 10), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  Widget _buildTableRow(String date, String inTime, String outTime, String total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(date, textAlign: TextAlign.center)),
          Expanded(child: Text(inTime, textAlign: TextAlign.center)),
          Expanded(child: Text(outTime, textAlign: TextAlign.center)),
          Expanded(child: Text(total, textAlign: TextAlign.center)),
        ],
      ),
    );
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
    //print("relevantHours $relevantHours");
    final int totalMinutes = relevantHours.fold(
      0, (total, current) => total + timeStringToMinutes(current['active_hours']),
    );
    return minutesToTimeString(totalMinutes);
  }

  String getFirstWord(String fullName) {
    //Time.fromStr("07:15")?.inMins;
    return fullName.split(' ').first;
  }



  List<Map<String, dynamic>> combineData(
      List<Map<String, dynamic>> workhours,
      List<Map<String, dynamic>> workhistory,
      List<Map<String, dynamic>> workActivehours,
      )
  {
    List<Map<String, dynamic>> combinedList = [];
    Map<String, dynamic> combinedItem={};
    combinedList.clear();
    for (var workhour in workhours) {
      final userId = workhour['user']['id'];
      if(userId==null)
      {
        continue;
      }
      // Find matching history item
      Map<String, dynamic>? historyItem; // Initialize to null
      for (var item in workhistory) {
        if (item['users'] != null && item['users']['hrm_id'] == userId) {
          historyItem = item; // Assign the matching item
          break; // Exit the loop once a match is found
        }
      }
      Map<String, dynamic>? activeHoursItem;
      for (var item in workActivehours) {
        if (item['active_hours'] != "00:00" && item['hrm_id'] == userId) {
          activeHoursItem = item; // Assign the matching item
          break; // Exit the loop once a match is found
        }
      }
      final taskCount = historyItem?['task_count'] ?? 0;
      final activeHours = activeHoursItem?['active_hours'] ?? "00:00";
      if (taskCount == 0 && activeHours == "00:00") {
        continue; // Skip this iteration (don't add to combinedList)
      }
      combinedItem = {
        'id': userId,
        'total_working_hours': workhour['user']['total_working_hours'],
        'list': workhour['user']['list'],
        'task_count': historyItem?['task_count'] ?? 0, // Default to 0 if not found
        'first_name': workhour['user']['name'] ?? '', // Default to empty string
        //'active_hours': activeHoursItem?['active_hours'] ?? '', // Default to empty string
      };
      combinedList.add(combinedItem);
    }
    return combinedList;
  }

  List<String> dropdownOptions  = [];
  List<Map<String, dynamic>> filteredData=[];
  String selectedOption = 'All';
  dynamic selectedName;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Utils.getText('Check In/Out', weight: FontWeight.bold, size: 20, color: AppC.black),
              GestureDetector(
                  onTap: () {
                  },
                  child: const Icon(Icons.close,color: AppC.white,)),
            ],
          ),
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
            // print("work history ${state.history}");
            loading = false;
            setState(() {
              workingHistory.clear();
              workingHistory = state.history;
            });
            //print("work history $workingHistory");
          }
          else if(state is GetActiveHoursLoaded)
          {
            //--print("work active hours ${state.data}");
            loading = false;
            // workActiveHours.addAll(state.data); // COMMENTED DUE TO ACTIVE HOURS INCREASED [D.B]
            workActiveHours.clear();
            workActiveHours = state.data;
            //print("work active hours $workActiveHours");
            print("selected date range---> $selectedDateRange");
          }else if(state is AssignedToLoaded)
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
          combinedData = combineData(workHours, workingHistory, workActiveHours);
          filteredData = combinedData;
          print("combined data $combinedData");
          dropDownResource = [{'id':'','full_name':'All'}, ...formattedResources];
          // print("formatted resources $formattedResources");
        },
            builder: (context, state)
            {
              return Stack(
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
                            Row(
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
                        SizedBox(height: 10,),
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
                                width: MediaQuery.of(context).size.width *
                                    0.470, // Responsive width
                                child: DateRangeField(
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
                                      String startDate = DateFormat('yyyy-MM-dd').format(selectedDateRange!.start);
                                      String endDate = DateFormat('yyyy-MM-dd').format(selectedDateRange!.end);
                                      print("dates----> $startDate  $endDate");
                                      workingHoursBloc.add(GetWorkingHistoryCount(startDate: startDate,endDate: endDate));
                                      workingHoursBloc.add(GetWorkingHoursData(minDate: startDate, maxDate: endDate));
                                      workingHoursBloc.add(GetActiveHoursData(minDate: startDate, maxDate: endDate));
                                    });
                                  },
                                  selectedDateRange: selectedDateRange,
                                  pickerBuilder: (context, onDateRangeChanged) => datePickerBuilder(context, onDateRangeChanged),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child:
                              Utils.dropdownBox('All'
                                  , dropDownResource,
                                      (value) {
                                    setState(() {
                                      selectedName = value!;
                                      filteredData = selectedName['full_name'] == 'All'
                                          ? combinedData
                                          : combinedData.where((item) {
                                        return item['first_name'] == selectedName['full_name'];
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
                              //print("Updated data in ListviewBuilder $employee");

                              String totalWorkingHours = employee['total_working_hours']!;
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
                              //print("active hours $activeHours");
                              if(activeHours!=null) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child:
                                  Container(
                                    key: ValueKey(employee['id']),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
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
                                              TopNotificationPopup.show(context, dataList: employee['list'], userName: employee['first_name'], selectedDateRange: selectedDateRange.toString());
                                            },
                                            child: Utils.getText(employee['total_working_hours']?.substring(0, 5) ?? ''),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: GestureDetector(
                                                onTap: () {

                                                },
                                                child:
                                                Utils.getText(employee['task_count'].toString() ?? '',)
                                            )
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: Utils.getText("$totalHoursValue" ?? '')
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
