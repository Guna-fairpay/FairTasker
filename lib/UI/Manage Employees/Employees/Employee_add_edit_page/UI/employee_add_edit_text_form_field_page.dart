
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/Bloc/employee_add_edit_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/Bloc/employee_add_edit_event.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/Bloc/employee_add_edit_state.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/Component/rich_text.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../Utilities/utils.dart';

class EmployeeAddEditTextFormFieldPage extends StatelessWidget {
  final dynamic id;
  const EmployeeAddEditTextFormFieldPage({super.key,this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeAddEditBloc, EmployeeAddEditState>(
        builder: (context, state) => Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MyRichText(text: 'First Name'),
            Utils.getTextFormField(null, context.read<EmployeeAddEditBloc>().firstNameController,hintText: 'Enter first name'),
            const MyRichText(text: 'Last Name'),
            Utils.getTextFormField(null, context.read<EmployeeAddEditBloc>().lastController,hintText: 'Enter last name'),
            const MyRichText(text: 'Mobile No'),
            Utils.getTextFormField(null, context.read<EmployeeAddEditBloc>().mobileController,hintText: 'Enter mobile number'),
            const MyRichText(text: 'Email'),
            Utils.getTextFormField(null, context.read<EmployeeAddEditBloc>().emailController,hintText: 'Enter email address'),
            if(id==null)...[
              const MyRichText(text: 'Password'),
              Utils.getTextFormField(
                null,
                context.read<EmployeeAddEditBloc>().passwordController,
                hintText: 'Enter password',
                obscure:context.watch<EmployeeAddEditBloc>().isShow,
                inputAction: TextInputAction.done,
                suffixIcon: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Icon(
                        context.watch<EmployeeAddEditBloc>().isShow
                            ? Icons.visibility_off_outlined
                            : Icons.remove_red_eye_outlined,
                      ),
                    ),
                    onTap: () => context.read<EmployeeAddEditBloc>().add(ShowPasswordEvent())),
              ),
            ],
            const MyRichText(text: 'Role'),
            Utils.dropdownBox('Select a role', context.read<EmployeeAddEditBloc>().roleList, (onSelected){}, labelKey: 'name',initialSelection: context.read<EmployeeAddEditBloc>().selectedRole),
            Text('Department',style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: const Color(0xff212529)),),
            Utils.dropdownBox('Select a department', context.read<EmployeeAddEditBloc>().departmentList, (onSelected){}, labelKey: 'name',initialSelection: context.read<EmployeeAddEditBloc>().selectedDepartment),
            Row(
              children: [
                Expanded(child: Utils.getElevatedButton(()=>context.read<EmployeeAddEditBloc>().add(EmployeeSaveEvent()),text: 'Save',bgColor: AppC.appColor)),
              ],
            ),
          ],
        ));
  }
}
