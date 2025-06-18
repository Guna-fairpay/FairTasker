import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/custom_compact_icon_button.dart';
import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/custom_tab_button.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Component/table_header_row.dart';
import 'package:fairpytasker/UI/Manage%20Employees/role/role_add_edit_page/ui/role_add_edit_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Employees/role/role_view_page/bloc/role_view_bloc.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'role_tab_view_ui.dart';
part 'role_list_ui.dart';
part 'users_list_ui.dart';

class RoleViewMainUI extends StatelessWidget {
  const RoleViewMainUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompactAppBar(
        titleWidget: Utils.getText('Role List', style: context.textTheme.titleMedium?.copyWith(color: AppC.white, fontWeight: FontWeight.bold),),
        foregroundColour: AppC.white,
        onClose: ()=> context.pop(),
      ),
      body: BlocProvider(create: (context) => RoleViewBloc()..add(InitialEvent()),
        child: BlocListener<RoleViewBloc, RoleViewState>(
          listener: (context, state) {
            if(state is LoadingState){
              EasyLoading.show();
            }else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
              switch (state) {
                case ErrorState(): Toaster.showError(state.message); break;
                case SuccessState():Toaster.showSuccess(state.message); break;
                case AddEditState(): context.push(RoleAddEditMainUI(data: state.model, isRoleEdit: state.isRoleEdit, isUserEdit: state.isUserEdit,)); break;
                default: break;
              }
            }
          },
          child: const RoleTabViewUI(),
        ),
      ),
    );
  }
}
