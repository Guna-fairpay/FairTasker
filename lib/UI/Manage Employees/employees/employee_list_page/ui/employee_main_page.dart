
import 'package:fairpytasker/UI/Manage%20Employees/Employees/employee_list_page/Bloc/employees_view_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/employee_list_page/Bloc/employees_view_event.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/employee_list_page/Bloc/employees_view_state.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/employee_list_page/UI/employee_list_page.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/UI/employee_add_edit_main_page.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
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
        title: Text('Employees', style: TextStyle(fontSize:20.spMin)),
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
            if(state is EmployeeAddOrEditState) context.push(EmployeeAddEditMainPage(id:state.id,));
          },
          child: SafeArea(
            minimum: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppC.grey, width: 0.5)
              ),
              child: const EmployeeListPage()
            ),
          ),
        ),
      ),
    );
  }
}
