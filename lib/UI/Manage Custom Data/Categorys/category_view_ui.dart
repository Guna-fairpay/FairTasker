
import 'package:fairpytasker/Bloc/vehicle_data_bloc.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Utilities/str.dart';
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

  void _filterCategory(String query) {
    setState(() {
      filteredCategory = category.where((category) {
        final name = category['name']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return name.contains(searchQuery);
      }).toList();
    });
  }

  void _navigateToCategoryAddUI() async {
    final newCategory = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const AddCategoryPage()),
    );
    if (newCategory != null) {
      setState(() {
        categoryDataBloc.add(AddCategoryData(
            name: newCategory['name'],
            id: newCategory['id']));
      });
      categoryDataBloc.add(const GetCategory());
      Utils.showMobileToast('Category added successfully');
    }
  }

  void _navigateToCategoryEditUI(int index) async {
    final updatedCategory = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) =>
          EditCategoryPage(category: filteredCategory[index]),
      ),
    );
    if (updatedCategory != null) {
      categoryDataBloc.add(AddCategoryData(
          name: updatedCategory['name'],
          id: updatedCategory['id']));
      categoryDataBloc.add(const GetCategory());
      Utils.showMobileToast('Category updated successfully');
    }
  }

  Future<void> _deleteCategory(int index) async {
    final confirmed = await Utils.showCustomDeleteDialog(context,'Category');
    if (confirmed == true) {
      final category = filteredCategory[index];
      categoryDataBloc.add(DeleteCategory(id: category['id']));
      categoryDataBloc.add(const GetCategory());
      Utils.showMobileToast('Category deleted successfully');
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
          title: const Text('Category'),
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.close,
              ),
            ),
          ]),
      body: BlocProvider(
        create: (_) => categoryDataBloc,
        child: BlocConsumer<VehicleDataBloc, VehicleDataState>(
            listener: (context, state) {
          if (state is VehicleDataLoading) {
            EasyLoading.show();
          } else if (state is CategoryListLoaded) {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            filteredCategory.clear();
            filteredCategory.addAll(state.categoryList ?? []);
            final List<Map<String, dynamic>> localList = [];
            localList.addAll(state.categoryList ?? []);
            localList.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
                .compareTo(DateTime.parse(a['created_at'] ?? '')));
            filteredCategory.addAll(localList.reversed.toList());
            category = localList;
            filteredCategory = List.from(category);
          } else {
            categoryDataBloc.add(const GetCategory());
            EasyLoading.show();
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
                  Expanded(
                    child: Utils.getSearchBarUI(
                      onChange:
                      (value) {
                        _filterCategory(value);
                      },
                      searchController:searchController,
                    ),
                  ),
                  Utils.getAddElevatedButton(_navigateToCategoryAddUI,),
                ],
              ),
              Expanded(
                child:filteredCategory.isEmpty && state is CategoryListLoaded
                  ? const Center(child: Text(
                  Str.noMatchFound,
                ),): ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    height: 0.5,
                  ),
                  itemCount: filteredCategory.length,
                  itemBuilder: (context, index) {
                    final name = filteredCategory[index];
                    return InkWell(
                      onTap: () => _navigateToCategoryEditUI(index),
                      child: SafeArea(
                        minimum: 10.padding,
                        child: Row(
                          children: [
                            Expanded(
                              child: Utils.getText(
                                name['name'] ?? '',
                              ),
                            ),
                            InkWell(
                                onTap: ()=> _deleteCategory(index),
                              child: const Icon(
                                  Icons.delete_outline,
                                  color: AppC.redAccent
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ]),
          );
        }),
      ),
    );
  }
}
