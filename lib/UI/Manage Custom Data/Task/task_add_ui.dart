
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

class TaskAddUI extends StatefulWidget {
  const TaskAddUI({super.key});

  @override
  State<TaskAddUI> createState() => _TaskAddUIState();
}

class _TaskAddUIState extends State<TaskAddUI> {
  final TextEditingController taskController = TextEditingController();
  final TextEditingController timeTakenController = TextEditingController();

  late TodoViewBloc cohortsBloc;
  List<Map<String, dynamic>> category = [];
  List<dynamic> subCategory = [];
  dynamic selectedCategory;
  dynamic selectedSubCategory;
  List<Map<String, dynamic>> userType = [
    {'id': 1, 'name': 'Select'},
    {'id': 2, 'name': 'Support Task'}
  ];
  dynamic selectedUserType;
  bool isTaskFieldEmpty = false;
  bool isTimeTakenEmpty = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    cohortsBloc = TodoViewBloc();
    timeTakenController.text='30';
  }

  void _save() {
    setState(() {
      isTaskFieldEmpty = taskController.text.isEmpty;
      isTimeTakenEmpty = timeTakenController.text.isEmpty;
    });

    if (taskController.text.isEmpty || timeTakenController.text.isEmpty) {
      return Utils.showMobileToast('Please fill in all required fields');
    }

    final newTask = {
      'task': taskController.text,
      'category_id': selectedCategory['id'],
      'subcategory_id': selectedSubCategory['id'],
      'time_taken': timeTakenController.text,
      'user_type': selectedUserType['id'] == 2 ? 1 : 0,
    };
    Navigator.of(context).pop(newTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Utils.getText(
            'Add Task',
            weight: FontWeight.bold,
            size: 18,
            color: AppC.white
        ),
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close,color: AppC.white,)),
        ],
      ),
      body: BlocProvider(
        create: (context) => cohortsBloc..add(const GetCohortsData()),
        child: BlocConsumer<TodoViewBloc, TodoViewState>(
          listener: (context, state) {
            if (state is TodoListLoading) {
              loading = true;
            } else if (state is CohortsListLoaded) {
              loading = false;
              category.clear();
              category.addAll(state.expenseData ?? []);
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Utils.getTextFormField(
                              '',
                              taskController,
                              label: Utils.getText('Task',color: AppC.grey),
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
                        Row(
                          children: [
                            Expanded(
                              child: Utils.dropdownBox(
                                "Select Category",
                                category,
                                    (selectedValue) {
                                  setState(() {
                                    selectedCategory = selectedValue;
                                    selectedSubCategory = "";
                                    subCategory.clear();
                                    if (selectedValue != null) {
                                      subCategory = (state as CohortsListLoaded)
                                          .expenseData!
                                          .where((category) =>
                                      category['id'].toString() ==
                                          selectedValue['id'].toString())
                                          .map((category) =>
                                      category['sub_categories'] ?? [])
                                          .expand(
                                              (subcategoryList) => subcategoryList)
                                          .toList();
                                    }
                                  });
                                },
                                labelKey: 'name',
                                initialSelection: selectedCategory,
                                selectedKey: selectedCategory,
                                topRRadius: 0,
                                bottomRRadius: 0,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(4),bottomRight: Radius.circular(4)),
                                  color: AppC.blue50,
                                  border: Border.all(
                                    color: AppC.fieldBase,
                                    width: Num.borderWidthField,)

                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 8,),
                                child: Icon(Icons.add,color: AppC.blue,),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Utils.dropdownBox(
                                "Select SubCategory",
                                subCategory,
                                    (selectedValue) {
                                  setState(() {
                                    selectedSubCategory = selectedValue;
                                  });
                                },
                                labelKey: 'name',
                                initialSelection: selectedSubCategory,
                                selectedKey: selectedSubCategory,
                                topRRadius: 0,
                                bottomRRadius: 0,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(4),bottomRight: Radius.circular(4)),
                                  color: AppC.blue50,
                                  border: Border.all(
                                    color: AppC.fieldBase,
                                    width: Num.borderWidthField,)

                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 8,),
                                child: Icon(Icons.add,color: AppC.blue,),
                              ),
                            )
                          ],
                        ),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Utils.getTextFormField(
                              'Time taken to complete in minutes(eg: 30)',
                              timeTakenController,
                              label: Utils.getText('Time Taken', color: AppC.grey),
                              borderColor: isTimeTakenEmpty
                                  ? Colors.red
                                  : AppC.fieldBase,
                            ),
                            if (isTimeTakenEmpty)
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.error_outline,
                                    color: Colors.red),
                              ),
                          ],
                        ),
                        Utils.dropdownBox(
                          'select user type',
                          userType,
                              (value){
                            setState(() {
                              selectedUserType = value;
                            });
                          },
                          labelKey: 'name',
                          initialSelection: selectedUserType,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 40,
                              child: Utils.getAddElevatedButton(() {
                                _save();
                              },
                                  text: 'Save',
                                  bgColor: AppC.green
                              ),
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
    );
  }
}
