import 'package:fairpytasker/Component/custom_multi_selection_chips_field.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/dialog/tasker_parts_supplies_dialog_bloc/tasker_parts_supplies_dialog_bloc.dart';
import 'package:fairpytasker/UI/dialog/tasker_parts_supplies_dialog_bloc/tasker_parts_supplies_dialog_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_parts_supplies_dialog_bloc/tasker_parts_supplies_dialog_states.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Manage Custom Data/Parts/ui/parts_main_ui.dart';
import '../Manage Custom Data/Supplies/UI/supplies_main_ui.dart';

class TaskerPartsSuppliesDialog {
  TaskerPartsSuppliesDialog._();

  static void show(BuildContext context, Map<String, dynamic>? model,
      {void Function(List<Map<String, dynamic>> value)? onChanged,
      required bool isParts,
      ValueChanged<dynamic>? onDelete}) async {
    await showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: true,
      builder: (context) => _TaskerPartsSuppliesDialogView(
          model: model, onChanged: onChanged, isParts: isParts, onDelete: onDelete),
    );
  }
}

class _TaskerPartsSuppliesDialogView extends StatelessWidget {
  final Map<String, dynamic>? model;
  final void Function(List<Map<String, dynamic>> value)? onChanged;
  final bool isParts;
  final ValueChanged<dynamic>? onDelete;

  const _TaskerPartsSuppliesDialogView(
      {this.model, this.onChanged, required this.isParts, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10)),
        insetPadding: 10.padding,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          minLeadingWidth: 0,
          minVerticalPadding: 0,
          minTileHeight: 0,
          horizontalTitleGap: 0,
          title: Utils.getText("${model?['display']?['task_title'] ?? ""}",
              size: 12.sp,
              overFlow: TextOverflow.ellipsis,
              weight: FontWeight.bold,
              color: AppC.appColor),
          trailing: IconButton(
              onPressed: context.popDialog,
              icon: const Icon(Icons.close_rounded)),
        ),
        content: BlocProvider(
            create: (context) =>
                TPSDBloc()..add(TPSDInitialEvent(model, isParts)),
            child: BlocListener<TPSDBloc, TPSDStates>(
              listener: (context, state) {
                if (state is TPSDLoadingState) {
                  EasyLoading.show();
                } else {
                  if (EasyLoading.isShow) EasyLoading.dismiss();
                  switch (state) {
                    case TPSDErrorState():
                      Toaster.showError(state.message);
                      break;
                    case TPSDSuccessState():
                      Toaster.showSuccess(state.message);
                      break;
                    case TPSDDeleteState(): onDelete?.call(state.id); break;
                  }
                }
              },
              child: _TaskerPartsSuppliesDialogBodyView(onChanged: onChanged, isParts: isParts),
            )));
  }
}

class _TaskerPartsSuppliesDialogBodyView extends StatelessWidget {
  final void Function(List<Map<String, dynamic>> value)? onChanged;
  final bool isParts;
  const _TaskerPartsSuppliesDialogBodyView({this.onChanged, required this.isParts});

  @override
  Widget build(BuildContext _) {
    return BlocBuilder<TPSDBloc, TPSDStates>(
        builder: (context, state) => Container(
              constraints: BoxConstraints(minWidth: context.width),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10.sp,
                  children: [
                    Flexible(
                        child: SingleChildScrollView(
                      child:
                          CustomMultiSelectionChipsField<Map<String, dynamic>>(
                        selectedPartsList:
                            context.watch<TPSDBloc>().selectedPartsList,
                        suggestionsList: context.watch<TPSDBloc>().apiResponse,
                        itemAsString: (item) => item['name'],
                        controller: context.read<TPSDBloc>().controller,
                        onChanged: (isChecked, value) => context
                            .read<TPSDBloc>()
                            .add(TPSDSelectedEvent(value, isChecked)),
                            onEmptyTap: () => isParts
                                ? context.push(PartsMainUI(title: context.read<TPSDBloc>().controller.text,))
                                : context.push(SuppliesMainUI(title: context.read<TPSDBloc>().controller.text,)),
                      ),
                    )),
                    Row(
                      children: [
                        SuccessButton(
                          text: "Save",
                          onPressed: () {
                            var selected =
                                context.read<TPSDBloc>().selectedPartsList;
                            var modelIds =
                                context.read<TPSDBloc>().modelIdsData;
                            var filtered = selected
                                .where((element) => !modelIds
                                    .contains(element['id'].toString()))
                                .toList();
                            Console.of.log(modelIds);
                            Console.of.log(selected);
                            if (filtered.isNotEmpty) {
                              onChanged?.call(filtered);
                              context.popDialog();
                            }
                          },
                        )
                      ],
                    ),
                  ]),
            ));
  }
}
