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
  dynamic loginUserRole;
  final Globalkey;

  TaskTabsView({
    super.key,
    required this.Globalkey,
    required this.taskbased,
    required this.hourlybased,
    this.resource, required this.loginUserId, required this.loginUserRole,
  });

  @override
  Widget build(BuildContext context) {
    final TabController tabController = DefaultTabController.of(context);
    return Expanded(
      child: TabBarView(
        controller: tabController,
        children: [
          TaskBasedTab(taskbased: taskbased, loginUserId: loginUserId, loginUserRole: loginUserRole, Globalkey: Globalkey),
          HourlyBasedTab(hourlybased: hourlybased, resource: resource, loginUserId: loginUserId, loginUserRole: loginUserRole, Globalkey: Globalkey),
        ],
      ),
    );
  }
}

class TaskBasedTab extends StatelessWidget {
  final List<Map<String, dynamic>> taskbased;
  final String? loginUserId;
  final dynamic loginUserRole;
  final Globalkey;

  const TaskBasedTab({
    super.key,
    required this.taskbased,
    this.loginUserId,
    this.loginUserRole,
    required this.Globalkey,
  });

  @override
  Widget build(BuildContext context) {
    final isAdmin = Session.of.getString(Str.userIdPrefText) == '3' ||
        Session.of.getString(Str.userIdPrefText) == '2';

    return buildTaskBasedTable(
      context,
      taskbased,
      isAdmin,
      Globalkey,
    );
  }
}

Widget buildTaskBasedTable(
    BuildContext context,
    List<Map<String, dynamic>> taskbased,
    bool isAdmin,
    final Globalkey,
    ) {
  return Table(
    columnWidths: {
      0: const FlexColumnWidth(1),
      1: const FlexColumnWidth(1),
      if (isAdmin) 2: const FlexColumnWidth(0.5),
    },
    children: [
      TableRow(
        decoration: BoxDecoration(color: Colors.blue.shade100),
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Task Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Amount',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          if (isAdmin)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Action',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
      ...taskbased.map(
            (task) => TableRow(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.black, width: 0.2),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Text(
                task['task_name'] ?? '',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(child: Text("\$${task['amount']}")),
            ),
            if (isAdmin)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Globalkey.currentState?.reset();
                        context.read<WorkingHoursBloc>().add(EnterEditModeEvent());
                        context.read<WorkingHoursBloc>().add(UpdateTaskEvent(
                          id: task['id'],
                          taskName: task['task_name'],
                          amount: task['amount'],
                          task: 'task',
                        ));
                      },
                      child: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () async {
                        final confirm = await showCustomDeleteDialog(context);
                        if (confirm == true) {
                          context.read<WorkingHoursBloc>().add(
                            DeleteTaskComponentsEvent(
                              id: task['id'],
                              task: "task",
                            ),
                          );
                          Toaster.showSuccess("Task deleted successfully");
                        }
                      },
                      child: const Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ],
  );
}


class HourlyBasedTab extends StatelessWidget {
  final List<Map<String, dynamic>> hourlybased;
  final List<Map<String, dynamic>>? resource;
  final String? loginUserId;
  final dynamic loginUserRole;
  final Globalkey;

  const HourlyBasedTab({
    super.key,
    required this.hourlybased,
    required this.resource,
    this.loginUserId,
    this.loginUserRole,
    required this.Globalkey,
  });

  @override
  Widget build(BuildContext context) {
    final isAdmin = Session.of.getString(Str.userIdPrefText) == '3' ||
        Session.of.getString(Str.userIdPrefText) == '2';

    return buildHourlyBasedTable(
      context,
      hourlybased,
      resource!,
      isAdmin,
      Globalkey,
    );
  }
}

Widget buildHourlyBasedTable(
    BuildContext context,
    List<Map<String, dynamic>> hourlyBased,
    List<Map<String, dynamic>> resource,
    bool isAdmin,
    final Globalkey,
    )
{
  return Table(
    columnWidths: {
      0: const FlexColumnWidth(1),
      1: const FlexColumnWidth(1),
      if (isAdmin) 2: const FlexColumnWidth(0.5),
    },
    children: [
      TableRow(
        decoration: BoxDecoration(color: Colors.blue.shade100),
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Amount/hr',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          if (isAdmin)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Action',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
      ...hourlyBased.map(
            (task) => TableRow(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.black, width: 0.2),
            ),
          ),
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Text(
                resource.firstWhere(
                      (user) => user['id'] == task['user_id'],
                  orElse: () => {'full_name': ''},
                )['full_name'] ?? '',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(child: Text("\$${task['amount']}")),
            ),
            if (isAdmin)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Globalkey.currentState?.reset();
                        context.read<WorkingHoursBloc>().add(EnterEditModeEvent());
                        context.read<WorkingHoursBloc>().add(UpdateTaskEvent(
                            id: task['id'],
                            userId: task['user_id'],
                            amount: task['amount'],
                            task: 'hourly'
                        ));
                      },
                      child: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () async {
                        final confirm = await showCustomDeleteDialog(context);
                        if (confirm == true) {
                          context.read<WorkingHoursBloc>().add(
                            DeleteTaskComponentsEvent(
                              id: task['id'],
                              task: "hourly",
                            ),
                          );
                          Toaster.showSuccess("Task deleted successfully");
                        }
                      },
                      child: const Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ],
  );
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
