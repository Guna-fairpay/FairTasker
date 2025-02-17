import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../Bloc/roles_bloc.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Event/roles_event.dart';
import '../../../State/department_state.dart';
import '../../../State/roles_state.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import 'role_add_ui.dart';
import 'role_edit_ui.dart';
import 'Users/user_view_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoleViewUI extends StatefulWidget {
  const RoleViewUI({super.key});

  @override
  State<RoleViewUI> createState() => _RoleViewUIState();
}

class _RoleViewUIState extends State<RoleViewUI> {
  late RolesBloc rolesBloc;
  final TextEditingController searchController = TextEditingController();
  bool loading = false;
  List<Map<String, dynamic>> roles = [];
  List<Map<String, dynamic>> filterRoles = [];

  @override
  void initState() {
    super.initState();
    rolesBloc = RolesBloc();
  }

  void _filterRoles(String query) {
    setState(() {
      filterRoles = roles.where((role) {
        final roleName = role['name']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return roleName.contains(searchQuery);
      }).toList();
    });
  }

  void _navigateToRoleAddUI() async {
    final newRole = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (context) => const RoleAddUI()),
    );

    if (newRole != null) {
      setState(() {
        roles.insert(0, newRole);
      });
    }
  }

  void _navigateToEditRoleUI(int index) async {
    final updatedRole = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => RoleEditUI(
          roles: filterRoles[index],
        ),
      ),
    );

    if (updatedRole != null) {
      setState(() {
        roles[index] = updatedRole;
        //_filterRoles(searchController.text);
      });
    }
  }

  Future<void> _deleteRole(int index) async {
    final confirmed = await Utils.showCustomDeleteDialog(context,'Role?');
    if (confirmed == true) {
      setState(() {
        roles.removeAt(index);
       // _filterRoles(searchController.text);
      });
    }
  }


  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppC.white,
        appBar: AppBar(
          title: TabBar(
            tabs: const [
              Tab(text: 'Roles', height: 30),
              Tab(text: 'Users', height: 30),
            ],
            dividerColor: AppC.trans,
            labelStyle: const TextStyle(fontSize: 16),
            labelColor: AppC.white,
            unselectedLabelColor: AppC.appColor,
            indicator: BoxDecoration(
              color: AppC.appColor,
              borderRadius: BorderRadius.circular(20),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ),
        body: BlocProvider(
          create: (context) => rolesBloc..add(const GetRolesData()),
          child: BlocConsumer<RolesBloc, RolesState>(
              listener: (context, state) async {
            if (state is DepartmentLoading) {
              EasyLoading.show();
            } else {
              if(EasyLoading.isShow) EasyLoading.dismiss();
              if (state is RolesListLoaded) {
                setState(() {
                  loading = false;
                  roles.clear();
                  filterRoles.addAll(state.data ?? []);
                  roles.addAll(state.data ?? []);
                });
              } else if (state is RolesLoaded) {
                setState(() {
                  loading = false;
                  roles.clear();
                  rolesBloc.add(const GetRolesData());
                });
              } else {
                rolesBloc.add(const GetRolesData());
                loading = true;
              }
            }
          }, builder: (context, state) {
            return TabBarView(
              children: [
                SafeArea(
                  minimum: const EdgeInsets.symmetric(horizontal: 15,vertical: 10,),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: Utils.getSearchBarUI(onChange: _filterRoles, searchController: searchController),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 40,
                            child: Utils.getAddFilledButton('Add', () {
                              // Implement add role functionality
                              _navigateToRoleAddUI();
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filterRoles.length,
                          itemBuilder: (context, index) {
                            final role = filterRoles[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: Slidable(
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) =>
                                          _deleteRole(index),
                                      backgroundColor: AppC.white,
                                      foregroundColor: AppC.red,
                                      icon: Icons.delete_outline,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: GestureDetector(
                                  onTap: () => _navigateToEditRoleUI(index),
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4),
                                    color: AppC.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Utils.getText(
                                              role['name'] ?? '',
                                              weight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
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
                const SafeArea(
                  minimum: EdgeInsets.symmetric(horizontal: 10),
                  child: UserViewUI(),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
