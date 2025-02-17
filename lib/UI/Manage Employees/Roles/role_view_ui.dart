
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Bloc/roles_bloc.dart';
import '../../../Event/roles_event.dart';
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
    final newRole = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const RoleAddUI()),
    );
    if (newRole != null) {
      rolesBloc.add(AddRoleData(
          name: newRole['name'],
          id: newRole['id'],
          permissions: newRole['permissions']));
    }
    rolesBloc.add(const GetRolesData());
  }

  void _navigateToEditRoleUI(int index) async {
    final updatedRole = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => RoleEditUI(roles: filterRoles[index],),
      ),
    );
    if (updatedRole != null) {
     rolesBloc.add(AddRoleData(
         name: updatedRole['name'],
         id: updatedRole['id'],
         permissions: updatedRole['permissions']));
    }
    rolesBloc.add(const GetRolesData());
  }

  Future<void> _deleteRole(int index) async {
    final confirmed = await Utils.showCustomDeleteDialog(context,'Role?');
    if (confirmed == true) {
      setState(() {
        rolesBloc.add(DeleteRole(id: filterRoles[index]['id']));
        rolesBloc.add(const GetRolesData());
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
          backgroundColor: AppC.appColor,
          automaticallyImplyLeading: true,
          foregroundColor: Colors.white,
          leadingWidth: 20,
          title: TabBar(
            tabs: const [
              Tab(text: 'Role', height: 30),
              Tab(text: 'Users', height: 30),
            ],
            dividerColor: AppC.trans,
            labelStyle: const TextStyle(fontSize: 16),
            labelColor: AppC.appColor,
            unselectedLabelColor: AppC.white,
            indicator: BoxDecoration(
                color: AppC.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppC.appColor)
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ),
        body: BlocProvider(
          create: (context) => rolesBloc..add(const GetRolesData()),
          child: BlocConsumer<RolesBloc, RolesState>(
              listener: (context, state) async {
            if (state is RolesLoading) {
              EasyLoading.show();
            } else {
              if(EasyLoading.isShow) EasyLoading.dismiss();
              if (state is RolesListLoaded) {
                setState(() {
                  roles.clear();
                  filterRoles.clear();
                  filterRoles.addAll(state.data ?? []);
                  roles.addAll(state.data ?? []);
                });
              } else if (state is RolesLoaded) {
                setState(() {
                  Utils.showMobileToast(state.message);
                  rolesBloc.add(const GetRolesData());
                });
              } else {
                rolesBloc.add(const GetRolesData());
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
                        spacing: 10,
                        children: [
                          Expanded(
                            child: Utils.getSearchBarUI(onChange: _filterRoles, searchController: searchController),
                          ),
                          Utils.getAddElevatedButton(()=>
                            _navigateToRoleAddUI()),
                        ],
                      ),
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const Divider(height: 0.5,),
                          itemCount: filterRoles.length,
                          itemBuilder: (context, index) {
                            final role = filterRoles[index];
                            return InkWell(
                              onTap: () => _navigateToEditRoleUI(index),
                              child: SafeArea(
                                minimum:10.padding,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Utils.getText(
                                        role['name'] ?? '',
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () => _deleteRole(index),
                                        child: const Icon(Icons.delete_outline,color: AppC.redAccent,)
                                    ),
                                  ],
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
                  minimum: EdgeInsets.symmetric(horizontal: 15,vertical: 10,),
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
