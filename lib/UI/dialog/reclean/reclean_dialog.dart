import 'package:fairpytasker/Component/close_badge.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/UI/dialog/reclean/bloc/reclean_bloc.dart';
import 'package:fairpytasker/UI/dialog/reclean/bloc/reclean_events.dart';
import 'package:fairpytasker/UI/dialog/reclean/bloc/reclean_states.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/Component/compact_file_picker.dart';
import 'package:fairpytasker/Component/compact_text_field.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter/material.dart';

class RecleanDialog {
  RecleanDialog._();

  static void show(BuildContext context, {void Function({String? reasonMessage, List<dynamic>? reasonFiles, bool? isSaveEvent})? onPressed, bool isSaveEvent = false}) async {
    await showDialog(
      context: context,
      builder: (context) => _RecleanDialogView(onPressed: onPressed, isSaveEvent: isSaveEvent),
    );
  }
}

class _RecleanDialogView extends StatelessWidget {
  final void Function({String? reasonMessage, List<dynamic>? reasonFiles, bool? isSaveEvent})? onPressed;
  final bool isSaveEvent;
  const _RecleanDialogView({this.onPressed, this.isSaveEvent = false});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      alignment: Alignment.topCenter,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      backgroundColor: Colors.white,
      titlePadding: EdgeInsets.zero,
      insetPadding: 10.sp.padding,
      title: ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        trailing: IconButton(
            onPressed: context.popDialog,
            icon: const Icon(Icons.close_rounded)),
      ),
      content: BlocProvider(
        create: (context) => RecleanBloc()..add(RecleanInitialEvent()),
        child: BlocListener<RecleanBloc, RecleanState>(
          listener: (_, state) {
            switch (state) {
              case RecleanCloseState():
                context.popDialog();
                break;
              case RecleanSubmitState():
                onPressed?.call(
                    isSaveEvent: isSaveEvent,
                    reasonMessage: state.reasonMessage,
                    reasonFiles: state.reasonFiles);
                context.popDialog();
                break;
              default:
                break;
            }
          },
          child: const _RecleanDialogContentView(),
        ),
      ),
    );
  }
}

class _RecleanDialogContentView extends StatelessWidget {
  const _RecleanDialogContentView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecleanBloc, RecleanState>(
        builder: (context, state) => SizedBox(
              width: double.maxFinite,
              child: Form(
                key: context.watch<RecleanBloc>().formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10.sp,
                  children: [
                    Text(
                      "Already assigned to IA",
                      style: context.textTheme.labelLarge?.copyWith(
                          color: AppC.redAccent, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                    if (context.watch<RecleanBloc>().isReasonEnabled) ...[
                      Text.rich(
                        TextSpan(text: "Reason for recleaning", children: [
                          TextSpan(
                              text: " * ",
                              style: context.textTheme.labelMedium
                                  ?.copyWith(color: AppC.redAccent))
                        ]),
                        style: context.textTheme.labelMedium,
                      ),
                      CompactTextField(
                        hintText: "Reason",
                        controller:
                            context.read<RecleanBloc>().reasonController,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                            (value?.trim().isNullOrEmpty ?? false)
                                ? "Reason is required"
                                : null,
                      ),
                      CompactFilePicker(
                        controller: context.read<RecleanBloc>().fileController,
                        onPressed: () => context.read<RecleanBloc>().add(RecleanPickFileEvent()),
                      ),
                      if (context.watch<RecleanBloc>().reasonFiles.isNotEmpty)
                        Flexible(
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 5),
                            itemBuilder: (context, index) {
                              var model = context.watch<RecleanBloc>().reasonFiles[index];
                              return CloseBadge(
                                  onTapDelete: () => context.read<RecleanBloc>().add(RecleanDeleteFileEvent(model)),
                                  child: Container(
                                    width: double.maxFinite,
                                    height: double.maxFinite,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Num.borderRadiusXLarge)),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: ImageViewer(imageInput: model, fit: BoxFit.cover),
                                  ));
                            },
                            itemCount: context.watch<RecleanBloc>().reasonFiles.length,
                            shrinkWrap: true,
                          ),
                        ),
                      Row(
                        spacing: 10,
                        children: [
                          SuccessButton(
                            text: "Submit",
                            onPressed: () => context.read<RecleanBloc>().add(RecleanSubmitEvent()),
                          ),
                          SuccessButton(
                            text: "Close",
                            backgroundColor: AppC.redAccent,
                            onPressed: () => context.read<RecleanBloc>().add(RecleanCloseEvent()),
                          ),
                        ],
                      ),
                    ],
                    if (!context.watch<RecleanBloc>().isReasonEnabled)
                      SuccessButton(
                        text: "Reclean",
                        backgroundColor: AppC.blueButtonColor,
                        onPressed: () => context.read<RecleanBloc>().add(RecleanTriggerEvent()),
                      ),
                  ],
                ),
              ),
            ));
  }
}
