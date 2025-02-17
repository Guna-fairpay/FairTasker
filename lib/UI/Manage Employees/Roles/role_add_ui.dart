
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Bloc/roles_bloc.dart';
import '../../../Event/roles_event.dart';
import '../../../State/roles_state.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';

class RoleAddUI extends StatefulWidget {

  const RoleAddUI({super.key});

  @override
  State<RoleAddUI> createState() => _RoleAddUIState();
}

class _RoleAddUIState extends State<RoleAddUI> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController roleController = TextEditingController();
  List<Map<String, dynamic>> permissions = [];
  RolesBloc rolesBloc = RolesBloc();
  List<int>permissionsId = [];
  Map<dynamic, bool> checked = {};


  @override
  void initState() {
    rolesBloc.add(const GetPermissionDataForRole());
    super.initState();
  }

  void _save() {
    if (!formKey.currentState!.validate()) {
      return ;
    }
    final newRole = {
      'name': roleController.text,
      'permissions': permissionsId,
    };
    Navigator.of(context).pop(newRole);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        backgroundColor: AppC.appColor,
        automaticallyImplyLeading: false,
        title: const Text('Add Role'),
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
            }
            },
          builder: (context, state) {
            return SafeArea(
              minimum: 15.padding,
              child: Form(
                key: formKey,
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
                            dense: true,
                              contentPadding: 0.padding,
                              title: Text(permission['name'] ?? ''),
                              value: checked[index] ?? false,
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: AppC.blue,
                              onChanged: (value){
                                  setState(() {
                                    checked[index] = value ?? false;
                                    if(value == true){
                                      permissionsId.add(permission['id']);
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
              ),
            );
          },
        ),
      ),
    );
  }
}
