import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';
import '../../../Utilities/utils.dart';

class SubcategoryEditui extends StatefulWidget {
  final Map<String, dynamic> subcategory;

  const SubcategoryEditui({super.key, required this.subcategory});

  @override
  _SubcategoryEdituiState createState() => _SubcategoryEdituiState();
}

class _SubcategoryEdituiState extends State<SubcategoryEditui> {
  late VehicleDataBloc vehicleDataBloc;
  late final TextEditingController subcategoryController;
  List<Map<String, dynamic>> categoriesData = [];
  dynamic selectedCategory;
  List<Map<String, dynamic>> expenseToData = [];
  dynamic selectedExpenseTo;
  bool isSubcategoryFieldEmpty = false;

  @override
  void initState() {
    super.initState();
    vehicleDataBloc = VehicleDataBloc();
    subcategoryController =
        TextEditingController(text: widget.subcategory['name']);
  }

  @override
  void dispose() {
    subcategoryController.dispose();
    super.dispose();
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

    final updatedSubcategory = {
      'name': subcategoryController.text,
      'id': widget.subcategory['id'],
      'parent_id': selectedCategory!['id'],
      'expense_to': selectedExpenseTo!['id'],
    };
    Navigator.of(context).pop(updatedSubcategory);
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
          listener: (context, state) {
            if (state is SubCategoryListLoaded) {
              categoriesData = state.categoriesResponse?.data ?? [];
              expenseToData = state.categoriesResponse?.expenseTo ?? [];
              selectedCategory = categoriesData.firstWhere(
                (category) =>
                    category['subcategories']?.any(
                        (sub) => sub['name'] == widget.subcategory['name']) ??
                    false,
              );
              selectedExpenseTo = expenseToData.firstWhere(
                (expenseTo) =>
                    expenseTo['expense_to'] ==
                    widget.subcategory['expense_to_data']?['expense_to'],
              );
              setState(() {});
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
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
                            Utils.getText('Edit Sub Category',
                                size: 20, weight: FontWeight.bold),
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
                        const SizedBox(height: 20),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppC.fieldBase,
                              width: Num.borderWidthField,
                            ),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(Num.subradiusButton)),
                          ),
                          child: DropdownButton<Map<String, dynamic>>(
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
                            underline:
                                Container(height: 0, color: Colors.transparent),
                            onChanged: (Map<String, dynamic>? value) {
                              setState(() {
                                selectedCategory = value;
                              });
                            },
                            items: categoriesData
                                .map<DropdownMenuItem<Map<String, dynamic>>>(
                              (Map<String, dynamic> value) {
                                return DropdownMenuItem<Map<String, dynamic>>(
                                  value: value,
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
                        const SizedBox(height: 15),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppC.fieldBase,
                              width: Num.borderWidthField,
                            ),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(Num.subradiusButton)),
                          ),
                          child: DropdownButton<Map<String, dynamic>>(
                            hint: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Utils.getText('Select ExpenseTo',
                                  color: AppC.grey),
                            ),
                            value: selectedExpenseTo,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            elevation: 3,
                            dropdownColor: AppC.white,
                            underline:
                                Container(height: 0, color: Colors.transparent),
                            onChanged: (Map<String, dynamic>? value) {
                              setState(() {
                                selectedExpenseTo = value;
                              });
                            },
                            items: expenseToData
                                .map<DropdownMenuItem<Map<String, dynamic>>>(
                              (Map<String, dynamic> value) {
                                return DropdownMenuItem<Map<String, dynamic>>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child:
                                        Utils.getText('${value['expense_to']}'),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
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
