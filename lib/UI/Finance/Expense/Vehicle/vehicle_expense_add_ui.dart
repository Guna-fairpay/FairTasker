import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Bloc/vehicle_data_bloc.dart';
import '../../../../Component/drawer_ui.dart';
import '../../../../Component/header.dart';
import '../../../../Event/todo_view_event.dart';
import '../../../../Utilities/num.dart';
import '../../../../Utilities/utils.dart';

class ExpenseAddUI extends StatefulWidget {
  final bool showHeader;
  const ExpenseAddUI({super.key, this.showHeader = true});

  @override
  State<ExpenseAddUI> createState() => _ExpenseAddUIState();
}

class _ExpenseAddUIState extends State<ExpenseAddUI> {
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
  String? selectedCategory;
  String? selectedSubCategory;
  String? selectedExpenseCategory;
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

  @override
  void initState() {
    super.initState();
    cohortsBloc = TodoViewBloc();
    vehicleDataBloc = VehicleDataBloc();
    cohortsBloc.add(const GetPaymentData());
    vehicleDataBloc.add(const GetSubCategory());
    dateController.text =
        Utils.convertDateTimeToTheFormat(DateTime.now().toString());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: widget.showHeader
          ? const PreferredSize(
              preferredSize: Size.fromHeight(35.0),
              child: HeaderView(),
            )
          : null,
      body: MultiBlocProvider(
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
                  subCategoryDropdownList = state.expenseData!
                      .where((category) =>
                          category['id'].toString() == 'category_id'.toString())
                      .map((category) => category['sub_categories'] ?? [])
                      .expand((subcategoryList) => subcategoryList)
                      .toList();
                } else if (state is PaymentListLoaded) {
                  setState(() {
                    loading = false;
                    paymentDropdownList.clear();
                    paymentDropdownList.addAll(state.data ?? []);
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
                    expenseToData
                        .addAll((state.categoriesResponse?.expenseTo ?? []));
                  });
                }
              });
            })
          ],
          child: BlocBuilder<TodoViewBloc, TodoViewState>(
              builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            if (widget.showHeader)
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(
                                    Icons.arrow_back,
                                    size: 16,
                                  )),
                            const SizedBox(width: 5),
                            if (widget.showHeader)
                              Utils.getText(
                                'Add Expense',
                                size: 16,
                                weight: FontWeight.bold,
                              ),
                          ],
                        ),
                        if (widget.showHeader) const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppC.blue,
                                    width: Num.borderWidthField,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(Num.subradiusButton),
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () => _pickImage(ImageSource.gallery),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.cloud_upload,
                                        color: AppC.blue,
                                        size: 12,
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
                            const SizedBox(width: 20),
                            Expanded(
                              child: Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppC.redAccent,
                                    width: Num.borderWidthField,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(Num.subradiusButton),
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () => _pickImage(ImageSource.camera),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.camera_enhance,
                                        color: AppC.redAccent,
                                        size: 12,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Utils.getText('Capture',
                                          color: AppC.redAccent),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_images.isNotEmpty) const SizedBox(height: 10),
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
                          const SizedBox(
                            height: 10,
                          ),
                        if (widget.showHeader)
                          Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                              'Vehicle', vehicleController,
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
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Utils
                                  .getBackgroundFilledTextFieldFirstLetterCaps(
                                'Amount in dollars',
                                amountController,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Utils.dropdownBox(
                                  'Select Category', paymentDropdownList,
                                  (selectedValue) {
                                setState(() {
                                  selectedPayment = selectedValue;
                                });
                              }, labelKey: 'name'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                          'Enter Description',
                          vehicleController,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 30,
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
                        const SizedBox(height: 10),
                        Container(
                          height: 30,
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
                        if (widget.showHeader)
                          const SizedBox(
                            height: 10,
                          ),
                        if (widget.showHeader)
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppC.fieldBase,
                                  width: Num.borderWidthField),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(Num.subradiusButton)),
                            ),
                            child: DropdownButton<String>(
                              hint: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Utils.getText('Select ExpenseTo',
                                    color: AppC.grey),
                              ),
                              value: selectedExpenseCategory,
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
                                  selectedExpenseCategory = value;
                                });
                              },
                              items:
                                  expenseToData.map<DropdownMenuItem<String>>(
                                (value) {
                                  return DropdownMenuItem<String>(
                                    value: value['id'].toString(),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Utils.getText(
                                          '${value['expense_to']}'),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        if (widget.showHeader)
                          const SizedBox(
                            height: 10,
                          ),
                        if (widget.showHeader)
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                                '',
                                dateController,
                                suffixIcon: Padding(
                                  padding: isDateFieldEmpty
                                      ? const EdgeInsets.only(right: 35.0)
                                      : EdgeInsets.zero,
                                  child: const Icon(
                                    Icons.date_range,
                                    color: AppC.appColor,
                                    size: 16,
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
                        const SizedBox(
                          height: 10,
                        ),
                        Stack(alignment: Alignment.centerRight, children: [
                          Utils.getBackgroundFilledTextFieldFirstLetterCaps(
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
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 1.0),
                                  child: Container(
                                    height: 28,
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
                              ),
                            ],
                          ),
                        ]),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 40,
                              child: Utils.getAddFilledButton(
                                'Save',
                                () {
                                  // _save();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: showVehicleList,
                  child: Positioned(
                    top: _getWidgetPosition(vehicleFieldKey).dy +
                        130, // Adjust offset as needed
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
      ),
      drawer: const DrawerView(),
    );
  }
}
