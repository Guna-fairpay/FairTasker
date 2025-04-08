
import 'package:fairpytasker/Component/custom_vehicle_history_card_view.dart';
import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/edit_todo_ui.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/bloc/vehicle_history_bloc.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/event/vehicle_history_event.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/state/vehicle_history_state.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history_detail/vehicle_history_details_ui.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_view_users_dialog.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:sticky_headers/sticky_headers.dart';

class VehicleHistoryViewUI extends StatelessWidget {
  final String? vin;
  final dynamic groupId;
  final String? vehicleName;
  final bool showHeader;
  final bool showSameTask;
  final String? title;

  const VehicleHistoryViewUI({super.key,
    this.vin,
    this.groupId,
    required this.vehicleName,
    this.title,
    this.showHeader = true,
    this.showSameTask = false});

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
      create: (context) =>
      VehicleHistoryBloc()
        ..add(VehicleInitialEvent(vin, vehicleName, groupId)),
      child: BlocListener<VehicleHistoryBloc, VehicleHistoryState>(
        listener: (context, state) {
          if (state.isLoading) {
            EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
          }
        },
        child: BlocBuilder<VehicleHistoryBloc, VehicleHistoryState>(
          builder: (context, state) =>
              SafeArea(
                  child: Padding(
                    padding: (showHeader) ? const EdgeInsets.symmetric(horizontal: 20) : EdgeInsets.zero,
                    child: Column(
                      children: [
                        10.height,
                        Utils.getSearchBarUI(
                          searchController:
                          context
                              .read<VehicleHistoryBloc>()
                              .searchController,
                          readOnly: state.isSameTaskSelected,
                          onSearch: (value) =>
                              context
                                  .read<VehicleHistoryBloc>()
                                  .add(VehicleHistorySearchEvent(value)),
                        ),
                        if ((showSameTask && ((title?.length ?? 0) > 0)))
                          ListTile(
                            dense: true,
                            onTap: () => context.read<VehicleHistoryBloc>().add(VehicleHistorySameTaskEvent(title, !state.isSameTaskSelected)),
                            contentPadding: EdgeInsets.zero,
                            title: Utils.getText(
                              'Same Task',
                              weight: FontWeight.bold,
                            ),
                            trailing: Transform.scale(
                              scale: 0.6,
                              alignment: AlignmentDirectional.centerEnd,
                              child: Switch(
                                value: state.isSameTaskSelected,
                                onChanged: (value) => context.read<VehicleHistoryBloc>().add(VehicleHistorySameTaskEvent(title, value)),
                                materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ),
                        10.height,
                        if (!state.isLoading && state.vehicleDataList.isEmpty)
                          const EmptyWidget(),
                        if (state.vehicleDataList.isNotEmpty)
                          Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(bottom: 20),
                                itemCount: (state.vehicleDataList).keys
                                    .length,
                                separatorBuilder: (context, index) =>
                                10.height,
                                // physics: showHeader ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var keyValue =
                                  (state.vehicleDataList).keys.elementAt(
                                      index);
                                  var value = state.vehicleDataList[keyValue];
                                  return StickyHeader(
                                      header: Center(
                                        child: Container(
                                          padding: 8.padding.copyWith(left: 10.sp, right: 10.sp),
                                          decoration: const BoxDecoration(
                                              color: AppC.borderColor,
                                              borderRadius: const BorderRadius.all(Radius.circular(Num.borderRadiusXLarge))),
                                          child: Text(
                                            "${keyValue.toFormat(
                                                format: "MM-dd-yy")}",
                                            style: context.textTheme.labelMedium
                                                ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppC.appColor),
                                          ),
                                        ),
                                      ),
                                      overlapHeaders: false,
                                      content: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: (value?.length ?? 0),
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, subIndex) {
                                          var model = value?[subIndex];
                                          List<
                                              dynamic> users = model?['users'];
                                          String? firstName =
                                          (users.firstOrNull?['first_name'] ?? "");
                                          String? lastName =
                                          (users.firstOrNull?['last_name'] ?? "");
                                          var firstLastChar = "${[firstName, lastName].toInitial}${users.length > 1 ? ".." : ""}";
                                          var customId = (model['custom_link_id'] ??
                                              0);
                                          var customText = (customId == 1)
                                              ? "Link"
                                              : (customId == 2)
                                              ? "TURO"
                                              : "GETAROUND";
                                          var time = model['todo_time']
                                              .toString()
                                              .toDateTime(
                                              inputFormat: "HH:mm:ss")
                                              .toFormat(format: "hh:mm a");
                                          var isCompleted =
                                          (model['status'] == 'Completed');
                                          String customLink = model['custom_link'] ?? "";
                                          return CustomVehicleHistoryCardView(
                                            titleText: model['title'],
                                            userNameText: firstLastChar,
                                            hasParts:
                                            ((model['parts'] as List?)
                                                ?.isNotEmpty ??
                                                false),
                                            hasSupplies: ((model['supplies'] as List?)
                                                ?.isNotEmpty ??
                                                false),
                                            locationText:
                                            model['vendor_name'] ??
                                                model['location'],
                                            notesText: model['notes'],
                                            timeText: time,
                                            cleanCarText: model['clean_required'],
                                            customText: customText,
                                            hasCustom: model['custom_link'] !=
                                                null,
                                            isCompleted: isCompleted,
                                            confirmDismiss: (
                                                direction) async {
                                              context.read<
                                                  VehicleHistoryBloc>().add(
                                                  VehicleHistoryCompleteEvent(
                                                      model['id'],
                                                      !isCompleted));
                                              return false;
                                            },
                                            onTap: () {
                                              context.read<VehicleHistoryBloc>().add(VehicleHistoryViewEvent(model));
                                              if (context.read<VehicleHistoryBloc>().isAdmin) {
                                                VehicleHistoryDetailsUiDialog
                                                    .show(context);
                                              } else {
                                                context.push(EditTodoUI(todoId: model['id']),fullscreenDialog: true);
                                              }
                                              // context.push(const VehicleHistoryDetailsUi(), fullscreenDialog: true);
                                            },
                                            onDelete: () {
                                              // SHOW DIALOG AND GET CONFIRMATION WITH REASON
                                              AskPermissionDialog.show(
                                                context,
                                                title:
                                                "Are you sure want to delete this task?",
                                                description:
                                                "Kindly enter a valid reason to confirm the deletion",
                                                positiveText: "Yes, delete it!",
                                                negativeText: "Cancel",
                                                isReasonRequired: true,
                                                onReasonSubmitted: (reason) =>
                                                    context
                                                        .read<
                                                        VehicleHistoryBloc>()
                                                        .add(
                                                        VehicleHistoryDeleteEvent(
                                                            model['id'],
                                                            reason)),
                                              );
                                            },
                                            onParts: () {
                                              ShowChipDialog.show<Map<String, dynamic>>(
                                                  context, data: model['parts'] ?? [],
                                                  title: "Parts",
                                                  avatarIcon: const Icon(Icons.repartition_sharp),
                                                  itemAsString: (
                                                      item) => "${item['parts_name'] ?? ""}");
                                            },
                                            onSupplies: () {
                                              ShowChipDialog.show<Map<String, dynamic>>(
                                                  context, data: model['supplies'] ?? [],
                                                  title: "Supplies",
                                                  avatarIcon: const Icon(Icons.support_rounded),
                                                  itemAsString: (
                                                      item) => "${item['supplies_name'] ?? ""}");
                                            },
                                            onUserTap: () {
                                              ShowChipDialog.show<Map<String, dynamic>>(
                                                  context, data: users,
                                                  title: "Users",
                                                  avatarIcon: const Icon(Icons.person),
                                                  itemAsString: (
                                                      item) => "${item['first_name'] ?? ""} ${item['last_name'] ?? ""}");
                                            },
                                            onCustom: () {
                                              switch(customId){
                                                case 1:
                                                  Utils.openURL(customLink);
                                                  break;
                                                case 2:
                                                  Utils.openURL(customLink.toTuroReserveUrl);
                                                  break;
                                                case 3:
                                                  Utils.openURL(customLink.toGetAroundReserveUrl);
                                                  break;
                                              }
                                            },
                                          );
                                        },
                                      ));
                                },
                              )),
                        if (state.vehicleDataList.isNotEmpty)
                          NumberPagination(
                            onPageChanged: (page) =>
                                context
                                    .read<VehicleHistoryBloc>()
                                    .add(VehicleHistoryPageEvent(page)),
                            totalPages: state.totalPage,
                            currentPage: state.currentPage,
                            enableInteraction: true,
                            betweenNumberButtonSpacing: 0,
                            buttonRadius: 3,
                            sectionSpacing: 0,
                            visiblePagesCount: 5,
                            controlButtonSize: const Size.fromRadius(20),
                            numberButtonSize: const Size.fromRadius(20),
                            fontFamily: "Lato",
                            buttonElevation: 0,
                            navigationButtonSpacing: 0,
                            controlButtonColor: AppC.lightGrey,
                            unSelectedButtonColor: AppC.trans,
                            selectedButtonColor: AppC.appColor,
                            selectedNumberFontWeight: FontWeight.bold,
                            unSelectedNumberColor: AppC.text,
                          ),
                        /*Expanded(child: filterVehicleDataList.isEmpty
                      && searchController.text.isNotEmpty ? Center(
                    child: Utils.getText(
                      'No Results Found',
                      color: Colors.grey,
                      weight: FontWeight.bold,
                      size: 16,
                    ),
                  )
                      : ListView.separated(
                    controller: _scrollController,
                    itemCount: filterVehicleDataList.length,
                    itemBuilder: (context, index) {
                      final data = filterVehicleDataList[index];
                      var d = data['todo_time'] ?? '';
                      return Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        spacing: 5,
                        children: [
                          Flexible(
                            child: Container(
                              padding:
                              const EdgeInsets.only(top: 6.0),
                              child: Utils.getText(
                                  DateTime.tryParse(data['todo_date'].toString()).toFormat(format: "MM-dd-yy") ?? "",
                                  weight: FontWeight.bold,
                                  color: AppC.green, size: 12),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: ClipRRect(
                              child: Dismissible(
                                  key: ValueKey(data['id']),
                                  background: Container(),
                                  secondaryBackground: Container(
                                    alignment: Alignment.centerRight,
                                    color: AppC.green.withValues(alpha: 0.8),
                                    child: TextButton.icon(onPressed: (){}, label: Utils.getText("Complete", color: AppC.white, weight: FontWeight.w600), icon: const Icon(Icons.check_circle_outline,color: AppC.white,)),
                                  ),
                                  direction: DismissDirection.endToStart,
                                  confirmDismiss: (direction) async {
                                    if (direction == DismissDirection.endToStart) {
                                      todoBloc!.add(CompleteTodoItem(
                                          todoId: data['id'].toString(), status: 'Completed',
                                          taskName: data['title']));
                                    }
                                    return false;
                                  },
                                  // key: UniqueKey(),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: const BorderSide(
                                            color: AppC.white,
                                            width: 1),
                                        left: const BorderSide(
                                            color: AppC.white,
                                            width: 1),
                                        right: const BorderSide(
                                            color: AppC.white,
                                            width: 1),
                                        bottom: BorderSide(
                                            color: Colors.grey
                                                .withOpacity(0.4),
                                            width: 1.2),
                                      ),
                                      color: AppC.white,),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          spacing: 10,
                                          children: [
                                            Utils.getText(
                                              data['title'] ?? '',
                                              weight: FontWeight.bold,
                                              color: AppC.green,),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () async {
                                                  final String link =
                                                  data['custom_link_id'] == 3
                                                      ? 'https://getaround.com/dashboard/rentals/${data['reference_id'] ?? data['reference_id']}'
                                                      : 'https://turo.com/us/en/reservation/${data['reference_id'] ?? data['reference_id']}';
                                                  if (await canLaunch(
                                                      link)) {
                                                    await launch(link,
                                                        forceSafariVC:
                                                        false,
                                                        forceWebView: false);
                                                  } else {
                                                    throw 'Could not launch $link';
                                                  }
                                                },
                                                child:
                                                Utils.getText(
                                                  data['custom_link_id'] != null &&
                                                      data['reference_id'] != null
                                                      ? (data['custom_link_id'] == 3 ? 'G' : 'T')
                                                      : data['reference_id'] !=
                                                      null
                                                      ? 'T' : '',
                                                  color: data['custom_link_id'] == 3
                                                      ? const Color(0xFFA608C0)
                                                      : Colors.black,
                                                  weight: FontWeight.w900,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                            Utils.getText(
                                              Utils.convertString24HTo12H(
                                                  data['todo_time'] ?? ''),
                                              color: AppC.green,),
                                            InkWell(
                                              onTap:(){
                                                DeletePermissionDialog.of.show(context, (val) {
                                                  setState(() {
                                                    if(val.isNotEmpty){
                                                      todoBloc?.add(DeleteTodoEvent(
                                                          todoId: data['id'].toString()));
                                                      vehicleHistoryBloc.add(vdb.DeleteExpense(
                                                          id: data['expense_id']));
                                                    }
                                                  });
                                                },);
                                              },
                                              child: const Icon(
                                                Icons.delete_outline,
                                                color: AppC.redAccent,
                                                size: 14,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          spacing: 10,
                                          children: [
                                            if (data['clean_required'] != null)
                                              Utils.getText('(${data['clean_required']})',
                                                weight: FontWeight.bold,
                                                color: AppC.orange,
                                              ),
                                            if (data['parts'].isNotEmpty)
                                              InkWell(
                                                  onTapDown: (details) =>
                                                      VehicleHistoryPop.instance.show(
                                                          context, data: data,
                                                          details: details,
                                                          compare: "parts",
                                                          display: "parts_name"),
                                                  child: Utils.getText(
                                                      "P",
                                                      weight: FontWeight.bold,
                                                      size: 13)),
                                            if (data['supplies'].isNotEmpty)
                                              InkWell(onTapDown: (details) =>
                                                  VehicleHistoryPop.instance
                                                      .show(context,
                                                      data: data,
                                                      details: details,
                                                      compare: "supplies",
                                                      display: "supplies_name"),
                                                  child: Utils.getText('S',
                                                      weight: FontWeight.bold)),
                                          ],
                                        ),
                                        Row(
                                          spacing: 10,
                                          children: [
                                            Expanded(
                                                child: (data['notes'] != null &&
                                                    data['notes'].toString().isNotEmpty)
                                                    ? ReadMoreText(
                                                  '(${data['notes']})',
                                                  trimLines: 1,
                                                  titleText: data['location'] ??
                                                      data['vendor_name'] ?? '',
                                                  titleTextStyle: context
                                                      .textTheme
                                                      .labelLarge
                                                      ?.copyWith(
                                                      color: AppC.green,
                                                      fontWeight: FontWeight.w500),
                                                  trimMode: TrimMode.Line,
                                                  trimCollapsedText: ' more',
                                                  trimExpandedText: ' less',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                  moreStyle: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.pink),
                                                  lessStyle: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.pink),
                                                ) : Container()),
                                            UserGroupWidget(
                                              todos: data,
                                              userGroupList: userGroupList,
                                              resourceList: resourceList,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => 1.height,
                  ),
                  ),*/
                      ],
                    ),
                  )),
        ),
      ),
    );
  }
}
