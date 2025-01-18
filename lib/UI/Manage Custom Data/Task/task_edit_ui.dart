import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:flutter/material.dart';
import '../../../Bloc/todo_view_bloc.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Event/todo_view_event.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';
import '../../../Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskEditUI extends StatefulWidget {
  final Map<String, dynamic> task;

  const TaskEditUI({super.key, required this.task});

  @override
  State<TaskEditUI> createState() => _TaskEditUIState();
}

class _TaskEditUIState extends State<TaskEditUI> {
  late TodoViewBloc cohortsBloc;
  late final TextEditingController taskController;
  late final TextEditingController timeTakenController;
  List<Map<String, dynamic>> categoryDropdownList = [];
  List<dynamic> subCategoryDropdownList = [];
  String? selectedCategory;
  String? selectedSubCategory;
  List<String> userType = ['select', 'Support Task'];
  String? selectedUserType;
  bool isTaskFieldEmpty = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    cohortsBloc = TodoViewBloc();
    taskController = TextEditingController(text: widget.task['task']);
    timeTakenController =
        TextEditingController(text: widget.task['time_taken']);

    if (widget.task['category_id'] != null &&
        widget.task['category_name'] != null) {
      selectedCategory = widget.task['category_id'].toString();
    } else {
      selectedCategory = null;
    }
    selectedSubCategory = widget.task['subcategory_id'].toString();
    selectedUserType = (widget.task['user_type'] ?? userType[1]) == 1
        ? userType[1]
        : userType[0];
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  void _save() {
    setState(() {
      isTaskFieldEmpty = taskController.text.isEmpty;
    });
    if (taskController.text.isEmpty) {
      return Utils.showMobileToast('Please fill in all required fields');
    }
    final updatedTask = {
      'id': widget.task['id'],
      'task': taskController.text,
      'categoryId': selectedCategory ?? '',
      'subcategoryId': selectedSubCategory ?? '',
      'timeTaken': timeTakenController.text,
      'userType': selectedUserType == 'Support Task' ? 1 : 0,
    };

    Navigator.pop(context, updatedTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: HeaderView(),
      ),
      body: BlocProvider(
        create: (context) => cohortsBloc..add(const GetCohortsData()),
        child: BlocConsumer<TodoViewBloc, TodoViewState>(
          listener: (context, state) {
            if (state is TodoListLoading) {
              loading = true;
            } else if (state is CohortsListLoaded) {
              loading = false;
              categoryDropdownList.clear();
              categoryDropdownList.addAll(state.expenseData ?? []);
              if (widget.task['category_id'] != null) {
                subCategoryDropdownList = state.expenseData!
                    .where((category) =>
                        category['id'].toString() ==
                        widget.task['category_id'].toString())
                    .map((category) => category['sub_categories'] ?? [])
                    .expand((subcategoryList) => subcategoryList)
                    .toList();
              }
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(Icons.arrow_back)),
                            const SizedBox(
                              width: 10,
                            ),
                            Utils.getText('Edit Task',
                                size: 20, weight: FontWeight.bold),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 40,
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                                '',
                                taskController,
                                label: Utils.getText('Task', color: AppC.grey),
                                borderColor: isTaskFieldEmpty
                                    ? Colors.red
                                    : AppC.fieldBase,
                              ),
                              if (isTaskFieldEmpty)
                                const Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(Icons.error_outline,
                                      color: Colors.red),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppC.fieldBase,
                                width: Num.borderWidthField),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(Num.subradiusButton)),
                          ),
                          child: DropdownButton<String>(
                            hint: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Utils.getText('Select Category',
                                  color: AppC.grey),
                            ),
                            value: selectedCategory,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            elevation: 3,
                            dropdownColor: AppC.white,
                            underline: Container(
                              height: 0,
                              color: Colors.transparent,
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value;
                                selectedSubCategory = null;
                                subCategoryDropdownList.clear();
                    
                                if (value != null) {
                                  subCategoryDropdownList = (state
                                          as CohortsListLoaded)
                                      .expenseData!
                                      .where((category) =>
                                          category['id'].toString() ==
                                          value.toString())
                                      .map((category) =>
                                          category['sub_categories'] ?? [])
                                      .expand(
                                          (subcategoryList) => subcategoryList)
                                      .toList();
                                }
                              });
                            },
                            items: categoryDropdownList
                                .map<DropdownMenuItem<String>>(
                              (value) {
                                return DropdownMenuItem<String>(
                                  value: value['id'].toString(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Utils.getText('${value['name']}'),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppC.fieldBase,
                                width: Num.borderWidthField),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(Num.subradiusButton)),
                          ),
                          child: DropdownButton<String>(
                            hint: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Utils.getText('Select SubCategory',
                                  color: AppC.grey),
                            ),
                            value: selectedSubCategory,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            elevation: 3,
                            dropdownColor: AppC.white,
                            underline: Container(
                              height: 0,
                              color: Colors.transparent,
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedSubCategory = value;
                              });
                            },
                            items: subCategoryDropdownList
                                .map<DropdownMenuItem<String>>(
                              (value) {
                                return DropdownMenuItem<String>(
                                  value: value['id'].toString(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Utils.getText('${value['name']}'),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 40,
                          child:
                              Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                            '',
                            timeTakenController,
                            label: Utils.getText('Time Taken', color: AppC.grey),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppC.fieldBase,
                                width: Num.borderWidthField,
                              ),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(Num.subradiusButton)),
                            ),
                            child: DropdownButton<String>(
                              hint: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Utils.getText('select', color: AppC.grey),
                              ),
                              value: selectedUserType,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              elevation: 3,
                              dropdownColor: AppC.white,
                              underline: Container(
                                height: 0,
                                color: Colors.transparent,
                              ),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  selectedUserType = value;
                                });
                              },
                              items: userType
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Utils.getText(value),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 40,
                              child: Utils.getAddFilledButton('Save', () {
                                _save();
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                    visible: loading,
                    child: Center(child: Utils.getProgressIndicator(context)))
              ],
            );
          },
        ),
      ),
      drawer: const DrawerView(),
    );
  }
}
