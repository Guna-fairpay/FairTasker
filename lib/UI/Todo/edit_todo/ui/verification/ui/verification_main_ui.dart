import 'package:card_swiper/card_swiper.dart';
import 'package:fairpytasker/Component/compact_doc_viewer.dart';
import 'package:fairpytasker/Component/compact_file_picker.dart';
import 'package:fairpytasker/Component/custom_checkbox.dart';
import 'package:fairpytasker/Component/custom_compact_icon_button.dart';
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/custom_tab_button.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/image_preview.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/verification/bloc/verification_bloc.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/verification/component/add_payment_dialog.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/verification/component/address_approve_warning_dialog.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/verification/component/image_view_dialog.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/verification/component/update_payment_model_dialog.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/verification/component/verification_enum.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/verification/component/verification_listing_page.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
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
import 'package:remixicon/remixicon.dart';

part 'tab_bar_ui.dart';
part 'license_page.dart';
part 'address_page.dart';
part 'agreement_page.dart';
part 'payment_page.dart';
part 'insurance_page.dart';
part 'final_agreement_page.dart';

class VerificationMainUI extends StatelessWidget {
  final dynamic data;
  final List<dynamic> vinList;
  const VerificationMainUI({super.key, required this.data, required this.vinList});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerificationBloc()..add(InitialEvent(data: data, vinList: vinList)),
      child: BlocListener<VerificationBloc, VerificationState>(
        listener: (context, state) {
          if(state is LoadingState){
            EasyLoading.show();
          }else{
            if(EasyLoading.isShow) EasyLoading.dismiss();
            switch(state){
              case SuccessState(): Toaster.showSuccess(state.message); break;
              case ErrorState(): Toaster.showError(state.message); break;
              case AddManualPaymentState(): AddPaymentDialog.show(context,);
              case ApproveWarningState(): AddressApproveWarningDialog.show(context, model: state.data);
              case UpdatePaymentModelState(): UpdatePaymentModelDialog.show(context, model: state.data);
              case InsuranceDeleteState(): AskPermissionDialog.show(context,
                description: 'Do you want to delete this insurance?',
                subPositiveText: 'Delete Insurance',
                onMultiSubmitted: (v)=> context.read<VerificationBloc>().add(InsuranceDeleteEvent(deleteBoth: false)),
                positiveText: 'Delete both',
                onPositivePressed: ()=> context.read<VerificationBloc>().add(InsuranceDeleteEvent(deleteBoth: true)),
              );
              default: break;
            }
          }
        },
        child: const TabBarUI(),
      ),
    );
  }
}
