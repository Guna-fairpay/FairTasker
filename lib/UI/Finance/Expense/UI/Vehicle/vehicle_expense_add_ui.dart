import 'dart:developer';

import 'package:fairpytasker/Component/close_badge.dart';
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/custom_single_selection_field.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/UI/Finance/Expense/Event/expense_event.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/dyno_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Bloc/expense_bloc.dart';
import '../../State/expense_state.dart';

class ExpenseVehicleAddUI extends StatelessWidget {
  const ExpenseVehicleAddUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExpenseBloc>(
      create: (context) => ExpenseBloc(),
      child: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context,state) {
            log("${state.vehicleList}",name: 'Vehicle_List');
            return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  foregroundColor: Colors.white,
                  backgroundColor: AppC.appColor,
                  title: const Text('Add Expense'),
                  actions: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: AppC.white,
                        ))
                  ],
                ),
                body: SafeArea(
                    minimum: 10.padding,
                    child: ListView(
                      children: [
                        Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    context.read<ExpenseBloc>().add(PickImageEvent()),
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
                                      Utils.getText('Upload',
                                          color: AppC.blue, weight: FontWeight.bold),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => context
                                    .read<ExpenseBloc>()
                                    .add(CaptureImageEvent()),
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
                                      Utils.getText('Capture',
                                          color: AppC.redAccent,
                                          weight: FontWeight.bold),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (state.expenseAttachments.isNotEmpty)
                          SizedBox(
                            height: 100,
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: state.expenseAttachments.length,
                              scrollDirection: Axis.horizontal,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1, mainAxisSpacing: 10),
                              itemBuilder: (context, index) => CloseBadge(
                                  onTapView: () {
                                    ShowAttachmentsDialog.of.show(context,
                                        attachments: state.expenseAttachments,
                                        title: "",
                                        currentAttachment:
                                            state.expenseAttachments[index]);
                                  },
                                  onTapDelete: () {
                                    AskPermissionDialog.show(context,
                                        title: "Are you sure?",
                                        description:
                                            "Do you want to delete this Expense Image?",
                                        positiveText: "Yes, delete it!",
                                        negativeText: "Cancel",
                                        isReasonRequired: false,
                                        onPositivePressed: () => context
                                            .read<ExpenseBloc>()
                                            .add(RemoveImageEvent(
                                                data: state
                                                    .expenseAttachments[index])));
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                          minHeight:
                                              MediaQuery.sizeOf(context).height,
                                          minWidth: MediaQuery.sizeOf(context).width,
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            color: AppC.grey.withValues(alpha: 0.2)),
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        child: ImageViewer(
                                          fit: BoxFit.cover,
                                          imageInput: state.expenseAttachments[index],
                                          isNotImage:
                                              !((state.expenseAttachments[index]
                                                      as Object)
                                                  .isImage),
                                        ),
                                      ),
                                      if ((state.expenseAttachments[index] as Object)
                                          .isPDF)
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppC.green,
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Utils.openURL(
                                                  state.expenseAttachments[index]);
                                            },
                                            child: Padding(
                                              padding: 4.padding,
                                              child: const Icon(
                                                Icons.remove_red_eye_outlined,
                                                color: AppC.white,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  )),
                            ),
                          ),
                        10.height,
                        CustomSingleSelectionField<Map<String, dynamic>>(
                          suggestionsList: state.vehicleList,
                          itemAsString: (item) => item['vehicle_name'] ?? '',
                          selected: state.selectedVehicle,
                          labelText: "Vehicle Name",
                          hintText: "",
                          onSelected: (val) {
                            context
                                .read<ExpenseBloc>()
                                .add(VehicleEvent(selectedVehicle: val));
                          },
                          controller: context
                              .read<ExpenseBloc>()
                              .vehicleController,
                        ),
                        10.height,
                        Row(
                          children: [
                            Expanded(
                              child: Utils.getTextFormField(
                                'Amount in dollars',
                                context.read<ExpenseBloc>().amountController,
                              ),
                            ),
                            10.width,
                            Expanded(
                              child: Utils.dropdownBox(
                                  'Select Category', [],
                                  (value) =>
                                context.read<ExpenseBloc>().add(SelectedPaymentEvent(paymentType:value)),
                                  labelKey: 'name'),
                            ),
                          ],
                        ),
                        10.height,
                        Utils.getTextFormField(
                          'Enter Description',
                          context.read<ExpenseBloc>().descriptionController,
                        ),
                        10.height,
                        Utils.dropdownBox(
                            'Select Category',
                            [],
                            (value)=>context.read<ExpenseBloc>().add(CategoryListEvent(selectedCategory:value)),
                            labelKey: '',
                        ),
                        10.height,
                        Utils.dropdownBox(
                            'Select Sub Category',
                            [],
                            (value)=>context.read<ExpenseBloc>().add(SubCategoryListEvent(selectedSubCategory:value)),
                            labelKey: '',
                        ),
                        10.height,
                        Utils.dropdownBox(
                          'Select Expense To',
                          [],
                              (value)=>context.read<ExpenseBloc>().add(SubCategoryListEvent(selectedSubCategory:value)),
                          labelKey: '',
                        ),
                        10.height,
                        CustomDateTimePicker<DateTime>(
                          controller: context
                              .read<ExpenseBloc>()
                              .dateController,
                          format: "dd-MM-yyyy",
                          suffixIcon: Icon(Icons.calendar_month_rounded,
                              size: 18, color: context.theme.hintColor),
                          textAlign: TextAlign.center,
                          value: state.selectedDate,
                          onChanged: (value) => context
                              .read<ExpenseBloc>()
                              .add(DateChangeEvent(selectedDate: value)),
                        ),
                        10.height,
                        Utils.getTextFormField(
                          'Odometer Reading',
                          context.read<ExpenseBloc>().odometerController,
                          textType: TextInputType.number,
                          suffixIcon: const Padding(
                            padding: EdgeInsets.symmetric(horizontal:10.0),
                            child: Icon(Icons.speed,color: AppC.redAccent,),
                          )
                        ),
                        10.height,
                        Utils.getElevatedButton((){})
                      ],
                    )));
          }
        ),
    );
  }
}

/*import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../Bloc/vehicle_data_bloc.dart';
import '../../../../../Component/drawer_ui.dart';
import '../../../../../Component/header.dart';
import '../../../../../Event/todo_view_event.dart';
import '../../../../../Utilities/num.dart';
import '../../../../../Utilities/utils.dart';

class ExpenseAddUI extends StatefulWidget {

  const ExpenseAddUI({super.key});

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
      appBar:  const PreferredSize(
              preferredSize: Size.fromHeight(35.0),
              child: HeaderView(),
            ),
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
                      spacing: 10,
                      children: [
                        Row(
                          children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(
                                    Icons.arrow_back,
                                    size: 16,
                                  )),
                            const SizedBox(width: 5),
                              Utils.getText(
                                'Add Expense',
                                size: 16,
                                weight: FontWeight.bold,
                              ),
                          ],
                        ),
                        Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
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
                                child: GestureDetector(
                                  onTap: () => _pickImage(ImageSource.gallery),
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
                                child: GestureDetector(
                                  onTap: () => _pickImage(ImageSource.camera),
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
                          Utils.getTextFormField(
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
                        Row(
                          spacing: 20,
                          children: [
                            Expanded(
                              child: Utils
                                  .getTextFormField(
                                'Amount in dollars',
                                amountController,
                              ),
                            ),
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
                        Utils.getTextFormField(
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

                          const SizedBox(
                            height: 10,
                          ),

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
                          const SizedBox(
                            height: 10,
                          ),
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
                        const SizedBox(
                          height: 10,
                        ),
                        Utils.getTextFormField(
                          '',
                          odometerController,
                          contentPadding:
                              const EdgeInsets.only(left: 10, right: 40),
                          label: Utils.getText('Odometer', color: AppC.grey),
                          suffixIcon: const Icon(
                            Icons.speed,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Utils.getAddFilledButton(
                              'Save',
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
}*/
