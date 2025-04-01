
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class SubcategoryEditUI extends StatefulWidget {
  final Map<String, dynamic> subcategory;

  const SubcategoryEditUI({super.key, required this.subcategory});

  @override
  State <SubcategoryEditUI> createState() => _SubcategoryEditUIState();
}

class _SubcategoryEditUIState extends State<SubcategoryEditUI> {
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
    setState(() {});

    if (subcategoryController.text.isEmpty) {
      return ;
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
      appBar: AppBar(
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        title: const Text('Edit Sub Category'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close,),)
        ],
      ),
      body: BlocProvider(
        create: (context) => vehicleDataBloc..add(const GetSubCategory()),
        child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
          listener: (context, state) {
            if (state is VehicleDataLoading) {
            EasyLoading.show();
            }
            else if (state is SubCategoryListLoaded) {
              if (EasyLoading.isShow) EasyLoading.dismiss();
              categoriesData.addAll(state.categoriesResponse?.data ?? []);
              expenseToData.addAll(state.categoriesResponse?.expenseTo ?? []);
              selectedCategory = categoriesData.firstWhere(
                (category) => category['subcategories']
                    ?.any((sub) => sub['id'] == widget.subcategory['id'])
                    ?? false,);
              selectedExpenseTo = expenseToData.firstWhere(
                (expenseTo) => expenseTo['id'] ==
                    widget.subcategory['expense_to_data']?['id']);
              setState(() {});
            }
          },
          builder: (context, state) {
            return SafeArea(
              minimum: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: ListView(
                children: [
                  Utils.getTextFormField(
                    'Sub Category',
                    subcategoryController,
                    autoValidate: AutovalidateMode.onUserInteraction,
                    validator: (val) => val!.isEmpty ? 'Please enter sub category' : null,
                  ),
                  const SizedBox(height: 10),
                  Utils.dropdownBox(
                      "Select Category",
                      categoriesData, (selectedValue) {
                      selectedCategory=selectedValue;
                      },
                      labelKey:'name',
                    initialSelection: selectedCategory,
                  ),
                  const SizedBox(height: 10),
                  Utils.dropdownBox(
                    "Select ExpenseTo",
                    expenseToData, (selectedValue) {
                    selectedExpenseTo=selectedValue;
                  },
                    labelKey:'expense_to',
                    initialSelection: selectedExpenseTo,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Utils.getElevatedButton(() => _save()),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
