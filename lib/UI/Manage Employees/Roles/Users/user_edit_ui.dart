
import 'package:fairpytasker/Event/users_event.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../Bloc/users_bloc.dart';
import '../../../../State/user_state.dart';
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
  late UsersBloc usersBloc = UsersBloc();
  TextEditingController userController = TextEditingController();
  List<Map<String, dynamic>> permissions = [];
  List<Map<String, dynamic>> filterPermissions = [];
  List<int> permissionsId=[];
  Map<dynamic, bool> checked = {};

  @override
  void initState() {
    super.initState();
    userController.text = '${widget.users['first_name'] ?? ''} ${widget.users['last_name'] ?? ''}';
  }

  void _save() {
    if (userController.text.isEmpty || permissionsId.isEmpty) {
      return ;
    }
    final newRole = {
      'user': widget.users['id'],
      'permissions': permissionsId,
    };
    Navigator.pop(context, newRole);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        title: const Text('Edit User'),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: BlocProvider(
        create: (context) => usersBloc..add(GetEditUsers(id: widget.users['id'])),
        child: BlocConsumer<UsersBloc, UsersState>(
            listener: (context, state) {
          if (state is UsersLoading) {
            EasyLoading.show();
          } else {
            if(EasyLoading.isShow)EasyLoading.dismiss();
            if (state is EditUsersLoaded){
              permissionsId.clear();
              permissions.clear();
              permissionsId.addAll(state.data ?? []);
              permissions.addAll(state.permission ?? []);
              checked.clear();
              for (int i = 0; i < permissions.length; i++) {
                checked[i] = permissionsId.contains(permissions[i]['id']);
              }
            }
          }
        }, builder: (context, state) {
          return SafeArea(
            minimum:15.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    itemCount: permissions.length,
                    itemBuilder: (context, index) {
                      final permission = permissions[index];
                      return CheckboxListTile(
                        value: checked[index] ?? false,
                        title: Text(permission['name'] ?? ''),
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: AppC.blue,
                        contentPadding: 0.padding,
                        dense: true,
                        onChanged: (bool? value) {
                          setState(() {
                            checked[index] = value ?? false;
                            if(value == true){
                              if(!permissionsId.contains(permission['id'])){
                                permissionsId.add(permission['id']);
                              }
                            }else{
                              permissionsId.remove(permission['id']);
                            }
                          });
                        },
                      );
                    },
                  ),
                ), // Reduced space between list and button
                Utils.getElevatedButton(() =>
                  _save(),),
              ],
            ),
          );
        }),
      ),
    );
  }
}
