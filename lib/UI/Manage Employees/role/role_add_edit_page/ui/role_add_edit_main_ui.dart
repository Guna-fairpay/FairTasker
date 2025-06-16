import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/CheckIn%20CheckOut/Component/custom_checkbox.dart';
import 'package:fairpytasker/UI/Manage%20Employees/role/role_add_edit_page/bloc/role_add_edit_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'role_add_edit_form_field_ui.dart';

class RoleAddEditMainUI extends StatelessWidget {
  final dynamic data;
  final bool isRoleEdit;
  final bool isUserEdit;
  const RoleAddEditMainUI({super.key, this.data, this.isRoleEdit = false, this.isUserEdit = false});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoleAddEditBloc()..add(InitialEvent(data: data, isUserEdit: isUserEdit, isRoleEdit: isRoleEdit)),
      child: BlocListener<RoleAddEditBloc, RoleAddEditState>(
        listener: (context, state) {
          if(state is LoadingState){
            EasyLoading.show();
          }else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            switch (state) {
              case ErrorState(): Toaster.showError(state.message); break;
              case SuccessState():
                {
                  Toaster.showSuccess(state.message);
                  context.pop();
                } break;
              default: break;
            }
          }

        },
        child: const RoleAddEditFormFieldUI(),
        ),
    );
  }
}
