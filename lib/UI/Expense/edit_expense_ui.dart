import 'dart:io';

import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/image_pick_helper.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_platform_interface/src/types/image_source.dart';

class EditExpenseUI extends StatefulWidget {
  final Map<String, dynamic>? expenseSummaryData;
  final List<Map<String, dynamic>>? categoriesListData;
  final int? todoId;

  const EditExpenseUI(
      {required this.expenseSummaryData,
      required this.categoriesListData,
      required this.todoId,
      Key? key})
      : super(key: key);

  @override
  State<EditExpenseUI> createState() => _EditExpenseUIState();
}

class _EditExpenseUIState extends State<EditExpenseUI>
    with TickerProviderStateMixin {
  TodoViewBloc? todoBloc;
  List<Map<String, dynamic>> todoList = [];
  List<Map<String, dynamic>> tempSearchList = [];
  Color textColors = AppC.text;
  List<Map<String, dynamic>> path = [];

  @override
  void initState() {
    super.initState();
    todoBloc = TodoViewBloc();

    if (widget.expenseSummaryData != null) {
      expenseDescriptionController.text =
          widget.expenseSummaryData?['expense_description'] ?? '';
      amountController.text =
          (widget.expenseSummaryData?['expense_amount'] ?? 0).toString();
      selectedDate = Utils.convertStringToDateTime(
          widget.expenseSummaryData?['expense_date'] ?? '');
      todoDateController.text =
          widget.expenseSummaryData?['expense_date'] ?? '';
      imageFile = (widget.expenseSummaryData?['attachments'] ?? []);
      if ((widget.expenseSummaryData?['category_id'] ?? 0) != 0) {
        categoriesData.clear();
        categoriesData = (widget.categoriesListData ?? []);
        for (int i = 0; i < (widget.categoriesListData ?? []).length; i++) {
          // var element = categoriesData[i];
          if (widget.categoriesListData![i]['id'] ==
              (widget.expenseSummaryData?['category_id'] ?? 0)) {
            selectedExpenseCategories = widget.categoriesListData![i];
            widget.expenseSummaryData?['category_name'] =
                widget.categoriesListData![i]['name'];
            subCategoriesData =
                (widget.categoriesListData![i]['subcategories'] ?? []);
            for (var element1
                in (widget.categoriesListData![i]['subcategories'] ?? [])) {
              if (element1.id ==
                  (widget.expenseSummaryData?['subcategory_id'] ?? 0)) {
                selectedExpenseSubCategories = element1;
                widget.expenseSummaryData?['subcategory_name'] = element1.name;
              }
            }
          }
        }
      }

      /*for (int i=0; i<(widget.categoriesListData ?? []).length; i++) {
        var element = widget.categoriesListData![i];
        if (element.id == widget.expenseSummaryData!.categoryId!) {
          widget.expenseSummaryData!.categoryName = element.name;
          for (var element1 in (element.subCategories ?? [])) {
            if (element1.id == widget.expenseSummaryData!.subcategoryId!) {
              widget.expenseSummaryData!.subCategoryName = element1.name;
             }
          }
         }
      }
      if(widget.expenseSummaryData?.attachments!=null) {
        path = (widget.expenseSummaryData!.attachments!);
      }*/
    }
    // debugPrint('widget.todos!.users: ${widget.todos!.users??'nj'}');
    // debugPrint('widget.todos!.userGroupId: ${widget.todos!.userGroupId??''}');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(true);
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: AppC.trans,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  color: AppC.black,
                )),
            title: Utils.getText('View Expense',
                size: 18, weight: FontWeight.w700),
          ),
          body: BlocProvider(
              create: (context) => todoBloc!..add(const TodoViewInitialEvent()),
              child: BlocConsumer<TodoViewBloc, TodoViewState>(
                  listener: (context, state) async {
                if (state is CreateTodoLoaded) {
                  Navigator.of(context).pop(true);
                }
              }, builder: (context, state) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: expenseTodoWidget(),
                      ),
                    ),
                    Visibility(
                        visible: state is TodoListLoading,
                        child:
                            Center(child: Utils.getProgressIndicator(context)))
                  ],
                );
              }))),
    );
  }

  ImagePickHelper imagePickHelper = ImagePickHelper();
  List<Map<String, dynamic>> imageFile = [];
  TextEditingController amountController = TextEditingController();
  TextEditingController expenseDescriptionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  DateTime? selectedDate = DateTime.now();
  DateTime? editSelectedDate = DateTime.now();
  List<Map<String, dynamic>> categoriesData = [];
  List<Map<String, dynamic>> subCategoriesData = [];
  dynamic selectedExpenseCategories;
  dynamic selectedExpenseSubCategories;
  TextEditingController todoDateController = TextEditingController();

  Widget expenseTodoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        /*Visibility(
            visible: widget.todoItem?.vehicleName != null &&
                widget.todoItem?.vehicleName.isNotEmpty,
            child: Utils.getText(
                'Expense Summary - ${widget.todoItem!.vehicleName ?? ''}',
                color: AppC().base)),
        const SizedBox(height: 10),*/
        Row(
          children: [
            Expanded(
              child: Utils.getOutlinedButton('Upload', () async {
                await imagePickHelper
                    .getSingleImage((ImageSource.gallery))
                    .then((value) {
                  if (value != null) {
                    debugPrint('value.path: ${value.path}');
                    // Attachments attachments = Attachments(file: value);
                    imageFile.add({'file': value});
                    // attachmentController.text = '${imageFile.length} file chosen';
                    setState(() {});
                    /*Future.delayed(const Duration(milliseconds: 400)).then((value)
                    {
                      Utils.scrollDown(scrollController);
                    });*/
                  } else {
                    return;
                  }
                });
              },
                  iconData: const Icon(Icons.cloud_upload,
                      color: AppC.blue, size: 15),
                  verticalPadding: 0,
                  radius: BorderRadius.zero,
                  borderColor: AppC.blue,
                  textColor: AppC.blue),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Utils.getOutlinedButton('Capture', () async {
                await imagePickHelper
                    .getSingleImage((ImageSource.camera))
                    .then((value) {
                  if (value != null) {
                    debugPrint('value.path: ${value.path}');
                    //Attachments attachments = Attachments(file: value);
                    imageFile.add({'file': value});
                    // attachmentController.text = '${imageFile.length} file chosen';
                    setState(() {});
                    /*Future.delayed(const Duration(milliseconds: 400)).then((value)
                    {
                      Utils.scrollDown(scrollController);
                    });*/
                  } else {
                    debugPrint('value is null');
                    return;
                  }
                });
              },
                  iconData:
                      const Icon(Icons.camera_alt, color: AppC.red, size: 15),
                  verticalPadding: 0,
                  radius: BorderRadius.zero,
                  borderColor: AppC.red,
                  textColor: AppC.red),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Visibility(
          visible: imageFile.isNotEmpty,
          child: SizedBox(
            height: 80,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: imageFile.length, // Number of items in the list
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      (imageFile[index]['path'] ?? '').isNotEmpty
                          ? Utils.getOvalCachedImageNetworkDisplay(
                              context, imageFile[index]['path'] ?? '')
                          : ClipOval(
                              child: Image.file(
                                File(imageFile[index]['file']?['path'] ?? ''),
                                width: 50.0, // Set the width as needed
                                height: 50.0, // Set the width as needed
                                fit: BoxFit
                                    .cover, // You can use other BoxFit values to control how the image is displayed
                              ),
                            ),
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: InkWell(
                          onTap: () {
                            if ((imageFile[index]['path'] ?? '').isEmpty) {
                              imageFile.removeAt(index);
                            } else {
                              todoBloc!.add(DeleteExpenseImage(
                                  id: imageFile[index]['id']));
                              imageFile.removeAt(index);
                            }
                            setState(() {});
                            // imageFile.removeAt(index);
                            // setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              color: AppC.red.shade400,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            alignment: Alignment.center,
                            child: const Icon(Icons.clear_rounded,
                                color: AppC.white, size: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 0),
        Utils.getTextFormField(
            'Enter Amount', amountController,
            label: Utils.getText('Enter Amount'),
            textType: TextInputType.number),
        const SizedBox(height: 15),
        Utils.getTextFormField(
          'Enter Description',
          expenseDescriptionController,
          label: Utils.getText('Enter Description'),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: AppC.fieldBase,
                width: Num.borderWidthField,
              ),
              borderRadius:
                  const BorderRadius.all(Radius.circular(Num.radiusButton))),
          child: DropdownButton<Map<String, dynamic>>(
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Utils.getText('Select Category', color: AppC.grey),
            ),
            value: selectedExpenseCategories,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 0,
            underline: Container(
              height: 0,
              color: Colors.transparent,
            ),
            onChanged: (Map<String, dynamic>? value) {
              // This is called when the user selects an item.
              selectedExpenseCategories = value;
              selectedExpenseSubCategories = null;
              subCategoriesData.clear();
              subCategoriesData.addAll(value?['subcategories'] ?? []);
              setState(() {});
            },
            items: categoriesData.map<DropdownMenuItem<Map<String, dynamic>>>(
                (Map<String, dynamic> value) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Utils.getText('${value['name']}'),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: AppC.fieldBase,
                width: Num.borderWidthField,
              ),
              borderRadius:
                  const BorderRadius.all(Radius.circular(Num.radiusButton))),
          child: DropdownButton<Map<String, dynamic>>(
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Utils.getText('Select Subcategory', color: AppC.grey),
            ),
            value: selectedExpenseSubCategories,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 0,
            underline: Container(
              height: 0,
              color: Colors.transparent,
            ),
            onChanged: (Map<String, dynamic>? value) {
              // This is called when the user selects an item.
              selectedExpenseSubCategories = value;
              setState(() {});
            },
            items: subCategoriesData
                .map<DropdownMenuItem<Map<String, dynamic>>>(
                    (Map<String, dynamic> value) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Utils.getText('${value['name']}'),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 15),
        Utils.getTextFormField(
            'Expense Date', todoDateController, readOnly: true,
            onTapCallback: () {
          Utils.datePicker(context, '', initial: DateTime.parse("2023-01-01"))
              .then((value) {
            selectedDate = value!;
            todoDateController.text =
                Utils.convertDateTimeToTheFormat(value.toString());
          });
        }, label: Utils.getText('Expense Date')),
        const SizedBox(height: 30),
        Utils.getFilledButton('Save', () {
          if (selectedExpenseCategories == null) {
            Utils.showMobileToast(Str.createTodoAlertText("Expense Category"));
          } else if (selectedExpenseSubCategories == null) {
            Utils.showMobileToast(
                Str.createTodoAlertText("Expense Subcategory"));
          }
          /*else if (amountController.text.isEmpty) {
              Utils.showMobileToast(Str.createTodoAlertText("Expense Amount"));
            } */
          else {
            todoBloc!.add(CreateExpenseTodo(
                widget.expenseSummaryData!['id']!.toString(),
                imageFile
                    .map((e) => (e['path'] ?? '').isEmpty ? e['file'] : null)
                    .where((element) => element != null)
                    .cast<File>()
                    .toList(),
                selectedExpenseCategories!.id,
                selectedExpenseSubCategories!.id,
                selectedExpenseSubCategories!.expenseTo,
                amountController.text,
                expenseDescriptionController.text,
                widget.expenseSummaryData!['cohort_id']!.toString(),
                widget.expenseSummaryData!['vin'],
                todoDateController.text,
                widget.todoId,
                '' /*odometerController.text*/,
                dontUpdateTodosExpense: true));
          }
        }),
        const SizedBox(height: 15),
      ],
    );
  }
}
