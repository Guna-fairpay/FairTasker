
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_List_Page/Bloc/employees_view_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_List_Page/Bloc/employees_view_event.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_List_Page/Bloc/employees_view_state.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_List_Page/UI/employee_list_page.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/UI/employee_add_edit_main_page.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmployeeMainPage extends StatelessWidget {
  const EmployeeMainPage({super.key});

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
      body: BlocProvider<EmployeesViewBloc>(
        create: (context) => EmployeesViewBloc()..add(EmployeesInitialEvent()),
        child: BlocListener<EmployeesViewBloc, EmployeesViewState>(
          listener: (context, state) {
            if (state is EmployeesLoadingState) {if (!EasyLoading.isShow) EasyLoading.show();}
            if (state is EmployeesCommonState) {if (EasyLoading.isShow) EasyLoading.dismiss();}
            if(state is EmployeeAddOrEditState) context.push(EmployeeAddEditMainPage(id:'${state.id}',));
          },
          child: SafeArea(
            minimum: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all( color: AppC.grey,width: 0.5)
              ),
              child: ListView(
                physics:const BouncingScrollPhysics(),
                children: [
                  Padding(
                    padding:  EdgeInsets.all(16.sp),
                    child: Utils.getText('User List',size: 16.sp,weight: FontWeight.bold),
                  ),
                  const Divider(thickness: 0.5,height: 0.5,),
                   Padding(
                    padding: EdgeInsets.all(16.sp),
                    child: const EmployeeListPage(),
                  )
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}
