import 'dart:math' as math;

import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:fairpytasker/Component/custom_single_selection_field.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Component/table_header_row.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleView/Components/image_upload_selection.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/vendors/bloc/vendor_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/vendors/vendor_types/ui/vendor_type_main_ui.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

part 'vendor_text_form_field_ui.dart';
part 'vendor_listing_ui.dart';

class VendorMainUI extends StatelessWidget {
  const VendorMainUI({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CompactAppBar(
        titleText: 'Vendor',
        foregroundColour: AppC.white,
        onClose: context.pop,
      ),
      body: BlocProvider(
        create: (context) => VendorBloc()..add(InitialEvent()),
        child: BlocListener<VendorBloc, VendorState>(
            listener: (context, state) {
              if(state is LoadingState) {
                EasyLoading.show();
              } else {
                if(EasyLoading.isShow) EasyLoading.dismiss();
                switch(state){
                  case ErrorState(): Toaster.showError(state.message); break;
                  case SuccessState(): Toaster.showSuccess(state.message); break;
                  case VendorTypeState(): context.push(VendorTypeMainUI(title: state.title)); break;
                  default: break;
                }
              }
            },
          child: SafeArea(
            minimum: 15.spMin.padding,
            child: ListView(
              children: [
                const VendorTextFormFieldUI(),
                5.spMin.height,
                const VendorListingUI(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
