import 'package:fairpytasker/UI/CheckIn%20CheckOut/Component/custom_checkbox.dart';
import 'package:fairpytasker/UI/dialog/tasker_filter_resource_bloc/tasker_filter_resource_bloc.dart';
import 'package:fairpytasker/UI/dialog/tasker_filter_resource_bloc/tasker_filter_resource_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_filter_resource_bloc/tasker_filter_resource_states.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskerFilterResourceDialog {
  TaskerFilterResourceDialog._();

  static void show(BuildContext context, {List<Map<String, dynamic>>? selected, void Function(List<Map<String, dynamic>>)? onChanged}) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      barrierColor: Colors.transparent,
      builder: (context) => _TaskerFilterResourceDialogView(selected: selected, onChanged: onChanged),
    );
  }
}

class _TaskerFilterResourceDialogView extends StatelessWidget {
  final List<Map<String, dynamic>>? selected;
  final void Function(List<Map<String, dynamic>>)? onChanged;
  const _TaskerFilterResourceDialogView({this.selected, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      surfaceTintColor: Colors.transparent,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      insetPadding: 10.padding,
      titlePadding: 10.horizontalPadding,
      backgroundColor: AppC.blue50?.withValues(alpha: 0.9),
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
        create: (context) => TFRDBloc()..add(TFRDInitialEvent(selected)),
        child: BlocListener<TFRDBloc, TFRDStates>(
          listener: (context, state) {
            if (state is TFRDLoadingState) {
              if (!EasyLoading.isShow) EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
              switch (state) {
                case TFRDSuccessState():
                  Toaster.showSuccess(state.message);
                  break;
                case TFRDErrorState():
                  Toaster.showError(state.message);
                  break;
                case TFRDSelectedState():
                  onChanged?.call(context.read<TFRDBloc>().selected ?? []);
                  // context.popDialog();
                  break;
              }
            }
          },
          child: const _TaskerFilterResourceDialogContentView(),
        ),
      ),
    );
  }
}

class _TaskerFilterResourceDialogContentView extends StatelessWidget {
  const _TaskerFilterResourceDialogContentView();

  @override
  Widget build(BuildContext _) {
    return BlocBuilder<TFRDBloc, TFRDStates>(
        builder: (context, state) => SizedBox(
              width: context.width,
              height: context.height * 0.7,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomCheckboxListTile(
                    title: const Text("All"),
                    value: context.watch<TFRDBloc>().isAllSelected,
                    onChanged: (value) => context.read<TFRDBloc>().add(TFRDAllEvent()),
                  ),
                  const Divider(),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: context
                          .watch<TFRDBloc>()
                          .departments
                          ?.map((e) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${e['name'] ?? ""}",
                            style: context.textTheme.labelMedium
                                ?.copyWith(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                              List.from(e['users']).length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var model = e['users'][index];
                                return CustomCheckboxListTile(
                                  title: Text("${model['first_name'] ?? ""} ${model['last_name'] ?? ""}"),
                                  suffix: (model['from_time']
                                      .toString()
                                      .isNotNullOrEmpty)
                                      ? Text(
                                      "${model['from_time'] ?? ""} - ${model['to_time'] ?? ""}",
                                    style: context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                                  )
                                      : null,
                                  value: (context.watch<TFRDBloc>().selected?.contains(model) ?? false),
                                  onChanged: (value) => context.read<TFRDBloc>().add(TFRDSelectEvent(model)),
                                );
                              }),
                        ],
                      ))
                          .toList() ??
                          [],
                    ),
                  )
                ],
              ),
            ));
  }
}
