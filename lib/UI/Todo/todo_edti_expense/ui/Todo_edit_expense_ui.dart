
import 'dart:developer';
import 'dart:io';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';

import '../../../../Component/close_badge.dart';
import '../../../../Component/image_viewer.dart';
import '../../../../Event/todo_view_event.dart';
import '../../../../State/todo_view_state.dart';
import '../../../dialog/show_attachments_dialog.dart';
import '../../../../core/app/extension/dyno_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Bloc/todo_view_bloc.dart';
import '../../../../Bloc/vehicle_data_bloc.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';
import '../../../../Utilities/num.dart';

class TodoEditExpenseUI extends StatefulWidget {
  final List<Map<String, dynamic>> vehicleName;
  final Map<String, dynamic> expenseData;
  final Map<String, dynamic> todoData;
  final Map<String, dynamic> vehicle;
  final List<Map<String, dynamic>> taskList;

  const TodoEditExpenseUI({
    super.key,
    required this.expenseData,
    required this.vehicle,
    required this.vehicleName,
    required this.taskList,
    required this.todoData,
  });

  @override
  State<TodoEditExpenseUI> createState() => _ExpenseAddUIState();
}

class _ExpenseAddUIState extends State<TodoEditExpenseUI> {
  late TodoViewBloc todoBloc;
  late VehicleDataBloc vehicleDataBloc;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController odometerController = TextEditingController();

  List<Map<String, dynamic>> categoryDropdownList = [];
  List<Map<String, dynamic>> paymentDropdownList = [];
  List<Map<String, dynamic>> vehicleNameList = [];
  List<Map<String, dynamic>> vehicleName = [];
  List<Map<String, dynamic>> taskList = [];
  List<dynamic> subCategoryDropdownList = [];
  List<String> vehicleSuggestionList = [];

  Map<String, dynamic> expenseData = {};
  Map<String, dynamic> vehicle = {};
  Map<String, dynamic> todoData = {};

  dynamic selectedCategory;
  dynamic selectedSubCategory;
  dynamic selectedPayment;
  dynamic selectedVin;

  bool showVehicleList = false;
  bool isDateFieldEmpty = false;
  bool loading = false;

  String? categoryId;
  String? subcategoryId;

  final List<dynamic> _images = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    todoBloc = TodoViewBloc();
    vehicleDataBloc = VehicleDataBloc();
    vehicleName = widget.vehicleName;
    vehicle = widget.vehicle;
    todoData = widget.todoData;

  }

  Future<void> _pickImages(ImageSource source) async {
    if (source == ImageSource.gallery) {
      final List<XFile> selectedImages = await _picker.pickMultiImage();
      if (selectedImages.isNotEmpty) {
        setState(() {
          _images.addAll(selectedImages.map((image) => File(image.path)));
        });
      }
    } else {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _images.add(File(image.path));
        });
      }
    }
  }

  void _removeImage(imageId) {
    vehicleDataBloc.add(
      DeleteExpenseImage(
          id: imageId),
    );
  }

  void _saveExpense (){
    todoBloc.add( CreateExpenseTodo(
      expenseId: expenseData['id'],
      files:_images.whereType<File>().map((e) => e).toList(),
      categoryId: selectedCategory['id'],
      subCategoryId: selectedSubCategory['id'],
      paymentMethodId: selectedPayment['id'],
      expenseTo: selectedSubCategory['expense_to'],
      expenseAmount: amountController.text,
      expenseDescription: descriptionController.text,
      cohortId:todoData['cohort_id'],
      vin: vehicle['vin'],
      todoId: todoData['id'],
      date: expenseData['expense_date'],
      odometer: odometerController.text,
    ));
  }




  @override
  void didUpdateWidget(covariant TodoEditExpenseUI oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.vehicle != widget.vehicle) {
      todoData = widget.todoData;
      vehicleName = widget.vehicleName;
      vehicle = widget.vehicle;
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoViewBloc, TodoViewState>(
      listener: (context, state) {
        log("${state.runtimeType}", name: "TODO_EDIT_EXPENSE_STATE");
        if (state is TodoListLoading) {
         // EasyLoading.show();
        }
        else if (state is TaskExpenseLoaded) {
         // if (EasyLoading.isShow) EasyLoading.dismiss();
          taskList.addAll(state.resource ?? []);
          if (todoData['category_id'] != null) {
            categoryId = todoData['category_id'].toString();
            subcategoryId = todoData['subcategory_id'].toString();
          } else {
            final Map<String, dynamic> task = taskList.firstWhere(
                  (element) => element['id'] == todoData['identifier_id'] || element['task'] == todoData['title'],
              orElse: () => {},
            );
            categoryId = task['category_id']?.toString() ?? '';
            subcategoryId = task['subcategory_id']?.toString() ?? '';
          }
        } else if (state is CohortsListLoaded) {
         // if (EasyLoading.isShow) EasyLoading.dismiss();
          categoryDropdownList.addAll(state.expenseData ?? []);
          subCategoryDropdownList = state.expenseData!
              .where((category) =>
          category['id'].toString() == categoryId)
              .map((category) => category['sub_categories'] ?? [])
              .expand((subcategoryList) => subcategoryList)
              .toList();
          selectedCategory = categoryDropdownList.firstWhere(
                (e) => e['id'].toString() == categoryId,
            orElse: () => {},
          );
          selectedSubCategory= subCategoryDropdownList.firstWhere(
                (e) => e['id'].toString() == subcategoryId,
            orElse: () => {},
          );
        }
        else if (state is ExpenseTodoLoaded) {
         // if (EasyLoading.isShow) EasyLoading.dismiss();
          expenseData = state.expenseSummaryData??{};
          _images.clear();
          // _images.addAll(expenseData['attachments']);
          _images.addAll(expenseData['attachments']?.map((e) => e['path'].toString().toStorageURL).toList());
          amountController.text=expenseData['expense_amount'].toString();
          descriptionController.text=expenseData['expense_description']??'';
        }
        else if (state is PaymentListLoaded) {
          paymentDropdownList.clear();
          paymentDropdownList.addAll(state.data ?? []);
          if(expenseData['payment_method_id'] != null){
            selectedPayment = paymentDropdownList.firstWhere(
                  (e) =>
              e['id'].toString() ==
                  expenseData['payment_method_id']?.toString(),
              orElse: () => {},
            );
          }
          else{
            selectedPayment = paymentDropdownList.firstWhere(
                  (e) => e['id'].toString() == '1',
              orElse: () => {},);
          }
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((todoData['vehicles']).length > 1)
                    Utils.dropdownBox(
                      'Select Vehicle',
                      vehicleName,
                      (selectedValue) {
                        setState(() {
                          selectedVin = selectedValue;
                        });
                      },
                      labelKey: 'vehicle_name',
                      initialSelection: selectedVin,
                      selectedKey: selectedVin,
                    ),
                  Utils.getText(
                    todoData['vehicle_name'] != null
                        ? 'Expense Summary - ${todoData['vehicle_name']}'
                        : vehicle['vehicle_name'] != null
                        ? 'Expense Summary - ${vehicle['vehicle_name']}'
                        : '',
                    size: 12,
                    color: AppC().base,
                    align: TextAlign.end,
                  ),
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickImages(ImageSource.gallery),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppC.blue,
                                width: Num.borderWidthField,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(Num.subradiusButton),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.cloud_upload,
                                  color: AppC.blue,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Utils.getText('Upload', color: AppC.blue),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickImages(ImageSource.camera),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppC.redAccent,
                                width: Num.borderWidthField,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(Num.subradiusButton),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.camera_enhance,
                                  color: AppC.redAccent,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Utils.getText('Capture', color: AppC.redAccent),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_images.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: _images.length,
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1, mainAxisSpacing: 10),
                        itemBuilder: (context, index) => CloseBadge(
                            onTapView: () {
                              ShowAttachmentsDialog.of.show(context,
                                  attachments: _images[index],
                                  title: "",
                                  currentAttachment: _images[index]);
                            },
                            onTapDelete: () {
                              var model = _images[index].toString().replaceAll(Str.STORAGE_BASE_URL, "");
                              var data = (expenseData['attachments'] as List?)?.where((element) => element['path'] == model).toList().firstOrNull;
                              log("Data:\t${data['id']} : ${data['path'].toString().toStorageURL}", name: "REMOVE_DATA");
                              if (data != null) _removeImage(data['id']);
                              _images.removeAt(index);
                              setState(() {

                              });
                            },
                            child: Container(
                              constraints: BoxConstraints(
                                minHeight: MediaQuery.sizeOf(context).height,
                                minWidth: MediaQuery.sizeOf(context).width,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: AppC.grey.withValues(alpha: 0.2)),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child:  ImageViewer(
                                fit: BoxFit.cover,
                                imageInput: _images[index],
                                isNotImage:
                                    !((_images[index] as Object).isImage),
                              ),
                            )),
                      ),
                    ),
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Utils.getTextFormField(
                          'Amount in dollars',
                          amountController,
                        ),
                      ),
                      Expanded(
                        child: Utils.dropdownBox(
                            'Select Payment Method',
                            paymentDropdownList,
                            (selectedValue) {
                          setState(() {
                            selectedPayment = selectedValue;
                          });
                        },
                            selectedKey: selectedPayment,
                            initialSelection: selectedPayment,
                            labelKey: 'name'),
                      ),
                    ],
                  ),
                  Utils.getTextFormField(
                    'Enter Description',
                    descriptionController,
                  ),
                  Utils.dropdownBox(
                      'Select Category',
                      categoryDropdownList,
                      selectedKey: selectedCategory,
                      initialSelection: selectedCategory,
                          (selectedValue) {
                        setState(() {
                          selectedCategory = selectedValue;
                          selectedSubCategory= "Select SubCategory";
                          subCategoryDropdownList.clear();
                          if (selectedValue != null) {
                            subCategoryDropdownList = categoryDropdownList
                                .where((category) =>
                            category['id'].toString() ==
                                selectedValue['id'].toString())
                                .map((category) =>
                            category['sub_categories'] ?? [])
                                .expand(
                                    (subcategoryList) => subcategoryList)
                                .toList();
                            //print("SUBCATEGORY-$subCategoryDropdownList");
                          }
                        });
                      },
                      labelKey: 'name'),
                  Utils.dropdownBox(
                    'Select SubCategory',
                    subCategoryDropdownList,
                    initialSelection: selectedSubCategory,
                        (selectedValue) {
                      setState(() {
                        selectedSubCategory = selectedValue;
                      });
                    },
                    selectedKey: selectedSubCategory,
                    //initialSelection: selectedSubCategory,
                    labelKey: 'name',
                  ),
                  Utils.getTextFormField(
                    '',
                    odometerController,
                    textType: TextInputType.number,
                    contentPadding: const EdgeInsets.only(left: 10, right: 40),
                    label: Utils.getText('Odometer', color: AppC.grey),
                    suffixIcon: const Icon(
                      Icons.speed,
                      color: Colors.red,
                    ),
                  ),
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Utils.getAddFilledButton(
                        'Save',
                        () {
                          _saveExpense();
                        },
                        bgColor: AppC.green,
                      ),
                      Utils.getAddFilledButton(
                        'Save Category',
                        () {
                          // _save();
                        },
                        bgColor: AppC.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
                visible: loading,
                child: Center(child: Utils.getProgressIndicator(context)))
          ],
        );
      },
    );
  }
}
