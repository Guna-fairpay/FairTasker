import 'dart:io';

import 'package:fairpytasker/Response/create_expense_field_data.dart';
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

class AddExpenseUI extends StatefulWidget {
  final CreateExpenseFieldData? createExpenseFieldData;
  final Map<String, dynamic>? vehicleStatusListData;

  const AddExpenseUI(
      {required this.createExpenseFieldData,
      required this.vehicleStatusListData,
      Key? key})
      : super(key: key);

  @override
  State<AddExpenseUI> createState() => _AddExpenseUIState();
}

class _AddExpenseUIState extends State<AddExpenseUI>
    with TickerProviderStateMixin {
  TodoViewBloc? todoBloc;
  // List<Vehicles>? vehiclesList;
  // List<ExpenseTo>? expenseToList;
  List<Map<String, dynamic>> cohortList = [];
  dynamic selectedCohort;

  @override
  void initState() {
    super.initState();
    todoBloc = TodoViewBloc();
    cohortList = widget.createExpenseFieldData!.cohortsData ?? [];
    categoriesData = widget.createExpenseFieldData!.expenseCategories ?? [];
    for (var element in cohortList) {
      if (element['id'] == widget.vehicleStatusListData!['cohort_id']) {
        selectedCohort = element;
        selectedVehicles = selectedCohort!['vehicles']![0];
        for (var elementV in selectedCohort!['vehicles']!) {
          if (elementV['id'] == widget.vehicleStatusListData!['vehicle_id']) {
            selectedVehicles = elementV;
          }
        }
      }
    }

/*
    if(widget.expenseSummaryData != null) {
      expenseDescriptionController.text =
          widget.expenseSummaryData?.expenseDescription ?? '';
      amountController.text =
          (widget.expenseSummaryData?.expenseAmount ?? 0)
              .toString();
      imageFile = (widget.expenseSummaryData?.attachments ?? []);
      if ((widget.expenseSummaryData?.categoryId ?? 0) != 0) {
        categoriesData.clear();
        categoriesData = (widget.categoriesListData ?? []);
        for (int i = 0; i < (widget.categoriesListData ?? [])
            .length; i++) {
          // var element = categoriesData[i];
          if (widget.categoriesListData![i].id ==
              (widget.expenseSummaryData?.categoryId ?? 0)) {
            selectedExpenseCategories =
            widget.categoriesListData![i];
            widget.expenseSummaryData?.categoryName =
                widget.categoriesListData![i].name;
            subCategoriesData =
            (widget.categoriesListData![i].subCategories ?? []);
            for (var element1 in (widget.categoriesListData![i]
                .subCategories ?? [])) {
              if (element1.id ==
                  (widget.expenseSummaryData?.subcategoryId ??
                      0)) {
                selectedExpenseSubCategories = element1;
                widget.expenseSummaryData?.subCategoryName =
                    element1.name;
              }
            }
          }
        }
      }

      */
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
      }*/ /*

    }
*/
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
            title:
                Utils.getText('Add Expense', size: 18, weight: FontWeight.w700),
          ),
          body: BlocProvider(
              create: (context) => todoBloc!..add(const TodoViewInitialEvent()),
              child: BlocConsumer<TodoViewBloc, TodoViewState>(
                  listener: (context, state) async {
                if (state is AddExpenseLoaded) {
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
  dynamic selectedVehicles;
  dynamic selectedExpenseSubCategories;
  TextEditingController todoDateController = TextEditingController();

  Widget expenseTodoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              child: Utils.getText('Select Cohort', color: AppC.grey),
            ),
            value: selectedCohort,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 0,
            underline: Container(
              height: 0,
              color: Colors.transparent,
            ),
            onChanged: (Map<String, dynamic>? value) {
              selectedCohort = value;
            },
            items: cohortList.map<DropdownMenuItem<Map<String, dynamic>>>(
                (Map<String, dynamic> value) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Utils.getText('${value['cohort']}'),
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
              child: Utils.getText('Select Vehicles', color: AppC.grey),
            ),
            value: selectedVehicles,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 0,
            underline: Container(
              height: 0,
              color: Colors.transparent,
            ),
            onChanged: (Map<String, dynamic>? value) {
              setState(() {
                selectedVehicles = value;
              });
            },
            items: cohortList.map<DropdownMenuItem<Map<String, dynamic>>>(
                (Map<String, dynamic> value) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Utils.getText('${value['vehicle_name']}'),
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
            'Amount in dollars', amountController,
            label: Utils.getText('Enter Amount'),
            textType: TextInputType.number),
        const SizedBox(height: 15),
        Utils.getTextFormField(
          'Enter Description',
          expenseDescriptionController,
          label: Utils.getText('Enter Description'),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: Utils.getOutlinedButton('Receipt', () async {
                await imagePickHelper
                    .getSingleImage((ImageSource.gallery))
                    .then((value) {
                  if (value != null) {
                    debugPrint('value.path: ${value.path}');
                    //  Attachments attachments = Attachments(file: value);
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
                              todoBloc!.add(DeleteExpenseTodoImage(
                                  id: imageFile[index]['id']));
                              imageFile.removeAt(index);
                            }
                            setState(() {});
                            // imageFile.removeAt(index);
                            // setState(() {});
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              color: AppC.red,
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
        // const SizedBox(height: 30),
        Utils.getFilledButton('Save', () {
          if (todoDateController.text.isEmpty) {
            Utils.showMobileToast(Str.createTodoAlertText("Date"));
          } else if (selectedExpenseCategories == null) {
            Utils.showMobileToast(Str.createTodoAlertText("Expense Category"));
          } else if (selectedExpenseSubCategories == null) {
            Utils.showMobileToast(
                Str.createTodoAlertText("Expense Subcategory"));
          } else if (amountController.text.isEmpty) {
            Utils.showMobileToast(Str.createTodoAlertText("Amount"));
          }
          /*else if (amountController.text.isEmpty) {
              Utils.showMobileToast(Str.createTodoAlertText("Expense Amount"));
            } */
          /*else {
            todoBloc!.add(CreateExpenseTodo(
                *//*todoItem!.expenseId*//* null,
                files: imageFile
                    .map((e) => (e['path'] ?? '').isEmpty ? e['file'] : null)
                    .where((element) => element != null)
                    .cast<File>()
                    .toList(),
                selectedExpenseCategories!.todoId,
               todoId:  selectedExpenseSubCategories!.todoId,
               expenseTo:  selectedExpenseSubCategories!.expenseTo,
                expenseAmount:  amountController.text,
                expenseDescription: expenseDescriptionController.text,
               cohortId:  widget.vehicleStatusListData!['cohortId'].toString(),
              vin:   widget.vehicleStatusListData!['vin'],
               date:  todoDateController.text,
               odometer:  null,
              expenseId: '', categoryId: null, paymentMethodId: '', subCategoryId: null,
            ));
          }*/
        }),
        const SizedBox(height: 15),
      ],
    );
  }
}
