import 'package:flutter/material.dart';
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
  final FocusNode searchFocusNode = FocusNode();
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
        final roleName = role['role']?.toLowerCase() ?? '';
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
        //roles.add(newRole);
        roles.insert(0, newRole);
        _filterRoles(searchController.text); // Update filtered list
      });
    }
  }

  void _navigateToEditRoleUI(int index) async {
    final updatedRole = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => RoleEditUI(
          roles: roles[index],
        ),
      ),
    );

    if (updatedRole != null) {
      setState(() {
        roles[index] = updatedRole;
        _filterRoles(searchController.text);
      });
    }
  }

  Future<void> _deleteRole(int index) async {
    final confirmed = await _confirmDelete(context);
    if (confirmed == true) {
      setState(() {
        roles.removeAt(index);
        _filterRoles(searchController.text);
      });
    }
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppC.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Utils.getText('Are you sure?'),
        content: Utils.getText('Are you sure you want to delete this role?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Utils.getText('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Utils.getText('Cancel'),
          ),
        ],
      ),
    );
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Column(
            children: [
              const HeaderView(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
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
              ),
            ],
          ),
        ),
        body: BlocProvider(
          create: (context) => rolesBloc..add(const GetRolesData()),
          child: BlocConsumer<RolesBloc, RolesState>(
              listener: (context, state) async {
            if (state is DepartmentLoading) {
              loading = true;
            } else if (state is RolesListLoaded) {
              setState(() {
                loading = false;
                roles.clear();
                filterRoles.addAll(state.data ?? []);
                roles.addAll(state.data ?? []);
                filterRoles = List.from(roles);
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
          }, builder: (context, state) {
            return Stack(
              children: [
                TabBarView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: Utils.getSearchBarUI(() {}, (value) {
                                    _filterRoles(value);
                                  }, searchController, searchFocusNode),
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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: UserViewUI(),
                    ),
                  ],
                ),
                Visibility(
                    visible: loading,
                    child: Center(child: Utils.getProgressIndicator(context)))
              ],
            );
          }),
        ),
        drawer: const DrawerView(),
      ),
    );
  }
}
