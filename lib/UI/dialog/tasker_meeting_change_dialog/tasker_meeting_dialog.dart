import 'package:fairpytasker/Component/compact_alert_dialog.dart';
import 'package:fairpytasker/Component/compact_drop_down.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/dialog/tasker_meeting_change_dialog/bloc/meeting_change_bloc.dart';
import 'package:fairpytasker/core/app/config/todo_config.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MeetingChangeDialog {
  MeetingChangeDialog._();

  static void show(BuildContext context, Map<String, dynamic>? model, {void Function(Map<String, dynamic> value, {Map<String, dynamic>? model})? onChanged}) async {
    await showDialog(context: context, builder: (context) => _MeetingChangeDialogView(key: UniqueKey(), model: model, onChanged: onChanged), barrierDismissible: false);
  }
}

class _MeetingChangeDialogView extends StatelessWidget {
  final Map<String, dynamic>? model;
  final void Function(Map<String, dynamic> value, {Map<String, dynamic>? model})? onChanged;
  const _MeetingChangeDialogView({super.key, this.model, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CompactAlertDialog(
      titleText: model?['display']?['task_title'],
      content: BlocProvider(create: (context) => MeetingChangeBloc()..initialize(model: model),
        child: BlocConsumer<MeetingChangeBloc, MeetingState>(
            builder: (context, state) => SizedBox(
              width: double.maxFinite,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 5.spMin,
                children: [
                  Expanded(
                    child: CompactDropDown<Map<String, dynamic>>(
                      items: ToDoConfig.meetingMode,
                      initialSelection: context.watch<MeetingChangeBloc>().selectedMeetingMode,
                      itemAsString: (item) => item['name'] ?? "",
                      onChanged: context.read<MeetingChangeBloc>().onChanged,
                    ),
                  ),
                  SuccessButton(
                    text: "Save",
                    onPressed: context.read<MeetingChangeBloc>().onSave,
                  ),
                ],
              ),
            ),
            listener: (context, state) {
              if ((state is CompleteState) || (state is CloseState)) {
                if (state is CompleteState) onChanged?.call(state.model, model: model);
                context.pop();
              }
            }),
      ),
    );
  }
}
