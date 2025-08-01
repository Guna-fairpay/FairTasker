import 'package:fairpytasker/Component/compact_drop_down.dart';
import 'package:fairpytasker/Component/compact_file_picker.dart';
import 'package:fairpytasker/Component/custom_checkbox.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Finance/Expense/component/icon_and_text.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/private_rental_checkout/bloc/checkout_bloc.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/verification/component/image_view_dialog.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remixicon/remixicon.dart';

part 'checkout_listing_ui.dart';

class CheckOutMainUI extends StatelessWidget {
  final dynamic model;
  const CheckOutMainUI({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context)=> CheckoutBloc()..add(InitialEvent(model)),
      child: BlocListener<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if(state is LoadingState){
            EasyLoading.show();
          }else {
            if(EasyLoading.isShow) EasyLoading.dismiss();
            switch (state) {
              case ApproveAndCloseState(): AskPermissionDialog.show(context,
              description: 'Do you want to approve and close this booking?',
                titleIcon: RemixIcons.error_warning_line,
                titleIconColor: const Color(0xffffca5b),
                positiveText: 'Yes, Approve and close',
                onPositivePressed:()=> context.read<CheckoutBloc>().add(SaveEvent(isApprove: true)),
              );
              break;
              case SuccessState():{
                Toaster.showSuccess(state.message);
                context.pop();
                break;
              }
              case ErrorState(): Toaster.showError(state.message); break;
            }
          }
        },
        child: const CheckoutListingUI(),
      ),
    );
  }
}
