import 'package:fairpytasker/UI/dialog/record_audio/record_audio_dialog.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/UI/log/edit/bloc/edit_log_events.dart';
import 'package:fairpytasker/UI/log/edit/bloc/edit_log_states.dart';
import 'package:fairpytasker/UI/log/edit/edit_log_attachments.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/log/edit/edit_log_input_body.dart';
import 'package:fairpytasker/UI/log/edit/bloc/edit_log_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class EditLog extends StatelessWidget {
  final Map<String, dynamic>? model;
  const EditLog({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Log"),
        automaticallyImplyLeading: false,
        leadingWidth: 0,
        foregroundColor: Colors.white,
        backgroundColor: AppC.appColor,
        actions: [
          IconButton(onPressed: context.pop, icon: const Icon(Icons.close_rounded))
        ],
      ),
      body: BlocProvider(create: (context) => EditLogBloc()..add(EditLogInitialEvent(model)),
        child: BlocListener<EditLogBloc, EditLogState>(
          listener: (context, state) {
            if (state is EditLogLoadingState) {
              EasyLoading.show();
            } else {
              if (state is! EditLogCompleteState) if (EasyLoading.isShow) EasyLoading.dismiss();
              switch(state) {
                case EditLogCompleteState(): context.pop(); break;
                case EditLogErrorState(): Toaster.showError(state.message, context: context); break;
                case EditLogSuccessState(): Toaster.showSuccess(state.message, context: context); break;
                case EditLogRecordState(): RecordAudioDialog.show(context, onRecorded: (file) => context.read<EditLogBloc>().add(EditLogInsertAttachmentEvent(file))); break;
                case EditLogDeletePermissionState(): AskPermissionDialog.show(context, title: "Are you sure?", description: "Do you want to delete this attachment?", positiveText: "Yes, delete it!", negativeText: "Cancel", onPositivePressed: () => context.read<EditLogBloc>().add(EditLogDeleteAttachmentEvent(state.model))); break;
              }
            }
          },
            child: SafeArea(
              minimum: 16.sp.padding,
              child: Column(
                spacing: 10.sp,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  EditLogInputBody(),
                  EditLogAttachments()
                ],
              ),
            )
        ),
      )
    );
  }
}
