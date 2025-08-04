import 'package:fairpytasker/Component/compact_text_field.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/log/edit/bloc/edit_log_bloc.dart';
import 'package:fairpytasker/UI/log/edit/bloc/edit_log_events.dart';
import 'package:fairpytasker/UI/log/edit/bloc/edit_log_states.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditLogInputBody extends StatelessWidget {
  const EditLogInputBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditLogBloc, EditLogState>(builder: (context, state) => Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 10.spMin,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompactTextField(
          minLines: 3,
          maxLines: 7,
          controller: context.read<EditLogBloc>().titleController,
          hintText: "Title",
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SuccessButton(
                text: "\u{1F4C1} Upload",
                backgroundColor: Colors.white,
                foregroundColor: AppC.text,
                isOutline: true,
                onPressed: () => context.read<EditLogBloc>().add(EditLogPickFilesEvent()),
              ),
              SuccessButton(
                text: "\u{1F399} Audio",
                backgroundColor: Colors.white,
                foregroundColor: AppC.text,
                isOutline: true,
                onPressed: () => context.read<EditLogBloc>().add(EditLogTapRecordAudioEvent()),
              ),
              SuccessButton(
                text: "\u{1F4F9} Video",
                backgroundColor: Colors.white,
                foregroundColor: AppC.text,
                isOutline: true,
                onPressed: () => context.read<EditLogBloc>().add(EditLogTapRecordVideoEvent()),
              )
            ]
        ),
        SuccessButton(
          text: "Upload",
          onPressed: () => context.read<EditLogBloc>().add(EditLogSubmitEvent()),
        ),
      ],
    ));
  }
}
