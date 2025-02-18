import 'package:fairpytasker/Bloc/permission_bloc.dart';
import 'package:fairpytasker/Event/permission_event.dart';
import 'package:fairpytasker/State/permission_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import 'permissions_add_ui.dart';
import 'permissions_edit_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PermissionsViewUI extends StatefulWidget {
  const PermissionsViewUI({super.key});

  @override
  State<PermissionsViewUI> createState() => _PermissionsViewUIState();
}

class _PermissionsViewUIState extends State<PermissionsViewUI> {
  late PermissionBloc permissionBloc;
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  List<Map<String, dynamic>> permissions = [];
  List<Map<String, dynamic>> filterPermissions = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    permissionBloc = PermissionBloc();
  }

  void _filterPermissions(String query) {
    setState(() {
      filterPermissions = permissions.where((permission) {
        final name = permission['name']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return name.contains(searchQuery);
      }).toList();
    });
  }

  Future<void> _navigateToPermissionAddUI() async {
    final newPermission = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const PermissionsAddUI()),
    );

    if (newPermission != null) {
      permissionBloc.add(AddPermissionData(
        name: newPermission['name'],
        id: newPermission['id'],
      ));
      permissionBloc.add(const GetPermissionData());
      Utils.showMobileToast('Permission Added Successfully');
    }
  }

  Future<void> _navigateToEditPermissionUI(int index) async {
    final updatedPermission = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PermissionsEditUI(permissions: permissions[index]),
      ),
    );

    if (updatedPermission != null) {
      permissionBloc.add(AddPermissionData(
        name: updatedPermission['name'],
        id: updatedPermission['id'],
      ));
      permissionBloc.add(const GetPermissionData());
      Utils.showMobileToast('Permission Updated Successfully');
    }
  }

  Future<void> _deletePermission(int index) async {
    final confirmed = await _confirmDelete(context);
    if (confirmed == true) {
      final delete = permissions[index];
      permissionBloc.add(DeletePermissionData(id: delete['id'].toString()));
      permissionBloc.add(const GetPermissionData());
      Utils.showMobileToast('Department Deleted Successfully');
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
            Utils.getText('Are you sure you want to delete this permission?'),
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
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: HeaderView(),
      ),
      body: BlocProvider(
        create: (context) => permissionBloc..add(const GetPermissionData()),
        child: BlocConsumer<PermissionBloc, PermissionState>(
            listener: (context, state) {
          if (state is PermissionLoading) {
            loading = true;
          } else if (state is PermissionListLoaded) {
            loading = false;
            permissions.clear();
            permissions.addAll(state.data ?? []);
            filterPermissions.addAll(state.data ?? []);
            filterPermissions = List.from(state.data ?? []);
          } else if (state is PermissionLoaded) {
            loading = false;
            permissions.clear();
            permissionBloc.add(const GetPermissionData());
          } else {
            permissionBloc.add(const GetPermissionData());
            loading = true;
          }
        }, builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20, bottom: 20, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back)),
                        const SizedBox(
                          width: 10,
                        ),
                        Utils.getText('Permissions List',
                            weight: FontWeight.bold, size: 20),
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
                            child: Utils.getSearchBarUI(onChange: _filterPermissions, searchController: searchController),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 40,
                          child: Utils.getAddFilledButton(
                              'Add', _navigateToPermissionAddUI),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filterPermissions.length,
                        itemBuilder: (_, index) {
                          return Slidable(
                            key: ValueKey(filterPermissions[index]),
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) =>
                                      _deletePermission(index),
                                  backgroundColor: AppC.white,
                                  foregroundColor: AppC.red,
                                  icon: Icons.delete_outline,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () => _navigateToEditPermissionUI(index),
                              child: Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                color: AppC.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Utils.getText(
                                              '${filterPermissions[index]['name'] ?? ''} ',
                                              weight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
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
