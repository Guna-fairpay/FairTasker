import 'package:fairpytasker/Component/compact_text_field.dart';
import 'package:fairpytasker/UI/Todo/maintenance_check/bloc/maintenance_check_bloc.dart';
import 'package:fairpytasker/UI/Todo/maintenance_check/bloc/maintenance_check_events.dart';
import 'package:fairpytasker/UI/Todo/maintenance_check/bloc/maintenance_check_states.dart';
import 'package:fairpytasker/UI/Todo/maintenance_check/maintenance_check_all_ui.dart';
import 'package:fairpytasker/UI/Todo/maintenance_check/maintenance_check_list_ui.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MaintenanceCheckUi extends StatelessWidget {
  final TextEditingController? commentsController;
  final Map<String, dynamic>? editToDo;
  final VoidCallback? onClose;
  const MaintenanceCheckUi({super.key, this.commentsController, this.editToDo, this.onClose});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MaintenanceCheckBloc()..add(MaintenanceCheckInitialEvent(editToDo)),
      child: BlocListener<MaintenanceCheckBloc, MaintenanceCheckState>(listener: (context, state) {
        if (state is MaintenanceCheckLoadingState) {
          EasyLoading.show();
        } else {
          if (EasyLoading.isShow) EasyLoading.dismiss();
          switch(state) {
            case MaintenanceCheckErrorState(): Toaster.showError(state.message); break;
            case MaintenanceCheckSuccessState(): Toaster.showSuccess(state.message); break;
            case MaintenanceCheckCompleteState(): onClose?.call(); break;
            case MaintenanceTaskExistDialogState(): Toaster.showInfo(" Task already exits, please complete or delete the task"); break;
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
