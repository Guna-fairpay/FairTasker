
import 'dart:io';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../../../../Component/drawer_ui.dart';
import '../../../../Component/header.dart';
import '../../../../Utilities/num.dart';

class ExpensePersonEditUi extends StatefulWidget {

  final dynamic existingData;
  const ExpensePersonEditUi({super.key, required this.existingData});

  @override
  State<ExpensePersonEditUi> createState() => _ExpensePersonEditUiState();
}

class _ExpensePersonEditUiState extends State<ExpensePersonEditUi> {

  final TextEditingController amountController= TextEditingController();
  final TextEditingController descriptionController=TextEditingController();
  final TextEditingController dateController=TextEditingController();
  dynamic selectedName;
  dynamic selectedCategory;
  dynamic selectedSubCategory;
  dynamic selectedExpenseTo;
  //dynamic selectedSubCategory;
  dynamic selectedPayment;
  dynamic selectedChoice;
  bool isDateFieldEmpty=false;

  @override
  void initState() {
    super.initState();

    // Initialize the form fields with the existing data passed to this screen.
    if (widget.existingData != null) {
      // Initialize the controllers with existing data
      amountController.text = widget.existingData['amount'] ?? '';
      descriptionController.text = widget.existingData['description'] ?? '';
      dateController.text = widget.existingData['date'] ?? '';

      // Initialize selectedName and other fields
      selectedName = widget.existingData['name'];

      // Use firstWhere to find the expenseTo value from the list
      selectedExpenseTo = expenseto.firstWhere(
            (item) => item['name'] == widget.existingData['expenseTo'],
        orElse: () => {}, // Return an empty map if not found
      );

      // Use firstWhere to find the subcategory
      selectedSubCategory = subcategory.firstWhere(
            (item) => item['name'] == widget.existingData['subcategory'],
        orElse: () => {}, // Return an empty map if not found
      );

      // Initialize selectedPayment
      selectedPayment = payments.firstWhere(
            (item) => item['name'] == widget.existingData['selectedPayment'],
        orElse: () => {}, // Return an empty map if not found
      );

      // Initialize selectedChoice as 'Yes' or 'No' based on approval
      selectedChoice = widget.existingData['approved'] == 1 ? 'Yes' : 'No';
    }
  }

  void _save() {
    // Convert "Yes" or "No" to 1 or 0
    selectedChoice = (selectedChoice == "Yes") ? 1 : 0;

    // Create the new data map from controllers and selected values
    final newdata = {
      'date': dateController.text,
      'amount': amountController.text,
      'approved': selectedChoice,
      'name': selectedName?['name'], // Added dynamic selectedName
      'category': selectedCategory?['category'], // Optional chaining to handle null
      'subcategory': selectedSubCategory?['subcategory'], // Optional chaining to handle null
      'description': descriptionController.text,
      'selectedPayment': selectedPayment?['payment'], // Optional chaining to handle null
      'expenseTo': selectedExpenseTo['ExpenseTo'], // Added dynamic selectedExpenseTo
    };

    // Print statements for debugging
    print('New Data: $newdata');
    // print("Category Type: ${newdata['category']?.runtimeType}");
    // print("Subcategory Type: ${newdata['subcategory']?.runtimeType}");

    // Return the new data
    Navigator.pop(context, newdata);
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

  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  List<Map<String,dynamic>> names=[{'firstname': 'John','lastname':'Doe','name':''},{
    'firstname': 'Jane','lastname':'Smith','name':''},
    {'firstname': 'Alice','lastname':'Jhonson','name':''},
    {'firstname': 'Bob','lastname':'Brown','name':''},
    {'firstname': 'Charlie','lastname':'White','name':''}];
  List<Map<String,dynamic>> category=[{"category":"Admin"}];
  List<Map<String,dynamic>> subcategory=[{"subcategory":"Payroll partime"}];
  List<Map<String,dynamic>> expenseto=[{"ExpenseTo":"FairPY"},{"ExpenseTo":"Cohort"}];//payments
  List<Map<String,dynamic>> payments=[{"payment":"Corporate card"},{"payment":"Zelle"},{"payment":"Cash"},{"payment":"Personal cash/card"},{"payment":"Other"}];
  List<Map<String,dynamic>> choices=[{"choice":"Yes"},{"choice":"No"}];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const DrawerView(),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: HeaderView(),
      ),
      body: SingleChildScrollView( // Wrap with SingleChildScrollView to make it scrollable
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
                  Utils.getText('Edit Person Expense', size: 16, weight: FontWeight.bold,),
                ],
              ),
              const SizedBox(height: 20,),
              // First Row: Select Person & Date Picker
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 35,
                      child: Utils.dropdownBox(
                        'Select Person',
                        names.map((person) => {
                          'name': '${person['firstname']} ${person['lastname']}'
                        }).toList(), // Combine firstname and lastname
                            (selectedValue) {
                          setState(() {
                            selectedName = selectedValue;
                          });
                        },
                        labelKey: 'name',
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
                      child: Utils.dropdownBox('Select Category', category,
                              (selectedValue) {
                            setState(() {
                              selectedCategory = selectedValue;
                            }
                            );
                          },
                          labelKey:'category',
                          initialSelection: selectedCategory
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 35,
                      child: Utils.dropdownBox('Select Subcategory', subcategory,
                              (selectedValue) {
                            setState(() {
                              selectedSubCategory = selectedValue;
                            }
                            );
                          },
                          labelKey:'subcategory',
                          initialSelection: selectedSubCategory
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
                              selectedExpenseTo = selectedValue;
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
                          labelKey:'payment'
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
                          labelKey:'choice'
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
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0), // Add space below
                  child: Container(
                    height: 30,
                    width: 150,
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
                            right: -5,
                            top: 2,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.red, // Circle color
                                  radius: 10, // Adjust the radius for the desired size
                                  child: IconButton(
                                    padding: EdgeInsets.zero, // Remove padding
                                    constraints: BoxConstraints(), // Remove extra constraints
                                    icon: const Icon(Icons.delete, color: Colors.white, size: 16), // Adjust icon size
                                    onPressed: () => _removeImage(index),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove_red_eye, color: Colors.blue, size: 20),
                                  onPressed: () => _viewImage(image),
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
      ),
    );
  }
}

