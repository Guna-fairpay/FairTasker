
import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:fairpytasker/Component/notes_item_card.dart';
import 'package:fairpytasker/Component/search_with_status_add_view.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/notes/edit_share_notes/ui/edit_share_notes_main_ui.dart';
import 'package:fairpytasker/UI/notes/shared_notes/bloc/shared_notes_bloc.dart';
import 'package:fairpytasker/UI/notes/shared_notes/component/share_notes_edit_dialog/ui/share_notes_edit_dialog_ui.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'shared_notes_header_ui.dart';
part 'shared_notes_listing_ui.dart';

class SharedNotesMainUI extends StatelessWidget {
  const SharedNotesMainUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SharedNotesBloc()..add(InitialEvent()),
        child: BlocListener<SharedNotesBloc, SharedNotesState>(
            listener: (context, state) {
              if(state is LoadingState){
                EasyLoading.show();
              }else {
                if(EasyLoading.isShow) EasyLoading.dismiss();
                switch(state){
                  case ErrorState(): Toaster.showError(state.error); break;
                  case SuccessState(): Toaster.showSuccess(state.message); break;
                  case DatePickerState(): Utils.showPickerDate(context, value: state.date, onChanged: (value) => context.read<SharedNotesBloc>().add(DatePickerEvent(date: value))); break;
                  case CheckAllState(): AskPermissionDialog.show(context, description: "Are you sure want to complete the task/product", positiveText: "Yes", negativeText: "No", onPositivePressed: () => context.read<SharedNotesBloc>().add(CheckAllEvent(state.data, isAll: state.isAll, status: state.status))); break;
                  case DeletePermissionState(): AskPermissionDialog.show(context, title: "Are you sure ?", description: "Do you want to delete this task/product?", positiveText: "Yes, delete it!", negativeText: "Cancel", onPositivePressed: () => context.read<SharedNotesBloc>().add(DeleteEvent(state.data))); break;
                  case EditTaskTapState(): ShareNotesEditDialogUI.show(context: context, model: state.data, list: state.list); break;
                  case AddTaskTapState(): ShareNotesEditDialogUI.show(context: context, list: state.list); break;
                }
              }
            },
          child: Padding(
            padding: 5.spMin.padding,
            child: const Column(
              spacing: 5,
              children: [
                SharedNotesHeaderUI(),
                SharedNotesListingUI(),
              ],
            ),
          ),
        ),
    );
  }
}
