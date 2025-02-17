

import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Event/todo_view_event.dart';
import '../../../State/todo_view_state.dart';
import '../../../Utilities/Str.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  bool noCategory = false;


  @override
  void initState() {
    super.initState();
    todoViewBloc = TodoViewBloc();
    todoViewBloc.add(const GetCohortsData());
  }

  void _filterTasks() {
    var query = searchController.text;
    setState(() {
      filteredTask = task.where((task) {
        final taskName = task['task']?.toLowerCase() ?? '';
        final category = task['category_name'];
        final subcategory = task['subcategory_name'];
        final searchQuery = query.toLowerCase();
        final matchesQuery = taskName.contains(searchQuery) ||
            (category?.toLowerCase().contains(searchQuery) ?? false) ||
            (subcategory?.toLowerCase().contains(searchQuery) ?? false);
        return matchesQuery;
      }).toList();
      filteredTask = filteredTask.where((task) {
        final category = task['category_name'];
        final subcategory = task['subcategory_name'];
        final matchesNoCategory = !noCategory || (category == null || subcategory == null);
        return matchesNoCategory;
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
    final confirmed = await Utils.showCustomDeleteDialog(context, 'identifier');
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
        backgroundColor: AppC.white,
        appBar: AppBar(
          backgroundColor: AppC.appColor,
          automaticallyImplyLeading: true,
          foregroundColor: Colors.white,
          leadingWidth: 20,
          title: TabBar(
            tabs: const [
              Tab(text: 'Task', height: 30),
              Tab(text: 'Category Config', height: 30),
            ],
            dividerColor: AppC.trans,
            labelStyle: const TextStyle(fontSize: 16),
            labelColor: AppC.appColor,
            unselectedLabelColor: AppC.white,
            indicator: BoxDecoration(
              color: AppC.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppC.appColor)
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ),
        body: BlocProvider(
          create: (context) => todoViewBloc..add(const GetTaskData()),
          child: BlocConsumer<TodoViewBloc, TodoViewState>(
              listener: (context, state) {
            if (state is TodoListLoading) {
              EasyLoading.show();
            } else if (state is TaskListLoaded) {
              if (EasyLoading.isShow) EasyLoading.dismiss();
              task.clear();
              List<Map<String, dynamic>> list = [];
              list.addAll(state.data ?? []);
              list.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
                  .compareTo(DateTime.parse(a['created_at'] ?? '')));
              task=list;
              filteredTask = List.from(task);
            } else if (state is CohortsListLoaded) {
              if (EasyLoading.isShow) EasyLoading.dismiss();
              category.clear();
              category.addAll(state.expenseData ?? []);
            }
            else if (State is TaskLoaded) {
              if (EasyLoading.isShow) EasyLoading.dismiss();
              task.clear();
              todoViewBloc.add(const GetTaskData());
            } else {
              todoViewBloc.add(const GetTaskData());
              EasyLoading.show();
            }
          }, builder: (context, state) {
            return SafeArea(
              minimum: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: TabBarView(
                physics:  const AlwaysScrollableScrollPhysics(),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Row(
                       spacing: 10,
                       children: [
                         Expanded(
                           child: Utils.getSearchBarUI(
                                 onChange:
                                 (value) {
                               _filterTasks();
                             },
                             searchController:searchController,
                           ),
                         ),
                         Utils.getAddElevatedButton(
                               ()=> _navigateToTaskAddUI(),),
                       ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Checkbox(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            activeColor: AppC.redAccent,
                            checkColor: AppC.white,
                                value: noCategory,
                                onChanged: (value){
                              setState(() {
                                noCategory = value!;
                                // noCategoryCheck();
                                _filterTasks();
                              });
                                }),
                            Utils.getText('No Category',weight: FontWeight.bold),
                        ],
                      ),
                       const Divider(
                        height:0.5,
                      ),
                      Expanded(
                        child:filteredTask.isEmpty && state is TaskListLoaded
                            ? const Center(child: Text(
                            Str.noMatchFound,))
                            : ListView.separated(
                          itemCount: filteredTask.length,
                          separatorBuilder: (context, index) => const Divider(
                            height: 0.5,
                          ),
                          shrinkWrap: true,
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
                            return InkWell(
                              onTap: () => _navigateToTaskEditUI(index),
                              child: ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                title: Row(
                                  spacing: 10,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        task['task'] ?? '-No Title-',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                        onTap: () => _deleteTask(index),
                                        child:const Icon(
                                            Icons.delete_outline,
                                          color: AppC.redAccent,
                                        )
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10,),
                                    Row(
                                      spacing: 10,
                                      children: [
                                        Expanded(
                                          child: Utils.dropdownBoxSmallSize(
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
                                          child: Utils.dropdownBoxSmallSize(
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
                        ),
                      ),
                    ],
                  ),
                  const SafeArea(
                    child: CategoryConfigViewUI(),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
