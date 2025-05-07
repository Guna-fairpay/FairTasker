import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/record_audio/record_audio_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/UI/log/bloc/log_bloc.dart';
import 'package:fairpytasker/UI/log/bloc/log_event.dart';
import 'package:fairpytasker/UI/log/bloc/log_state.dart';
import 'package:fairpytasker/UI/log/edit/edit_log.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/UI/log/log_bottom_controllers.dart';
import 'package:fairpytasker/UI/log/logs_table.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LogUi extends StatelessWidget {
  const LogUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogBloc()..add(LogInitialEvent()),
      child: BlocListener<LogBloc, LogState>(
        listener: (context, state) {
          if (state is LogLoadingState) {
            EasyLoading.show();
          } else {
            EasyLoading.dismiss();
            switch(state) {
              case LogEditState(): context.push(EditLog(model: state.model), fullscreenDialog: true); break;
              case LogSuccessState(): Toaster.showSuccess(state.message, context: context); break;
              case LogErrorState(): Toaster.showError(state.message, context: context); break;
              case LogDeletePermissionState(): AskPermissionDialog.show(context, title: "Are you sure?", description: "Do you want to delete this log?", positiveText: "Yes, delete it!", negativeText: "Cancel", onPositivePressed: () => context.read<LogBloc>().add(LogDeleteEvent(state.model))); break;
              case LogViewAttachmentState(): ShowAttachmentsDialog.of.show(context, attachments: List.from(state.model).map((e) => e['path'].toString().toAttachmentURL).toList(), title: ""); break;
              case LogAddRecordingState(): RecordAudioDialog.show(context, onRecorded: (file) => context.read<LogBloc>().add(LogInsertAttachmentEvent(file))); break;
              case LogAddViewAttachmentState(): ShowAttachmentsDialog.of.show(context, attachments: state.model, title: ""); break;
              default:
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Logs"),
            actions: [
              IconButton(
                  onPressed: context.pop, icon: const Icon(Icons.close_rounded))
            ],
            leadingWidth: 0,
          ),
          backgroundColor: Colors.white,
          body: const Column(
            children: [
              Expanded(child: LogsTable()),
              LogBottomControllers()
            ],
          ),
        ),
      ),
    );
  }
}
