
import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../Bloc/todo_view_bloc.dart';
import '../../../../../Component/drawer_ui.dart';
import '../../../../../Event/todo_view_event.dart';
import '../../../../../Utilities/num.dart';
import '../../../../../Utilities/utils.dart';

class ExpenseEditUI extends StatefulWidget {
  final bool showHeader;
  final Map<String, dynamic> expense;

  const ExpenseEditUI({super.key, required this.expense,this.showHeader = true});

  @override
  State<ExpenseEditUI> createState() => _ExpenseEditUIState();
}

class _ExpenseEditUIState extends State<ExpenseEditUI> {
  late TodoViewBloc cohortsBloc;
  late VehicleDataBloc vehicleDataBloc;
  final TextEditingController vehicleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController odometerController = TextEditingController();
  List<Map<String, dynamic>> categoryDropdownList = [];
  List<Map<String, dynamic>> paymentDropdownList = [];
  List<Map<String, dynamic>> expenseDropdownList = [];
  List<Map<String, dynamic>> vehicleNameList = [];
  List<dynamic> subCategoryDropdownList = [];
  dynamic selectedCategory;
  dynamic selectedSubCategory;
  dynamic selectedExpenseCategory;
  dynamic selectedPayment;
  bool isDateFieldEmpty = false;
  bool loading = false;

  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  bool showVehicleList = false;
  final FocusNode vehicleFocusNode = FocusNode();
  final GlobalKey vehicleFieldKey = GlobalKey();
  List<String> vehicleSuggestionList = [];
  List<Map<String, dynamic>> expenseToData = [];
  List<Map<String, dynamic>> categoryData = [];

  Map<String, dynamic> expense = {};

  @override
  void initState() {
    super.initState();
    cohortsBloc = TodoViewBloc();
    vehicleDataBloc = VehicleDataBloc();
    cohortsBloc.add(const GetPaymentData());
    vehicleDataBloc.add(const GetSubCategory());
   expense= widget.expense;
   vehicleController.text=expense['vehicle']?['vehicle_name']??'';
   amountController.text=(expense['expense_amount']??'').toString();
   descriptionController.text=expense['expense_description']??'';
   dateController.text=expense['expense_date']?? Utils.convertDateTimeToTheFormat(DateTime.now().toString());
   odometerController.text=expense['odometer']??'';

  }


  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _images.add(File(image.path));
      });
    }
  }

  void _viewImage(File image) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Image.file(image),
      ),
    );
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Offset _getWidgetPosition(GlobalKey key) {
    final renderObject = key.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      return renderObject.localToGlobal(Offset.zero);
    } else {
      return Offset
          .zero; // Return a default position if RenderBox is not available
    }
  }
  void _save() {
    setState(() {

    });
    if (vehicleController.text.isEmpty) {
      return Utils.showMobileToast('Please fill the required field');
    }
    final updatedExpense = {
      'id': widget.expense['id'],
      'vehicle_id': vehicleController.text,
      'expense_amount': amountController.text,
      'payment_method_id': selectedPayment,
      'expense_description': descriptionController.text,
      'category_id': selectedCategory,
      'subcategory_id': selectedSubCategory,
      'expense_to': selectedExpenseCategory,
      'expense_date': dateController.text,
      'odometer': widget.expense['odometer'],
    };
    Navigator.pop(context, updatedExpense);
  }

  @override
  Widget build(BuildContext context) {
    return (widget.showHeader) ? Scaffold(
      backgroundColor: AppC.white,
      appBar: widget.showHeader
          ? AppBar(
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        title: Utils.getText(
            expense['vehicle']['vehicle_name']??'',
            color: AppC.white,overFlow: TextOverflow.ellipsis
        ),
        actions: [
          IconButton(onPressed: (){
            _save();
          }, icon: const Icon(Icons.delete_outline,color: AppC.redAccent,)),
          IconButton(onPressed: (){
            Navigator.pop(context);
            }, icon: const Icon(Icons.close,color: AppC.white,))
        ],
      ): null,
      body: body,
      drawer: const DrawerView(),
    ) : body;
  }

  Widget get body => MultiBlocProvider(
    providers: [
      BlocProvider(
          create: (context) => cohortsBloc..add(const GetCohortsData())),
      BlocProvider(
          create: (context) =>
          vehicleDataBloc..add(const GetAddedVehicleListData())),
    ],
    child: MultiBlocListener(
      listeners: [
        BlocListener<TodoViewBloc, TodoViewState>(
          listener: (context, state) {
            if (state is TodoListLoading) {
              loading = true;
            } else if (state is CohortsListLoaded) {
              loading = false;
              categoryDropdownList.clear();
              expenseDropdownList.addAll(state.expenseData ?? []);
              categoryDropdownList.addAll(state.expenseData ?? []);
              selectedCategory = categoryDropdownList.firstWhere(
                    (e) => e['id'] == expense['category_id'],
                orElse: () => {},
              );
                subCategoryDropdownList = state.expenseData!
                    .where((category) =>
                category['id'].toString() == expense['category_id'].toString())
                    .map((category) => category['sub_categories'] ?? [])
                    .expand((subcategoryList) => subcategoryList)
                    .toList();
              selectedSubCategory= subCategoryDropdownList.firstWhere(
                    (e) => e['id'] == expense['subcategory_id'],
                orElse: () => {},
              );

            } else if (state is PaymentListLoaded) {
              setState(() {
                loading = false;
                paymentDropdownList.clear();
                paymentDropdownList.addAll(state.data ?? []);
                selectedPayment = paymentDropdownList.firstWhere(
                      (e) => e['id'] == expense['payment_method_id'],
                  orElse: () => {},
                );

              });
            }
          },
        ),
        BlocListener<VehicleDataBloc, VehicleDataState>(
            listener: (context, state) {
              setState(() {
                if (state is VehicleListLoaded) {
                  loading = false;
                  vehicleNameList.clear();
                  vehicleNameList.addAll(state.vehicleDataList ?? []);
                } else if (state is SubCategoryListLoaded) {
                  setState(() {
                    categoryData.addAll(state.categoriesResponse?.data ?? []);
                    expenseToData.addAll((state.categoriesResponse?.expenseTo ?? []));
                    selectedExpenseCategory = expenseToData.firstWhere(
                          (e) => e['id'] == expense['expense_to'],
                      orElse: () => {},
                    );
                  });
                }
              });
            }),
      ],
      child: BlocBuilder<TodoViewBloc, TodoViewState>(
          builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      if (!widget.showHeader)
                      Utils.getText(expense['vehicle']?['vehicle_name']??''),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 35,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppC.blue,
                                    width: Num.borderWidthField,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(Num.subradiusButton),
                                  ),
                                ),
                                child: Utils.getOutlinedButton(
                                  'Upload',
                                      () => _pickImage(ImageSource.gallery),
                                  iconData: const Icon(
                                    Icons.cloud_upload,
                                    color: AppC.blue,
                                    size: 18,
                                  ),
                                  verticalPadding: 0,
                                  radius: BorderRadius.zero,
                                  bgColor: AppC.trans,
                                  borderColor: AppC.trans,
                                  textColor: AppC.blue,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: SizedBox(
                              height: 35,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppC.redAccent,
                                    width: Num.borderWidthField,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(Num.subradiusButton),
                                  ),
                                ),
                                child: Utils.getOutlinedButton(
                                  'Capture',
                                      () => _pickImage(ImageSource.camera),
                                  iconData: const Icon(
                                    Icons.camera_enhance,
                                    color: AppC.redAccent,
                                    size: 18,
                                  ),
                                  verticalPadding: 0,
                                  radius: BorderRadius.zero,
                                  bgColor: AppC.trans,
                                  borderColor: AppC.trans,
                                  textColor: AppC.redAccent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_images.isNotEmpty)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _images.asMap().entries.map((entry) {
                              int index = entry.key;
                              File image = entry.value;
                              return Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Image.file(
                                      image,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    right: 10,
                                    top: -15,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.remove_red_eye,
                                              color: Colors.white,
                                              size: 20),
                                          onPressed: () => _viewImage(image),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.clear,
                                              color: Colors.white, size: 20),
                                          onPressed: () =>
                                              _removeImage(index),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      if (widget.showHeader)
                        Utils.getTextFormField(
                            '', vehicleController,
                            label: Utils.getText('Vehicle',
                                color: AppC.grey),
                            onChangeCallback: (value) async {
                              setState(() {
                                vehicleSuggestionList.clear();
                                if (value.isNotEmpty) {
                                  List taskList = vehicleNameList
                                      .map((e) => e['vehicle_name'] ?? '')
                                      .toList();
                                  vehicleSuggestionList
                                      .addAll(Utils.searchList(taskList, value));
                                  showVehicleList =
                                      vehicleSuggestionList.isNotEmpty;
                                } else {
                                  showVehicleList = false;
                                }
                              });
                            }),
                      Row(
                        children: [
                          Expanded(
                            child: Utils
                                .getTextFormField(
                              '',
                              amountController,
                              label: Utils.getText('Amount in dollars',
                                  color: AppC.grey),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child:
                            Utils.dropdownBox(
                              'Select Payment Method',
                              paymentDropdownList,
                              initialSelection: selectedPayment,
                                  (selectedValue) {
                                setState(() {
                                  selectedPayment = selectedValue;
                                });
                              },
                              selectedKey: selectedPayment,
                              //initialSelection: selectedSubCategory,
                              labelKey: 'name',
                            ),
                          ),
                        ],
                      ),
                      Utils.getTextFormField(
                          '', descriptionController,
                          label: Utils.getText(
                              'Enter Description',
                              color: AppC.grey,
                          ),
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
                                    subCategoryDropdownList = (state as CohortsListLoaded)
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
                      if (widget.showHeader)
                        Utils.dropdownBox(
                          'Select ExpenseTo',
                          expenseToData,
                          initialSelection: selectedExpenseCategory,
                              (selectedValue) {
                            setState(() {
                              selectedExpenseCategory = selectedValue;
                            });
                          },
                          selectedKey: selectedExpenseCategory,
                          labelKey: 'expense_to',
                        ),
                      if (widget.showHeader)
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Utils.getTextFormField(
                              '',
                              dateController,
                              suffixIcon: Padding(
                                padding: isDateFieldEmpty
                                    ? const EdgeInsets.only(right: 35.0)
                                    : EdgeInsets.zero,
                                child: const Icon(
                                  Icons.date_range,
                                  color: AppC.appColor,
                                ),
                              ),
                              readOnly: true,
                              onTapCallback: () {
                                Utils.datePicker(
                                  context,
                                  '',
                                  initial: DateTime
                                      .now(), // Set initial date to the current date
                                ).then((value) {
                                  if (value != null) {
                                    dateController.text =
                                        Utils.convertDateTimeToTheFormat(
                                          value.toString(),
                                        );
                                  }
                                });
                              },
                              label: Utils.getText('Date', color: AppC.grey),
                              borderColor: isDateFieldEmpty
                                  ? Colors.red
                                  : AppC.fieldBase,
                            ),
                            if (isDateFieldEmpty)
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.error_outline,
                                    color: Colors.red),
                              ),
                          ],
                        ),
                      if (!widget.showHeader)
                        Stack(alignment: Alignment.centerRight, children: [
                          Utils.getTextFormField(
                            '',
                            odometerController,
                            contentPadding:
                            const EdgeInsets.only(left: 10, right: 40),
                            label: Utils.getText('Odometer', color: AppC.grey),
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 32,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: AppC.grey.shade300,
                                      borderRadius:
                                      const BorderRadiusDirectional.only(
                                        topEnd: Radius.circular(4),
                                        bottomEnd: Radius.circular(4),
                                      )),
                                  child: const Icon(
                                    Icons.speed,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Utils.getAddFilledButton(
                              'Save',
                                  () {
                                // _save();
                              },
                              bgColor: AppC.green
                          ),
                          if (!widget.showHeader)
                            const SizedBox(width: 10,),
                          if (!widget.showHeader)
                            Utils.getAddFilledButton(
                              'Save Category',
                                  () {
                                // _save();
                              },
                              bgColor: AppC.appColor,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: showVehicleList,
                  child: Positioned(
                    top: _getWidgetPosition(vehicleFieldKey).dy +
                        130,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Utils.customAutoCompleteList(
                        vehicleSuggestionList,
                            (index) {
                          setState(() {
                            showVehicleList = false;
                            vehicleController.text =
                            vehicleSuggestionList[index];
                            vehicleController.selection =
                                TextSelection.fromPosition(
                                  TextPosition(
                                      offset: vehicleController.text.length),
                                );
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Visibility(
                    visible: loading,
                    child: Center(child: Utils.getProgressIndicator(context)))
              ],
            );
          }),
    ),
  );
}
