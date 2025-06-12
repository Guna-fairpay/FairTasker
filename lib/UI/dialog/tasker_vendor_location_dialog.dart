import 'package:fairpytasker/Component/custom_vendor_location_field.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/dialog/tasker_vendor_location_dialog/bloc/tasker_vendor_location_dialog_bloc.dart';
import 'package:fairpytasker/UI/dialog/tasker_vendor_location_dialog/bloc/tasker_vendor_location_dialog_event.dart';
import 'package:fairpytasker/UI/dialog/tasker_vendor_location_dialog/bloc/tasker_vendor_location_dialog_state.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskerVendorLocationDialog {
  TaskerVendorLocationDialog._();

  static void show(BuildContext context, Map<String, dynamic>? model, {void Function(Map<String, dynamic> val)? onSelected}) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (context) => _TaskerVendorLocationDialogView(model: model, onSelected: onSelected),
    );
  }
}

class _TaskerVendorLocationDialogView extends StatelessWidget {
  final Map<String, dynamic>? model;
  final void Function(Map<String, dynamic>)? onSelected;
  const _TaskerVendorLocationDialogView({required this.model, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      titlePadding: 10.padding,
      insetPadding: 10.padding,
      backgroundColor: Colors.white,
      alignment: Alignment.topCenter,
      title: ListTile(
        dense: true,
        minTileHeight: 0,
        minLeadingWidth: 0,
        minVerticalPadding: 0,
        horizontalTitleGap: 0,
        contentPadding: 10.padding,
        title: Utils.getText("${model?['display']?['task_title']}",
            size: 12.spMin, weight: FontWeight.w600),
        trailing: IconButton(
            onPressed: context.popDialog,
            icon: const Icon(Icons.close_rounded)),
      ),
      contentPadding: 10.padding,
      content: BlocProvider(
        create: (context) => TVLDBloc()..add(TVLDInitialEvent(model)),
        child: BlocListener<TVLDBloc,TVLDState>(
          listener: (context, state) {
            if (state is TVLDSubmitState) {
              onSelected?.call(state.data);
              context.popDialog();
            }
          },
          child: BlocBuilder<TVLDBloc, TVLDState>(
            builder: (context, state) => SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 5.spMin,
                children: [
                  CustomVendorLocationField(
                    vendorsList: context.watch<TVLDBloc>().vendorsList,
                    locationsList: context.watch<TVLDBloc>().locationsList,
                    controller: context.read<TVLDBloc>().controller,
                    selected: {3: context.watch<TVLDBloc>().selectedVendor},
                    onSelected: (val) => context.read<TVLDBloc>().add(TVLDSelectEvent(val)),
                  ),
                  SuccessButton(
                    text: "Save",
                    onPressed: () => context.read<TVLDBloc>().add(TVLDSubmitEvent()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
