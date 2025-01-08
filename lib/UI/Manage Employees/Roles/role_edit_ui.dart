import 'package:flutter/material.dart';
import '../../../Bloc/permission_bloc.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Event/permission_event.dart';
import '../../../State/permission_state.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoleEditUI extends StatefulWidget {
  final Map<String, dynamic> roles;
  const RoleEditUI({super.key, required this.roles});

  @override
  State<RoleEditUI> createState() => _RoleEditUIState();
}

class _RoleEditUIState extends State<RoleEditUI> {
  late PermissionBloc permissionBloc;
  TextEditingController roleController = TextEditingController();
  List<Map<String, dynamic>> permissions = [];
  List<Map<String, dynamic>> filterPermissions = [];
  bool loading = false;

  @override
  void initState() {
    permissionBloc = PermissionBloc();
    roleController.text = widget.roles['name'] ?? '';
    if (widget.roles.containsKey('permissions') && widget.roles['permissions'] is List<String>) {
      for (String perm in widget.roles['permissions']['id']) {
        for (var permission in permissions) {
          if (permission['name'] == perm) {
            permission['permissions'] = true;
          }
        }
      }
    }
    super.initState();
  }

  void _save() {
    if (roleController.text.isEmpty) {
      return Utils.showMobileToast('Please fill in all required fields');
    }

    final updatedRole = {
      'role': roleController.text,
      'permissions': permissions,
    };

    Navigator.of(context).pop(updatedRole);
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
              setState(() {
                loading = true;
              });
            } else if (state is PermissionListLoaded) {
              setState(() {
                loading = false;
                permissions.clear();
                permissions.addAll(state.data ?? []);
                filterPermissions = List.from(state.data ?? []);
              });
            } else if (state is PermissionLoaded) {
              setState(() {
                loading = false;
                permissions.clear();
                permissionBloc.add(const GetPermissionData());
              });
            } else if (state is PermissionError) {
              setState(() {
                loading = false;
              });
              Utils.showMobileToast('Error loading permissions');
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back),
                          ),
                          const SizedBox(width: 10),
                          Utils.getText('Edit Role', size: 20, weight: FontWeight.bold),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 40,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Utils.getBackgroundFilledTextFieldFirstLetterCaps(
                              '',
                              roleController,
                              label: Utils.getText('Role', color: AppC.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Utils.getText('Permissions', size: 15, weight: FontWeight.bold),
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: permissions.map((permission) {
                              return Container(
                                height: 25,
                                margin: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: permission['permissions'] ?? false,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          permission['permissions'] = value ?? false;
                                        });
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Utils.getText(permission['name']),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Container(
                        color: AppC.trans,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 40,
                              child: Utils.getAddFilledButton('Save', () {
                                _save();
                              }),
                            ),
                          ],
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
          },
        ),
      ),
      drawer: const DrawerView(),
    );
  }
}
