
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:flutter/material.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Event/todo_view_event.dart';
import '../../../State/todo_view_state.dart';
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
  late TodoViewBloc todoViewBloc;
  TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  List<Map<String, dynamic>> task = [];
  List<Map<String, dynamic>> filteredTask = [];
  List<Map<String, dynamic>> category = [];
  List<dynamic> subCategory = [];
  dynamic selectedCategory;
  dynamic selectedSubCategory;
  bool isNoCategorySelected = false;
  bool loading = false;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    todoViewBloc = TodoViewBloc();
    todoViewBloc.add(const GetCohortsData());
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
      todoViewBloc.add(AddTaskData(
        id: newTask['id'],
        name: newTask['task'],
        userType: newTask['user_type'],
        timeTaken: newTask['time_taken'],
        categoryId: newTask['category_id'],
        subCategoryId: newTask['subcategory_id'],
      ));
      todoViewBloc.add(const GetTaskData());
      Utils.showMobileToast('Task added successfully');
    }
  }

  void _navigateToTaskEditUI(int index) async {
    final updatedTask = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => TaskEditUI(task: filteredTask[index]),
      ),
    );
    if (updatedTask != null) {
      todoViewBloc.add(AddTaskData(
        id: updatedTask['id'],
        name: updatedTask['task'],
        userType: updatedTask['user_type'],
        timeTaken: updatedTask['time_taken'],
        categoryId: updatedTask['category_id'],
        subCategoryId: updatedTask['subcategory_id'],
      ));

      todoViewBloc.add(const GetTaskData());
      Utils.showMobileToast('Task updated successfully');
    }
  }

  void _deleteTask(int index) async {
    final confirmed = await Utils.showCustomDeleteDialog(context, 'Do you want to delete this identifier');
    if (confirmed == true) {
      final delete = filteredTask[index];
      todoViewBloc.add(DeleteTaskData(id: delete['id'].toString()));
      todoViewBloc.add(const GetTaskData());
      Utils.showMobileToast('Deleted!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const DrawerView(),
        backgroundColor: AppC.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Column (
            children: [
              const HeaderView(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0),
                    border: const Border(
                      bottom: BorderSide(
                        color: AppC.appColor, // Your desired border color
                        width: 1.0, // Adjust thickness as needed
                      ),
                    )
                  ),
                  child: TabBar(
                    tabs: const [
                      Tab(text: 'Task', height: 30),
                      Tab(text: 'Category Config', height: 30),
                    ],
                    dividerColor: AppC.trans,
                    labelStyle: const TextStyle(fontSize: 16),
                    labelColor: AppC.appColor,
                    unselectedLabelColor: AppC.text,
                    indicator: BoxDecoration(
                      color: AppC.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppC.appColor)
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
          create: (context) => todoViewBloc..add(const GetTaskData()),
          child: BlocConsumer<TodoViewBloc, TodoViewState>(
              listener: (context, state) {
            if (state is TodoListLoading) {
              loading = true;
            } else if (state is TaskListLoaded) {
              loading = false;
              task.clear();
              List<Map<String, dynamic>> list = [];
              list.addAll(state.data ?? []);
              list.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
                  .compareTo(DateTime.parse(a['created_at'] ?? '')));
              task=list;
              filteredTask = List.from(task);
            } else if (state is CohortsListLoaded) {
              loading = false;
              category.clear();
              category.addAll(state.expenseData ?? []);
            }
            else if (State is TaskLoaded) {
              loading = false;
              task.clear();
              todoViewBloc.add(const GetTaskData());
            } else {
              todoViewBloc.add(const GetTaskData());
              loading = true;
            }
          }, builder: (context, state) {
            return Stack(
              children: [
                TabBarView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         Row(
                           spacing: 10,
                           children: [
                             const Icon(Icons.arrow_back),
                             Expanded(
                               child: SizedBox(
                                 height: 45,
                                 child: Utils.getSearchBarUI(
                                       () {},
                                       (value) {
                                     _filterTasks(value);
                                   },
                                   searchController,
                                 ),
                               ),
                             ),
                             Utils.getAddElevatedButton(() {
                               _navigateToTaskAddUI();},
                               icon: Icons.add
                             ),
                           ]
                          ),
                          Expanded(
                            child:filteredTask.isEmpty && state is TaskListLoaded
                                ? Center(child: Utils.getText(
                                "No data founded",
                              size: 16
                            )): ListView.separated(
                              itemCount: filteredTask.length,
                              itemBuilder: (context, index) {
                                final task = filteredTask[index];
                                selectedCategory = category.firstWhere(
                                      (e) => e['id'] == task['category_id'],
                                  orElse: () => {},
                                );
                                subCategory = category
                                    .where((category) => category['id'].toString() == task['category_id'].toString())
                                    .map((category) => category['sub_categories'] ?? [])
                                    .expand((subcategoryList) => subcategoryList)
                                    .toList();
                                selectedSubCategory = subCategory.firstWhere(
                                      (e) => e['id'] == task['subcategory_id'],
                                  orElse: () => {},
                                );

                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: AppC.white,
                                  elevation: 3,
                                  child: ListTile(
                                     contentPadding: const EdgeInsets.symmetric(horizontal: 8,vertical:4 ),
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            task['task'] ?? 'No Title',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () => _navigateToTaskEditUI(index),
                                            icon:const Icon(
                                                Icons.edit_outlined,
                                              color: AppC.appColor,
                                            ),
                                        ),
                                        IconButton(
                                            onPressed: () => _deleteTask(index),
                                            icon:const Icon(
                                                Icons.delete_outline,
                                              color: AppC.redAccent,
                                            )
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          spacing: 10,
                                          children: [
                                            Expanded(
                                              child: Utils.dropdownBox(
                                                "Select Category",
                                                category,
                                                    (value) {
                                                  setState(() {
                                                    selectedCategory = value;
                                                    selectedSubCategory = null;
                                                    subCategory.clear();
                                                    if (value != null) {
                                                      subCategory = category
                                                          .where((category) => category['id'].toString() == value['id'].toString())
                                                          .map((category) => category['sub_categories'] ?? [])
                                                          .expand((subcategoryList) => subcategoryList)
                                                          .toList();
                                                    }
                                                  });
                                                  todoViewBloc.add(AddTaskData(
                                                    id: task['id'],
                                                    name: task['task'],
                                                    userType: task['userType'],
                                                    timeTaken: task['timeTaken'],
                                                    categoryId: selectedCategory['id'],
                                                    subCategoryId: null,
                                                  ));
                                                },
                                                initialSelection: selectedCategory,
                                                selectedKey: selectedCategory,
                                                labelKey: 'name',
                                              ),
                                            ),
                                            Expanded(
                                              child: Utils.dropdownBox(
                                                "Select Subcategory",
                                                subCategory,
                                                    (value) {
                                                  setState(() {
                                                    selectedSubCategory = value;
                                                  });
                                                  todoViewBloc.add(AddTaskData(
                                                    id: task['id'],
                                                    name: task['task'],
                                                    userType: task['userType'],
                                                    timeTaken: task['time_taken'],
                                                    categoryId: task['category_id'],
                                                    subCategoryId: selectedSubCategory['id'],
                                                  ));
                                                },
                                                initialSelection: selectedSubCategory,
                                                selectedKey: selectedSubCategory,
                                                labelKey: 'name',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => const SizedBox(height: 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
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
      ),
    );
  }
}
