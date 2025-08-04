import 'package:fairpytasker/Component/custom_vehicle_person_field.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/dialog/tasker_vehicls_dialog_bloc/tasker_vehicle_persons_dialog_bloc.dart';
import 'package:fairpytasker/UI/dialog/tasker_vehicls_dialog_bloc/tasker_vehicles_persons_dialog_events.dart';
import 'package:fairpytasker/UI/dialog/tasker_vehicls_dialog_bloc/tasker_vehicles_persons_dialog_states.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TaskerVehiclesChangeDialog {
  TaskerVehiclesChangeDialog._();

  static void show(BuildContext context, Map<String, dynamic>? data, {void Function(Map<String, dynamic>? model,List<Map<String, dynamic>> value)? onSelected, ValueChanged<Map<String, dynamic>?>? onDeleted}) async {
    await showDialog(
        context: context,
        useSafeArea: true,
        barrierDismissible: true,
        builder: (context) => _TaskerVehiclesDialogView(data: data, onSelected: onSelected, onDeleted: onDeleted));
  }
}

class _TaskerVehiclesDialogView extends StatelessWidget {
  final Map<String, dynamic>? data;
  final ValueChanged<Map<String, dynamic>?>? onDeleted;
  final void Function(Map<String, dynamic>? model, List<Map<String, dynamic>> value)? onSelected;
  const _TaskerVehiclesDialogView({required this.data, this.onSelected, this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: 10.padding,
      alignment: Alignment.topCenter,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Colors.white,
      title: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        minLeadingWidth: 0,
        minVerticalPadding: 0,
        minTileHeight: 0,
        horizontalTitleGap: 0,
        title: Text("${data?['display']?['task_title']}"),
        trailing: IconButton(
            onPressed: context.popDialog,
            icon: const Icon(Icons.close_rounded)),
      ),
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      content: BlocProvider<TVPDBloc>(
        create: (context) => TVPDBloc()..add(TVPDInitialEvent(data: data)),
        child: BlocListener<TVPDBloc, TVPDStates>(
          listener: (BuildContext context, TVPDStates state) {
            if (state is TVPDLoadingState) {
              EasyLoading.show();
            } else {
              if (EasyLoading.isShow) EasyLoading.dismiss();
              switch (state) {
                case TVPDDeleteState(): onDeleted?.call(state.model); break;
              }
            }
          },
          child: _TaskerVehiclesContent(onSelected: onSelected),
        ),
      ),
    );
  }
}

class _TaskerVehiclesContent extends StatelessWidget {
  final void Function(Map<String, dynamic>? model, List<Map<String, dynamic>> value)? onSelected;
  const _TaskerVehiclesContent({this.onSelected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TVPDBloc, TVPDStates>(
        builder: (context, state) => Container(
              constraints: BoxConstraints(minWidth: context.width),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 10,
                children: [
                  CustomVehiclePersonField(
                    controller: context.read<TVPDBloc>().controller,
                    vehiclesList: context.watch<TVPDBloc>().vehicles,
                    personsList: context.watch<TVPDBloc>().persons,
                    groupVehicles: context.watch<TVPDBloc>().groupVehicles,
                    selected: context.watch<TVPDBloc>().selectedVehicles,
                    onSelected: (val) => context.read<TVPDBloc>().add(TVPDSelectedEvent(data: val)),
                    onDeleted: (val) => context.read<TVPDBloc>().add(TVPDDeleteEvent(data: val)),
                    updateWhileDelete: false,
                    onEmptyAsync: () async => context.popDialog(),
                  ),
                  if (onSelected != null)
                    SuccessButton(
                      text: "Save",
                      onPressed: () {
                        var value = context.read<TVPDBloc>().selectedVehicles;
                        var model = context.read<TVPDBloc>().selectedModel;
                        if (value.isNotEmpty) onSelected?.call(model, value);
                        context.popDialog();
                      },
                    ),
                ],
              ),
            ));
  }
}
