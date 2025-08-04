import 'package:fairpytasker/Component/focus_node_wrapper.dart';
import 'package:fairpytasker/UI/log/bloc/log_bloc.dart';
import 'package:fairpytasker/UI/log/bloc/log_event.dart';
import 'package:fairpytasker/UI/log/bloc/log_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogBottomControllers extends StatelessWidget {
  const LogBottomControllers({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogBloc, LogState>(
      builder: (context, state) => Container(
        padding: 10.spMin.padding,
        color: Colors.white,
        child: Row(
          spacing: 5,
          children: [
            Expanded(
              child: FocusNodeWrapper(
                builder: (focusNode) => TextField(
                  controller: context.read<LogBloc>().titleController,
                  textInputAction: TextInputAction.newline,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  keyboardType: TextInputType.multiline,
                  focusNode: focusNode,
                  maxLines: 5,
                  minLines: 1,
                  enableIMEPersonalizedLearning: true,
                  onTapOutside: (event) => focusNode.unfocus(),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(width: Num.borderWidthThinField, color: AppC.borderColor),
                          borderRadius: BorderRadius.circular(30)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: Num.borderWidthThinField, color: AppC.borderColor),
                          borderRadius: BorderRadius.circular(30)),
                      hintText: "Type here...",
                      hintStyle: context.textTheme.labelLarge?.copyWith(color: AppC.fieldBase)
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => context.read<LogBloc>().add(LogAddAttachmentEvent()),
              child: const Icon(Icons.attach_file_rounded, color: AppC.appColor),
            ),
            GestureDetector(
              onTap: () => context.read<LogBloc>().add(LogAddRecordingEvent()),
              child:
              const Icon(Icons.mic_rounded, color: AppC.bouncieButtonColor),
            ),
            GestureDetector(
              onTap: () => context.read<LogBloc>().add(LogAddVideoEvent()),
              child:
              const Icon(Icons.videocam_rounded, color: AppC.blue),
            ),
            if (context.watch<LogBloc>().attachments.isNotEmpty)
            GestureDetector(
              onTap: () => context.read<LogBloc>().add(LogAddViewAttachmentEvent()),
              child:
              const Icon(Icons.visibility_rounded, color: AppC.redAccent),
            ),
            IconButton(
                onPressed: () => context.read<LogBloc>().add(LogAddSubmitEvent()),
                style: ButtonStyle(
                    shape: const WidgetStatePropertyAll(CircleBorder()),
                    backgroundColor: const WidgetStatePropertyAll(AppC.green),
                    elevation: const WidgetStatePropertyAll(5),
                    foregroundColor:
                    const WidgetStatePropertyAll(
                        Colors.white),
                    padding:
                    WidgetStatePropertyAll(5.padding)),
                icon: const Icon(Icons.save_outlined)
            )
          ],
        ),
      ),
    );
  }
}
