import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import 'subcategory_add_ui.dart';
import 'subcategory_edit_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubcategoryViewui extends StatefulWidget {
  const SubcategoryViewui({super.key});

  @override
  State<SubcategoryViewui> createState() => _SubcategoryViewuiState();
}

class _SubcategoryViewuiState extends State<SubcategoryViewui> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  late VehicleDataBloc vehicleDataBloc;
  List<Map<String, dynamic>> expenseToData = [];
  dynamic selectedExpenseToData;
  List<Map<String, dynamic>> categoriesData = [];
  dynamic selectedExpenseCategories;
  List<Map<String, dynamic>> subcategory = []; // Sample data list
  List<Map<String, dynamic>> filteredsubcategory = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    vehicleDataBloc = VehicleDataBloc();
    vehicleDataBloc.add(const GetSubCategory());
  }

  void _filterSubcategory(String query) {
    setState(() {
      filteredsubcategory = subcategory.where((sub) {
        final name = sub['name']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return name.contains(searchQuery);
      }).toList();
    });
  }

  Future<void> _navigateToSubcAddUI() async {
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

  Future<void> _navigateToEditSubcUI(int index) async {
    final updatedsubcat = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SubcategoryEditui(subcategory: filteredsubcategory[index]),
      ),
    );

    if (updatedsubcat != null) {
      vehicleDataBloc.add(AddSubCategoryData(
          id: updatedsubcat['id'],
          name: updatedsubcat['name'],
          parentId: updatedsubcat['parent_id'].toString(),
          expenseTo: updatedsubcat['expense_to'].toString()));
      vehicleDataBloc.add(const GetSubCategory());
      Utils.showMobileToast('SubCategory Updated successfully');
    }
  }

  Future<void> _deletesubc(int index) async {
    final confirmed = await _confirmDelete(context);
    if (confirmed == true) {
      final subcategory = filteredsubcategory[index];
      vehicleDataBloc.add(DeleteCategory(id: subcategory['id']));
      vehicleDataBloc.add(const GetSubCategory());
      Utils.showMobileToast('Deleted successfully');
    }
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppC.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Utils.getText('Are you sure!'),
        content:
            Utils.getText('Are you sure you want to delete this Subcategory?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Confirm the deletion
            },
            child: Utils.getText('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancel the deletion
            },
            child: Utils.getText('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0), // Change the height here
        child: HeaderView(),
      ),
      body: BlocProvider(
        create: (_) => vehicleDataBloc..add(const GetSubCategory()),
        child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
            listener: (context, state) async {
          print(state);
          if (state is VehicleDataLoading) {
            loading = true;
          } else if (state is SubCategoryListLoaded) {
            setState(() {
              loading = false;
              filteredsubcategory.clear();
              categoriesData.clear();
              expenseToData.clear();
              categoriesData = state.categoriesResponse?.data ?? [];

              // Ensure all elements are maps and have subcategories as List<Map<String, dynamic>>
              List<Map<String, dynamic>> list = [];
              for (var element in categoriesData) {
                if (element['subcategories'] != null &&
                    element['subcategories'] is List) {
                  final subcategories = element['subcategories'] as List;
                  list.addAll(subcategories.whereType<Map<String, dynamic>>());
                }
              }

              // Sort the list by creation date, checking for non-null and parseable dates
              list.sort((a, b) {
                final dateA = a['created_at'];
                final dateB = b['created_at'];
                if (dateA == null || dateB == null) return 0;
                return DateTime.parse(dateB).compareTo(DateTime.parse(dateA));
              });

              expenseToData.addAll(state.categoriesResponse?.expenseTo ?? []);
              subcategory = list;
              filteredsubcategory = List.from(subcategory);
            });
          } else {
            loading = true;
            vehicleDataBloc.add(const GetSubCategory());
          }
        }, builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
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
                        Utils.getText('Sub Category',
                            size: 20, weight: FontWeight.bold),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: Utils.getSearchBarUI(onChange: _filterSubcategory, searchController: searchController,),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 40,
                          child: Utils.getAddFilledButton('Add', () {
                            _navigateToSubcAddUI();
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredsubcategory.length,
                        itemBuilder: (context, index) {
                          final subCategoryName = filteredsubcategory[index];
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) => _deletesubc(index),
                                  backgroundColor: AppC.white,
                                  foregroundColor: AppC.redAccent,
                                  icon: Icons.delete_outline,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _navigateToEditSubcUI(index);
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                color: AppC.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      // Align to the left
                                      child: Utils.getText(
                                        subCategoryName['name'] ?? '',
                                        align: TextAlign.left,
                                        // Text aligned to the left
                                        weight: FontWeight.bold,
                                      ),

                                      // Add more widgets or content here if needed
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                  visible: loading,
                  child: Center(child: Utils.getProgressIndicator(context)))
            ],
          );
        }),
      ),
      drawer: const DrawerView(),
    );
  }
}
