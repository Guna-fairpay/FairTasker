
import 'package:fairpytasker/Component/custom_wrap_choice.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/bloc/edit_todo_bloc.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/state/edit_todo_state.dart';
import 'package:fairpytasker/UI/dialog/tasker_resource_dialog_bloc/tasker_resource_dialog_bloc.dart';
import 'package:fairpytasker/UI/dialog/tasker_resource_dialog_bloc/tasker_resource_dialog_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_resource_dialog_bloc/tasker_resource_dialog_states.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResourceDialog {
  ResourceDialog._();

  static void show(
      BuildContext context,
      Map<String, dynamic>? model,
      {void Function(List<Map<String, dynamic>> value)? onSelected}) async {
    await showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: true,
      builder: (context) => _ResourceDialogView(model: model, onSelected: onSelected),
    );
  }
}

class _ResourceDialogView extends StatelessWidget {
  final Map<String, dynamic>? model;
  final void Function(List<Map<String, dynamic>>)? onSelected;
  const _ResourceDialogView({required this.model, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditToDoBloc, EditTodoState>(
        builder: (context,state) {
          return AlertDialog(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
            insetPadding: 10.padding,
            title: ListTile(
              dense: true,
              minTileHeight: 0,
              minVerticalPadding: 0,
              minLeadingWidth: 0,
              horizontalTitleGap: 0,
              contentPadding: EdgeInsets.zero,
              title: Utils.getText("Selected Resource",
                  size: 12.sp,
                  overFlow: TextOverflow.ellipsis,
                  weight: FontWeight.bold),
              trailing: IconButton(
                  onPressed: context.popDialog,
                  icon: const Icon(Icons.close_rounded)),
            ),
            content: BlocProvider(
              create: (context) => TRSDBloc()..add(TRSDInitialEvent(model)),
              child: BlocListener<TRSDBloc, TRSDStates>(
                listener: (context, state) {
                  if (state is TRSDLoadingState) {
                    EasyLoading.show();
                  } else {
                    if (EasyLoading.isShow) EasyLoading.dismiss();
                    switch (state) {
                      case TRSDErrorState():
                        Toaster.showError(state.message);
                        break;
                      case TRSDSuccessState():
                        Toaster.showSuccess(state.message);
                        break;
                    }
                  }
                },
                child: _ResourceDialogBodyView(onSelected: onSelected),
              ),
            ),
          );
        }
    );
  }
}

class _ResourceDialogBodyView extends StatelessWidget {
  final void Function(List<Map<String, dynamic>>)? onSelected;
  const _ResourceDialogBodyView({this.onSelected});

  @override
  Widget build(BuildContext _) {
    return BlocBuilder<EditToDoBloc, EditTodoState>(
      builder: (context, state) => Container(
        constraints: BoxConstraints(minWidth: context.width),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // CustomWrapChoice<Map<String, dynamic>>(
            //     items: state.resources,
            //     itemAsString: (item) =>
            //     item['first_name'] + "\t${item['last_name']}",
            //     selectionItemAsString: (item) => item['id'].toString(),
            //     selectedItems: context.watch<TRSDBloc>().selectedResourcesList,
            //     onChanged: (isChecked, value) => context
            //         .read<TRSDBloc>()
            //         .add(TRSDSelectedEvent(value, isChecked))),
            // if (onSelected != null)
            //   Utils.getFilledButton("Save", () {
            //     // var selected = state.selectedResource;
            //     // if (selected.isNotEmpty) {
            //     //   onSelected?.call(selected);
            //     //   context.popDialog();
            //     // } else {
            //     //   Toaster.showError("Select at least one resource");
            //     // }
            //   })
          ],
        ),
      ),
    );
  }
}
