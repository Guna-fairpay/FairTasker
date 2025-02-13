import 'package:fairpytasker/Component/header.dart';
import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import 'category_add_ui.dart';
import 'category_edit_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryViewUi extends StatefulWidget {
  const CategoryViewUi({super.key});

  @override
  State<CategoryViewUi> createState() => _CategoryViewUiState();
}

class _CategoryViewUiState extends State<CategoryViewUi> {
  TextEditingController searchController = TextEditingController();
  late VehicleDataBloc categoryDataBloc;
  final FocusNode searchFocusNode = FocusNode();
  List<Map<String, dynamic>> category = [];
  List<Map<String, dynamic>> filteredCategory = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    categoryDataBloc = VehicleDataBloc();
    categoryDataBloc.add(const GetCategory());
  }

  @override
  void dispose() {
    categoryDataBloc.close();
    searchController.dispose();
    super.dispose();
  }

  void _filtercategory(String query) {
    setState(() {
      filteredCategory = category.where((categorys) {
        final name = categorys['name']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return name.contains(searchQuery);
      }).toList();
    });
  }

  void _navigateToCategoryAddUI() async {
    final newcategorys = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const AddCategoryPage()),
    );

    if (newcategorys != null) {
      setState(() {
        categoryDataBloc.add(AddCategoryData(
            name: newcategorys['name'], id: newcategorys['id']));
      });
      categoryDataBloc.add(const GetCategory());
      Utils.showMobileToast('Category added successfully');
    }
  }

  void _navigateToCategoryEditUI(int index) async {
    final updatedCategory = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditCategoryPage(category: filteredCategory[index]),
      ),
    );
    if (updatedCategory != null) {
      categoryDataBloc.add(AddCategoryData(
          name: updatedCategory['name'], id: updatedCategory['id']));
      categoryDataBloc.add(const GetCategory());
      Utils.showMobileToast('Category updated successfully');
    }
  }

  Future<void> _deleteCategory(int index) async {
    final confirmed = await _confirmDelete(context);
    if (confirmed == true) {
      final category = filteredCategory[index];
      categoryDataBloc.add(DeleteCategory(id: category['id']));
      categoryDataBloc.add(const GetCategory());
      Utils.showMobileToast('Category deleted successfully');
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
            Utils.getText('Are you sure you want to delete this category?'),
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
        create: (_) => categoryDataBloc,
        child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
            listener: (context, state) {
          if (state is VehicleDataLoading) {
            loading = true;
          } else if (state is CategoryListLoaded) {
            loading = false;
            filteredCategory.clear();
            filteredCategory.addAll(state.categoryList ?? []);
            List<Map<String, dynamic>> localList = [];
            localList.addAll(state.categoryList ?? []);
            localList.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
                .compareTo(DateTime.parse(a['created_at'] ?? '')));
            filteredCategory.addAll(localList.reversed.toList());
            category = localList;
            filteredCategory = List.from(category);
          } else {
            categoryDataBloc.add(const GetCategory());
            loading = true;
          }
        }, builder: (context, state) {
          return Stack(
            children: [
              Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          Utils.getText('Category',
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
                              child: Utils.getSearchBarUI(
                                onChange: (value) {
                                  _filtercategory(value);
                                },
                                searchController: searchController,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 40,
                            child: Utils.getAddFilledButton('Add', () {
                              _navigateToCategoryAddUI();
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                    itemCount: filteredCategory.length,
                    itemBuilder: (context, index) {
                      final name = filteredCategory[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Slidable(
                          key: ValueKey(name),
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) => _deleteCategory(index),
                                backgroundColor: AppC.white,
                                foregroundColor: AppC.red,
                                icon: Icons.delete_outline,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () => _navigateToCategoryEditUI(index),
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              color: AppC.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                alignment: Alignment.centerLeft,
                                height: 42,
                                child: Utils.getText(
                                  name['name'] ?? '',
                                  weight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ]),
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
