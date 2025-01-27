
import 'dart:io';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Event/todo_view_event.dart';
import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../../../../Component/drawer_ui.dart';
import '../../../../Component/header.dart';
import '../../../../Utilities/num.dart';

class ExpensePersonAddUi extends StatefulWidget {
  const ExpensePersonAddUi({super.key});

  @override
  State<ExpensePersonAddUi> createState() => _ExpensePersonAddUiState();
}

class _ExpensePersonAddUiState extends State<ExpensePersonAddUi> {

  late TodoViewBloc expenseBloc;
  late TodoViewBloc empnameBloc;
  final TextEditingController amountController= TextEditingController();
  final TextEditingController descriptionController=TextEditingController();
  final TextEditingController dateController=TextEditingController();
  dynamic selectedName;
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
  List<Map<String,dynamic>> choices=[{'choices':'Yes'},{'choices':'No'}];
  List<Map<String, dynamic>> filteredSubcategories = [];
  List<Map<String,dynamic>> names=[];
  List<Map<String,dynamic>> Employeenames=[];
  List<Map<String,dynamic>> expenseto=[{"ExpenseTo":"FairPY"},{"ExpenseTo":"Cohort"}];//payments
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  bool isDateFieldEmpty=false;
  bool loading = false;

  @override
  void initState() {
    expenseBloc=TodoViewBloc();
    empnameBloc=TodoViewBloc();
    //empnameBloc.add(const GetEmployeeNameData());
    expenseBloc.add(const GetPaymentData());
    expenseBloc.add(const GetEmployeeNameData());
    dateController.text = Utils.convertDateTimeToTheFormat(DateTime.now().toString());
    super.initState();
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

  void _save() {
    // Convert "Yes" or "No" to 1 or 0
    selectedChoice = (selectedChoice == "Yes") ? 1 : 0;

    // Create the new data map from controllers and selected values
    // final newdata = {
    //   'expense_date': dateController.text,
    //   'expense_amount': amountController.text,
    //   'approved': selectedChoice,
    //   'name': selectedName['name'], // Added dynamic selectedName
    //   'category': selectedRole1?['role'], // Optional chaining to handle null
    //   'subcategory': selectedRole2?['subcategory'], // Optional chaining to handle null
    //   'description': descriptionController.text,
    //   'selectedPayment': selectedPayment?['payment'], // Optional chaining to handle null
    //   'expenseTo': selectedExpenseTo['ExpenseTo'], // Added dynamic selectedExpenseTo
    // };

    // Print statements for debugging
    // print('New Data: $newdata');
    // print("Category Type: ${newdata['category']?.runtimeType}");
    // print("Subcategory Type: ${newdata['subcategory']?.runtimeType}");

    // Return the new data
    // Navigator.pop(context, newdata);
  }

  // final List<File> _images = [];
  // final ImagePicker _picker = ImagePicker();




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
                  });
                }else if (state is EmployeeNameLoaded) {

                  loading = false;
                  names.clear();
                  names.addAll(state.EmployeeData ?? []);
                  try {
                    final dataList = names[0]['data'] as List<dynamic>?; // Ensure it's a List
                    if (dataList != null) {
                      for (final name in dataList) {
                        if (name is Map<String, dynamic> &&
                            name.containsKey('first_name') &&
                            name.containsKey('last_name')) {

                          String fullName = '${name['first_name']} ${name['last_name']}';

                          // Store the full name along with first_name and last_name
                          Employeenames.add({
                            'full_name': fullName,  // Store full name as a String
                            'first_name': name['first_name'],  // Store first name dynamically
                            'last_name': name['last_name'],  // Store last name dynamically
                          });
                        } else {
                          print("Incomplete or Invalid data: $name");
                        }
                      }
                    } else {
                      print("No 'data' key or it's not a List.");
                    }
                  } catch (e) {
                    print("Error: $e");
                  }

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
                        Utils.getText('Add Person Expense', size: 16, weight: FontWeight.bold,),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    // First Row: Select Person & Date Picker
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 35,
                            child: Utils.dropdownBox('Select Person', Employeenames,
                                    (selectedValue) {
                                  setState(() {
                                    selectedName = selectedValue;
                                  }
                                  );
                                },
                                labelKey:'full_name'
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),
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
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Second Row: Select Category & Sub Category
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 35,
                            child: Utils.dropdownBox('Select Category', categoryNames.where((category)=>category['name']=='Admin').toList(),
                                    (selectedValue) {
                                  setState(() {
                                    selectedCategory=selectedValue;
                                    selectedSubCategory=null;
                                    filteredSubcategories=subcategory.where((item) => item['categoryId'] == selectedValue['id'])
                                        .toList();
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
                            child: AbsorbPointer(
                              absorbing: selectedCategory == null, // Disable interaction if no category is selected
                              child: Utils.dropdownBox(
                                'Select SubCategory', // Placeholder text
                                subcategory, // Filtered subcategory data
                                    (selectedValue) {
                                  setState(() {
                                    selectedSubCategory = selectedValue;
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
                    // Third Row: Select Expense To & Amount
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 35,
                            child: Utils.dropdownBox('Select Expense To', expenseto,
                                    (selectedValue) {
                                  setState(() {
                                    // selectedExpenseTo = selectedValue;
                                  }
                                  );
                                },
                                labelKey:'ExpenseTo'
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SizedBox(
                              height: 35,
                              child: Utils.getTextFormField("Enter Amount", amountController)
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
                            child: Utils.dropdownBox('Select ', payments,
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
                          height: 40, // Set the button's height
                          child: Utils.getAddFilledButton(
                            'Save', // Button label
                                () {
                              _save(); // Callback function
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
