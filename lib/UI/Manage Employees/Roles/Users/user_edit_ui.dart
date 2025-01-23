import 'package:flutter/material.dart';
import '../../../../Bloc/permission_bloc.dart';
import '../../../../Component/drawer_ui.dart';
import '../../../../Component/header.dart';
import '../../../../Event/permission_event.dart';
import '../../../../State/permission_state.dart';
import '../../../../Utilities/appC.dart';
import '../../../../Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserEditUI extends StatefulWidget {
  final Map<String, dynamic> users;
  const UserEditUI({super.key, required this.users});

  @override
  State<UserEditUI> createState() => _UserEditUIState();
}

class _UserEditUIState extends State<UserEditUI> {
  late PermissionBloc permissionBloc;
  TextEditingController userController = TextEditingController();
  List<Map<String, dynamic>> permissions = [];
  List<Map<String, dynamic>> filterPermissions = [];
  List<String> userPermissions = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    permissionBloc = PermissionBloc();
    userController.text =
        '${widget.users['first_name'] ?? ''} ${widget.users['last_name'] ?? ''}';

    // Fetch user's permissions from widget
    if (widget.users.containsKey('permissions') &&
        widget.users['permissions']) {
      userPermissions = (widget.users['permissions']['id']);
    }
    print('ID____________$userPermissions');
  }

  void _save() {
    if (userController.text.isEmpty) {
      return Utils.showMobileToast('Please fill in all required fields');
    }

    final newRole = {};
    Navigator.pop(context);
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
                        Utils.getText('Edit User',
                            size: 20, weight: FontWeight.bold),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Utils.getTextFormField(
                            '',
                            userController,
                            label: Utils.getText(
                                '${widget.users['first_name'] ?? ''} ${widget.users['last_name'] ?? ''}',
                                color: AppC.grey),
                            readOnly: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Utils.getText('Permissions',
                        size: 15, weight: FontWeight.bold),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filterPermissions.length,
                        itemBuilder: (context, index) {
                          final permission = filterPermissions[index];
                          bool isChecked = userPermissions
                              .contains(permission['id'].toString());

                          return Container(
                            height: 25,
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        if (!userPermissions
                                            .contains(permission['id'])) {
                                          userPermissions
                                              .add(permission['id'].toString());
                                        }
                                      } else {
                                        userPermissions.remove(
                                            permission['id'].toString());
                                      }
                                    });
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Utils.getText(permission['name']),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(
                        height: 15), // Reduced space between list and button
                    Row(
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
