import 'package:fairpytasker/Component/custom_searcher_view.dart';
import 'package:fairpytasker/Component/custom_vehicle_person_field.dart';
import 'package:fairpytasker/UI/dialog/tasker_group_vehicle_dialog_bloc/tasker_group_vehicle_dialog_bloc.dart';
import 'package:fairpytasker/UI/dialog/tasker_group_vehicle_dialog_bloc/tasker_group_vehicle_dialog_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_group_vehicle_dialog_bloc/tasker_group_vehicle_dialog_states.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TaskerGroupVehicleDialog {
  TaskerGroupVehicleDialog._();

  static void show(BuildContext context, Map<String, dynamic>? model) async {
    await showDialog(context: context,
        barrierDismissible: true,
        useSafeArea: true,
        builder: (context) => _TaskerGroupVehicleDialogView(model: model));
  }
}

class _TaskerGroupVehicleDialogView extends StatelessWidget {
  final Map<String, dynamic>? model;
  const _TaskerGroupVehicleDialogView({this.model});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: 10.padding,
      alignment: Alignment.topCenter,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      title: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        minLeadingWidth: 0,
        minVerticalPadding: 0,
        minTileHeight: 0,
        horizontalTitleGap: 0,
        title: Text("${model?['display']?['task_title']}"),
        trailing: IconButton(
            onPressed: context.popDialog,
            icon: const Icon(Icons.close_rounded)),
      ),
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      content: BlocProvider(create: (context) => TGVDBloc()..add(TGVDInitialEvent(model: model)),
        child: BlocListener<TGVDBloc, TGVDStates>(
          listener: (context, state) {
            if (state is TGVDLoadingStates) {
              EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
              switch(state) {
                case TGVDSuccessStates(): Toaster.showSuccess(state.message); break;
                case TGVDErrorStates(): Toaster.showError(state.message); break;
              }
            }
          },
          child: const _TaskerGroupVehicleDialogContentView(),
        ),
      ),
    );
  }
}

class _TaskerGroupVehicleDialogContentView extends StatelessWidget {
  const _TaskerGroupVehicleDialogContentView();

  @override
  Widget build(BuildContext _) {
    return BlocBuilder<TGVDBloc, TGVDStates>(builder: (context, state) => SizedBox(
      width: context.width,
      child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${context.watch<TGVDBloc>().model?['display']?['vehicle_name'] ?? ""}"),
            Wrap(
              children: context.watch<TGVDBloc>().selectedVehicles?.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Chip(
                    onDeleted: () => context.read<TGVDBloc>().add(TGVDeleteVehicleEvent(model: e)),
                    side: const BorderSide(color: AppC.trans),
                    deleteIcon: const Icon(
                      Icons.close,
                      color: AppC.red,
                      size: 18,
                    ),
                    backgroundColor: const Color(0xffb5d2bb),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    // side: BorderSide(),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Utils.getText(e['vehicle_name'] ?? '',
                            color: AppC.text),
                      ],
                    ),
                  ))).toList() ?? [],
            ),
            SearchViewField<Map<String, dynamic>>(
              controller: TextEditingController(),
              suggestions: getIt<CommonService>().activeVehicleList,
              labelText: "Vehicles",
              onSelected: (value) => context.read<TGVDBloc>().add(TGVDAddVehicleEvent(model: value)),
              itemAsString: (item) => (item['vehicle_number'].toString().isNotNullOrEmpty) ? "${item['vehicle_name']} (${item['vehicle_number'] ?? ""})" : "${item['vehicle_name'] ?? ""}",
            ),
            Utils.getFilledButton("Submit", () => context.read<TGVDBloc>().add(TGVDSubmitEvent()))
          ]),
    ));
  }
}


