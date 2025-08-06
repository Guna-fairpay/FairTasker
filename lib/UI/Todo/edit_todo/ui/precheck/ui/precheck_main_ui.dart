
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/icon_and_text.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/precheck/bloc/precheck_bloc.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/private_rental_popup.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remixicon/remixicon.dart';

part 'precheck_listing_ui.dart';

class PrecheckMainUI extends StatelessWidget {
  final dynamic model;
  final List<dynamic> vinList;
  const PrecheckMainUI({super.key, required this.model, required this.vinList});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrecheckBloc()..add(InitialEvent(payload: model, vinList: vinList)),
        child: BlocListener<PrecheckBloc, PrecheckState>(
          listener: (context, state) {
            if(state is LoadingState){
              if(!EasyLoading.isShow) EasyLoading.show();
            }else{
              if(EasyLoading.isShow) EasyLoading.dismiss();
              switch(state){
                case SuccessState():
                  {
                    Toaster.showSuccess(state.message);
                    if(state.pop){
                      context.pop();
                    }
                  } break;
                case ErrorState(): Toaster.showError(state.message); break;
                case TollAlertDialogState(): AskPermissionDialog.show(context,
                  description: 'Do you want to uncheck and remove existing toll data?',
                  positiveText: 'Yes, continue',
                  onPositivePressed: ()=> context.read<PrecheckBloc>().add(CheckEvent(payload: state.model)),
                ); break;
                case DeleteImageState(): AskPermissionDialog.show(context,
                  description: 'Do you want to delete this image?',
                  positiveText: 'Yes',
                  onPositivePressed: ()=> context.read<PrecheckBloc>().add(DeleteImageEvent(state.model)),
                ); break;
                case DeleteOrCompleteState(): PrivateRentalDialog.show(context,
                  onCompleted: ()=> context.read<PrecheckBloc>().add(CompleteTaskEvent(state.model)),
                  onDelete: ()=> AskPermissionDialog.show(context,
                        description: "${Session.of.getString("name")}, are you sure you want to delete this task? Kindly enter a valid reason to confirm the deletion",
                        title: "Are you sure?",
                        boldWords: [(Session.of.getString("name") ?? ''),","],
                        positiveText: "Yes, delete it!",
                        negativeText: "Cancel",
                        isReasonRequired: true,
                        onReasonSubmitted: (reason) => context.read<PrecheckBloc>().add(DeleteTaskEvent(payload: state.model, reason: reason))
                    )); break;
                default: break;
              }
            }
          },
            child: const PrecheckListingUI()
        ),
    );
  }
}
