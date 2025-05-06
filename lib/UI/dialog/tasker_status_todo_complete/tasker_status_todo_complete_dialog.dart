import 'package:fairpytasker/Component/compact_alert_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_status_todo_complete/bloc/tasker_status_bloc.dart';
import 'package:fairpytasker/UI/dialog/tasker_status_todo_complete/bloc/tasker_status_event.dart';
import 'package:fairpytasker/UI/dialog/tasker_status_todo_complete/bloc/tasker_status_state.dart';
import 'package:fairpytasker/UI/dialog/tasker_status_todo_complete/tasker_status_new_task.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TaskerToDoCompleteDialog {
  TaskerToDoCompleteDialog._();

  static void show(BuildContext context, Map<String, dynamic>? model) async {
    await showDialog(
        context: context,
        builder: (context) => _TaskerToDoCompleteDialog(model),
        barrierDismissible: false);
  }
}

class _TaskerToDoCompleteDialog extends StatelessWidget {
  final Map<String, dynamic>? model;

  const _TaskerToDoCompleteDialog(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    return CompactAlertDialog(
      textDirection: TextDirection.rtl,
      content: BlocProvider(
        create: (context) => TaskerStatusBloc()..add(TaskerStatusInitialEvent(model)),
        child: BlocListener<TaskerStatusBloc, TaskerStatusState>(
          listener: (context, state) {
            if (state is TaskerStatusLoadingState) {
              EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
              switch(state){
                case TaskerStatusErrorState(): Toaster.showError(state.message, context: context); break;
                case TaskerStatusSuccessState(): Toaster.showSuccess(state.message, context: context); break;
              }
            }
          },
          child: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TaskerStatusNewTask(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
