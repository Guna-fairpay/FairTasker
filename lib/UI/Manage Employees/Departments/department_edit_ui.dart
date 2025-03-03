import 'package:fairpytasker/Event/users_event.dart';
import 'package:fairpytasker/State/user_state.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Bloc/department_bloc.dart';
import '../../../Bloc/users_bloc.dart';
import '../../../Component/drawer_ui.dart';
import '../../../Component/header.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/num.dart';
import '../../../Utilities/utils.dart';

class DepartmentEditUI extends StatefulWidget {
  final Map<String, dynamic> heads;

  const DepartmentEditUI({super.key, required this.heads});

  @override
  State<DepartmentEditUI> createState() => _DepartmentEditUIState();
}

class _DepartmentEditUIState extends State<DepartmentEditUI> {
  TextEditingController departmentNameController = TextEditingController();
  List<Map<String, dynamic>> dropdownList = [];
  final UsersBloc userBloc = UsersBloc();
  dynamic selectedHead;

  @override
  void initState() {
    super.initState();
    departmentNameController.text = widget.heads['name'] ?? '';
  }

  void _save() {
    if (departmentNameController.text.isEmpty || selectedHead==null) {
      return ;
    }
    final updateDepartment = {
      'id': widget.heads['id'],
      'name': departmentNameController.text,
      'head': selectedHead['id'].toString(),
    };
    Navigator.of(context).pop(updateDepartment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      appBar: AppBar(
        title: const Text('Edit Department'),
        backgroundColor: AppC.appColor,
        foregroundColor: AppC.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: ()=>Navigator.pop(context),
              icon: const Icon(Icons.close)
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => userBloc..add(const GetUsersData()),
        child: BlocConsumer<UsersBloc, UsersState>(
          listener: (context, state) async {
            if(state is UsersLoading){
             EasyLoading.show();
            }
            else{
              if(EasyLoading.isShow)EasyLoading.dismiss();
              if (state is UsersListLoaded) {
                  dropdownList.clear();
                  dropdownList.addAll(state.data ?? []);
                  selectedHead = dropdownList.firstWhere(
                        (e) => e['id'] == widget.heads['users']['id'],
                    orElse: () => {},
                  );
              }
            }
          },
          builder: (context, state) {
            return SafeArea(
              minimum:15.padding,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Utils.getTextFormField(
                    'Department Name',
                    departmentNameController,
                    autoValidate: AutovalidateMode.onUserInteraction,
                    validator: (val)=>val!.isEmpty?'Department name is required':null,
                  ),
                  Utils.dropdownBox(
                    'Select a Head',
                    dropdownList ,
                        (value){
                    selectedHead=value;
                  }, labelKey:'first_name',
                    labelKey2: 'last_name',
                    initialSelection: selectedHead,
                  ),
                  Utils.getElevatedButton(()=>_save())
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
