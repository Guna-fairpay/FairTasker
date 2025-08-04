
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/Bloc/employee_add_edit_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/Bloc/employee_add_edit_event.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/Bloc/employee_add_edit_state.dart';
import 'package:fairpytasker/UI/Manage%20Employees/Employees/Employee_add_edit_page/UI/employee_add_edit_text_form_field_page.dart';
import 'package:fairpytasker/UI/Manage%20Employees/department/department_add_edit/bloc/department_add_edit_bloc.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'department_add_edit_text_field_ui.dart';

class DepartmentAddEditMainUI extends StatelessWidget {
  final dynamic model;
  const DepartmentAddEditMainUI({super.key, this.model});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DepartmentAddEditBloc()..add(InitialEvent(model: model)),
      child: BlocListener<DepartmentAddEditBloc, DepartmentAddEditState>(
        listener: (context, state) {
          if(state is LoadingState){
            EasyLoading.show();
          }else{
            if(state is! SuccessState) if(EasyLoading.isShow) EasyLoading.dismiss();
            switch(state){
              case ErrorState(): Toaster.showError(state.message); break;
              case SuccessState(): {
                Toaster.showSuccess(state.message);
                context.pop();
              }
              break;
            }
          }
        },
        child: const DepartmentAddEditTextFieldUI(),
      ),
    );
  }
}
