import 'package:fairpytasker/Component/custom_compact_pagination.dart';
import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/custom_vehicle_history_card_view.dart';
import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:fairpytasker/Component/expand_wrapper.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/edit_todo_ui.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/bloc/vehicle_history_bloc.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/event/vehicle_history_event.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/state/vehicle_history_state.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history_detail/vehicle_history_details_ui.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_view_users_dialog.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VehicleHistoryViewUI extends StatelessWidget {
  final String? vin;
  final dynamic groupId;
  final String? vehicleName;
  final bool showHeader;
  final bool showSameTask;
  final String? title;
  final bool additionalScroll;
  final int itemPerPage;
  final bool showLoading;
  final bool isAsset;

  const VehicleHistoryViewUI(
      {super.key,
      this.vin,
      this.groupId,
      required this.vehicleName,
      this.title,
      this.itemPerPage = 10,
      this.showLoading = true,
      this.showHeader = true,
      this.showSameTask = false,
      this.additionalScroll = true,
      this.isAsset = false,
      });

  @override
  Widget build(BuildContext context) {
    if (!showHeader) return body(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppC.white,
      appBar: AppBar(
        backgroundColor: AppC.appColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Utils.getText(vehicleName ?? '',
            weight: FontWeight.bold, color: AppC.white, size: 16),
        titleSpacing: -8,
      ),
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    return BlocProvider(
      create: (context) => VehicleHistoryBloc()
        ..add(VehicleInitialEvent(vin, vehicleName, groupId,
            itemPerPage: itemPerPage)),
      child: BlocListener<VehicleHistoryBloc, VehicleHistoryState>(
        listener: (context, state) {
          if ((state is VehicleHistoryLoadingState) || (state is VehicleHistorySubLoadingState)) {
            if (showLoading || (state is VehicleHistorySubLoadingState)) EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
            switch (state) {
              case VehicleHistorySelectTaskState():
                (context.read<VehicleHistoryBloc>().isAdmin && !isAsset)
                  ? context.push(EditTodoUI(todoId: state.selectedTask?['id']), fullscreenDialog: true)
                  : VehicleHistoryDetailsUiDialog.show(context,
                  mapData: state.selectedTask);
              break;
              case VehicleHistoryDeleteInitState(): AskPermissionDialog.show(
                context,
                title:
                "Are you sure want to delete this task?",
                description:
                "Kindly enter a valid reason to confirm the deletion",
                positiveText: "Yes, delete it!",
                negativeText: "Cancel",
                isReasonRequired: true,
                onReasonSubmitted: (reason) => context.read<VehicleHistoryBloc>().add(VehicleHistoryDeleteEvent(state.selectedTask?['id'], reason)));
              break;
              case VehicleHistoryShowPartsState():
                ShowChipDialog.show<Map<String, dynamic>>(
                    context,
                    data: state.model?['parts'] ?? [],
                    title: "Parts",
                    avatarIcon:
                    const Icon(Icons.repartition_sharp),
                    itemAsString: (item) =>
                    "${item['parts_name'] ?? ""}");
                break;
              case VehicleHistoryShowSuppliesState():
                ShowChipDialog.show<Map<String, dynamic>>(
                    context,
                    data: state.model?['supplies'] ?? [],
                    title: "Supplies",
                    avatarIcon:
                    const Icon(Icons.support_rounded),
                    itemAsString: (item) =>
                    "${item['supplies_name'] ?? ""}");
                break;
              case VehicleHistoryShowUsersState():
                ShowChipDialog.show<Map<String, dynamic>>(
                    context,
                    data: state.model,
                    title: "Users",
                    avatarIcon: const Icon(Icons.person),
                    itemAsString: (item) =>
                    "${item['first_name'] ?? ""} ${item['last_name'] ?? ""}");
                break;
            }
          }
        },
        child: BlocBuilder<VehicleHistoryBloc, VehicleHistoryState>(
          builder: (context, state) => SafeArea(
              minimum: (showHeader)
                  ? const EdgeInsets.symmetric(horizontal: 20)
                  : EdgeInsets.zero,
              child: Column(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox.shrink(),
                  CompactSearchView(
                    controller: context
                        .read<VehicleHistoryBloc>()
                        .searchController,
                    readOnly: context
                        .watch<VehicleHistoryBloc>()
                        .isSameTaskSelected,
                    onSubmitted: (value) => context
                        .read<VehicleHistoryBloc>()
                        .add(VehicleHistorySearchEvent(value)),
                  ),
                  if (title?.trim().isNotNullOrEmpty ?? false)
                    ListTile(
                      dense: true,
                      onTap: () => context.read<VehicleHistoryBloc>().add(
                          VehicleHistorySameTaskEvent(
                              title,
                              !context
                                  .read<VehicleHistoryBloc>()
                                  .isSameTaskSelected)),
                      contentPadding: EdgeInsets.zero,
                      title: Utils.getText(
                        'Same Task',
                        weight: FontWeight.bold,
                      ),
                      trailing: Transform.scale(
                        scale: 0.6,
                        alignment: AlignmentDirectional.centerEnd,
                        child: Switch(
                          value: context
                              .watch<VehicleHistoryBloc>()
                              .isSameTaskSelected,
                          onChanged: (value) => context
                              .read<VehicleHistoryBloc>()
                              .add(VehicleHistorySameTaskEvent(
                              title, value)),
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                  if ((state is! VehicleHistoryLoadingState) && context.watch<VehicleHistoryBloc>().listData.isEmpty)
                    const EmptyWidget(withExpand: false),
                  if (context.watch<VehicleHistoryBloc>().listData.isNotEmpty)
                    ExpandWrapper(
                        asExpand: additionalScroll,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: context
                              .watch<VehicleHistoryBloc>()
                              .listData
                              .length,
                          physics: additionalScroll
                              ? const BouncingScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var model = context
                                .watch<VehicleHistoryBloc>()
                                .listData[index];
                            var isCompleted =
                            (model['status'] == 'Completed');
                            return CustomVehicleHistoryCardView(
                              model: model,
                              confirmDismiss: (direction) async {
                                context.read<VehicleHistoryBloc>().add(
                                    VehicleHistoryCompleteEvent(
                                        model['id'], !isCompleted));
                                return false;
                              },
                              onTap: () => context.read<VehicleHistoryBloc>().add(VehicleHistoryViewEvent(model)),
                              onDelete: () => context.read<VehicleHistoryBloc>().add(VehicleHistoryDeleteInitEvent(model)),
                              onParts: () => context.read<VehicleHistoryBloc>().add(VehicleHistoryShowPartsEvent(model)),
                              onSupplies: () => context.read<VehicleHistoryBloc>().add(VehicleHistoryShowSuppliesEvent(model)),
                              onUserTap: (users) => context.read<VehicleHistoryBloc>().add(VehicleHistoryShowUsersEvent(users)),
                              onCustom: (customId, customLink) => context.read<VehicleHistoryBloc>().add(VehicleHistoryViewCustomLinkEvent(customId, customLink)),
                            );
                          },
                        )),
                  CompactPagination(
                      totalPages:
                      context.watch<VehicleHistoryBloc>().totalPage,
                      currentPage:
                      context.watch<VehicleHistoryBloc>().currentPage,
                      onPageChanged: (value) => context
                          .read<VehicleHistoryBloc>()
                          .add(VehicleHistoryPageEvent(value)))
                ],
              )),
        ),
      ),
    );
  }
}
