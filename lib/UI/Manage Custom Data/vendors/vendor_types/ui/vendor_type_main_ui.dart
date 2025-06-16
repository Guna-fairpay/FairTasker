import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Component/table_header_row.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/vendors/vendor_types/bloc/vendor_type_bloc.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'vendor_type_listing_ui.dart';

class VendorTypeMainUI extends StatelessWidget {
  const VendorTypeMainUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompactAppBar(
        titleWidget: Utils.getText('Vendor Types', style: context.textTheme.titleMedium?.copyWith(color: AppC.white, fontWeight: FontWeight.bold),),
        foregroundColour: AppC.white,
        onClose: ()=> context.pop(),
      ),
      body: BlocProvider(
          create: (context) => VendorTypeBloc()..add(InitialEvent()),
          child: BlocListener<VendorTypeBloc, VendorTypeState>(
            listener: (context, state) {
              if(state is LoadingState){
                EasyLoading.show();
              }else{
                if(EasyLoading.isShow) EasyLoading.dismiss();
                switch(state){
                  case ErrorState(): Toaster.showError(state.error); break;
                  case SuccessState(): Toaster.showSuccess(state.message); break;
                  default: break;
                }
              }
            },
            child: const VendorTypeListingUI(),
          ),
      ),
    );
  }
}
