import 'package:fairpytasker/Component/custom_date_time_picker.dart';
import 'package:fairpytasker/Component/custom_tab_button.dart';
import 'package:fairpytasker/Component/todo_task_item_card.dart';
import 'package:fairpytasker/UI/dialog/tasker_move_previous_dialog_bloc/tasker_move_previous_dialog_bloc.dart';
import 'package:fairpytasker/UI/dialog/tasker_move_previous_dialog_bloc/tasker_move_previous_dialog_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_move_previous_dialog_bloc/tasker_move_previous_dialog_states.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskerMoveTomorrowDialog {
  TaskerMoveTomorrowDialog._();

  static void show(BuildContext context, Map<String, dynamic>? model,
      List<Map<String, dynamic>>? models, {void Function(List<Map<String, dynamic>> models, DateTime date, TimeOfDay time)? onChanged}) async {
    await showDialog(
        context: context,
        useSafeArea: true,
        barrierDismissible: true,
        builder: (context) =>
            _TaskerMoveTomorrowDialogView(model: model, models: models, onChanged: onChanged));
  }
}

class _TaskerMoveTomorrowDialogView extends StatelessWidget {
  final Map<String, dynamic>? model;
  final List<Map<String, dynamic>>? models;
  final Function(List<Map<String, dynamic>> models, DateTime date, TimeOfDay time)? onChanged;
  const _TaskerMoveTomorrowDialogView({this.model, this.models, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      insetPadding: 10.padding,
      contentPadding: 10.padding,
      title: ListTile(
        dense: true,
        minTileHeight: 0,
        minLeadingWidth: 0,
        minVerticalPadding: 0,
        horizontalTitleGap: 0,
        contentPadding: EdgeInsets.zero,
        title: Utils.getText("Select Date & Time",
            size: 17.sp, weight: FontWeight.w500),
        trailing: IconButton(
            onPressed: context.popDialog,
            icon: const Icon(Icons.close_rounded)),
      ),
      content: BlocProvider(
          create: (context) => TMPDBloc()..add(TMPDInitialEvent(model, models)),
          child: BlocListener<TMPDBloc, TMPDStates>(
            listener: (context, state) {
              if (state is TMPDLoadingState) {
                EasyLoading.show();
              } else {
                if (EasyLoading.isShow) EasyLoading.dismiss();
              }
            },
            child: _TaskerMoveTomorrowDialogContentView(onChanged: onChanged),
          )),
    );
  }
}

class _TaskerMoveTomorrowDialogContentView extends StatelessWidget {
  final Function(List<Map<String, dynamic>> models, DateTime date, TimeOfDay time)? onChanged;
  const _TaskerMoveTomorrowDialogContentView({this.onChanged});

  @override
  Widget build(BuildContext _) {
    return BlocBuilder<TMPDBloc, TMPDStates>(
        builder: (context, state) => Container(
              width: double.maxFinite, // Ensures full width usage
              constraints: BoxConstraints(
                maxHeight: context.height * 0.8, // Limits height
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [
                  Column(
                    spacing: 5,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: CustomDateTimePicker<DateTime>(
                              controller:
                                  context.read<TMPDBloc>().dateController,
                              format: "dd-MM-yyyy",
                              suffixIcon: Icon(Icons.calendar_month_rounded,
                                  size: 18, color: context.theme.hintColor),
                              textAlign: TextAlign.start,
                              value: context.watch<TMPDBloc>().selectedDate,
                              onChanged: (value) => context
                                  .read<TMPDBloc>()
                                  .add(TMPDSelectDateEvent(value)),
                            ),
                          ),
                          Expanded(
                            child: CustomDateTimePicker<TimeOfDay>(
                              controller:
                                  context.read<TMPDBloc>().timeController,
                              value: context.watch<TMPDBloc>().selectedTime,
                              format: "HH:mm",
                              showAsExpanded: true,
                              textAlign: TextAlign.center,
                              suffixIcon: Icon(Icons.access_time_rounded,
                                  size: 18, color: context.theme.hintColor),
                              onNeutral: (value) async {
                                context.read<TMPDBloc>().add(TMPDSelectTimeEvent(value));
                                Console.of.log(value, name: "NEUTRAL_TIME");
                                await Future.delayed(Durations.short1);
                                Console.of.log("COMPLETING", name: "NEUTRAL_TIME");
                                var selectedModels = (context.read<TMPDBloc>().selectedModels ?? []);
                                var date = context.read<TMPDBloc>().selectedDate;
                                var time = context.read<TMPDBloc>().selectedTime;
                                if (selectedModels.isNotEmpty) {
                                  onChanged?.call(selectedModels, date, time);
                                  context.popDialog();
                                }
                              },
                              onChanged: (value) => context
                                  .read<TMPDBloc>()
                                  .add(TMPDSelectTimeEvent(value)),
                            ),
                          ),
                        ],
                      ),
                      if (context
                              .watch<TMPDBloc>()
                              .selectedModels
                              ?.isNotEmpty ??
                          false)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: 10,
                          children: [
                            Utils.getText(
                                "Selected: ${context.watch<TMPDBloc>().selectedModels?.length}",
                                align: TextAlign.end,
                                weight: FontWeight.bold,
                                size: 12.sp),
                            const SizedBox.shrink(),
                          ],
                        ),
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                              child: Wrap(
                            children: [
                              if (context.watch<TMPDBloc>().hasByVehicle)
                                CustomTabButton(
                                    buttonText: "By Vehicle",
                                    value: 0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppC.borderColor,
                                          width: Num.borderWidthThinField),
                                      borderRadius: const BorderRadius.only(
                                        topRight:
                                            Radius.circular(Num.borderRadius),
                                        topLeft:
                                            Radius.circular(Num.borderRadius),
                                      ),
                                    ),
                                    onPressed: (value) => context
                                        .read<TMPDBloc>()
                                        .add(TMPDSelectVehicleEvent()),
                                    selectedValue: context
                                        .watch<TMPDBloc>()
                                        .selectedIndex),
                              CustomTabButton(
                                  buttonText: "By Day",
                                  value: 1,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppC.borderColor,
                                        width: Num.borderWidthThinField),
                                    borderRadius: const BorderRadius.only(
                                      topRight:
                                          Radius.circular(Num.borderRadius),
                                      topLeft:
                                          Radius.circular(Num.borderRadius),
                                    ),
                                  ),
                                  onPressed: (value) => context
                                      .read<TMPDBloc>()
                                      .add(TMPDSelectDayEvent()),
                                  selectedValue:
                                      context.watch<TMPDBloc>().selectedIndex),
                            ],
                          )),
                          Expanded(
                              child: InkWell(
                            onTap: () => context.read<TMPDBloc>().add(
                                TMPDSelectAllTaskEvent(
                                    selected: !(context
                                            .read<TMPDBloc>()
                                            .isAllSelected ??
                                        false))),
                            child: Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Utils.getText("Select All", size: 12.sp),
                                Icon(
                                  (context.watch<TMPDBloc>().isAllSelected ==
                                          null)
                                      ? Icons.indeterminate_check_box_rounded
                                      : (context
                                                  .watch<TMPDBloc>()
                                                  .isAllSelected ??
                                              false)
                                          ? Icons.check_box_rounded
                                          : Icons
                                              .check_box_outline_blank_rounded,
                                  color: ((context
                                                  .watch<TMPDBloc>()
                                                  .isAllSelected ==
                                              null) ||
                                          (context
                                                  .watch<TMPDBloc>()
                                                  .isAllSelected ??
                                              false))
                                      ? AppC.appColor
                                      : context.theme.hintColor,
                                )
                              ],
                            ),
                          )),
                          const SizedBox.shrink(),
                        ],
                      )
                    ],
                  ),
                  if (context.watch<TMPDBloc>().filteredModels?.isNotEmpty ??
                      false)
                    Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var model = context
                                      .watch<TMPDBloc>()
                                      .filteredModels?[index] ??
                                  {};
                              return TodoTaskItemCard(
                                model: model,
                                showCheckbox: true,
                                value: context
                                    .watch<TMPDBloc>()
                                    .selectedModels
                                    ?.contains(model),
                                onChecked: (value) => context
                                    .read<TMPDBloc>()
                                    .add(TMPDSelectTaskEvent(model, value)),
                                onTap: () => context.read<TMPDBloc>().add(
                                    TMPDSelectTaskEvent(
                                        model,
                                        !(context
                                                .read<TMPDBloc>()
                                                .selectedModels
                                                ?.contains(model) ??
                                            false))),
                              );
                            },
                            itemCount: context
                                    .watch<TMPDBloc>()
                                    .filteredModels
                                    ?.length ??
                                0)),
                  if (onChanged != null)
                  Utils.getFilledButton("Move Task", () {
                    var selectedModels = (context.read<TMPDBloc>().selectedModels ?? []);
                    var date = context.read<TMPDBloc>().selectedDate;
                    var time = context.read<TMPDBloc>().selectedTime;
                    if (selectedModels.isNotEmpty) {
                      onChanged?.call(selectedModels, date, time);
                      context.popDialog();
                    }
                  })
                ],
              ),
            ));
  }
}
