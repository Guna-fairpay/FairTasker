
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

  @override
  void initState() {
    rolesBloc.add(const GetPermissionDataForRole());

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
        create: (context) => rolesBloc..add(GetEditRoleData(id: widget.roles['id'])),
        child: BlocConsumer<RolesBloc, RolesState>(
          listener: (context, state) {
            if(state is RolesLoading){
              EasyLoading.show();
            }else{
              if(EasyLoading.isShow) EasyLoading.dismiss();
              if (state is EditRolesLoaded){
                permissionsId.clear();
                permissions.clear();
                permissionsId.addAll(state.rolePermission ?? []);
                permissions.addAll(state.data ?? []);
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

                        return CheckboxListTile(
                            value: checked[index] ?? false,
                            activeColor: AppC.blue,
                            contentPadding: 0.padding,
                            dense: true,
                            title: Text(permission['name'] ?? ''),
                            controlAffinity: ListTileControlAffinity.leading,
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
                              });
                            });
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
