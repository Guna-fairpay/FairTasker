import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/custom_compact_icon_button.dart';
import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Employees/permission/permission_add_edit/ui/permission_add_edit_main_ui.dart';
import 'package:fairpytasker/UI/Manage%20Employees/permission/permission_listing/bloc/permission_listing_bloc.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'permission_data_listing_ui.dart';

class PermissionListingMainUI extends StatelessWidget {
  const PermissionListingMainUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompactAppBar(
        titleWidget: Utils.getText('Permission List', style: context.textTheme.titleMedium?.copyWith(color: AppC.white, fontWeight: FontWeight.bold),),
        foregroundColour: AppC.white,
        onClose: ()=> context.pop(),
      ),
      body: BlocProvider(
        create: (context) =>  PermissionListingBloc()..add(InitialEvent()),
          child: BlocListener<PermissionListingBloc, PermissionListingState>(
            listener: (context, state) {
              if(state is LoadingState){
                EasyLoading.show();
              }else{
                if(EasyLoading.isShow) EasyLoading.dismiss();
                switch(state){
                  case ErrorState(): Toaster.showError(state.message); break;
                  case SuccessState(): Toaster.showSuccess(state.message); break;
                  case AddEditState(): context.push(PermissionAddEditMainUI(model: state.model,)); break;
                }
              }
            },
              child: const PermissionDataListingUI())),
    );
  }
}
