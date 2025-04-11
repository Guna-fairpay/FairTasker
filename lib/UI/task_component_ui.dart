//
// import 'package:fairpytasker/Response/create_expense_field_data.dart';
// import 'package:fairpytasker/Bloc/todo_view_bloc.dart' as tvb;
// import 'package:fairpytasker/event/todo_view_event.dart';
// import 'package:fairpytasker/state/todo_view_state.dart';
// import 'package:fairpytasker/Utilities/appC.dart';
// import 'package:fairpytasker/Utilities/num.dart';
// import 'package:fairpytasker/Utilities/str.dart';
// import 'package:fairpytasker/Utilities/utils.dart';
// import 'package:fairpytasker/Response/create_vehicle_data.dart';
// import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class TaskComponentUI extends StatefulWidget {
//   const TaskComponentUI({Key? key}) : super(key: key);
//
//   @override
//   state<TaskComponentUI> createState() => _TaskComponentUIState();
// }
//
// class _TaskComponentUIState extends state<TaskComponentUI> with TickerProviderStateMixin {
//   late tvb.TodoViewBloc todoViewBloc;
//   TextEditingController nameController = TextEditingController();
//   TextEditingController amountController = TextEditingController();
//   CreateExpenseFieldData? createExpenseFieldData;
//   List<Map<String,dynamic>> cohortsData = [];
//   bool goBack = false;
//   AnimationController? animationController;
//   int? editedVehicleItemId;
//   List<Map<String,dynamic>> taskHistoryConfigurationList = [];
//
//   @override
//   void dispose() {
//     if (animationController != null) {
//       animationController!.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     todoViewBloc = tvb.TodoViewBloc();
//     animationController = BottomSheet.createAnimationController(this);
//     animationController!.duration = Num.bottomSheetStartDuration;
//     animationController!.reverseDuration = Num.bottomSheetEndDuration;
//     animationController!.drive(CurveTween(curve: Curves.easeIn));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             centerTitle: true,
//             elevation: 0,
//             backgroundColor: AppC.trans,
//             leading: IconButton(
//                 onPressed: () {
//                   Utils.hideKeyboard(context);
//                   if (goBack) {
//                     Navigator.of(context).pop();
//                   }
//                   Navigator.of(context).pop();
//                 },
//                 icon: const Icon(
//                   Icons.arrow_back_sharp,
//                   color: AppC.black,
//                 )),
//             title: Utils.getText('Task Components - Settings',
//                 size: 18, weight: FontWeight.w700)),
//         body: WillPopScope(
//           onWillPop: () async {
//             Navigator.of(context).pop();
//             return true;
//           },
//           child: MultiBlocProvider(
//               providers: [
//                 BlocProvider(
//                   create: (context) =>
//                       todoViewBloc..add(const GetTaskHistoryConfiguration()),
//                 ),
//               ],
//               child: MultiBlocListener(
//                   listeners: [
//                     BlocListener<tvb.TodoViewBloc, TodoViewState>(
//                       listener: (context, state) async {
//                         if (state is TaskHistoryConfigurationLoaded) {
//                           taskHistoryConfigurationList.clear();
//                           editedVehicleItemId = null;
//                           taskHistoryConfigurationList.addAll(state.taskHistoryConfigurationList ?? []);
//                           taskHistoryConfigurationList.sort((a, b) => DateTime.parse(a['created_at'] ?? '')
//                               .compareTo(DateTime.parse(b['created_at'] ?? '')));
//                           Utils.showListAsSheet(context, animationController,
//                               listWidget(taskHistoryConfigurationList.reversed.toList()), () {});
//                           goBack = true;
//                         }else if (state is AddTaskConfigurationLoaded) {
//                           clearAllFields();
//                           todoViewBloc.add(const GetTaskHistoryConfiguration());
//                         }else if (state is DeleteTaskConfigurationLoaded) {
//                           todoViewBloc.add(const GetTaskHistoryConfiguration());
//                         }
//                       },
//                     ),
//                   ],
//                   child: BlocBuilder<tvb.TodoViewBloc, TodoViewState>(
//                     builder: (context, state) {
//                       return Stack(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(
//                                 bottom:
//                                     MediaQuery.of(context).size.height * 0.2),
//                             child: SingleChildScrollView(
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 15),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const SizedBox(
//                                       height: 15,
//                                     ),
//                                     Utils.getBackgroundFilledTextFieldFirstLetterCaps(
//                                             'Name', nameController,
//                                             label: Utils.getText('Name')),
//                                     const SizedBox(
//                                       height: 15,
//                                     ),
//                                     Utils.getBackgroundFilledTextFieldFirstLetterCaps(
//                                             'Amount', amountController,
//                                             label: Utils.getText('Amount'),
//                                         textType: TextInputType.number),
//                                     const SizedBox(
//                                       height: 15,
//                                     ),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child:
//                                               Utils.getFilledButton('Save', () {
//                                             manipulateVehicleData();
//                                           }),
//                                         ),
//                                         Visibility(
//                                           visible: editedVehicleItemId != null,
//                                           child: Expanded(
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 15.0),
//                                               child: Utils.getFilledButton(
//                                                   'Cancel', () {
//                                                 clearAllFields();
//                                                 setState(() {});
//                                               }),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(
//                                       height: 15,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Visibility(
//                               visible: state is VehicleDataLoading,
//                               child: Center(
//                                   child: Utils.getProgressIndicator(context)))
//                         ],
//                       );
//                     },
//                   ))),
//         ));
//   }
//
//   void clearAllFields() {
//     localId = 0;
//     nameController.clear();
//     amountController.clear();
//   }
//
//   CreateVehicleData? createVehicleData;
//   void manipulateVehicleData() {
//     if (nameController.text.isEmpty) {
//       Utils.showMobileToast(Str.createTodoAlertText("Name"));
//     } else if (amountController.text.isEmpty) {
//       Utils.showMobileToast(Str.createTodoAlertText("Amount"));
//     } else {
//       // createVehicleData = CreateVehicleData();
//       // createVehicleData!.id = editedVehicleItemId;
//       // createVehicleData!.year = yearController.text;
//       // createVehicleData!.make = makeController.text;
//       todoViewBloc.add(AddConfigurationEvent(id: localId, name: nameController.text, amount: amountController.text));
//     }
//   }
//
//   int localId = 0;
//   TextEditingController searchController = TextEditingController();
//
//   Widget listWidget(List<Map<String,dynamic>> list) {
//     return StatefulBuilder(builder: (context, setState) {
//       return ListView.builder(
//           padding: EdgeInsets.zero,
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: list.length,
//           itemBuilder: (_, index) {
//             return Stack(
//               alignment: Alignment.center,
//               children: [
//                 Utils.commonListItemWithTwoColumns(index, list[index]['name'],
//                     '\$${list[index]['amount']??0}',
//                     () {}, () {
//               //edit tap
//                       editedVehicleItemId = list[index]['id'];
//                       nameController.text = list[index]['name'] ?? '';
//                       amountController.text = list[index]['amount'] ?? '';
//                     }, () {
//               //delete tap
//               setState(() {});
//               Utils.getAlertDialog(context, () {
//                 localId = list[index]['id']!;
//                 Navigator.of(context).pop();
//                 setState(() {});
//                 todoViewBloc.add(DeleteTaskConfigurationEvent(id: list[index]['id']));
//                 });
//                 }),
//                 Visibility(
//                     visible: localId == list[index]['id']!,
//                     child: Center(
//                         child: Utils.getProgressIndicator(context,
//                             height: 35, width: 35)))
//               ],
//             );
//           });
//     });
//   }
//
//   void doSetState() {
//     setState(() {});
//   }
// }
