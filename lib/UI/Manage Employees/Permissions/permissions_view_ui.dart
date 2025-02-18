import 'package:fairpytasker/Bloc/permission_bloc.dart';
import 'package:fairpytasker/Event/permission_event.dart';
import 'package:fairpytasker/State/permission_state.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

  final PermissionBloc permissionBloc = PermissionBloc();
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> permissions = [];
  List<Map<String, dynamic>> filterPermissions = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
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
      MaterialPageRoute(builder: (context) => const PermissionsAddUI(),allowSnapshotting: false),
    );

    if (newPermission != null) {
      permissionBloc.add(AddPermissionData(
        name: newPermission['name'],
        id: newPermission['id'],
      ));
      permissionBloc.add(const GetPermissionData());
    }
  }

  Future<void> _navigateToEditPermissionUI(int index) async {
    final updatedPermission = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PermissionsEditUI(permissions: filterPermissions[index]),
      ),
    );
    if (updatedPermission != null) {
      permissionBloc.add(AddPermissionData(
        name: updatedPermission['name'],
        id: updatedPermission['id'],
      ));
      permissionBloc.add(const GetPermissionData());
    }
  }

  Future<void> _deletePermission(int index) async {
    final confirmed = await Utils.showCustomDeleteDialog(context ,'Permission?');
    if (confirmed == true) {
      final delete = permissions[index];
      permissionBloc.add(DeletePermissionData(id: delete['id'].toString()));
      permissionBloc.add(const GetPermissionData());
    }
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
      appBar:AppBar(
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        title: const Text('Permissions'),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          )
          ],
      ),
      body: BlocProvider(
        create: (context) => permissionBloc..add(const GetPermissionData()),
        child: BlocConsumer<PermissionBloc, PermissionState>(
            listener: (context, state) {
          if (state is PermissionLoading) {
            EasyLoading.show();
          } else {
            if(EasyLoading.isShow)EasyLoading.dismiss();
            if (state is PermissionListLoaded) {
              permissions.clear();
              filterPermissions.clear();
              permissions.addAll(state.data ?? []);
              permissions.sort((a, b) => DateTime.parse(b['created_at'] ?? '')
                  .compareTo(DateTime.parse(a['created_at'] ?? '')));
              filterPermissions.addAll(permissions);
            } else if (state is PermissionLoaded) {
              Utils.showMobileToast(state.message);
              permissionBloc.add(const GetPermissionData());
            } else {
              permissionBloc.add(const GetPermissionData());
            }
          }
        }, builder: (context, state) {
          return SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Utils.getSearchBarUI(onChange: _filterPermissions, searchController: searchController),
                    ),
                    Utils.getAddElevatedButton(_navigateToPermissionAddUI),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>const Divider(height: 0.5,),
                    itemCount: filterPermissions.length,
                    itemBuilder: (_, index) {
                      final name = filterPermissions[index];
                      return InkWell(
                        onTap: () => _navigateToEditPermissionUI(index),
                        child: SafeArea(
                          minimum: 10.padding,
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Utils.getText(
                                      name['name'] ?? '',
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                  InkWell(
                                    onTap:()=> _deletePermission(index),
                                      child: const Icon(
                                          Icons.delete_outline,
                                        color: AppC.redAccent,
                                      )
                                  ),
                                ],
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
          );
        }),
      ),
    );
  }
}
