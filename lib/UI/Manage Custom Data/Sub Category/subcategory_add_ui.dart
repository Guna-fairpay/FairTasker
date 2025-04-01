
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    vehicleDataBloc = VehicleDataBloc();
  }

  void _save() {
    _formKey.currentState!.validate();
    setState(() {});
    if (subcategoryController.text.isEmpty) {
      return;
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
      appBar:AppBar(
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        title: const Text('Add Sub Category'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close,),)
        ],
      ),
      body: BlocProvider(
        create: (context) => vehicleDataBloc..add(const GetSubCategory()),
        child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
          listener: (context, state) async {
            if (state is VehicleDataLoading) {
              EasyLoading.show();
            }
            else if (state is SubCategoryListLoaded) {
              if (EasyLoading.isShow) EasyLoading.dismiss();
                categoriesData = state.categoriesResponse?.data ?? [];
                expenseToData = state.categoriesResponse?.expenseTo ?? [];
            }
          },
          builder: (context, state) {
            return SafeArea(
              minimum: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Utils.getTextFormField(
                      'Subcategory',
                      subcategoryController,
                      validator: (val) => val!.isEmpty ? 'Please enter sub category' : null,
                    ),
                    const SizedBox(height: 10),
                    Utils.dropdownBox('Select Category', categoriesData,
                        (selectedValue) {
                      setState(() {
                        selectedCategory = selectedValue;
                      });
                    }, labelKey: 'name'),
                    const SizedBox(height: 10),
                    Utils.dropdownBox('Select ExpenseTo', expenseToData,
                        (selectedValue) {
                      setState(() {
                        selectedExpenseTo = selectedValue;
                      });
                    }, labelKey: 'expense_to'),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Utils.getElevatedButton(()=> _save()),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
