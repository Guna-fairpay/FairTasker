import 'package:fairpytasker/UI/CheckIn%20CheckOut/Component/custom_checkbox.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/UI/dialog/tasker_rental_complete_dialog_bloc/tasker_rental_complete_dialog_bloc.dart';
import 'package:fairpytasker/UI/dialog/tasker_rental_complete_dialog_bloc/tasker_rental_complete_dialog_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_rental_complete_dialog_bloc/tasker_rental_complete_dialog_states.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TaskerRentalCompleteDialog {
  TaskerRentalCompleteDialog._();

  static void show(BuildContext context, Map<String, dynamic>? model,
      bool isCheckOut, {VoidCallback? onCompleted}) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: true,
        builder: (context) => _TaskerRentalCompleteDialogView(
            model: model, isCheckOut: isCheckOut, onCompleted: onCompleted));
  }
}

class _TaskerRentalCompleteDialogView extends StatelessWidget {
  final Map<String, dynamic>? model;
  final bool isCheckOut;
  final VoidCallback? onCompleted;
  const _TaskerRentalCompleteDialogView({this.model, required this.isCheckOut, this.onCompleted});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      contentPadding: 16.horizontalPadding,
      insetPadding: 10.padding,
      titlePadding: EdgeInsets.zero,
      title: ListTile(
        title: const Text(""),
        trailing: IconButton(
            onPressed: context.popDialog,
            icon: const Icon(Icons.close_rounded)),
      ),
      backgroundColor: Colors.white,
      content: BlocProvider(
        create: (context) => TRCDBloc()
          ..add(TRCDInitialEvent(isCheckOut: isCheckOut, model: model)),
        child: BlocListener<TRCDBloc, TRCDStates>(
          listener: (context, state) {
            if (state is TRCDLoadingState) {
              if (!EasyLoading.isShow) EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
              switch (state) {
                case TRCDErrorState(): Toaster.showError(state.message); break;
                case TRCDCompletedState():
                  onCompleted?.call();
                  context.popDialog();
                  break;
                case TRCDShowAttachmentState(): ShowAttachmentsDialog.of.show(context, attachments: state.attachments, title: "", onDeleted: (value) => context.read<TRCDBloc>().add(TRCDRemoveAttachmentEvent(value, state.type))); break;
                case TRCDNoCleanDialogState(): AskPermissionDialog.show(context, title: "Are you sure?", description: "Do you want to delete Clean car task?", positiveText: "Yes, delete it!", negativeText: "Cancel", onPositivePressed: () => context.read<TRCDBloc>().add(TRCDNoCleanDialogEvent()), onNegativePressed: () => context.read<TRCDBloc>().add(TRCDNoCleanDialogEvent(isPositive: false))); break;
              }
            }
          },
          child: const _TaskerRentalCompleteDialogContentView(),
        ),
      ),
    );
  }
}

class _TaskerRentalCompleteDialogContentView extends StatelessWidget {
  const _TaskerRentalCompleteDialogContentView();

  @override
  Widget build(BuildContext _) {
    return BlocBuilder<TRCDBloc, TRCDStates>(
      builder: (context, state) => SizedBox(
          width: context.width,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    child: ListView(
                  shrinkWrap: true,
                  children: [
                    if (context.watch<TRCDBloc>().isCheckOut)
                    Row(
                      children: [
                        Flexible(
                          child: Transform.scale(
                              scale: 0.8,
                              alignment: Alignment.centerLeft,
                              child: SwitchListTile(
                                value: context.watch<TRCDBloc>().isMoveToRepair,
                                splashRadius: 0,
                                onChanged: (value) => context.read<TRCDBloc>().add(TRCDMoveToRepairEvent(value: value)),
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Transform.scale(
                                  scale: 1.2,
                                  child: const FittedBox(
                                      child: Text("Move To Repair")),
                                ),
                              )),
                        ),
                        Expanded(
                            child: Transform.scale(
                          scale: 0.8,
                          alignment: Alignment.centerLeft,
                          child: SwitchListTile(
                            value: context.watch<TRCDBloc>().isBlockCalendar,
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (value) => context.read<TRCDBloc>().add(TRCDBlockCalendarEvent(value: value)),
                            title: Transform.scale(
                                scale: 1.2,
                                child: const FittedBox(
                                    child: Text("Block Calendar",
                                        overflow: TextOverflow.visible))),
                          ),
                        )),
                      ],
                    ),
                    if (context.watch<TRCDBloc>().showPreviousOdometerValue)
                      Text.rich(TextSpan(
                          text: "Previous Odometer :",
                          children: [
                            TextSpan(
                                text:
                                    "${context.watch<TRCDBloc>().previousOdometerValue}")
                          ])),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                            child: Utils.getTextFormField(
                                "Odometer",
                                textType: const TextInputType.numberWithOptions(
                                    decimal: true),
                                inputAction: TextInputAction.done,
                                autoValidate: AutovalidateMode.onUserInteraction,
                                textInputFormatter: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*')),
                                ],
                                validator: (val) => ((double.tryParse(
                                                val.toString()) ??
                                            0) <
                                        (context
                                                .watch<TRCDBloc>()
                                                .previousOdometerValue ??
                                            0))
                                    ? "Cannot enter lower than previous oil change odometer"
                                    : null,
                                context.read<TRCDBloc>().odometerController)),
                        Utils.getOutlinedButton(
                            "Upload",
                            () => context
                                .read<TRCDBloc>()
                                .add(TRCDMileageImagePickEvent()),
                            radius: BorderRadius.circular(Num.borderRadius),
                            iconData: const Icon(Icons.cloud_upload_rounded)),
                        if (context.watch<TRCDBloc>().mileageAttachments.isNotEmpty)
                          IconButton(onPressed: () => context.read<TRCDBloc>().add(TRCDMileageAttachmentViewEvent()), icon: const Icon(Icons.remove_red_eye_rounded, color: AppC.appColor))
                      ],
                    ),
                    const Text("What type of cleaning does this vehicle need?"),
                    Wrap(
                      spacing: 10,
                      runSpacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      children: [
                        "Vaccum only",
                        "Exterior only",
                        "Light Clean",
                        "Vaccum & wash",
                        "Deep Clean",
                        "No Clean"
                      ]
                          .map((e) => ChoiceChip(
                                label: Utils.getText(
                                  e,
                                  color: (context.watch<TRCDBloc>().selectedCleaningNeed == e) ? AppC.white : AppC.appColor,
                                  weight: FontWeight.bold,
                                ),
                                selected: context
                                        .watch<TRCDBloc>()
                                        .selectedCleaningNeed ==
                                    e,
                                labelPadding: EdgeInsets.zero,
                                selectedColor: AppC.appColor,
                                disabledColor: Colors.blue[50],
                                showCheckmark: false,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  side: const BorderSide(
                                    color: AppC.appColor,
                                    width: 0.5,
                                  ),
                                ),
                                backgroundColor: Colors.blue[40],
                                onSelected: (selected) => context
                                    .read<TRCDBloc>()
                                    .add(TRCDVehicleCleaningNeedEvent(
                                        selected: e)),
                              ))
                          .toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: CustomCheckboxListTile(
                            value: context
                                .watch<TRCDBloc>()
                                .selectedCheckboxes
                                .contains("Remove Smell"),
                            useExpand: false,
                            mainAxisSize: MainAxisSize.min,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            onChanged: (value) => context.read<TRCDBloc>().add(
                                TRCDPostCheckOutCheckEvent(
                                    selected: "Remove Smell")),
                            title: const Text("Remove Smell"),
                          ),
                        ),
                        Flexible(
                          child: CustomCheckboxListTile(
                            value: context
                                .watch<TRCDBloc>()
                                .selectedCheckboxes
                                .contains("Remove Strains"),
                            useExpand: false,
                            mainAxisSize: MainAxisSize.min,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            onChanged: (value) => context.read<TRCDBloc>().add(
                                TRCDPostCheckOutCheckEvent(
                                    selected: "Remove Strains")),
                            title: const Text("Remove Strains"),
                          ),
                        ),
                      ],
                    ),
                    const Text("Incidentals"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomCheckboxListTile(
                          title: const Text("Refuel"),
                          value: context
                              .watch<TRCDBloc>()
                              .selectedCheckboxes
                              .contains("Refuel"),
                          useExpand: false,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          onChanged: (value) => context.read<TRCDBloc>().add(
                              TRCDPostCheckOutCheckEvent(selected: "Refuel")),
                        ),
                        CustomCheckboxListTile(
                          value: context
                              .watch<TRCDBloc>()
                              .selectedCheckboxes
                              .contains("Additional Distance"),
                          onChanged: (value) => context.read<TRCDBloc>().add(
                              TRCDPostCheckOutCheckEvent(
                                  selected: "Additional Distance")),
                          useExpand: false,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          title: const Text("Additional Distance"),
                        ),
                      ],
                    ),
                    if (context.watch<TRCDBloc>().showAdditionalDistance)
                    ...[
                      const Text("Enter additional distance"),
                      5.height,
                      Utils.getTextFormField("Additional Distance",
                          context.read<TRCDBloc>().additionalDistanceController,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          ],
                          inputAction: TextInputAction.done,
                          textType: const TextInputType.numberWithOptions(decimal: true)),
                      10.height,
                    ],
                    const Text("Maintenance"),
                    Wrap(
                      spacing: 2,
                      runSpacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      children: [
                        "Oil Change required",
                        "Bad Brakes",
                        "Check Engine light",
                        "Low tire pressure",
                        "Other maintenance"
                      ]
                          .map((e) => CustomCheckboxListTile(
                              title: Text(e),
                              value: context
                                  .watch<TRCDBloc>()
                                  .selectedCheckboxes
                                  .contains(e),
                              onChanged: (value) => context
                                  .read<TRCDBloc>()
                                  .add(TRCDPostCheckOutCheckEvent(selected: e)),
                              useExpand: false,
                              mainAxisSize: MainAxisSize.min,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5)))
                          .toList(),
                    ),
                    if (context.watch<TRCDBloc>().showOtherMaintenance)
                    ...[
                      const Text("Enter other maintenance"),
                      5.height,
                      Utils.getTextFormField("Other Maintenance",
                        context.read<TRCDBloc>().otherMaintenanceController,
                        textType: TextInputType.text,
                        inputAction: TextInputAction.done),
                      10.height,
                    ],
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                            child: Utils.getTextFormField("Notes",
                                context.read<TRCDBloc>().notesController,
                                inputAction: TextInputAction.done,
                                textType: TextInputType.multiline,
                                minLines: 3,
                                maxLines: 6)),
                        Utils.getOutlinedButton(
                            "Upload",
                            () => context
                                .read<TRCDBloc>()
                                .add(TRCDNotesImagePickEvent()),
                            iconData: const Icon(Icons.cloud_upload_rounded)),
                        if (context.watch<TRCDBloc>().notesAttachments.isNotEmpty)
                          IconButton(onPressed: () => context.read<TRCDBloc>().add(TRCDNotesAttachmentViewEvent()), icon: const Icon(Icons.remove_red_eye_rounded, color: AppC.appColor)),
                      ],
                    )
                  ],
                )),
                Utils.getFilledButton("Submit", () => context.read<TRCDBloc>().add(TRCDSubmitEvent())),
                const SizedBox.shrink(),
              ])),
    );
  }
}
