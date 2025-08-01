import 'package:collection/collection.dart';
import 'package:fairpytasker/Component/custom_checkbox.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/UI/archive_task/component/task_filter_dialog/bloc/task_filter_dialog_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskFilterDialogView {
  TaskFilterDialogView._();
  static void show(BuildContext context, {
    Function(List<dynamic>)? onChanged,
    required List<dynamic> taskFilterList,
    required bool isAll,
  }) async {
    await showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => _TaskFilterDialogView(
        taskFilterList: taskFilterList,
        isAll: isAll,
        onChanged: onChanged,
      ),
    );
  }
}

class _TaskFilterDialogView<T extends Bloc<Event, State>, Event, State> extends StatelessWidget {
  final Function(List<dynamic>)? onChanged;
  final List<dynamic> taskFilterList;
  final bool isAll;

  const _TaskFilterDialogView({
    required this.onChanged,
    required this.taskFilterList,
    required this.isAll
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskFilterDialogBloc()..add(InitialEvent(taskFilterList: taskFilterList, isAll: isAll)),
      child: BlocListener<TaskFilterDialogBloc, TaskFilterDialogState>(
        listener: (context, state) {
          switch(state){
            case ErrorState(): Toaster.showError(state.message);
            case EmitValueState(): onChanged?.call(context.read<TaskFilterDialogBloc>().taskFilterList);
          }
        },
        child: const _TaskDialog(),
      ),
    );
  }
}

class _TaskDialog extends StatelessWidget {
  const _TaskDialog();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskFilterDialogBloc, TaskFilterDialogState>(
      builder: (context, state) {
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
            title:Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomCheckboxListTile(
                  useExpand: false,
                  title: const CompactText("All", fontWeight: FontWeight.w600, color: AppC.lightDark),
                  mainAxisSize: MainAxisSize.min,
                  padding: 10.horizontalPadding,
                  value: context.watch<TaskFilterDialogBloc>().isAll,
                  onChanged: (value)=> context.read<TaskFilterDialogBloc>().add(AllCheckEvent()),
                ),
              ],
            ),
            trailing: IconButton(
                onPressed: context.popDialog,
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.red,
                )),
          ),
          contentPadding: 10.horizontalPadding,
          content: SizedBox(
            width: context.width,
            child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: 20.spMin),
                children: [
                  Wrap(
                    children:context.watch<TaskFilterDialogBloc>().taskFilterList.map((mainModel) {
                      var childTasks = List<Map<String, dynamic>>.from(mainModel['tasks']);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomCheckboxListTile(
                            isCheckboxOnRight: true,
                            mainAxisSize: MainAxisSize.min,
                            padding: 10.padding,
                            title: CompactText(mainModel['name'] ?? '', fontWeight: FontWeight.w600, color: AppC.lightDark),
                            suffix: CompactText(
                                "${childTasks.map<num>((e) => num.tryParse((e['count'] ?? 0).toString()) ?? 0).sum}",
                                fontWeight: FontWeight.w600,
                                color: AppC.lightDark
                            ),
                            value: mainModel['isChecked'] == 1,
                            onChanged: (value)=> context.read<TaskFilterDialogBloc>().add(TitleCheckEvent(value: mainModel)),
                          ),
                          ...childTasks.map((e) => CustomCheckboxListTile(
                            padding: 10.padding,
                            title: CompactText(
                                "${e['task_name'] ?? ""}",
                                fontWeight: FontWeight.w400),
                            value: e['isChecked'] == 1,
                            suffix: CompactText(' ${e['count'] ?? 0}', fontWeight: FontWeight.w800),
                            mainAxisSize: MainAxisSize.min,
                            useExpand: false,
                            onChanged: (value)=> context.read<TaskFilterDialogBloc>().add(TaskCheckEvent(value: e)),
                          )).toList(),
                        ],
                      );
                    }).toList(),
                  )
                ]),
          ),
        );
      }
    );
  }
}

