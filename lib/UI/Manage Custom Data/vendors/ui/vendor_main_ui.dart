import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/custom_single_selection_field.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/vendors/bloc/vendor_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'vendor_text_form_field_ui.dart';

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
              }
            },
          child: SafeArea(
            minimum: 15.spMin.padding,
            child: ListView(
              children: const [
                VendorTextFormFieldUI(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
