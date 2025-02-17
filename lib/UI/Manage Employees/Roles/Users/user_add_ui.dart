
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../Bloc/users_bloc.dart';
import '../../../../Event/users_event.dart';
import '../../../../State/user_state.dart';
import '../../../../Utilities/appC.dart';
import '../../../../Utilities/utils.dart';

class UserAddUI extends StatefulWidget {
  const UserAddUI({super.key});
  @override
  State<UserAddUI> createState() => _UserAddUIState();
}

class _UserAddUIState extends State<UserAddUI> {

  UsersBloc userBloc = UsersBloc();
  List<Map<String, dynamic>> users = [];
  dynamic selectedUsers;
  List<Map<String, dynamic>> permissions = [];
  Map<dynamic, bool> isChecked = {};
  List<int>permissionsId = [];

  @override
  void initState() {
    userBloc.add(const GetUsersData());
    userBloc.add(const GetPermissionForUsers());
    super.initState();
  }

  void _save() {
    if (permissionsId.isEmpty || selectedUsers == null) {
      return;
    }
    final newUser = {
      'user': selectedUsers['id'],
      'permissions': permissionsId,
    };
    Navigator.of(context).pop(newUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        title: const Text('Add User'),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: BlocProvider(
        create: (context) => userBloc..add(const GetUsersData()),
        child: BlocConsumer<UsersBloc, UsersState>(listener: (context, state) {
          if (state is UsersLoading) {
            EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            if (state is UsersListLoaded) {
              users.clear();
              users.addAll(state.data ?? []);
            } else if (state is PermissionForUsersLoaded) {
              permissions.clear();
              permissions.addAll(state.data ?? []);
            }
          }
        }, builder: (context, state) {
          return SafeArea(
              minimum: 15.padding,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Utils.dropdownBox('Select a User', users, (value) {
                    setState(() {
                      selectedUsers = value;
                    });
                  }, labelKey: 'first_name', labelKey2: 'last_name'),
                  Utils.getText('Permissions', weight: FontWeight.bold),
                  Expanded(
                    child: ListView.builder(
                      itemCount: permissions.length,
                      itemBuilder: (context, index) {
                        final permission = permissions[index];
                        return
                          CheckboxListTile(
                            dense: true,
                              contentPadding: 0.padding,
                              title: Text(permission['name'] ?? ''),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: isChecked[index] ?? false,
                              activeColor: AppC.blue,
                              onChanged: (value){
                                setState(() {
                                  isChecked[index] = value ?? false;
                                  if(value == true){
                                    permissionsId.add(permission['id']);
                                  }else{
                                    permissionsId.remove(permission['id']);
                                  }
                                  print(permissionsId);
                                });
                              }
                              );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Utils.getElevatedButton(
                        () => _save(),
                      ),
                    ],
                  ),
                ],
              ));
        }),
      ),
    );
  }
}
