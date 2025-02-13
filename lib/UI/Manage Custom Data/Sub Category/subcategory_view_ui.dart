
import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import 'subcategory_add_ui.dart';
import 'subcategory_edit_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubcategoryViewUI extends StatefulWidget {
  const SubcategoryViewUI({super.key});

  @override
  State<SubcategoryViewUI> createState() => _SubcategoryViewUIState();
}

class _SubcategoryViewUIState extends State<SubcategoryViewUI> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  late VehicleDataBloc vehicleDataBloc;
  List<Map<String, dynamic>> categoriesData = [];
  List<Map<String, dynamic>> subcategory = [];
  List<Map<String, dynamic>> filteredSubcategory = [];

  @override
  void initState() {
    super.initState();
    vehicleDataBloc = VehicleDataBloc();
    vehicleDataBloc.add(const GetSubCategory());
  }

  void _filterSubcategory(String query) {
    setState(() {
      filteredSubcategory = subcategory.where((sub) {
        final name = sub['name']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return name.contains(searchQuery);
      }).toList();
    });
  }

  Future<void> _navigateToSubCategoryAddUI() async {
    final newSubcategory = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const SubcategoryAddUI()),
    );
    if (newSubcategory != null) {
      vehicleDataBloc.add(AddSubCategoryData(
        id: newSubcategory['id'],
        name: newSubcategory['name'],
        parentId: newSubcategory['parent_id'].toString(),
        expenseTo: newSubcategory['expense_to'].toString(),
      ));
      vehicleDataBloc.add(const GetSubCategory());
      Utils.showMobileToast('SubCategory Add successfully');
    }
  }

  Future<void> _navigateToEditSubCategoryUI(int index) async {
    final updatedSubCategory = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SubcategoryEditUI(subcategory: filteredSubcategory[index]),
      ),
    );
    if (updatedSubCategory != null) {
      vehicleDataBloc.add(AddSubCategoryData(
          id: updatedSubCategory['id'],
          name: updatedSubCategory['name'],
          parentId: updatedSubCategory['parent_id'].toString(),
          expenseTo: updatedSubCategory['expense_to'].toString()));
      vehicleDataBloc.add(const GetSubCategory());
      Utils.showMobileToast('SubCategory Updated successfully');
    }
  }

  Future<void> _deleteSubCategory(int index) async {
    final confirmed = await Utils.showCustomDeleteDialog(context ,'SubCategory');
    if (confirmed == true) {
      final subcategory = filteredSubcategory[index];
      vehicleDataBloc.add(DeleteCategory(id: subcategory['id']));
      vehicleDataBloc.add(const GetSubCategory());
      Utils.showMobileToast('Deleted successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        title: const Text('Sub Category'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close,
            ),
          ),
        ],
      ),
      body: BlocProvider(
        create: (_) => vehicleDataBloc..add(const GetSubCategory()),
        child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
            listener: (context, state) async {
          if (state is VehicleDataLoading) {
            EasyLoading.show();
          } else if (state is SubCategoryListLoaded) {
              if (EasyLoading.isShow) EasyLoading.dismiss();
              filteredSubcategory.clear();
              categoriesData.clear();
              categoriesData = state.categoriesResponse?.data ?? [];
              final List<Map<String, dynamic>> list = [];
              for (var element in categoriesData) {
                if (element['subcategories'] != null &&
                    element['subcategories'] is List) {
                  final subcategories = element['subcategories'] as List;
                  list.addAll(subcategories.whereType<Map<String, dynamic>>());
                }
              }
              list.sort((a, b) {
                final dateA = a['created_at'];
                final dateB = b['created_at'];
                if (dateA == null || dateB == null) return 0;
                return DateTime.parse(dateB).compareTo(DateTime.parse(dateA));
              });
              subcategory = list;
              filteredSubcategory = List.from(subcategory);
          } else {
            EasyLoading.show();
            vehicleDataBloc.add(const GetSubCategory());
          }
        }, builder: (context, state) {
          return SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Column(
              spacing: 10,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Expanded(child: Utils.getSearchBarUI(onChange: _filterSubcategory, searchController: searchController)),
                    Utils.getAddElevatedButton(() => _navigateToSubCategoryAddUI())
                  ],
                ),
                Container(
                  color: AppC.blue50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(child: Utils.getText('Sub Category',weight: FontWeight.bold)),
                        Expanded(child: Utils.getText('Category',weight: FontWeight.bold)),
                        const SizedBox(width: 30,)
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context,index)=> const Divider(height: 0.5,),
                    itemCount: filteredSubcategory.length,
                    itemBuilder: (context, index) {
                      final subCategoryName = filteredSubcategory[index];
                      final category = categoriesData.firstWhere(
                            (cat) => cat['id'] == subCategoryName['parent_id'],
                        orElse: () => {},
                      );
                      return InkWell(
                        onTap: () {
                          _navigateToEditSubCategoryUI(index);
                          },
                        child: SafeArea(
                          minimum: 10.padding,
                          child: Row(
                            spacing: 10,
                            children: [
                              Expanded(
                                child: Utils.getText(
                                  subCategoryName['name'] ?? '',
                                ),
                              ),
                              Expanded(
                                child: Utils.getText(
                                  category['name'] ?? '',
                                ),
                              ),
                              InkWell(
                                  onTap: () => _deleteSubCategory(index),
                                  child: const Icon(Icons.delete_outline,color: AppC.redAccent,))
                            ],
                          ),
                        ),
                      );
                      },
                  ),
                ),
              ],
            ),
          );
            }),
      ),
    );
  }
}
