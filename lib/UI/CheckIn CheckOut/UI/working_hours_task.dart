//
// import 'package:flutter/material.dart';
// import 'package:fairpytasker/UI/CheckIn%20CheckOut/Event/workingHoursEvent.dart';
// import 'package:fairpytasker/UI/CheckIn%20CheckOut/State/workingHoursState.dart';
// import 'package:fairpytasker/UI/CheckIn%20CheckOut/Bloc/workHoursBloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import '../Component/task_expansion.dart';
// import '../Component/task_expansion_list_tile.dart';
// import '../../../Utilities/Utils.dart';
// import '../../../Utilities/appC.dart';
// import 'Popups/task_filter.dart';
//
// class WorkingHoursTaskUI extends StatefulWidget {
//   final Map<String, dynamic> workingHoursData;
//   final Map<String, String> dateRange;
//   const WorkingHoursTaskUI({super.key, required this.workingHoursData, required this.dateRange});
//
//   @override
//   State<WorkingHoursTaskUI> createState() => _WorkingHoursTaskUIState();
// }
//
// class _WorkingHoursTaskUIState extends State<WorkingHoursTaskUI> {
//   bool isExpanded = false;
//   bool loading=false;
//   late TaskBloc taskBloc;
//   late TaskBloc getConfig;
//   List<Map<String, dynamic>> categoryGroupData=[];
//   List<Map<String, dynamic>> cohortsData=[];
//   late Map<String, dynamic> workingHoursData;
//   late Map<String, String> dateRange;
//   List<dynamic> combinedList=[];
//
//
//   @override
//   void initState() {
//     super.initState();
//     taskBloc=TaskBloc();
//     taskBloc.add(const fetchWorkingGetConfigurationEvent());
//     taskBloc.add(const fetchTaskCategoryGroupEvent());
//     taskBloc.add(const fetchCohortsDataEvent());
//     workingHoursData = widget.workingHoursData;
//     dateRange = widget.dateRange;
//   }
//
//   String convertDateToCustomFormat(Map<String, String> inputDate)
//   {
//     try {
//       //print("inputDate ${inputDate['from']} ${inputDate['to']}");
//       String startDate = inputDate['from'].toString();
//       String endDate = inputDate['to'].toString();
//       String formattedStartDate = DateFormat("dd MMM yyyy").format(
//         DateFormat("yyyy-MM-dd").parse(startDate),
//       ).toUpperCase();
//       String formattedEndDate = DateFormat("dd MMM yyyy").format(
//         DateFormat("yyyy-MM-dd").parse(endDate),
//       ).toUpperCase();
//       return "$formattedStartDate - $formattedEndDate";
//     } catch (e) {
//       return "Invalid date format";
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppC.white,
//       appBar:
//       AppBar(
//         backgroundColor: AppC.appColor,
//         automaticallyImplyLeading: false,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Utils.getText("${widget.workingHoursData['first_name']}",
//                 color: Colors.white, size: 18, weight: FontWeight.bold),
//             Row(
//               children: [
//                 Container(
//                   width: 40,
//                   height: 20,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: Colors.white),
//                   ),
//                   child: Center(
//                       child: Utils.getText("12",
//                           size: 14,
//                           color: Colors.white,
//                           weight: FontWeight.bold)),
//                 ),
//                 const SizedBox(width: 8),
//                 const Text(
//                   '\$84',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: const Icon(
//                     Icons.close,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ) ,
//       body: BlocProvider(
//         create: (context) => taskBloc..add(fetchEmployeeTaskHistoryEvent(to: dateRange['to'].toString(), from: dateRange['from'].toString(), userId: workingHoursData['empID'])),
//       child: BlocConsumer<TaskBloc, TaskState>(listener: (context, state){
//         if(state is TaskLoadingState)
//           {
//             loading=true;
//           }
//         else if (state is TaskHistoryLoadedState)
//         {
//           loading = false;
//           //print("working hours data ${workingHoursData['empID']}  date range${dateRange}");
//         }
//         else if(state is GetConfigurationLoadedState)
//           {
//             //print("get configs--> ${state.data}");
//           }
//         else if(state is CategoryGroupLoadedState)
//         {
//           categoryGroupData.clear();
//           categoryGroupData.addAll(state.data);
//           //print("get configs--> ${categoryGroupData}");
//         }
//         else if(state is CohortDataLoadedState)
//         {
//           loading = false;
//           cohortsData.clear();
//           cohortsData.addAll(state.data);
//           //print("get configs--> ${cohortsData}");
//         }
//         else{
//           loading = true;
//         }
//       },builder: (context, state)
//       {
//         return
//           Stack(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 20, right: 20),
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Utils.getText(
//                             convertDateToCustomFormat(dateRange),
//                             size: 14,
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               showDialog(
//                                 context: context,
//                                 builder: (context) => CheckboxPopup(cohortsData),
//                               );
//                             },
//                             child: Icon(Icons.filter_alt_sharp),
//                           )
//                         ],
//                       ),
//                     ),
//                     SingleChildScrollView(
//                       child: SizedBox(
//                         height: 600,
//                         child: ListView.separated(shrinkWrap: true,itemCount: categoryGroupData.length,itemBuilder: (context, index)
//                         {
//                           final item = categoryGroupData[index];
//                           return TaskExpansion(
//                             leadingText: "${item['name']}",
//                             titleText: "4",
//                             isInitialExpand: (index % 2 == 0),
//                             children: const [
//                               TaskExpansion(leadingText: "",
//                                   titleText: "",
//                                   children: [
//                                     TaskExpansionListTile(leadingText: '2018 FORD', dateText: '10-17-24', timeText: '00:30',),
//                                     TaskExpansionListTile(leadingText: '2018 FORD', dateText: '10-17-24', timeText: '00:30',)
//                                   ]
//                               ),
//                             ],
//                           );
//                         }, separatorBuilder: (context, index) => SizedBox(height: 10,),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Visibility(
//                   visible: loading,
//                   child: Center(child: Utils.getProgressIndicator(context))),
//             ],
//           );
//       }
//       ),
//       )
//     );
//   }
// }
