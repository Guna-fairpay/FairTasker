import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/UI/WorkingHours/work_time_task_view.dart';
import 'package:flutter/material.dart';
import '../../Component/bottom_nav_for_task.dart';
import '../../Component/drawer_ui.dart';
import '../../Utilities/appC.dart';
import '../../Utilities/num.dart';
import '../../Utilities/utils.dart';
import 'package:intl/intl.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import '../CheckIn CheckOut/task_components-setting_ui.dart';
import 'hours_view.dart';

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

  @override
  void initState() {
    super.initState();
    workingHistoryBloc=TodoViewBloc();
    workingHoursBloc=TodoViewBloc();
    workingHoursBloc.add(const GetWorkingHistoryCount());
    workingActiveBloc=TodoViewBloc();
    employees = [
      {
        'Name': 'Hasnath Mohammed',
        'Active': '00:00',
        'Hours': '02:00',
        'Task': '16',
        'No': '1'
      },
      {
        'Name': 'Inshaf Nazir',
        'Active': '00:00',
        'Hours': '05:00',
        'Task': '04',
        'No': '16'
      },
      {
        'Name': 'Kareem Anas',
        'Active': '00:00',
        'Hours': '00:00',
        'Task': '24',
        'No': '24'
      },
      {
        'Name': 'Abdullah khan',
        'Active': '00:00',
        'Hours': '10:20',
        'Task': '164',
        'No': '4'
      },
      {
        'Name': 'Product Owner Admin',
        'Active': '00:00',
        'Hours': '01:20',
        'Task': '12',
        'No': '12'
      },
      {
        'Name': 'Zohaib Ahmed',
        'Active': '00:00',
        'Hours': '08:00',
        'Task': '64',
        'No': '14'
      },
      {
        'Name': 'Mudassir Iqbal',
        'Active': '00:00',
        'Hours': '03:00',
        'Task': '44',
        'No': '2'
      }
    ];
    filteredEmployees = employees;
  }

  void _onflidernamesChanged(String? value) {
    setState(() {
      selectName = value;
      // Filter employees based on selected name
      if (selectName == 'All') {
        filteredEmployees = employees;
      } else {
        filteredEmployees = employees.where((employee) {
          return employee['Name'] == selectName;
        }).toList();
      }
    });
  }

  List<Map<String, dynamic>> workingHistory=[];
  List<Map<String, dynamic>> workingHistoryExtract=[];
  List<Map<String, dynamic>> workHours = [];
  List<Map<String, dynamic>> workActiveHours = [];
  List<Map<String, dynamic>> combinedData = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3,
      child: Scaffold(
        backgroundColor: AppC.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(55, 78, 140, 1),
            ),

            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Utils.getText('Check In/Out', weight: FontWeight.bold, size: 20, color: AppC.white),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const BottomNavigationForTaskView(
                            selectedIndex: 2,
                            message: '',
                          ),
                        ));
                      },
                      child: const Icon(Icons.close,color: AppC.white,)),
                ],
              ),
            ),
          ),
        ),
        body:BlocProvider(
          create: (context) => workingHoursBloc..add(GetWorkingHoursData(minDate: '', maxDate: '')),
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
              //--print("work hours ${state.data}");
              loading=false;
              workHours.addAll(state.data);

              //print("work history ${workingHistory}");
            }
            else if(state is GetWorkingHistoryLoaded)
            {
              print("work history ${state.history}");
              loading = false;
              workingHistory.addAll(state.history);

              //print("work history $workingHistory");
            }
            else if(state is GetActiveHoursLoaded)
            {
              //extractedActiveData
              //--print("work active hours ${state.data}");
              loading = false;
              workActiveHours.addAll(state.data);
              //print("work active hours $workActiveHours");
            }
            else {
              setState(() {
                loading = true;
              });
            }
            for (var history in workingHistory) {
              var hrmId = history['users']?['hrm_id'];
              print("Looking for hrmId: $hrmId");
              if (hrmId == null) {
                print("Skipping entry with null hrmId");
                continue;
              }
              var matchingWorkHours = workHours.firstWhere(
                      (work) => work['user'] != null && work['user']['id'] == hrmId, orElse: () => {});
              var matchingActiveHours = workActiveHours.firstWhere(
                      (active) => active['hrm_id'] == hrmId, orElse: () => {});
              print("matchingWorkHours: $matchingWorkHours");
              print("matchingActiveHours: $matchingActiveHours");

              if (matchingWorkHours != null && matchingActiveHours != null) {
                combinedData.add({
                  'first_name': history['users']?['first_name'] ?? 'Unknown',
                  'total_working_hours': matchingWorkHours['user'] != null
                      ? matchingWorkHours['user']['total_working_hours'] ?? '00:00:00'
                      : '00:00:00',
                  'task_count': history['task_count'] ?? 0,
                  'list': matchingWorkHours['user']?['list'] ?? [],
                  'active_Hours':matchingActiveHours['active_hours'],
                });
              } else {
                print("Could not find matching data for hrmId: $hrmId");
              }
            }
            print("Combined Data: $combinedData");
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
                              SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width *
                                    0.470, // Responsive width
                                child: DateRangeField(
                                  decoration: InputDecoration(
                                    contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 12),
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
                                  pickerBuilder: datePickerBuilder,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Utils.buildDropdownButton(
                                  '',
                                  names,
                                  selectName,
                                  _onflidernamesChanged,
                                ),
                              ),
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
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: combinedData.length,
                              itemBuilder: (context, index) {
                                final employee = combinedData[index];
                                //final name= employee['user']['id']==workHours['users']['hrm_id']?workHours['first_name']:"null";
                                //print("name is $name");
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0.5),
                                  child: Container(
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
                                            child: employee['first_name'] != null
                                                ? Utils.getText(
                                              "${employee['first_name']}",
                                              color: AppC.black,
                                            ):SizedBox.shrink()
                                        ),
                                        Expanded(
                                            flex: 3,
                                            child: Utils.getText(employee['active_Hours'] ?? '')),
                                        Expanded(
                                            flex: 3,
                                            child: GestureDetector(
                                                onTap: () {

                                                },
                                                child:
                                                Utils.getText("${employee['total_working_hours']}" ?? ''))),
                                        Expanded(
                                            flex: 2,
                                            child: GestureDetector(
                                                onTap: () {

                                                },
                                                child:
                                                Utils.getText("${employee['task_count']}",))),
                                        Expanded(
                                            flex: 2,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: Utils.getText("listLength" ?? ''))),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                );
              }
          ),
        ),

        drawer: const DrawerView(),
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

  void doSetState() {
    setState(() {});
  }
}

