import 'package:fairpytasker/Event/task_event.dart';
import 'package:flutter/material.dart';
import '../../../Bloc/task_bloc.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../State/task_state.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'Category Config/category_config_view_ui.dart';
import 'task_add_ui.dart';
import 'task_edit_ui.dart';

class TaskViewUI extends StatefulWidget {
  const TaskViewUI({super.key});

  @override
  State<TaskViewUI> createState() => _TaskViewUIState();
}

class _TaskViewUIState extends State<TaskViewUI> {
  late TaskBloc taskBloc;
  TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  List<Map<String, dynamic>> task = [];
  List<Map<String, dynamic>> filteredTask = [];
  bool isNoCategorySelected = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    taskBloc = TaskBloc();
  }

  void _filterTasks(String query) {
    setState(() {
      filteredTask = task.where((task) {
        final taskName = task['task']?.toLowerCase() ?? '';
        final category = task['category_name']?.toLowerCase() ?? '';
        final subcategory = task['subcategory_name']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return taskName.contains(searchQuery) ||
            category.contains(searchQuery) ||
            subcategory.contains(searchQuery);
      }).toList();
    });
  }

  void _navigateToTaskAddUI() async {
    final newTask = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const TaskAddUI()),
    );
    if (newTask != null) {
      taskBloc.add(AddTaskData(
        id: newTask['id'],
        name: newTask['task'],
        userType: newTask['userType'].toString(),
        timeTaken: newTask['timeTaken'],
        category: newTask['categoryId'],
        subCategory: newTask['subcategoryId'],
      ));
      taskBloc.add(const GetTaskData());
      Utils.showMobileToast('Task added successfully');
    }
  }

  void _navigateToTaskEditUI(int index) async {
    final updatedTask = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => TaskEditUI(task: task[index]),
      ),
    );
    if (updatedTask != null) {
      taskBloc.add(AddTaskData(
        id: updatedTask['id'],
        name: updatedTask['task'],
        userType: updatedTask['userType'].toString(),
        timeTaken: updatedTask['timeTaken'],
        category: updatedTask['categoryId'],
        subCategory: updatedTask['subcategoryId'],
      ));

      taskBloc.add(const GetTaskData());
      Utils.showMobileToast('Task updated successfully');
    }
  }

  void _deleteTask(int index) async {
    final confirmed = await _confirmDelete(context);
    if (confirmed == true) {
      final delete = filteredTask[index];
      taskBloc.add(DeleteTaskData(id: delete['id'].toString()));
      taskBloc.add(const GetTaskData());
      Utils.showMobileToast('Deleted!');
    }
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppC.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Utils.getText('Are you sure!'),
        content: Utils.getText('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Confirm the deletion
            },
            child: Utils.getText('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancel the deletion
            },
            child: Utils.getText('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppC.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0), // Change the height here
          child: Column(
            children: [
              const HeaderView(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    tabs: const [
                      Tab(text: 'Task', height: 30),
                      Tab(text: 'Category Config', height: 30),
                    ],
                    dividerColor: AppC.trans,
                    labelStyle: const TextStyle(fontSize: 16),
                    labelColor: AppC.white,
                    unselectedLabelColor: AppC.appColor,
                    indicator: BoxDecoration(
                      color: AppC.appColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: BlocProvider(
          create: (context) => taskBloc..add(const GetTaskData()),
          child: BlocConsumer<TaskBloc, TaskState>(listener: (context, state) {
            if (state is TaskLoading) {
              loading = true;
            } else if (state is TaskListLoaded) {
              loading = false;
              task.clear();
              task.addAll(state.data ?? []);
              filteredTask.addAll(state.data ?? []);
              filteredTask = List.from(state.data ?? []);
            } else if (State is TaskLoaded) {
              loading = false;
              task.clear();
              taskBloc.add(const GetTaskData());
            } else {
              taskBloc.add(const GetTaskData());
              loading = true;
            }
          }, builder: (context, state) {
            return Stack(
              children: [
                TabBarView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: Utils.getSearchBarUI(
                                    () {},
                                    (value) {
                                      _filterTasks(value);
                                    },
                                    searchController,
                                    searchFocusNode,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                height: 40,
                                child: Utils.getAddFilledButton('Add', () {
                                  _navigateToTaskAddUI();
                                }),
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredTask.length,
                              itemBuilder: (context, index) {
                                final task = filteredTask[index];
                                return Slidable(
                                  key: ValueKey(filteredTask[index]),
                                  endActionPane: ActionPane(
                                    motion: const DrawerMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) =>
                                            _deleteTask(index),
                                        backgroundColor: AppC.white,
                                        foregroundColor: AppC.red,
                                        icon: Icons.delete_outline,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      _navigateToTaskEditUI(index);
                                    },
                                    child: Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      color: AppC.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Utils.getText(
                                              task['task'] ?? '',
                                              weight: FontWeight.bold,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Utils.getText(
                                                  task['category_name'] ?? '',
                                                  weight: FontWeight.bold,
                                                  color: AppC.subText,
                                                ),
                                                Utils.getText(
                                                  task['subcategory_name'] ??
                                                      '',
                                                  weight: FontWeight.bold,
                                                  color: AppC.subText,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CategoryConfigViewUI(),
                    ),
                  ],
                ),
                Visibility(
                    visible: loading,
                    child: Center(child: Utils.getProgressIndicator(context)))
              ],
            );
          }),
        ),
        drawer: const DrawerView(),
      ),
    );
  }
}
