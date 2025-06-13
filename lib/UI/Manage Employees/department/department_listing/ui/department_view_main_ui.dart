import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/custom_compact_icon_button.dart';
import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Employees/department/department_add_edit/ui/department_add_edit_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Employees/department/department_listing/bloc/department_view_bloc.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'department_list_ui.dart';

class DepartmentViewMainUI extends StatelessWidget {
  const DepartmentViewMainUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompactAppBar(
        titleWidget: Utils.getText('Department List', style: context.textTheme.titleMedium?.copyWith(color: AppC.white, fontWeight: FontWeight.bold),),
        foregroundColour: AppC.white,
        onClose: ()=> context.pop(),
      ),
      body: BlocProvider<DepartmentViewBloc>(
        create: (context) => DepartmentViewBloc()..add(InitialEvent()),
        child: BlocListener<DepartmentViewBloc, DepartmentViewState>(
          listener: (context, state) {
            if (state is LoadingState) {
              if (!EasyLoading.isShow) EasyLoading.show();
            }else{
              if (EasyLoading.isShow) EasyLoading.dismiss();
              switch(state){
                case SuccessState(): Toaster.showSuccess(state.message); break;
                case ErrorState(): Toaster.showError(state.message); break;
                case AddEditState(): context.push(DepartmentAddEditMainUI(model: state.model)); break;
                default: break;
              }
            }
          },
          child: const DepartmentListUI(),
        ),
      ),
    );
  }
}
