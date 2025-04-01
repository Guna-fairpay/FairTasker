
import 'package:fairpytasker/Bloc/category_config_bloc.dart';
import 'package:fairpytasker/Event/category_config_event.dart';
import 'package:fairpytasker/State/category_config_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Category%20Config/category_config_add_ui.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Task/Category%20Config/category_config_edit_ui.dart';
import 'package:flutter/material.dart';
import '../../../../Component/drawer_ui.dart';
import '../../../../Utilities/appC.dart';
import '../../../../Utilities/utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryConfigViewUI extends StatefulWidget {
  const CategoryConfigViewUI({super.key});

  @override
  State<CategoryConfigViewUI> createState() => _CategoryConfigViewUIState();
}

class _CategoryConfigViewUIState extends State<CategoryConfigViewUI> {

  late CategoryConfigBloc categoryConfigBloc;
  TextEditingController searchController=TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  List<Map<String,dynamic>> categoryConfig = [];
  List<Map<String,dynamic>> filteredConfig = [];
  List<Map<String,dynamic>> category = [];

  bool loading=true;

  @override
  void initState() {
    super.initState();
    categoryConfigBloc=CategoryConfigBloc();
  }

  void _filteredconfig(String query) {
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
      MaterialPageRoute(builder: (context) => const CategoryConfigAddUI()),
    );

    if (newConfig != null) {
      categoryConfigBloc.add(AddCategoryConfigData(
          name: newConfig['name'],
          userType: newConfig['todo_user_type'].toString(),
          parentId: newConfig['parent_id'],
          id: newConfig['id']));
      categoryConfigBloc.add(const GetCategoryConfigData());
      Utils.showMobileToast('CategoryConfig Added Successfully');
    }
  }

  void _navigateToCategoryConfigEditUI(int index) async {
    final updateConfig = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryConfigEditUI(
          config: categoryConfig[index],
        ),
      ),
    );

    if (updateConfig != null) {
      categoryConfigBloc.add(AddCategoryConfigData(
          name: updateConfig['name'],
          userType: updateConfig['todo_user_type'].toString(),
          parentId: updateConfig['parent_id'],
          id: updateConfig['id']));
      categoryConfigBloc.add(const GetCategoryConfigData());
      Utils.showMobileToast('CategoryConfig updated successfully');

    }
  }


  void _deleteConfig(int index) async {
    final confirmed = await _confirmDelete(context);
    if (confirmed == true) {
     final delete=filteredConfig[index];
     categoryConfigBloc.add(DeleteCategoryConfig(id: delete['id'].toString())
     );
     categoryConfigBloc.add(const GetCategoryConfigData());
      Utils.showMobileToast('Deleted!');
    }
  }


  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppC.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Utils.getText('Are you sure!'),
        content: Utils.getText('Are you sure you want to delete this task?'),
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
      body: BlocProvider(
        create: (context)=>categoryConfigBloc..add(const GetCategoryConfigData()),
        child: BlocConsumer<CategoryConfigBloc,CategoryConfigState>(
            listener: (context, state) {
              if(state is CategoryConfigLoading){
                loading=true;
              }
              else if (state is CategoryConfigListLoaded) {
                loading = false;
                categoryConfig.clear();
                categoryConfig.addAll(state.data??[]);
                filteredConfig.addAll(state.data??[]);
                filteredConfig = List.from(state.data??[]);
                //List<String> reversedAnimals = filteredConfig.reversed.toList();
              }
              else if (state is CategoryConfigLoaded){
                loading = false;
                categoryConfig.clear();
                categoryConfigBloc.add(const GetCategoryConfigData());
              }
              else {
                categoryConfigBloc.add(const GetCategoryConfigData());
                loading = true;
              }
            },
          builder: (context,state) {
            return Stack(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: Utils.getSearchBarUI(
                                  () {
                                // onTap action for search bar if needed
                              },
                                  (value) {
                                    _filteredconfig(value);
                              },
                              searchController,searchFocusNode,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 40,
                          child: Utils.getAddFilledButton('Add', () {
                            _navigateToCategoryConfigAddUI();
                          }),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredConfig.length,
                        itemBuilder: (_, index) {
                          final config = filteredConfig[index];
                          final parentCategory = categoryConfig.firstWhere(
                                (cat) => cat['id'] == config['parent_id'],
                            orElse: () => {}, // Default if no parent found
                          );
                          return Slidable(
                            key: ValueKey(filteredConfig[index]),
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  onPressed:(context) => _deleteConfig(index),
                                  backgroundColor: AppC.white,
                                  foregroundColor: AppC.red,
                                  icon: Icons.delete_outline,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {

                                _navigateToCategoryConfigEditUI(index);
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                color: AppC.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Utils.getText(
                                        config['name'] ?? '',
                                        weight: FontWeight.bold,

                                      ),
                                      Utils.getText(
                                        parentCategory['name'] ?? '',
                                        weight: FontWeight.bold,
                                        color: AppC.subText,
                                      ),
                                    ],
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
                Visibility(
                    visible: loading,
                    child: Center(child: Utils.getProgressIndicator(context)))
              ],
            );
          }
        ),
      ),
      drawer: const DrawerView(),
    );
  }
}
