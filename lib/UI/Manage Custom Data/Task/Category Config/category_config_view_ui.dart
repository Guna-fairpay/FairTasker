
import 'dart:math';

import 'package:fairpytasker/Bloc/todo_view_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Category%20Config/category_config_add_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Category%20Config/category_config_edit_ui.dart';
import 'package:flutter/material.dart';
import '../../../../Event/todo_view_event.dart';
import '../../../../State/todo_view_state.dart';
import '../../../../Utilities/appC.dart';
import '../../../../Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryConfigViewUI extends StatefulWidget {
  const CategoryConfigViewUI({super.key});

  @override
  State<CategoryConfigViewUI> createState() => _CategoryConfigViewUIState();
}

class _CategoryConfigViewUIState extends State<CategoryConfigViewUI> {

  late TodoViewBloc todoViewBloc;
  TextEditingController searchController=TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  List<Map<String,dynamic>> categoryConfig = [];
  List<Map<String,dynamic>> filteredConfig = [];

  bool loading=true;

  @override
  void initState() {
    super.initState();
    todoViewBloc=TodoViewBloc();
  }

  void _filteredConfig(String query) {
    setState(() {
      filteredConfig = categoryConfig.where((config) {
        final name = config['name']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return name.contains(searchQuery);
      }).toList();
    });
  }

  void _navigateToCategoryConfigAddUI() async {
    final newConfig = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => CategoryConfigAddUI(category: categoryConfig,)),
    );
    if (newConfig != null) {
      print( "Name : ${newConfig['name']}",);
      todoViewBloc.add(AddCategoryConfigData(
          name: newConfig['name'],
          userType: newConfig['todo_user_type'],
          parentId: newConfig['parent_id'],
          id: newConfig['id']));
      todoViewBloc.add(const GetCategoryConfigData());
      Utils.showMobileToast('CategoryConfig Added Successfully');
    }
  }

  void _navigateToCategoryConfigEditUI(int index) async {
    final updateConfig = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryConfigEditUI(
          config: filteredConfig[index],
        ),
      ),
    );
    if (updateConfig != null) {
      todoViewBloc.add(AddCategoryConfigData(
          name: updateConfig['name'],
          userType: updateConfig['todo_user_type'],
          parentId: updateConfig['parent_id'],
          id: updateConfig['id']));
      todoViewBloc.add(const GetCategoryConfigData());
      Utils.showMobileToast('CategoryConfig updated successfully');

    }
  }

  void _deleteConfig(int index) async {
    final confirmed = await Utils.showCustomDeleteDialog(context,'Category');
    if (confirmed == true) {
      final delete=filteredConfig[index];
      todoViewBloc.add(DeleteCategoryConfig(id: delete['id'].toString())
      );
      todoViewBloc.add(const GetCategoryConfigData());
      Utils.showMobileToast('Deleted!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      body: BlocProvider(
        create: (context)=>todoViewBloc..add(const GetCategoryConfigData()),
        child: BlocConsumer<TodoViewBloc,TodoViewState>(
            listener: (context, state) {
              if(state is TodoListLoading){
                loading=true;
              }
              else if (state is CategoryConfigListLoaded) {
                loading = false;
                categoryConfig.clear();
                List<Map<String, dynamic>> list = [];
                list.addAll(state.data ?? []);
                list.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
                .compareTo(DateTime.parse(a['created_at'] ?? '')));
                categoryConfig=list;
                filteredConfig.addAll(categoryConfig);
              }
              else if (state is CategoryConfigLoaded){
                loading = false;
                categoryConfig.clear();
                todoViewBloc.add(const GetCategoryConfigData());
              }
              else {
                todoViewBloc.add(const GetCategoryConfigData());
                loading = true;
              }
            },
          builder: (context,state) {
            return Stack(
              children: [
                Column(
                  children: [
                    Row(spacing: 10,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: Utils.getSearchBarUI(
                                  () {
                                // onTap action for search bar if needed
                              },
                                  (value) {
                                    _filteredConfig(value);
                              },
                              searchController,
                            ),
                          ),
                        ),
                        Utils.getAddElevatedButton(
                              ()=> _navigateToCategoryConfigAddUI(),),
                      ],
                    ),
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Container(
                        color: AppC.blue50,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Utils.getText(
                                'Name',
                                weight: FontWeight.bold)
                            ),
                            Expanded(child: Utils.getText(
                              'Category',
                               weight: FontWeight.bold)
                            ),
                            const SizedBox(width: 25,)
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: filteredConfig.length,
                        itemBuilder: (_, index) {
                          final config = filteredConfig[index];
                          final parentCategory = categoryConfig.firstWhere(
                                (cat) => cat['id'] == config['parent_id'],
                            orElse: () => {},
                          );
                          return GestureDetector(
                            onTap: () => _navigateToCategoryConfigEditUI(index),
                            child: ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Utils.getText(
                                          config['name'] ?? '',
                                          weight: FontWeight.bold,

                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Utils.getText(
                                          parentCategory['name'] ?? '',
                                          weight: FontWeight.bold,
                                          color: AppC.subText,
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _deleteConfig(index),
                                    child: const Icon(
                                      Icons.delete_outline,
                                      color: AppC.redAccent,
                                    ),
                                  ),
                                ],
                              ),

                            ),
                          );
                        }, separatorBuilder: (context, index) =>const Divider(height: 0.5,),
                      ),
                    ),
                  ],
                ),
                Visibility(
                    visible: loading,
                    child: Center(child: Utils.getProgressIndicator(context))
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
