import 'dart:io';
import 'package:fairpytasker/Event/todo_view_event.dart';
import 'package:fairpytasker/State/todo_view_state.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Bloc/todo_view_bloc.dart';
import '../../../../Component/drawer_ui.dart';
import '../../../../Component/header.dart';
import '../../../../Utilities/num.dart';

class OtherEditUi extends StatefulWidget {
  final Map<String, dynamic> existingData; // Expecting data to be passed from the previous screen.

  const OtherEditUi({super.key, required this.existingData});

  @override
  State<OtherEditUi> createState() => _OtherEditUiState();
}

class _OtherEditUiState extends State<OtherEditUi> {
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
  dynamic editId;

  List<Map<String,dynamic>> categoryNames=[];
  List<Map<String,dynamic>> subcategory=[];
  List<Map<String,dynamic>> roles=[];
  List<Map<String,dynamic>> payments=[];
  List<Map<String,dynamic>> choices=[{'value':1,'choices':'Yes'},{'value':0,'choices':'No'}];
  List<Map<String, dynamic>> filteredSubcategories = [];
  List<Map<String, dynamic>> trimmedPayments=[];
  List<Map<String, dynamic>> initialChoice=[];
  Map<String,dynamic> Values={};

  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  bool isDateFieldEmpty=false;
  bool loading = false;
  dynamic selectedCategorys;
  dynamic selectedSubCategorys;
  dynamic selectedPayments;
  dynamic selectedChoices;
  DateTime? selectedDates;


  @override
  void initState() {
    expenseBloc=TodoViewBloc();
    expenseBloc.add(const GetPaymentData());
    Values.addAll(widget.existingData);
    editId=widget.existingData['id'];
    amountController.text= widget.existingData['expense_amount'].toString();
    descriptionController.text = widget.existingData['expense_description']?? '';
    selectedDates=DateTime.tryParse(widget.existingData['expense_date']);
    dateController.text = widget.existingData['expense_date'];
    if (widget.existingData['category_id'] != null) {
      selectedCategory = categoryNames.firstWhere(
            (category) => category['id'] == widget.existingData['category_id'],
        orElse: () => {},
      );
    }

    if (widget.existingData['subcategory_id'] != null) {
      selectedSubCategory = subcategory.firstWhere(
            (subCategory) => subCategory['id'] == widget.existingData['subcategory_id'],
        orElse: () => {},
      );
    }

    selectedChoices = widget.existingData['approved'] == 1 ? choices[0] : choices[1];
    print("choice $selectedChoice");
    //selectedPayment = payments.firstWhere((payment) => payment['id'] == widget.existingData['payment_id']);

    super.initState();
  }

  void _save() {
    //print("Selected payment: $selectedChoice");
    if(selectedChoice!=null){
      if(selectedChoice['choices']=='Yes') {
        selectedChoice=1;
      }else{
        selectedChoice=0;
      }
    }else{
      selectedChoice=selectedChoices['value'];
    }
    print("Selected payment: $selectedChoice");
    final newData = {
      'id': editId,
      'expense_date': dateController.text.toString(),
      'approved': selectedChoice,
      'expense_amount': double.tryParse(amountController.text) ?? 0.0,
      'category_id': selectedCategory?['id'] ?? selectedCategorys?['id'], // Fallback to existing data
      'subcategory_id': selectedSubCategory?['id'] ?? selectedSubCategorys?['id'], // Ensure this is handled similarly if required
      'expense_description': descriptionController.text,
      'payment_method_id': selectedPayment?['id'] ?? selectedPayments['id'], // Ensure this is handled similarly if required
      'expense_to': subcategory[0]['expense_to'], // Handle subcategory safety
      'attachments': _images.map((e) => e.path).toList(), // Image paths if any
    };

    print("New data to be saved: $newData");


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
                //print(widget.existingData);
                //print(widget.existingData['approved']);
                //print(widget.existingData['payment_method_id']);
                if(state is TodoListLoading){
                  loading=true;
                }
                else if (state is ExpenseCategoryLoaded){
                  loading=false;
                  categoryNames.clear();
                  categoryNames.addAll(state.data??[]);
                  subcategory.clear();
                  subcategory.addAll(
                      categoryNames[0]['subcategories'].whereType<Map<String, dynamic>>());
                  //print(categoryNames);
                  selectedCategorys=categoryNames.firstWhere((item) => item['name'] == widget.existingData['category']['name']);
                  selectedSubCategorys=subcategory.firstWhere((item) => item['name'] == widget.existingData['subcategory']['name']);
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

                    selectedPayments = trimmedPayments.firstWhere(
                          (item) => item['id'] == widget.existingData['payment_method_id'],
                    );
                  });
                }
              },
              builder: (context, state) {
                return Stack(
                  children: [
                    SingleChildScrollView( // Wrap with SingleChildScrollView to make it scrollable
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
                                Utils.getText('Edit Other Expense', size: 16, weight: FontWeight.bold,),
                              ],
                            ),
                            const SizedBox(height: 20,),
                            // First Row: Select Person & Date Picker
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 35,
                                    child: Utils.getBackgroundFilledTextFieldFirstLetterCaps('',
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
                                          initial: selectedDates,
                                        ).then((value) {
                                          if (value != null) {
                                            dateController.text = "${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}";
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
                                      Utils.getBackgroundFilledTextFieldFirstLetterCaps("Enter Amount", amountController)
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
                                          selectedCategory = value ?? selectedCategorys;
                                        });
                                      },
                                      labelKey: 'name',
                                      initialSelection: selectedCategorys ?? selectedCategory,
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
                                            selectedSubCategory = value ?? selectedCategorys;
                                          });
                                        },
                                        labelKey: 'name', // Key to display in the dropdown
                                        initialSelection: selectedSubCategorys ?? selectedSubCategory,
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
                                          (value) {
                                        setState(() {
                                          selectedPayment = value ?? selectedPayments;
                                        }
                                        );
                                      },
                                      labelKey:'name',
                                      initialSelection: selectedPayments,
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
                                          print("selected choice $selectedChoices");
                                          selectedChoice = selectedValue ?? selectedChoices['choices'];
                                          print("selected choice $selectedValue");
                                          print("selected choice $selectedChoice");
                                        });
                                      },
                                      labelKey:'choices',
                                      initialSelection: selectedChoices,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Expense Description
                            Utils.getBackgroundFilledTextFieldFirstLetterCaps(
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
                    ),
                  ],
                );
              }
          ),
        )
    );
  }
}
