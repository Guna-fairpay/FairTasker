import 'package:fairpytasker/Component/close_badge.dart';
import 'package:fairpytasker/Component/compact_file_viewer.dart';
import 'package:fairpytasker/UI/log/edit/bloc/edit_log_bloc.dart';
import 'package:fairpytasker/UI/log/edit/bloc/edit_log_events.dart';
import 'package:fairpytasker/UI/log/edit/bloc/edit_log_states.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditLogAttachments extends StatelessWidget {
  const EditLogAttachments({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditLogBloc, EditLogState>(
        builder: (context, state) =>
            (context.watch<EditLogBloc>().attachments.isEmpty)
                ? const SizedBox.shrink()
                : Expanded(
                    child: Material(
                    elevation: 1,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    borderRadius: BorderRadius.circular(Num.borderRadiusLarge),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Num.borderRadiusLarge),
                          color: const Color(0xfff6f7f9)),
                      padding: 15.sp.padding,
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 10.sp,
                          runSpacing: 10.sp,
                          children: context
                              .watch<EditLogBloc>()
                              .attachments
                              .map((e) => CloseBadge(
                                  child: CompactFileViewer(input: e),
                                  onTapDelete: () => context
                                      .read<EditLogBloc>()
                                      .add(EditLogTapDeleteAttachmentEvent(e))))
                              .toList(),
                        ),
                      ),
                    ),
                  )));
  }
}
