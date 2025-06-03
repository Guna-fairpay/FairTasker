import 'package:fairpytasker/Component/compact_text_field.dart';
import 'package:fairpytasker/UI/Todo/maintenance_check/bloc/maintenance_check_bloc.dart';
import 'package:fairpytasker/UI/Todo/maintenance_check/bloc/maintenance_check_events.dart';
import 'package:fairpytasker/UI/Todo/maintenance_check/bloc/maintenance_check_states.dart';
import 'package:fairpytasker/UI/Todo/maintenance_check/maintenance_check_all_ui.dart';
import 'package:fairpytasker/UI/Todo/maintenance_check/maintenance_check_list_ui.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/maintenance_check/maintenance_check_confirmation_dialog.dart';
import 'package:fairpytasker/Utilities/Str.dart';
import 'package:fairpytasker/Utilities/prefs.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MaintenanceCheckUi extends StatelessWidget {
  final TextEditingController? commentsController;
  final Map<String, dynamic>? editToDo;
  final Map<String, dynamic>? selectedVehicle;
  final VoidCallback? onClose;
  const MaintenanceCheckUi({super.key, this.commentsController, this.editToDo, this.onClose, this.selectedVehicle});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MaintenanceCheckBloc()..add(MaintenanceCheckInitialEvent(editToDo, selectedVehicle: selectedVehicle)),
      child: BlocListener<MaintenanceCheckBloc, MaintenanceCheckState>(listener: (context, state) {
        if (state is MaintenanceCheckLoadingState) {
          EasyLoading.show();
        } else {
          if (state is! MaintenanceCheckCompleteState) if (EasyLoading.isShow) EasyLoading.dismiss();
          switch(state) {
            case MaintenanceCheckErrorState(): Toaster.showError(state.message); break;
            case MaintenanceCheckSuccessState(): Toaster.showSuccess(state.message); break;
            case MaintenanceCheckCompleteState(): onClose?.call(); break;
            case MaintenanceTaskExistDialogState(): MaintenanceCheckConfirmDialog.show(context, model: state.model,
                onComplete: () => context.read<MaintenanceCheckBloc>().add(MaintenanceCompleteTaskEvent(state.model)),
                onUpdate: (model) => context.read<MaintenanceCheckBloc>().add(MaintenanceUpdateTaskEvent(state.model, model)),
                onDelete: () => context.read<MaintenanceCheckBloc>().add(MaintenanceDeleteTaskEvent(state.model))); break;
            case MaintenanceTaskDeleteDialogState(): AskPermissionDialog.show(context,
                title: "Are you sure?",
                description: "${Session.of.getString("name")},  are you sure you want to delete this task? Kindly enter a valid reason to confirm the deletion",
                boldWords: [(Session.of.getString("name") ?? ''),","],
                positiveText: "Yes, delete it!",
                negativeText: "Cancel",
                isReasonRequired: true,
                onReasonSubmitted: (reason) => context.read<MaintenanceCheckBloc>().add(MaintenanceDeleteTaskEvent(state.model, reason: reason))
            ); break;
          }
        }
      },
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            const MaintenanceCheckAllUi(),
            const MaintenanceCheckListUi(),
            16.sp.height,
            CompactTextField(
              controller: commentsController,
              hintText: "Comments",
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              minLines: 3,
              maxLines: 10,
            ),
            16.sp.height,
          ],
        ),
      ),
    );
  }
}
