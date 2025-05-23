import 'package:collection/collection.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Utilities/Str.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/prefs.dart';
import '../Bloc/workHoursBloc.dart';
import '../Event/workingHoursEvent.dart';

class TaskTabsView extends StatelessWidget {
  final List<Map<String, dynamic>> taskbased;
  final List<Map<String, dynamic>> hourlybased;
  final List<Map<String, dynamic>>? resource;
  String? loginUserId;
  dynamic selectedBases;
  dynamic loginUserRole;

  TaskTabsView({
    super.key,
    required this.taskbased,
    required this.hourlybased,
    required this.selectedBases,
    this.resource, required this.loginUserId, required this.loginUserRole,
  });

  @override
  Widget build(BuildContext context) {
    final TabController tabController = DefaultTabController.of(context);
    return Expanded(
      child: TabBarView(
        controller: tabController,
        children: [
          TaskBasedTab(taskbased: taskbased, selectedBases: selectedBases, loginUserId: loginUserId, loginUserRole: loginUserRole),
          HourlyBasedTab(hourlybased: hourlybased, resource: resource, loginUserId: loginUserId, loginUserRole: loginUserRole),
        ],
      ),
    );
  }
}

class TaskBasedTab extends StatelessWidget {
  final List<Map<String, dynamic>> taskbased;
  dynamic selectedBases;
  String? loginUserId;
  dynamic loginUserRole;

  TaskBasedTab({
    super.key,
    required this.taskbased,
    required this.selectedBases,
    this.loginUserId,
    this.loginUserRole
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),)),
              child: ListTile(
      leading: Utils.getText("Task Name",weight: FontWeight.bold),title: Utils.getText("Amount",align: TextAlign.center, weight: FontWeight.bold),trailing:(Session.of.getString(Str.userIdPrefText) == '3' || Session.of.getStringList(Str.rolePrefText)!.contains("Admin")) ? Utils.getText("Action", weight: FontWeight.bold) : Utils.getText(""),)
        ),
        // Container(
        //   decoration: BoxDecoration(
        //     color: Colors.blue.shade100,
        //     borderRadius: const BorderRadius.only(
        //       topLeft: Radius.circular(4),
        //       topRight: Radius.circular(4),
        //     ),
        //   ),
        //   padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        //   child:
        //   Table(
        //     columnWidths: const {
        //       0: FlexColumnWidth(5), // Task name
        //       1: FlexColumnWidth(2), // Amount
        //       2: FlexColumnWidth(3), // Actions
        //     },
        //     children:[
        //       TableRow(
        //         children: [
        //           const Padding(
        //             padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
        //             child: Text('Task Name', style: TextStyle(fontWeight: FontWeight.bold)),
        //           ),
        //           const Padding(
        //             padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
        //             child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)),
        //           ),
        //           if(Session.of.getString(Str.userIdPrefText) == '3' || Session.of.getString(Str.userIdPrefText) == '2' || Session.of.getString(Str.userIdPrefText) == '1')
        //           const Padding(
        //             padding: EdgeInsets.only(left: 30, top: 8.0, bottom: 8.0, right: 0),
        //             child: Text('Action', style: TextStyle(fontWeight: FontWeight.bold)),
        //           ),
        //         ],
        //       ),
        //     ],
        //   )
        // ),
        Expanded(
          child:
          SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child:
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(4), // Task name
                      1: FlexColumnWidth(2), // Amount
                      2: FlexColumnWidth(2), // Actions
                    },
                    border: const TableBorder(
                      bottom: BorderSide(color: Colors.black26, width: 0.2),
                    ),
                    children: taskbased.map((task) {
                      return TableRow(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(color: Colors.black, width: 0.2),
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Utils.getText("${task['task_name']}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Utils.getText("\$${task['amount']}"),
                          ),
                          if(Session.of.getString(Str.userIdPrefText) == '3' || Session.of.getString(Str.userIdPrefText) == '2' || Session.of.getString(Str.userIdPrefText) == '1')
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context.read<WorkingHoursBloc>().add(EnterEditModeEvent());
                                    context.read<WorkingHoursBloc>().add(UpdateTaskEvent(
                                      id: task['id'],
                                      taskName: task['task_name'],
                                      amount: task['amount'],
                                    ));
                                  },
                                  child: const Icon(
                                    Icons.edit_outlined,
                                    size: 20,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () async {
                                    final confirm = await showCustomDeleteDialog(context);
                                    if (confirm == true) {
                                      context.read<WorkingHoursBloc>().add(
                                          DeleteTaskComponentsEvent(id: task['id'])
                                      );
                                      Toaster.showSuccess("Task deleted successfully");
                                      context.read<WorkingHoursBloc>().add(ExitEditModeEvent());
                                    }
                                  },
                                  child: const Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          )
        ),
      ],
    );
  }
}


class HourlyBasedTab extends StatelessWidget {
  final List<Map<String, dynamic>> hourlybased;
  final List<Map<String, dynamic>>? resource;
  String? loginUserId;
  dynamic loginUserRole;

  HourlyBasedTab(
      {super.key, required this.hourlybased, required this.resource, this.loginUserId, this.loginUserRole}){
    print("${hourlybased} hourlybased data");
    print("${resource} resource_data");
  }

  @override
  Widget build(BuildContext context) {
    return
      Column(
      children: [
        Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: ListTile(
              leading: Utils.getText("Name",weight: FontWeight.bold),title: Utils.getText("Amount/hr",align: TextAlign.center, weight: FontWeight.bold),trailing:(Session.of.getString(Str.userIdPrefText) == '3' || Session.of.getStringList(Str.rolePrefText)!.contains("Admin")) ? Utils.getText("Action", weight: FontWeight.bold) : Utils.getText(""),)),
        // Container(
        //   decoration: BoxDecoration(
        //     color: Colors.blue.shade100,
        //     borderRadius: const BorderRadius.only(
        //       topLeft: Radius.circular(4),
        //       topRight: Radius.circular(4),
        //     ),
        //   ),
        //   child:
        //   Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        //     child:
        //     Table(
        //       columnWidths: const {
        //         0: FlexColumnWidth(5), // User name
        //         1: FlexColumnWidth(6), // Amount
        //         2: FlexColumnWidth(3), // Actions
        //       },
        //       children: [
        //         TableRow(
        //           children: [
        //             const Padding(
        //               padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
        //               child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
        //             ),
        //             const Padding(
        //               padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
        //               child: Text('Amount/hr', style: TextStyle(fontWeight: FontWeight.bold)),
        //             ),
        //             if(Session.of.getString(Str.userIdPrefText) == '3' || Session.of.getStringList(Str.rolePrefText)!.contains("Admin"))
        //             const Padding(
        //               padding: EdgeInsets.symmetric(horizontal: 9, vertical: 8.0),
        //               child: Text('Action', style: TextStyle(fontWeight: FontWeight.bold)),
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   )
        // ),
        Expanded(
          child:
          SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2), // Resource name
                      1: FlexColumnWidth(1), // Amount/hr
                      2: FlexColumnWidth(2), // Action
                    },
                    border: const TableBorder(
                      bottom: BorderSide(color: Colors.black26, width: 0.2),
                    ),
                    children: hourlybased.map((task) {
                      return
                        TableRow(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(color: Colors.black, width: 0.2),
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Utils.getText("${resource?.firstWhereOrNull((user) => user['id'] == task['user_id'])?['full_name']?.toString() ?? ''}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Utils.getText("\$${task['amount']}"),
                          ),
                          if(Session.of.getString(Str.userIdPrefText) == '3' || Session.of.getStringList(Str.rolePrefText)!.contains("Admin"))
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context.read<WorkingHoursBloc>().add(EnterEditModeEvent());
                                    context.read<WorkingHoursBloc>().add(UpdateTaskEvent(
                                      id: task['id'],
                                      userId: task['user_id'],
                                      amount: task['amount'],
                                    ));
                                  },
                                  child: const Icon(
                                    Icons.edit_outlined,
                                    size: 20,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () async {
                                    final confirm =
                                    await showCustomDeleteDialog(context);
                                    if (confirm == true)
                                    {
                                      context.read<WorkingHoursBloc>().add(
                                          DeleteTaskComponentsEvent(
                                              id: task['id']));
                                      Toaster.showSuccess("Task deleted successfully");
                                      context.read<WorkingHoursBloc>().add(ExitEditModeEvent());
                                    }
                                  },
                                  child: const Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Future<bool?> showCustomDeleteDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: AppC.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.help_outline_sharp, size: 50, color: Colors.blue),
            const SizedBox(height: 16),
            Utils.getText(
              "Are you sure?",
              size: 18,
              weight: FontWeight.bold,
              align: TextAlign.center,
              color: AppC.black,
            ),
            const SizedBox(height: 8),
            Utils.getText(
              "Do you want to delete?",
              align: TextAlign.center,
              color: AppC.black,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Utils.getAddFilledButton("Yes, delete it!", () {
                  Navigator.pop(context, true);
                }, bgColor: AppC.blue),
                Utils.getAddFilledButton("Cancel", () {
                  Navigator.pop(context, false);
                }, bgColor: AppC.red),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
