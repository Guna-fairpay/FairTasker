
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/Bloc/employee_add_edit_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/Bloc/employee_add_edit_event.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/Bloc/employee_add_edit_state.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/UI/employee_add_edit_text_form_field_page.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmployeeAddEditMainPage extends StatelessWidget {
  final dynamic id;
  const EmployeeAddEditMainPage({super.key, this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee'),
        titleTextStyle:
        context.textTheme.titleMedium?.copyWith(color: AppC.white, fontWeight: FontWeight.bold),
        backgroundColor: AppC.appColor,
        foregroundColor: AppC.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: ()=>context.pop(),
            icon: const Icon(Icons.close_outlined),
          ),
        ],
      ),
      body: BlocProvider<EmployeeAddEditBloc>(
        create: (context) => EmployeeAddEditBloc()..add(EmployeesAddEditInitialEvent(id: id)),
        child: BlocListener<EmployeeAddEditBloc, EmployeeAddEditState>(
          listener: (context, state) {
            if (state is EmployeeAddEditLoadingState) {if (!EasyLoading.isShow) EasyLoading.show();}
            if (state is EmployeeAddEditCommonState) {if (EasyLoading.isShow) EasyLoading.dismiss();}
            if (state is EmployeeAddEditSuccessState) {context.pop();}
          },
          child: SafeArea(
            minimum: const EdgeInsets.all(10),
            child: ListView(
              physics:const BouncingScrollPhysics(),
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all( color: AppC.grey,width: 0.5)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:  EdgeInsets.all(16.sp),
                        child: Utils.getText(
                            id==null?'Add User':'Edit User',size: 16.sp,weight: FontWeight.bold),
                      ),
                      const Divider(thickness: 0.5,height: 0.5,),
                      Padding(
                        padding: EdgeInsets.all(16.sp),
                        child: EmployeeAddEditTextFormFieldPage(id: id,),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
