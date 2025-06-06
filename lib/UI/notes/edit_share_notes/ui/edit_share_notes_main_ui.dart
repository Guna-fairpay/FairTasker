import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/notes/edit_share_notes/bloc/edit_share_notes_bloc.dart';
import 'package:fairpytasker/UI/notes/edit_share_notes/component/delete_alert_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'edit_share_notes_listing_ui.dart';

class EditShareNotesMainUI extends StatelessWidget {
  final dynamic data;
  const EditShareNotesMainUI({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompactAppBar(
        titleText: 'Edit Products',
        foregroundColour: AppC.white,
        onClose: ()=> context.pop(),
      ),
      body: BlocProvider(
        create: (context) => EditShareNotesBloc()..add(InitialEvent(data ?? {})),
        child: BlocListener<EditShareNotesBloc, EditShareNotesState>(
          listener: (context, state) {
            if(state is LoadingState){
              EasyLoading.show();
            } else{
              if(EasyLoading.isShow) EasyLoading.dismiss();
              switch(state){
                case ErrorState(): Toaster.showError(state.error);
                break;
                case SuccessState():{
                  Toaster.showSuccess(state.message);
                  context.pop();
                }
                break;
                case DeleteDialogState(): DeleteAlertDialog.show(context, onChanged:()=> context.read<EditShareNotesBloc>().add(RemoveEvent(state.data ?? {})));
                break;
                }
            }
          },
          child: SafeArea(
            minimum: 15.spMin.padding,
              child: const EditShareNotesListingUI()),
        ),
      ),
    );
  }
}
