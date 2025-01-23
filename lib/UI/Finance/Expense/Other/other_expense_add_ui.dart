
import 'dart:io';
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Component/drawer_ui.dart';
import '../../../../Component/header.dart';
import '../../../../Event/todo_view_event.dart';
import '../../../../Utilities/num.dart';



class OtherAddUi extends StatefulWidget {
  const OtherAddUi({super.key});

  @override
  State<OtherAddUi> createState() => _OtherAddUiState();
}

class _OtherAddUiState extends State<OtherAddUi> {
  late TodoViewBloc expenseBloc;
  final TextEditingController amountController= TextEditingController();
  final TextEditingController descriptionController=TextEditingController();
  final TextEditingController dateController=TextEditingController();
  //dynamic selectedName;
  dynamic selectedCategory;
  //dynamic selectedExpenseTo;
  //dynamic selectedCategory;
  dynamic selectedSubCategory;
  dynamic selectedPayment;
  dynamic selectedChoice;
  dynamic selectedDate;

  List<Map<String,dynamic>> categoryNames=[];
  List<Map<String,dynamic>> subcategory=[];
  List<Map<String,dynamic>> roles=[];
  List<Map<String,dynamic>> payments=[];
  List<Map<String,dynamic>>trimmedPayments=[];
  List<Map<String,dynamic>> choices=[{'choices':'Yes'},{'choices':'No'}];
  List<Map<String, dynamic>> filteredSubcategories = [];

  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  bool isDateFieldEmpty=false;
  bool loading = false;


  @override
  void initState() {
    expenseBloc=TodoViewBloc();
    expenseBloc.add(const GetPaymentData());
    dateController.text = Utils.convertDateTimeToTheFormat(DateTime.now().toString());
    super.initState();
  }

  void _save() {

    print("approved value $selectedChoice");
    if(dateController.text.isEmpty || selectedChoice ==null ||
        amountController.text.isEmpty || selectedCategory ==null ||
        selectedSubCategory ==null || selectedSubCategory ==null ||
        selectedPayment ==null)
    {
      return Utils.showMobileToast('Please fill in all required fields');
    }
    final newData = {
      'expense_date': dateController.text, // Date from the controller
      'approved': selectedChoice['choices'] == "Yes" ? 1 : 0,
      'expense_amount': double.tryParse(amountController.text), // Amount from the controller
      'category_id': selectedCategory['id'], // Store category_id
      'subcategory_id': selectedSubCategory['id'], // Store subcategory_id
      'expense_description': descriptionController.text, // Description from the controller
      'payment_method_id': selectedPayment['id'], // Assuming selectedPayment is selected
      'expense_to': subcategory[0]['expense_to'], // Add this field
      'attachments': _images.map((e) => e.path).toList(), // Image paths if any
    };
    print("Add page: ${newData}");
    Navigator.of(context).pop(newData);
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: const DrawerView(),
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(35.0),
          child: HeaderView(),
        ),
        body: BlocProvider(
          create: (context) => expenseBloc..add(const GetExpenseCategoriesData()),
          child: BlocConsumer<TodoViewBloc,TodoViewState>(
              listener: (context, state) {
                if(state is TodoListLoading){
                  loading=true;
                }
                else if (state is ExpenseCategoryLoaded){
                  loading=false;
                  categoryNames.clear();
                  categoryNames.addAll(state.data??[]);
                  subcategory.clear();
                  subcategory.addAll(
                      categoryNames[0]['subcategories'].whereType<Map<String, dynamic>>() // Ensure subcategories are maps
                  );

                }else if (state is PaymentListLoaded) {
                  setState(() {
                    loading = false;
                    payments.clear();
                    payments.addAll(state.data ?? []);
                    trimmedPayments = payments.map((payment) {
                      return payment.map((key, value) {
                        // Check if the value is a String, and apply trim
                        if (value is String) {
                          return MapEntry(key, value.trim());
                        }
                        return MapEntry(key, value);
                      });
                    }).toList();
                  });
                }
              }, builder: (context, state) {
            return SingleChildScrollView( // Wrap with SingleChildScrollView to make it scrollable
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
                  children: [
                    Row(
                      children: [
                        GestureDetector(onTap:(){
                          Navigator.pop(context);
                        },
                            child:
                            const Icon(Icons.arrow_back,size: 16,)),
                        const SizedBox(width: 5),
                        Utils.getText('Add Other Expense', size: 16, weight: FontWeight.bold,),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    // First Row: Select Person & Date Picker
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 35,
                            child: Utils.getTextFormField('',
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
                                  initial: DateTime.now(), // Set initial date to the current date
                                ).then((value) {
                                  if (value != null) {
                                    dateController.text = Utils.convertDateTimeToTheFormat(
                                      value.toString(),
                                    );
                                  }
                                });
                              },
                              label: Utils.getText('Date', color: AppC.grey),
                              borderColor: isDateFieldEmpty ? Colors.red : AppC.fieldBase,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SizedBox(
                              height: 35,
                              child:
                              Utils.getTextFormField("Enter Amount", amountController)
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Second Row: Select Category & Sub Category
                    Row(
                      children: [
                        // Category Dropdown
                        Expanded(
                          child: SizedBox(
                            height: 35,
                            child: Utils.dropdownBox(
                              'Select Category', // Placeholder text
                              categoryNames
                                  .where((category) => category['name'] == 'Admin')
                                  .toList(),
                                  (value) {
                                setState(() {
                                  selectedCategory = value;
                                  selectedSubCategory = null;

                                  // Filter subcategories based on selected category
                                  filteredSubcategories = subcategory
                                      .where((item) => item['categoryId'] == value['id'])
                                      .toList();
                                });
                              },
                              labelKey: 'name', // Key to display in the dropdown
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // SubCategory Dropdown (conditionally disabled)
                        Expanded(
                          child: SizedBox(
                            height: 35,
                            child: AbsorbPointer(
                              absorbing: selectedCategory == null, // Disable interaction if no category is selected
                              child: Utils.dropdownBox(
                                'Select SubCategory', // Placeholder text
                                subcategory, // Filtered subcategory data
                                    (value) {
                                  setState(() {
                                    selectedSubCategory = value;
                                  });
                                },
                                labelKey: 'name', // Key to display in the dropdown
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Fourth Row: Select & Select
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 35,
                            child: Utils.dropdownBox('Select ', trimmedPayments,
                                    (selectedValue) {
                                  setState(() {
                                    selectedPayment = selectedValue;
                                  }
                                  );
                                },
                                labelKey:'name'
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SizedBox(
                            height: 35,
                            child: Utils.dropdownBox('Select ', choices,
                                    (selectedValue) {
                                  setState(() {
                                    selectedChoice = selectedValue;
                                  }
                                  );
                                },
                                labelKey:'choices'
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Expense Description
                    Utils.getTextFormField(
                        'Enter Description',descriptionController
                    ),
                    const SizedBox(height: 16),
                    // Upload Button
                    GestureDetector(
                      onTap: () => _pickImage(ImageSource.gallery), // Handle tap gesture
                      child: Container(
                        height: 30,
                        width:150,
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
                              size: 12,
                            ),
                            const SizedBox(width: 5),
                            Utils.getText('Upload', color: AppC.blue),
                          ],
                        ),
                      ),
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
                                        icon: const Icon(Icons.remove_red_eye, color: Colors.white, size: 20),
                                        onPressed: () => _viewImage(image),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.clear, color: Colors.white, size: 20),
                                        onPressed: () => _removeImage(index),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    const SizedBox(height: 15), // Add spacing
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start, // Align to the start
                      children: [
                        SizedBox(
                          height: 40,
                          child: Utils.getAddFilledButton(
                            'Save', // Button label
                                () {
                              _save();
                            },
                            bgColor: AppC.green, // Set the button's background color
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            );
          }
          ),
        )
    );
  }
}
