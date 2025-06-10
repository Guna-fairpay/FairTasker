import 'package:fairpytasker/UI/CheckIn%20CheckOut/Component/custom_checkbox.dart';
import 'package:fairpytasker/UI/dialog/tasker_filter_tasks_dialog_bloc/tasker_filter_tasks_dialog_bloc.dart';
import 'package:fairpytasker/UI/dialog/tasker_filter_tasks_dialog_bloc/tasker_filter_tasks_dialog_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_filter_tasks_dialog_bloc/tasker_filter_tasks_dialog_states.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:collection/collection.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskerFilterTasksDialog {
  TaskerFilterTasksDialog._();

  static void show(BuildContext context,
      {List<Map<String, dynamic>>? toDos,
      List<dynamic>? selected,
      void Function(List<dynamic>? value)? onChanged}) async {
    await showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => _TaskerFilterTasksDialogView(
          toDos: toDos, selected: selected, onChanged: onChanged),
    );
  }
}

class _TaskerFilterTasksDialogView extends StatelessWidget {
  final List<Map<String, dynamic>>? toDos;
  final List<dynamic>? selected;
  final void Function(List<dynamic>? value)? onChanged;

  const _TaskerFilterTasksDialogView(
      {this.toDos, this.selected, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      surfaceTintColor: Colors.transparent,
      alignment: Alignment.topCenter,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      insetPadding: 10.padding.copyWith(top: 90),
      titlePadding: 10.horizontalPadding,
      backgroundColor: AppC.userFilterBg,
      title: ListTile(
        dense: true,
        minLeadingWidth: 0,
        contentPadding: EdgeInsets.zero,
        leading: IconButton(
            onPressed: context.popDialog,
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.red,
            )),
      ),
      contentPadding: 10.horizontalPadding,
      content: BlocProvider(
        create: (context) =>
            TFTDBloc()..add(TFTDInitialEvent(toDos: toDos, selected: selected)),
        child: BlocListener<TFTDBloc, TFTDStates>(
            listener: (context, state) {
              if (state is TFTDLoadingState) {
                if (!EasyLoading.isShow) EasyLoading.show();
              } else {
                if (EasyLoading.isShow) EasyLoading.dismiss();
                switch (state) {
                  case TFTDErrorState():
                    Toaster.showError(state.message);
                    break;
                  case TFTDTriggerSelectedState():
                    onChanged?.call(state.value);
                    break;
                }
              }
            },
            child: const _TaskerFilterTasksDialogContentView()),
      ),
    );
  }
}

class _TaskerFilterTasksDialogContentView extends StatelessWidget {
  const _TaskerFilterTasksDialogContentView();

  @override
  Widget build(BuildContext _) {
    return BlocBuilder<TFTDBloc, TFTDStates>(
        builder: (context, state) => SizedBox(
              width: context.width,
              child: ListView(shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 20.spMin),
                  children: [
                CustomCheckboxListTile(
                  title: Text("All Todo",style: TextStyle(fontSize: 12.spMin, fontWeight: FontWeight.w700,),),
                  mainAxisSize: MainAxisSize.min,
                  padding: 10.horizontalPadding,
                  value: context.watch<TFTDBloc>().isSelectedAll,
                  onChanged: (value) =>
                      context.read<TFTDBloc>().add(TFTDAllSelectEvent()),
                ),
                Wrap(
                  children: context
                      .watch<TFTDBloc>()
                      .processedCategories
                      .map((mainModel) {
                    var childTasks =
                        List<Map<String, dynamic>>.from(mainModel['tasks']);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomCheckboxListTile(
                          isCheckboxOnRight: true,
                          mainAxisSize: MainAxisSize.min,
                          padding: 10.padding,
                          title: Utils.getText(mainModel['name'] ?? '',
                              weight: FontWeight.w700, size: 12.spMin),
                          suffix: Utils.getText(
                            ' ${childTasks.map<num>((e) => num.tryParse((e['count'] ?? 0).toString()) ?? 0).sum}',
                            size: 12.spMin,
                            weight: FontWeight.w700,
                          ),
                          value: (mainModel['related_sub_names']?.every((e) =>
                                  context
                                      .watch<TFTDBloc>()
                                      .selected
                                      .contains(e)) ??
                              false),
                          onChanged: (value) => context.read<TFTDBloc>().add(
                              TFTDMultiSelectEvent(
                                  mainModel['related_sub_names'])),
                        ),
                        ...childTasks
                            .map((e) => CustomCheckboxListTile(
                                  padding: 10.padding,
                                  title: Utils.getText(
                                      "${e['task_name'] ?? ""}",
                                      weight: FontWeight.w400,
                                      size: 12.spMin),
                                  value: context
                                      .watch<TFTDBloc>()
                                      .selected
                                      .contains(e['task_name']),
                                  suffix: Utils.getText('${e['count'] ?? 0}',
                                      weight: FontWeight.bold, size: 12.spMin),
                                  mainAxisSize: MainAxisSize.min,
                                  useExpand: false,
                                  onChanged: (value) => context
                                      .read<TFTDBloc>()
                                      .add(TFTDSingleSelectEvent(
                                          e['task_name'])),
                                ))
                            .toList(),
                      ],
                    );
                  }).toList(),
                )
              ]),
            ));
  }
}
