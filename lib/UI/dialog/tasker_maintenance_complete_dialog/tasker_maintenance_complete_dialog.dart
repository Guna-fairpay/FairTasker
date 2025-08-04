import 'package:fairpytasker/Component/compact_alert_dialog.dart';
import 'package:fairpytasker/Component/compact_drop_down.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/dialog/tasker_maintenance_complete_dialog/bloc/tasker_maintenance_complete_bloc.dart';
import 'package:fairpytasker/UI/dialog/tasker_maintenance_complete_dialog/bloc/tasker_maintenance_complete_event.dart';
import 'package:fairpytasker/UI/dialog/tasker_maintenance_complete_dialog/bloc/tasker_maintenance_complete_state.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskerMaintenanceCompleteDialog {
  TaskerMaintenanceCompleteDialog._();

  static void show(BuildContext context, {Map<String, dynamic>? model}) async {
    await showDialog(context: context, builder: (context) => _TaskerMaintenanceCompleteDialog(model: model), barrierDismissible: false);
  }
}

class _TaskerMaintenanceCompleteDialog extends StatelessWidget {
  final Map<String, dynamic>? model;
  const _TaskerMaintenanceCompleteDialog({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return CompactAlertDialog(
      content: BlocProvider(
        create: (context) => TaskerMaintenanceBloc()..add(TaskerMaintenanceInitialEvent(model)),
        child: BlocListener<TaskerMaintenanceBloc, TaskerMaintenanceCompleteState>(listener: (context, state) {
          if (state is TaskerMaintenanceLoadingState) {
            EasyLoading.show();
          } else {
            if (state is! TaskerMaintenanceCompletedState) if (EasyLoading.isShow)  EasyLoading.dismiss();
            switch(state) {
              case TaskerMaintenanceSuccessState(): Toaster.showSuccess(state.message, context: context); break;
              case TaskerMaintenanceErrorState(): Toaster.showError(state.message, context: context); break;
              case TaskerMaintenanceCompletedState(): context.popDialog(); break;
            }
          }
        },
        child: BlocBuilder<TaskerMaintenanceBloc, TaskerMaintenanceCompleteState>(builder: (context, state) => Column(
          spacing: 10.spMin,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CompactDropDown<Map<String, dynamic>>(
              items: context.watch<TaskerMaintenanceBloc>().tasks,
              initialSelection: context.watch<TaskerMaintenanceBloc>().selectedTask,
              itemAsString: (item) => item['name'].toString(),
              onChanged: (value) => context.read<TaskerMaintenanceBloc>().add(TaskerMaintenanceSelectEvent(value)),
            ),
            if (context.watch<TaskerMaintenanceBloc>().showButton)
            SuccessButton(
              text: "Update Task",
              onPressed: () => context.read<TaskerMaintenanceBloc>().add(TaskerMaintenanceUpdateEvent())
            )
          ],
        ))),
      ),
    );
  }
}
