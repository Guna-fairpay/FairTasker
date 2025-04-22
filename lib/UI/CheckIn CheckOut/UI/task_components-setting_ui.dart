// import 'dart:developer';
//
// import 'package:fairpytasker/UI/CheckIn%20CheckOut/UI/task_components_settings_tabBar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import '../../../Utilities/Str.dart';
// import '../../../Utilities/appC.dart';
// import '../../../Utilities/prefs.dart';
// import '../../../Utilities/utils.dart';
// import '../Bloc/workHoursBloc.dart';
// import '../Event/workingHoursEvent.dart';
// import '../State/workingHoursState.dart';
//
// class TaskComponentSettingsUI extends StatelessWidget {
//   const TaskComponentSettingsUI({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => WorkingHoursBloc()..add(const TaskComponentsInitialEvent()),
//       child: TaskComponentsSettingView(),
//     );
//   }
// }
//
// class TaskComponentsSettingView extends StatelessWidget {
//   TaskComponentsSettingView({super.key});
//   dynamic selectedBases;
//   dynamic resource;
//   TextEditingController taskNameController = TextEditingController();
//   TextEditingController amountController = TextEditingController();
//   TextEditingController hourlyAmountController = TextEditingController();
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<WorkingHoursBloc, WorkingHoursState>(
//       listener: (context, state) {
//         if (state.isLoading) {
//           EasyLoading.show();
//         } else {
//           if (EasyLoading.isShow) EasyLoading.dismiss();
//           taskNameController.clear();
//           amountController.clear();
//           hourlyAmountController.clear();
//           taskNameController.text = state.taskNameController?.text ?? '';
//           amountController.text = state.amountController?.text ?? '';
//           hourlyAmountController.text = state.hourlyAmountController?.text ?? '';
//           FocusScope.of(context).unfocus();
//           // Reset resource when exiting edit mode or no selected user
//           if (!state.isEditMode) {
//             resource = null;
//             print("Resource reset to null on exit edit mode at ${DateTime.now()}");
//           }
//         }
//       },
//       child: BlocBuilder<WorkingHoursBloc, WorkingHoursState>(
//         builder: (context, state) {
//           print("BlocBuilder state: isEditMode=${state.isEditMode}, resource=$resource, selectedUser=${state.selectedUser}");
//           final isHourlyBased = state.selectedBase?['base'] == 'Hour based';
//
//           if (isHourlyBased && state.selectedUser == null && resource != null) {
//             resource = null;
//             print("Force reset resource to null due to no selected user at ${DateTime.now()}");
//           }
//
//           return Scaffold(
//             backgroundColor: AppC.white,
//             appBar: PreferredSize(
//               preferredSize: const Size.fromHeight(56),
//               child: AppBar(
//                 automaticallyImplyLeading: false,
//                 backgroundColor: AppC.appColor,
//                 title: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Utils.getText("Task Components - Settings",
//                         color: AppC.white, weight: FontWeight.bold, size: 18),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Icon(Icons.close_sharp, color: AppC.white),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             body: SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
//                 child: Form(
//                   autovalidateMode: AutovalidateMode.onUnfocus,
//                   key: formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 16),
//                       if (Session.of.getString(Str.userIdPrefText) == '3')
//                         Utils.dropdownBox(
//                           'Select Mode',
//                           state.selectedBase1,
//                               (value) {
//                             selectedBases = value;
//                             context.read<WorkingHoursBloc>().add(UpdateDropdownValueEvent(value));
//                           },
//                           labelKey: 'base',
//                           initialSelection: state.selectedBase,
//                         ),
//                       const SizedBox(height: 16),
//                       if (Session.of.getString(Str.userIdPrefText) == '3')
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             if (!isHourlyBased) ...[
//                               Utils.getTextFormField('Task Name', taskNameController,
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty) {
//                                       return 'Task Name required';
//                                     }
//                                     return null;
//                                   }),
//                               const SizedBox(height: 16),
//                               Utils.getTextFormField('Amount (\$)',
//                                   amountController,
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty) {
//                                       return 'Amount required';
//                                     }
//                                     return null;
//                                   }),
//                             ] else ...[
//                               StatefulBuilder(
//                                 builder: (context, setState) {
//                                   return Utils.dropdownBox(
//                                     'Select User',
//                                     state.userList,
//                                         (value) {
//                                       setState(() {
//                                         resource = value;
//                                       });
//                                       print("Selected Resource: $resource");
//                                     },
//                                     labelKey: 'first_name',
//                                     labelKey2: 'last_name',
//                                     initialSelection: resource ?? state.selectedUser ?? null,
//                                   );
//                                 },
//                               ),
//                               const SizedBox(height: 16),
//                               Utils.getTextFormField(
//                                   'Amount per hour (\$)',
//                                   hourlyAmountController,
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty) {
//                                       return 'Amount required';
//                                     }
//                                     return null;
//                                   }),
//                             ],
//                             const SizedBox(height: 30),
//                             Row(
//                               children: [
//                                 if (!state.isEditMode)
//                                   Utils.getAddFilledButton("Save", () {
//                                     if (formKey.currentState!.validate()) {
//                                       FocusScope.of(context).unfocus();
//                                       if (!isHourlyBased && taskNameController.text.isNotEmpty && amountController.text.isNotEmpty) {
//                                         context.read<WorkingHoursBloc>().add(CreateTaskEvent(
//                                           taskName: taskNameController.text,
//                                           amount: amountController.text,
//                                           task: 'task',
//                                         ));
//                                       } else if (isHourlyBased && resource != null && hourlyAmountController.text.isNotEmpty) {
//                                         context.read<WorkingHoursBloc>().add(CreateTaskEvent(
//                                           userId: resource['id'],
//                                           amount: hourlyAmountController.text,
//                                           task: 'hourly',
//                                         ));
//                                       } else {
//                                         Utils.showMobileToast("Please fill all required fields");
//                                       }
//                                     }
//                                   }, bgColor: AppC.green),
//                                 if (state.isEditMode)
//                                   Utils.getAddFilledButton("Update", () {
//                                     if (formKey.currentState!.validate()) {
//                                       FocusScope.of(context).unfocus();
//                                       if (state.userId == null) {
//                                         context.read<WorkingHoursBloc>().add(CreateTaskEvent(
//                                           id: state.taskId,
//                                           taskName: taskNameController.text,
//                                           amount: amountController.text,
//                                           task: 'task',
//                                         ));
//                                       } else {
//                                         context.read<WorkingHoursBloc>().add(CreateTaskEvent(
//                                           id: state.taskId,
//                                           userId: resource?['id'] ?? state.userId,
//                                           amount: hourlyAmountController.text,
//                                           task: 'hourly',
//                                         ));
//                                       }
//                                       context.read<WorkingHoursBloc>().add(ExitEditModeEvent());
//                                     }
//                                   }, bgColor: AppC.green),
//                                 if (state.isEditMode) const SizedBox(width: 16),
//                                 if (state.isEditMode)
//                                   Utils.getAddFilledButton("Cancel", () {
//                                     FocusScope.of(context).unfocus();
//                                     context.read<WorkingHoursBloc>().add(ExitEditModeEvent());
//                                   }, bgColor: AppC.red),
//                               ],
//                             ),
//                           ],
//                         ),
//                       const SizedBox(height: 16),
//                       Expanded(
//                         child: SingleChildScrollView(
//                           child: Column(
//                             children: [
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.blue.shade100,
//                                   borderRadius: const BorderRadius.only(
//                                     topLeft: Radius.circular(4),
//                                     topRight: Radius.circular(4),
//                                   ),
//                                 ),
//                                 padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//                                 child: Table(
//                                   columnWidths: const {
//                                     0: FlexColumnWidth(5),
//                                     1: FlexColumnWidth(6),
//                                     2: FlexColumnWidth(3),
//                                   },
//                                   children: [
//                                     TableRow(
//                                       children: [
//                                         const Padding(
//                                           padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
//                                           child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
//                                         ),
//                                         Padding(
//                                           padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
//                                           // child: Text(isHourlyBased ? 'Amount/hr' : 'Amount', style: TextStyle(fontWeight: FontWeight.bold)),
//                                           child: isHourlyBased ? Text('Amount/hr', style: TextStyle(fontWeight: FontWeight.bold)) : Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)),
//                                         ),
//                                         if (Session.of.getString(Str.userIdPrefText) == '3')
//                                           const Padding(
//                                             padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
//                                             child: Text('Action', style: TextStyle(fontWeight: FontWeight.bold)),
//                                           ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Table(
//                                 columnWidths: const {
//                                   0: FlexColumnWidth(2),
//                                   1: FlexColumnWidth(2),
//                                   2: FlexColumnWidth(2),
//                                 },
//                                 border: const TableBorder(
//                                   bottom: BorderSide(color: Colors.black26, width: 0.2),
//                                 ),
//                                 children: (isHourlyBased ? state.hourlyBased : state.taskBased).map((task) {
//                                   return TableRow(
//                                     decoration: const BoxDecoration(
//                                       color: Colors.white,
//                                       border: Border(
//                                         bottom: BorderSide(color: Colors.black, width: 0.2),
//                                       ),
//                                     ),
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Utils.getText(
//                                           isHourlyBased
//                                               ? "${state.resources?.firstWhere((user) => user['id'] == task['user_id'], orElse: () => {})['full_name'] ?? ''}"
//                                               : "${task['task_name']}",
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Utils.getText("\$${task['amount']}"),
//                                       ),
//                                       if (Session.of.getString(Str.userIdPrefText) == '3')
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Row(
//                                             mainAxisAlignment: MainAxisAlignment.end,
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   context.read<WorkingHoursBloc>().add(EnterEditModeEvent());
//                                                   context.read<WorkingHoursBloc>().add(UpdateTaskEvent(
//                                                     id: task['id'],
//                                                     userId: isHourlyBased ? task['user_id'] : null,
//                                                     taskName: !isHourlyBased ? task['task_name'] : null,
//                                                     amount: task['amount'],
//                                                     task: isHourlyBased ? 'hourly' : 'task',
//                                                   ));
//                                                 },
//                                                 child: const Icon(
//                                                   Icons.edit_outlined,
//                                                   size: 20,
//                                                   color: Colors.blue,
//                                                 ),
//                                               ),
//                                               const SizedBox(width: 20),
//                                               GestureDetector(
//                                                 onTap: () async {
//                                                   final confirm = await showCustomDeleteDialog(context);
//                                                   if (confirm == true) {
//                                                     context.read<WorkingHoursBloc>().add(
//                                                         DeleteTaskComponentsEvent(id: task['id']));
//                                                     ScaffoldMessenger.of(context).showSnackBar(
//                                                       const SnackBar(
//                                                         content: Text('Task deleted successfully'),
//                                                       ),
//                                                     );
//                                                   }
//                                                 },
//                                                 child: const Icon(
//                                                   Icons.delete_outline,
//                                                   size: 20,
//                                                   color: Colors.red,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                     ],
//                                   );
//                                 }).toList(),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }