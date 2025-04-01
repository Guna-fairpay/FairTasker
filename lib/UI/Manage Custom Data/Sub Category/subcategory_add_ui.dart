import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';

class SubcategoryAddUI extends StatefulWidget {
  const SubcategoryAddUI({super.key});

  @override
  State<SubcategoryAddUI> createState() => _SubcategoryAddUIState();
}

class _SubcategoryAddUIState extends State<SubcategoryAddUI> {
  late VehicleDataBloc vehicleDataBloc;
  TextEditingController subcategoryController = TextEditingController();
  List<Map<String, dynamic>> categoriesData = [];
  dynamic selectedCategory;
  List<Map<String, dynamic>> expenseToData = [];
  dynamic selectedExpenseTo;
  bool isSubcategoryFieldEmpty = false;
  Map<String, dynamic> list = {};

  @override
  void initState() {
    super.initState();
    vehicleDataBloc = VehicleDataBloc();
  }

  void _save() {
    setState(() {
      isSubcategoryFieldEmpty = subcategoryController.text.isEmpty;
    });
    if (subcategoryController.text.isEmpty ||
        selectedCategory == null ||
        selectedExpenseTo == null) {
      return Utils.showMobileToast('Please fill in all required fields');
    }
    final newSubcategory = {
      'name': subcategoryController.text,
      'parent_id': selectedCategory!['id'],
      'expense_to': selectedExpenseTo['id'],
    };
    Navigator.of(context).pop(newSubcategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: HeaderView(),
      ),
      body: BlocProvider(
        create: (context) => vehicleDataBloc..add(const GetSubCategory()),
        child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
          listener: (context, state) async {
            if (state is SubCategoryListLoaded) {
              setState(() {
                categoriesData = state.categoriesResponse?.data ?? [];
                expenseToData = state.categoriesResponse?.expenseTo ?? [];
              });
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Utils.getText('Add Sub Category',
                              size: 16, weight: FontWeight.bold),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 40,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                              '',
                              subcategoryController,
                              label: Utils.getText('Subcategory',
                                  color: AppC.grey),
                              borderColor: isSubcategoryFieldEmpty
                                  ? Colors.red
                                  : AppC.fieldBase,
                            ),
                            if (isSubcategoryFieldEmpty)
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.error_outline,
                                    color: Colors.red),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // DropdownMenu<Map<String, dynamic>>(
                      //   hintText: 'Select Category',
                      //   menuHeight: 250,
                      //   menuStyle: MenuStyle(
                      //     backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                      //     shadowColor: WidgetStateProperty.all<Color>(Colors.indigo),
                      //     surfaceTintColor: WidgetStateProperty.all<Color>(Colors.indigo),
                      //     visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity),
                      //     side: WidgetStateProperty.all<BorderSide>(BorderSide(color: Colors.blue.shade50),
                      //     ),
                      //   ),
                      //   expandedInsets: EdgeInsets.symmetric(horizontal: 0.0,),
                      //   dropdownMenuEntries: categoriesData.map<DropdownMenuEntry<Map<String, dynamic>>>(
                      //         (Map<String, dynamic> value) {
                      //       return DropdownMenuEntry<Map<String, dynamic>>(
                      //         value: value,
                      //         label: '${value['name']}',
                      //       );
                      //     },
                      //   ).toList(),
                      //   onSelected: (selectedValue) {
                      //     setState(() {
                      //       selectedCategory = selectedValue;  // Store the selected value
                      //     });
                      //   },
                      // ),
                      Utils.dropdownBox('Select Category', categoriesData,
                          (selectedValue) {
                        setState(() {
                          selectedCategory = selectedValue;
                        });
                      }, labelKey: 'name'),
                      //   Container(height: 40,
                      //     decoration: BoxDecoration(
                      //         border: Border.all(
                      //           color: AppC.fieldBase,
                      //           width: Num.borderWidthField,
                      // ),
                      // borderRadius: const BorderRadius.all(
                      //     Radius.circular(
                      //         Num.subradiusButton))),
                      //     child: DropdownMenu<Map<String, dynamic>>(
                      //       hintText: 'Select ExpenseTo',
                      //       menuHeight: 250,
                      //       textStyle: const TextStyle(fontSize:12,fontWeight: FontWeight.bold),
                      //       inputDecorationTheme: const InputDecorationTheme(
                      //        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      //         border: InputBorder. none,
                      //         isDense: true,
                      //       ),
                      //       menuStyle: MenuStyle(
                      //         backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                      //         shadowColor: WidgetStateProperty.all<Color>(Colors.blue),
                      //         surfaceTintColor: WidgetStateProperty.all<Color>(Colors.blue),
                      //         visualDensity: const VisualDensity(
                      //             vertical: VisualDensity.minimumDensity),
                      //       ),
                      //       expandedInsets: const EdgeInsets.symmetric(horizontal: 0.0),
                      //       dropdownMenuEntries: expenseToData.map<DropdownMenuEntry<Map<String, dynamic>>>(
                      //             (Map<String, dynamic> value) {
                      //           return DropdownMenuEntry<Map<String, dynamic>>(
                      //             value: value,
                      //             label: '${value['expense_to']}', // Replace with your widget
                      //           );
                      //         },
                      //       ).toList(),
                      //       onSelected: (selectedValue) {
                      //         setState(() {
                      //           selectedExpenseTo = selectedValue;  // Store the selected value
                      //         });
                      //       },
                      //     ),
                      //   ),
                      const SizedBox(height: 10),
                      Utils.dropdownBox('Select ExpenseTo', expenseToData,
                          (selectedValue) {
                        setState(() {
                          selectedExpenseTo = selectedValue;
                        });
                      }, labelKey: 'expense_to'),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 40,
                            child: Utils.getAddFilledButton(
                              'Save',
                              _save,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      drawer: const DrawerView(),
    );
  }
}
