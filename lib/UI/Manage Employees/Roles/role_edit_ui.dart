
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Bloc/roles_bloc.dart';
import '../../../Event/roles_event.dart';
import '../../../State/roles_state.dart';
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
  late RolesBloc rolesBloc= RolesBloc();
  TextEditingController roleController = TextEditingController();
  List<Map<String, dynamic>> permissions = [];
  List<int>permissionsId = [];
  Map<dynamic, bool> checked = {};
  bool loading = false;

  @override
  void initState() {
    rolesBloc.add(const GetPermissionDataForRole());
    rolesBloc.add(GetEditRoleData(id: widget.roles['id']));
    roleController.text = widget.roles['name'] ?? '';

    super.initState();
  }

  void _save() {
    if (roleController.text.isEmpty) {
      return ;
    }
    final updatedRole = {
      'id':widget.roles['id'],
      'name': roleController.text,
      'permissions': permissionsId,
    };
    Navigator.of(context).pop(updatedRole);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
      backgroundColor: AppC.appColor,
      automaticallyImplyLeading: false,
      title: const Text('Edit Role'),
      foregroundColor: Colors.white,
      actions: [
        IconButton(onPressed: ()=>Navigator.pop(context)
            , icon: const Icon(Icons.close))
      ],
    ),
      body: BlocProvider(
        create: (context) => rolesBloc,
        child: BlocConsumer<RolesBloc, RolesState>(
          listener: (context, state) {
            if(state is RolesLoading){
              EasyLoading.show();
            }else{
              if(EasyLoading.isShow) EasyLoading.dismiss();
              if (state is PermissionDataForRoleLoaded){
                permissions.clear();
                permissions.addAll(state.data ?? []);
              }
              else if (state is EditRolesLoaded){
                permissionsId.clear();
                permissionsId.addAll(state.rolePermission ?? []);
                checked.clear();
                for (int i = 0; i < permissions.length; i++) {
                  checked[i] = permissionsId.contains(permissions[i]['id']);
                }
              }
            }
          },
          builder: (context, state) {
            return SafeArea(
              minimum: 15.padding,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Utils.getTextFormField(
                    'Role',
                    roleController,
                    inputAction: TextInputAction.done,
                    autoValidate: AutovalidateMode.onUserInteraction,
                    validator: (val)=>val!.isEmpty?'Role is required':null,
                  ),
                  Utils.getText('Permissions', size: 15, weight: FontWeight.bold),
                  Expanded(
                    child: ListView.builder(
                      itemCount: permissions.length,
                      itemBuilder: (context,  index) {
                        final permission = permissions[index];

                        return Row(
                          children: [
                            Checkbox(
                                value: checked[index] ?? false,
                                activeColor: AppC.blue,
                                onChanged: (value){
                                  setState(() {
                                    checked[index] = value ?? false;
                                    if(value == true){
                                      if(!permissionsId.contains(permission['id'])){
                                        permissionsId.add(permission['id']);
                                      }
                                    }else{
                                      permissionsId.remove(permission['id']);
                                    }
                                    print(permissionsId);
                                  });
                                }),
                            Utils.getText(permission['name']),
                          ],
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Utils.getElevatedButton(()=>_save()),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
