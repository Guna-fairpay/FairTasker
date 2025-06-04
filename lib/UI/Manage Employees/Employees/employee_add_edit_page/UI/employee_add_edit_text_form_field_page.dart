
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/Bloc/employee_add_edit_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/Bloc/employee_add_edit_event.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/Bloc/employee_add_edit_state.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/employee_add_edit_page/Component/custom_rich_text.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmployeeAddEditTextFormFieldPage extends StatelessWidget {
  final dynamic id;
  const EmployeeAddEditTextFormFieldPage({super.key,this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeAddEditBloc, EmployeeAddEditState>(
        builder: (context, state) => Form(
          key: context.read<EmployeeAddEditBloc>().formKey,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomRichText(text: 'First Name'),
              Utils.getTextFormField(
                  null, context.read<EmployeeAddEditBloc>().firstNameController,
                  hintText: 'Enter first name',
                  autoValidate: context.read<EmployeeAddEditBloc>().autoValidateMode,
                  validator: (value)=>(value?.isEmpty??true)?'Please enter first name':null,),
              const CustomRichText(text: 'Last Name'),
              Utils.getTextFormField(
                  null, context.read<EmployeeAddEditBloc>().lastController,
                  autoValidate: context.read<EmployeeAddEditBloc>().autoValidateMode,
                  validator: (value)=>(value?.isEmpty??true)?'Please enter last name':null,
                  hintText: 'Enter last name'),
              const CustomRichText(text: 'Mobile No'),
              Utils.getTextFormField(
                  null, context.read<EmployeeAddEditBloc>().mobileController,
                  autoValidate: context.read<EmployeeAddEditBloc>().autoValidateMode,
                  validator: (value)=>(value?.isEmpty??true)?'Please enter mobile number':null,
                  hintText: 'Enter mobile number',textType: TextInputType.phone),
              const CustomRichText(text: 'Email'),
              Utils.getTextFormField(
                  null, context.read<EmployeeAddEditBloc>().emailController,
                  autoValidate: context.read<EmployeeAddEditBloc>().autoValidateMode,
                  validator: (value)=>(/*(context.read<EmployeeAddEditBloc>().emailController.text.isValidEmail()) || */(value?.isEmpty??true))?'Please enter email address':null,
                  hintText: 'Enter a valid email address',
                  inputAction: TextInputAction.done,textType: TextInputType.emailAddress),
              if(id==null)...[
                const CustomRichText(text: 'Password'),
                Utils.getTextFormField(
                  null,
                  context.read<EmployeeAddEditBloc>().passwordController,
                  hintText: 'Enter password',
                  obscure:context.watch<EmployeeAddEditBloc>().isShow,
                  inputAction: TextInputAction.done,
                  autoValidate: context.read<EmployeeAddEditBloc>().autoValidateMode,
                  validator: (value)=>(value?.isEmpty??true)?'Please enter password':null,
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
              const CustomRichText(text: 'Role'),
              Utils.dropdownBox(
                  'Select a role',
                  context.read<EmployeeAddEditBloc>().roleList,
                      (onSelected)=>context.read<EmployeeAddEditBloc>().add(RoleSelectionEvent(value : onSelected)),
                  labelKey: 'name',initialSelection: context.read<EmployeeAddEditBloc>().selectedRole,
                validator: (value) => (value==null) ? 'Please select a role' : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              Text('Department',style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: const Color(0xff212529)),),
              Utils.dropdownBox(
                  'Select a department',
                  context.read<EmployeeAddEditBloc>().departmentList,
                      (onSelected)=>context.read<EmployeeAddEditBloc>().add(DepartmentSelectionEvent(value : onSelected)),
                  labelKey: 'name',
                  initialSelection: context.read<EmployeeAddEditBloc>().selectedDepartment
              ),
              Row(
                children: [
                  Expanded(child: Utils.getElevatedButton(()=>context.read<EmployeeAddEditBloc>().add(EmployeeSaveEvent()),text: 'Save',bgColor: AppC.appColor)),
                ],
              ),
            ],
          ),
        ));
  }
}
