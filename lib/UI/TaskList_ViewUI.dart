
import 'package:fairpytasker/Bloc/task_list_bloc.dart';
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/Event/task_list_event.dart';
import 'package:fairpytasker/State/task_list_state.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Component/drawer_ui.dart';
import '../Component/header.dart';
import '../Event/todo_view_event.dart';
import '../Utilities/appC.dart';
import '../Utilities/num.dart';
import '../Utilities/utils.dart';
import 'package:intl/intl.dart';

class TaskListViewUI extends StatefulWidget {
  const TaskListViewUI({super.key});

  @override
  State<TaskListViewUI> createState() => _TaskListViewUIState();
}

class _TaskListViewUIState extends State<TaskListViewUI> {
  late TodoViewBloc todoViewBloc;
  late TaskListBloc taskListBloc;
  TextEditingController dateController = TextEditingController();
  DateRange? selectedDateRange;
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> filteredTasks = [];
  List<Map<String, dynamic>> expenseData = [];
  bool loading = false;
  bool extraHours = false;
  bool offShore = true;
  bool hideSupport = false;
  bool isAscending = true;

  @override
  void initState() {
    todoViewBloc = TodoViewBloc();
    taskListBloc = TaskListBloc();
    filteredTasks = tasks;
    DateTime now = DateTime.now();

    selectedDateRange = DateRange(
      now.subtract(const Duration(days: 7)),
      now,
    );
    String startDate = selectedDateRange!.start.toString();
    String endDate = selectedDateRange!.end.toString();
    taskListBloc.add(GetTaskListData(startDate, endDate));
    super.initState();
  }

  String formatTimeToAmPm(String? time) {
    if (time == null || time.isEmpty) {
      return '';
    }
    try {
      DateTime dateTime = DateFormat('HH:mm').parse(time);
      return DateFormat('h:mm a').format(dateTime);
    } catch (e) {
      return time;
    }
  }

  void filterTasksByDateRange() {
    List<Map<String, dynamic>> result = tasks;
    if (selectedDateRange != null) {
      result = result.where((item) {
        final dateParts = item['date']?.split(' to ');
        if (dateParts == null || dateParts.length != 2) return false;

        final startDate =
            DateTime.tryParse(dateParts[0].split('-').reversed.join('-'));
        final endDate =
            DateTime.tryParse(dateParts[1].split('-').reversed.join('-'));

        return startDate != null && endDate != null;
      }).toList();
    }
    setState(() {
      filteredTasks = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: HeaderView(),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => todoViewBloc..add(const GetCohortsData())),
          BlocProvider(
              create: (context) => taskListBloc
                ..add(GetTaskListData(
                  selectedDateRange!.start.toString(),
                  selectedDateRange!.end.toString(),
                ))),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<TodoViewBloc, TodoViewState>(
              listener: (context, state) {
                if (state is CohortsListLoaded) {
                  setState(() {
                    expenseData.clear();
                    expenseData.addAll(state.expenseData ?? []);
                  });
                }
              },
            ),
            BlocListener<TaskListBloc, TaskListState>(
              listener: (context, state) {
                setState(() {
                  if (state is TaskListViewLoading) {
                    loading = true;
                  } else if (state is TaskListViewLoaded) {
                    loading = false;
                    tasks.clear();
                    tasks.addAll(state.data);
                    filteredTasks = List.from(state.data);
                  } else {
                    loading = false; // Set loading to false for other states
                  }
                });
              },
            ),
          ],
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back)),
                        Utils.getText('Task List',
                            size: 20, weight: FontWeight.bold),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: DateRangeField(
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      Num.subradiusButton),
                                ),
                              ),
                              selectedDateRange: selectedDateRange,
                              onDateRangeSelected: (DateRange? value) {
                                setState(() {
                                  selectedDateRange = value;
                                  String startDate =
                                      selectedDateRange!.start.toString();
                                  String endDate =
                                      selectedDateRange!.end.toString();
                                  taskListBloc
                                      .add(GetTaskListData(startDate, endDate));
                                  filterTasksByDateRange();
                                });
                              },
                              pickerBuilder: datePickerBuilder,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 15,
                                  child: Checkbox(
                                    value: hideSupport,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        hideSupport = value ?? false;
                                        if (hideSupport) {
                                          filteredTasks = tasks
                                              .where((task) =>
                                                  task['todo_user_type'] != 1)
                                              .toList();
                                        } else {
                                          filteredTasks = List.from(tasks);
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Utils.getText('Hide Support'),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: 15,
                                  child: Checkbox(
                                    value: extraHours,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        extraHours = value ?? false;
                                        // Optionally, filter tasks by the checkbox value here
                                      });
                                    },
                                  ),
                                ),
                                Utils.getText('Extra Hours'),
                              ],
                            ),
                          ],
                        ),
                        PopupMenuButton<int>(
                          elevation: 3,
                          padding: EdgeInsets.zero,
                          color: Colors.white,
                          onSelected: (int selectedValue) {
                            setState(() {
                              if (selectedValue == 1) {
                                isAscending = !isAscending;
                                filteredTasks.sort((a, b) {
                                  return isAscending
                                      ? a['complete_time_approved'].compareTo(
                                          b['complete_time_approved'])
                                      : b['complete_time_approved'].compareTo(
                                          a['complete_time_approved']);
                                });
                              } else if (selectedValue == 2) {
                                offShore = !offShore;
                                filteredTasks.sort((a, b) {
                                  return offShore
                                      ? a['todo_user_type']
                                          .compareTo(b['todo_user_type'])
                                      : b['todo_user_type']
                                          .compareTo(a['todo_user_type']);
                                });
                              }
                            });
                          },
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(
                                    isAscending
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    size: 15,
                                    color:
                                        isAscending ? Colors.green : Colors.red,
                                  ),
                                  Utils.getText('Task InCompleted',
                                      weight: FontWeight.bold),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: Row(
                                children: [
                                  Icon(
                                    offShore
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    size: 15,
                                    color: offShore ? Colors.green : Colors.red,
                                  ),
                                  Utils.getText('Offshore Team',
                                      weight: FontWeight.bold),
                                ],
                              ),
                            ),
                          ],
                          icon: const Icon(
                            Icons.filter_alt_outlined,
                            color: AppC.appColor,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final taskList = filteredTasks[index];
                          bool isChecked =
                              (taskList['complete_time_approved'] == 1);

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            color: AppC.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Utils.getText(taskList['title'] ?? '',
                                          color: AppC.appColor,
                                          weight: FontWeight.bold),
                                      Expanded(
                                        child: Utils.getText(
                                            '(${taskList['complete_time_taken'] ?? ' '})',
                                            color: AppC.appColor,
                                            weight: FontWeight.bold),
                                      ),
                                      Utils.getText(
                                          taskList['todo_date']?.substring(5) ??
                                              '',
                                          color: AppC.appColor),
                                      const SizedBox(width: 5),
                                      Utils.getText(
                                          formatTimeToAmPm(
                                                  taskList['todo_time']),
                                          color: AppC.appColor),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Utils.getText(
                                            taskList['vehicle_name'] ??
                                                taskList['person'] ??
                                                '',
                                            size: 12),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Utils.getText('(P)',
                                            weight: FontWeight.bold),
                                      ),
                                      if (taskList['users'] != null)
                                        Utils.getText(
                                            '${taskList['users']['first_name'][0] ?? ''}${taskList['users']['last_name'][0] ?? ''}'),
                                      const SizedBox(width: 5),
                                      SizedBox(
                                        height: 15,
                                        child: Checkbox(
                                          value: isChecked,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              isChecked = value ?? false;
                                              taskList[
                                                      'complete_time_approved'] =
                                                  isChecked ? 1 : 0;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: loading,
                child: Center(child: Utils.getProgressIndicator(context)),
              ),
            ],
          ),
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
      initialDisplayedDate: selectedDateRange?.start ?? DateTime.now(),
      onDateRangeChanged: onDateRangeChanged,
      height: 340,
      displayMonthsSeparator: true,
    );
  }
}
