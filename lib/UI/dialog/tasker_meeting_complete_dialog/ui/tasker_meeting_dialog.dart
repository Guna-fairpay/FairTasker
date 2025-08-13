

import 'package:fairpytasker/Component/compact_alert_dialog.dart';
import 'package:fairpytasker/Component/custom_quill_editor.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/dialog/tasker_meeting_complete_dialog/bloc/tasker_meeting_bloc.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskerMeetingDialog {
  TaskerMeetingDialog._();

  static void show(BuildContext context, {Map<String, dynamic>? model}) async {
    await showDialog(context: context, builder: (context) => _TaskerMeetingDialog(model: model), barrierDismissible: false);
  }
}

class _TaskerMeetingDialog extends StatelessWidget {
  final Map<String, dynamic>? model;
  const _TaskerMeetingDialog({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return CompactAlertDialog(
      titleText: 'Add Meeting Summary',
      titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      content: BlocProvider(
        create: (context) => TaskerMeetingBloc()..add(InitialEvent(model)),
        child: BlocListener<TaskerMeetingBloc, TaskerMeetingState>(listener: (context, state) {
          if (state is LoadingState) {
            if(!EasyLoading.isShow) EasyLoading.show();
          } else {
            if(EasyLoading.isShow) EasyLoading.dismiss();
            switch(state) {
              case SuccessState():
                {
                  Toaster.showSuccess(state.message, context: context);
                  context.pop();
                } break;
              case ErrorState(): Toaster.showError(state.message, context: context); break;
            }
          }
        },
            child: BlocBuilder<TaskerMeetingBloc, TaskerMeetingState>(builder: (context, state) => ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                CustomQuillEditor(controller: context.read<TaskerMeetingBloc>().quillMeetingController,),
                  10.spMin.height,
                  SuccessButton(
                      onPressed: () => context.read<TaskerMeetingBloc>().add(SubmitEvent()),
                    backgroundColor: AppC.appColor,
                  )
              ],
            ))),
      ),
    );
  }
}
