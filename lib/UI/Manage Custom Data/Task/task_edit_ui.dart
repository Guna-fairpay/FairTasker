
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Categorys/category_view_ui.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Bloc/todo_view_bloc.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Event/todo_view_event.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';
import '../../../Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Sub Category/subcategory_view_ui.dart';

class TaskEditUI extends StatefulWidget {
  final Map<String, dynamic> task;

  const TaskEditUI({super.key, required this.task});

  @override
  State<TaskEditUI> createState() => _TaskEditUIState();
}

class _TaskEditUIState extends State<TaskEditUI> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TodoViewBloc cohortsBloc;
  TextEditingController taskController=TextEditingController();
  TextEditingController timeTakenController=TextEditingController();
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
    taskController.text = widget.task['task'] ?? '';
    timeTakenController.text = widget.task['time_taken'] ?? '';
    selectedUserType = (widget.task['user_type'] == 1 ? userType[1] : userType[0]);
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  void _save() {

    _formKey.currentState!.validate();
    setState(() { });
    if (taskController.text.isEmpty || timeTakenController.text.isEmpty) {
      return;
    }
    final updatedTask = {
      'id': widget.task['id'],
      'task': taskController.text,
      'category_id': selectedCategory['id'],
      'subcategory_id': selectedSubCategory['id'],
      'time_taken': timeTakenController.text,
      'user_type': selectedUserType['id'] == 2 ? 1 : 0,
    };
   Navigator.pop(context, updatedTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        backgroundColor: AppC.appColor,
        title:const Text('Edit Task',),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.close,
                color: AppC.white,
              ),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => cohortsBloc..add(const GetCohortsData()),
        child: BlocConsumer<TodoViewBloc, TodoViewState>(
          listener: (context, state) {
            if (state is TodoListLoading) {
               EasyLoading.show();
            } else if (state is CohortsListLoaded) {
              if(EasyLoading.isShow)EasyLoading.dismiss();
              category.clear();
              category.addAll(state.expenseData ?? []);
              selectedCategory = category.firstWhere(
                (e) => e['id'] == widget.task['category_id'],
                orElse: () => {},
              );
              subCategory = state.expenseData!
                  .where((category) =>
                      category['id'].toString() ==
                      widget.task['category_id'].toString())
                  .map((category) => category['sub_categories'] ?? [])
                  .expand((subcategoryList) => subcategoryList)
                  .toList();
              selectedSubCategory = subCategory.firstWhere(
                (e) => e['id'] == widget.task['subcategory_id'],
                orElse: () => {},
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              minimum:15.padding,
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Utils.getTextFormField(
                      'Task',
                      taskController,
                      autoValidate: AutovalidateMode.onUserInteraction,
                      validator: (val) => val!.isEmpty ? 'Please enter task name' : null,
                    ),
                    const SizedBox(height: 10,),
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
                                  subCategory = (state as CohortsListLoaded).expenseData!
                                      .where((category) =>
                                  category['id'].toString() ==
                                      selectedValue['id'].toString())
                                      .map((category) =>
                                  category['sub_categories'] ?? [])
                                      .expand((subcategoryList) => subcategoryList)
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
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CategoryViewUi()),
                            );
                            },
                          child: Container(
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
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10,),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SubcategoryViewUI()),
                        );
                        },
                      child: Row(
                        children: [
                          Expanded(
                            child: Utils.dropdownBox( "Select SubCategory",
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
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(4),
                                    bottomRight: Radius.circular(4)),
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
                    ),
                    const SizedBox(height: 10,),
                    Utils.getTextFormField(
                      'Time taken to complete in minutes(eg: 30)',
                      timeTakenController,
                      autoValidate: AutovalidateMode.onUserInteraction,
                      validator: (val) => val!.isEmpty ? 'Please enter time' : null,
                    ),
                    const SizedBox(height: 10,),
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
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Utils.getElevatedButton(() => _save(),),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
