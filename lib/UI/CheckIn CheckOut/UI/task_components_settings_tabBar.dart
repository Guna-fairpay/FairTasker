
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';
import '../Bloc/workHoursBloc.dart';
import '../Event/workingHoursEvent.dart';

class TaskTabsView extends StatelessWidget {
  final List<Map<String, dynamic>> taskbased;
  final List<Map<String, dynamic>> hourlybased;

  const TaskTabsView({
    super.key,
    required this.taskbased,
    required this.hourlybased,
  });

  @override
  Widget build(BuildContext context) {
    final TabController tabController = DefaultTabController.of(context);
    return Expanded(
      child: TabBarView(
        controller: tabController,
        children: [
          TaskBasedTab(taskbased: taskbased),
          HourlyBasedTab(hourlybased: hourlybased),
        ],
      ),
    );
  }
}

class TaskBasedTab extends StatelessWidget {
  final List<Map<String, dynamic>> taskbased;
  const TaskBasedTab({super.key, required this.taskbased,
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
              topRight: Radius.circular(4),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 30 * 2),
                  Text('Action', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: taskbased.length,
            itemBuilder: (context, index) {
              final task = taskbased[index];
              return Column(
                children: [
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color: Colors.black, width: 0.2)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 10, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Utils.getText("${task['task_name']}"),
                            Row(
                              children: [
                                Utils.getText("\$${task['amount']}"),
                                const SizedBox(width: 30 * 3),
                                GestureDetector(
                                  onTap: () {
                                    // Handle edit
                                  },
                                  child: const Icon(
                                    Icons.edit_outlined,
                                    size: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () async {
                                    final confirm = await showCustomDeleteDialog(context);
                                    if (confirm == true) {
                                      context.read<WorkingHoursBloc>().add(DeleteTaskComponentsEvent(id: task['id']));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Task deleted successfully')),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Deletion cancelled.')),
                                      );
                                    }
                                  },
                                  child: const Icon(
                                    Icons.delete_outline,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class HourlyBasedTab extends StatelessWidget {
  final List<Map<String, dynamic>> hourlybased;
  const HourlyBasedTab({super.key, required this.hourlybased,
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
              topRight: Radius.circular(4),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Text('Amount/hr', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 30 * 2),
                  Text('Action', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: hourlybased.length,
            itemBuilder: (context, index) {
              final task = hourlybased[index];
              return Column(
                children: [
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color: Colors.black, width: 0.2)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 10, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Utils.getText("${task['user_id']}"), // Replace with actual name
                            Row(
                              children: [
                                Utils.getText("\$${task['amount']}"),
                                const SizedBox(width: 30 * 3),
                                GestureDetector(
                                  onTap: () {
                                    // Handle edit
                                  },
                                  child: const Icon(
                                    Icons.edit_outlined,
                                    size: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () async {
                                    final confirm = await showCustomDeleteDialog(context);
                                    if (confirm == true) {
                                      context.read<WorkingHoursBloc>().add(DeleteTaskComponentsEvent(id: task['id']));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Task deleted successfully')),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Deletion cancelled.')),
                                      );
                                    }
                                  },
                                  child: const Icon(
                                    Icons.delete_outline,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
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