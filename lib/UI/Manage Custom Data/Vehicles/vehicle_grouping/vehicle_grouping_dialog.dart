import 'package:collection/collection.dart';
import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/custom_multi_selection_chips_field.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/vehicle_grouping/bloc/vehicle_group_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/vehicle_grouping/bloc/vehicle_group_events.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/vehicle_grouping/bloc/vehicle_group_states.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/vehicle_grouping/vehicle_group_item.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:fairpytasker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleGroupingDialog {
  VehicleGroupingDialog._();

  static void show(BuildContext context, {dynamic vids}) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _VehicleGroupingDialogView(vids: vids),
    );
  }
}

class _VehicleGroupingDialogView extends StatelessWidget {
  final dynamic vids;

  const _VehicleGroupingDialogView({this.vids});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: 10.sp.padding,
      titlePadding: EdgeInsets.zero,
      alignment: Alignment.topCenter,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      title: ListTile(
        title: const Text("Vehicle Grouping"),
        titleTextStyle: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold, color: AppC.appColor),
        trailing: InkWell(
            onTap: context.popDialog, child: const Icon(Icons.close_rounded)),
      ),
      content: BlocProvider(create: (context) =>
      VehicleGroupBloc()
        ..add(VehicleGroupInitialEvent(selectedModels: vids)),
          child: BlocListener<VehicleGroupBloc, VehicleGroupState>(
              listener: (context, state) {
                if (state is VehicleGroupLoadingState) {
                  EasyLoading.show();
                } else {
                  if (EasyLoading.isShow) EasyLoading.dismiss();
                  if (state is VehicleGroupDeleteTapVehicleState) {
                    AskPermissionDialog.show(context, title: "Are you sure?",
                        description: "Do you want to delete this group?",
                        onPositivePressed: () =>
                            context.read<VehicleGroupBloc>().add(
                                VehicleGroupDeleteVehicleEvent(
                                    selectedModel: state.selectedModel)));
                  } else if (state is VehicleGroupErrorState) {
                    Toaster.showError(state.message);
                  }
                }
              },
              child: const _VehicleGroupingDialogContentView())),
    );
  }
}

class _VehicleGroupingDialogContentView extends StatelessWidget {
  const _VehicleGroupingDialogContentView();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ListView(
        shrinkWrap: true,
        children: [
          const _VehicleGroupingDialogCreateView(),
          10.height,
          const _VehicleGroupingDialogListView(),
        ],
      ),
    );
  }
}

class _VehicleGroupingDialogCreateView extends StatelessWidget {
  const _VehicleGroupingDialogCreateView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleGroupBloc, VehicleGroupState>(
        builder: (context, state) =>
            Form(
              key: context
                  .read<VehicleGroupBloc>()
                  .formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  const SizedBox.shrink(),
                  Utils.getTextFormField('Group Name', context
                      .read<VehicleGroupBloc>()
                      .groupNameController,
                    autoValidate: context.watch<VehicleGroupBloc>().autoValidateMode,
                    validator: (value) =>
                    (value
                        ?.trim()
                        .isNullOrEmpty ?? true)
                        ? "Please Enter Group Name"
                        : null,),
                  CustomMultiSelectionChipsField<Map<String, dynamic>>(
                    selectedPartsList: context
                        .watch<VehicleGroupBloc>()
                        .selectedVehicles,
                    suggestionsList: context
                        .watch<VehicleGroupBloc>()
                        .apiResponseVehicles,
                    itemAsString: (item) => item['vehicle_name'].toString(),
                    controller: context
                        .read<VehicleGroupBloc>()
                        .vehicleController,
                    hintText: "Select Vehicle",
                    labelText: "Vehicles",
                    onChanged: (isChecked, value) =>
                        context.read<VehicleGroupBloc>().add(
                            VehicleGroupSelectVehicleEvent(
                                isChecked: isChecked, selectedModel: value)),
                    controllerAutoClear: true,
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      SuccessButton(onPressed: () =>
                          context.read<VehicleGroupBloc>().add(
                              VehicleGroupSaveEvent()), text: (context
                          .watch<VehicleGroupBloc>()
                          .selectedModel != null) ? "Update" : "Save"),
                      if (context
                          .watch<VehicleGroupBloc>()
                          .selectedModel != null)
                        SuccessButton(onPressed: () =>
                            context.read<VehicleGroupBloc>().add(
                                VehicleGroupCancelEvent()),
                            text: "Cancel",
                            backgroundColor: AppC.redAccent),
                      const Spacer(flex: 1),
                      Expanded(
                          flex: 8, child: CompactSearchView(controller: context
                          .read<VehicleGroupBloc>()
                          .searchController,
                          onChanged: (value) =>
                              context.read<VehicleGroupBloc>().add(
                                  VehicleGroupSearchEvent(query: value))))
                    ],
                  )
                ],
              ),
            ));
  }
}

class _VehicleGroupingDialogListView extends StatelessWidget {
  const _VehicleGroupingDialogListView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleGroupBloc, VehicleGroupState>(
        builder: (context, state) {
          var currentPage = context
              .watch<VehicleGroupBloc>()
              .currentPage;
          return Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(4),
                  2: FlexColumnWidth(2),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: const TableBorder(
                    horizontalInside: BorderSide(
                        color: AppC.borderColor,
                        width: Num.borderWidthThinField)),
                children: context
                    .watch<VehicleGroupBloc>()
                    .filteredResponse
                    .mapIndexed((index, element) =>
                    VehicleGroupItem(
                    index: (((currentPage != 1) ? (((currentPage - 1) * context
                        .read<VehicleGroupBloc>()
                        .itemsPerPage) + index) : index) + 1),
                    model: element,
                    onEdit: () =>
                        context.read<VehicleGroupBloc>().add(
                            VehicleGroupEditEvent(model: element)),
                    onDelete: () =>
                        context.read<VehicleGroupBloc>().add(
                            VehicleGroupDeleteTapVehicleEvent(
                                selectedModel: element))))
                    .toList(),
              ),
              CompactPagination(totalPages: context
                  .watch<VehicleGroupBloc>()
                  .totalPages,
                  currentPage: context
                      .watch<VehicleGroupBloc>()
                      .currentPage,
                  onPageChanged: (value) =>
                      context.read<VehicleGroupBloc>().add(
                          VehicleGroupPaginationEvent(page: value)))
            ],
          );
        });
  }
}





