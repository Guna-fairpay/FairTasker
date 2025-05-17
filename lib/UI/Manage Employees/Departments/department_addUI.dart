import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../Bloc/users_bloc.dart';
import '../../../Event/users_event.dart';
import '../../../State/user_state.dart';
import '../../../Utilities/appC.dart';
import '../../../Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DepartmentAddUI extends StatefulWidget {
  const DepartmentAddUI({super.key});

  @override
  State<DepartmentAddUI> createState() => _DepartmentAddUIState();
}

class _DepartmentAddUIState extends State<DepartmentAddUI> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController departmentNameController = TextEditingController();
  final UsersBloc userBloc = UsersBloc();
  dynamic selectedHead;
  List<Map<String, dynamic>> dropdownList = [];

  @override
  void initState() {
    super.initState();
  }

  void _save() {
    if(!formKey.currentState!.validate()){
      return;
    }
    final updateDepartment = {
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
        title: const Text('Add Department'),
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
              }
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
              child: SafeArea(
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
                      inputAction: TextInputAction.done,
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
              ),
            );
          },
        ),
      ),
    );
  }
}
