import 'package:date_time/date_time.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/UI/reason_employee_task_history.dart';
import 'package:fairpytasker/main.dart';
import 'package:flutter/material.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Event/workingHoursEvent.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/State/workingHoursState.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Bloc/workHoursBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Component/task_expansion.dart';
import '../../../Component/task_expansion_list_tile.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';

class WorkingHoursTaskUI extends StatefulWidget {
  final Map<String, dynamic> workingHoursData;
  final String dateRange;
  const WorkingHoursTaskUI({super.key, required this.workingHoursData, required this.dateRange});

  @override
  State<WorkingHoursTaskUI> createState() => _WorkingHoursTaskUIState();
}

class _WorkingHoursTaskUIState extends State<WorkingHoursTaskUI> {
  bool isExpanded = false;
  bool loading=false;
  late TaskBloc taskBloc;
  late TaskBloc getConfig;
  late Map<String, dynamic> workingHoursData;
  late String dateRange;
  List<dynamic> combinedList=[];

  Map<String, String> parseDateRange(String dateRange) {
    // Split the input by ' - ' to get the start and end dates
    final dates = dateRange.split(' - ');

    // Helper function to convert "DD/MM/YYYY" to "YYYY-MM-DD"
    String formatDate(String date) {
      final parts = date.split('/');
      if (parts.length == 3) {
        return '${parts[2]}-${parts[1]}-${parts[0]}'; // Rearrange parts to YYYY-MM-DD
      } else {
        throw FormatException('Invalid date format: $date');
      }
    }

    // Ensure there are exactly two dates
    if (dates.length != 2) {
      throw FormatException('Invalid date range format: $dateRange');
    }

    return {
      'fromDate': formatDate(dates[0]),
      'toDate': formatDate(dates[1]),
    };
  }


  @override
  void initState() {
    super.initState();
    taskBloc=TaskBloc();
    taskBloc.add(const fetchWorkingGetConfigurationEvent());
    workingHoursData = widget.workingHoursData;
    dateRange = widget.dateRange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Utils.getText("${widget.workingHoursData['first_name']}",
                color: Colors.white, size: 14, weight: FontWeight.bold),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Center(
                      child: Utils.getText("12",
                          size: 14,
                          color: Colors.white,
                          weight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                const Text(
                  '\$84',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: BlocProvider(
        create: (context) => taskBloc..add(fetchEmployeeTaskHistoryEvent(to: '', from: '2024-12-01', userId: workingHoursData['empID'])),
      child: BlocConsumer<TaskBloc, TaskState>(listener: (context, state){
        if(state is TaskLoadingState)
          {
            loading=true;
          }
        else if (state is TaskHistoryLoadedState)
        {
          loading = false;
          print("working hours data ${workingHoursData['empID']}  date range${dateRange}");

          print("Taskhistory ${state.taskHistory}");
        }
        else if(state is GetConfigurationLoadedState)
          {
            print("get config--> ${state.data}");
          }
      },builder: (context, state)
      {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Utils.getText(
                          "01 Sep 2024 - 31 Dec 2024 ${combinedList.length}",
                          size: 14,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Icon(Icons.filter_alt_sharp),
                        )
                      ],
                    ),
                  ),
                ),
                ListView.separated(shrinkWrap: true,itemCount: combinedList.length,itemBuilder: (context, index)
                {
                  final item = combinedList[index];
                  //int count = combinedList[index]['title'];
                  //print("Count $count");
                  return TaskExpansion(
                    leadingText: "Rental",
                    titleText: "4",
                    isInitialExpand: (index % 2 == 0),
                    children: [
                      TaskExpansion(leadingText: "${item['title']}",
                          titleText: "3",
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              leading: Utils.getText("2018 FORD"),trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Utils.getText("10-17-24 ",),
                                Utils.getText("00:30",color: AppC.red)
                                ],
                              ),
                            )
                          ]
                      ),
                    ],
                  );
                }, separatorBuilder: (context, index) => SizedBox(height: 10,),
                ),
                TaskExpansion(
                  leadingText: "Rental",
                  titleText: "4",
                  children: [
                    TaskExpansion(leadingText: "Drop Car Rental",
                        titleText: "3",
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            leading: Utils.getText("2018 FORD"),trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Utils.getText("10-17-24 ",),
                              Utils.getText("00:30",color: AppC.red)
                            ],
                          ),
                          )
                        ]
                    ),
                    const SizedBox(height: 8,),
                    TaskExpansion(leadingText: "Pickup Car Rental",
                        titleText: "1",
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ReasonEmployeeTaskHistory())
                              );
                            },
                            child:
                            TaskExpansionListTile(leadingText: '2019 CHEVROLET SPARK LS',
                              dateText: '10-17-24',
                              timeText: '00:30',
                              timeTextColor: AppC.red,),
                          )
                        ]
                    ),
                  ],
                ),
                const SizedBox(height: 8,),
                TaskExpansion(leadingText: "Repair", titleText: "6", children: []),
                const SizedBox(height: 8,),
                TaskExpansion(leadingText: "Parts", titleText: "0", children: []),
                const SizedBox(height: 8,),
                TaskExpansion(leadingText: "Rental Ready", titleText: "0", children: []),
                const SizedBox(height: 8,),
                TaskExpansion(leadingText: "Maintenance", titleText: "0", children: []),
                const SizedBox(height: 8,),
                TaskExpansion(leadingText: "Operations", titleText: "1", children: []),
                const SizedBox(height: 8,),
                TaskExpansion(leadingText: "Other", titleText: "0", children: []),
              ],
            ),
          ),
        );
      }),
      )



    );
  }
}
