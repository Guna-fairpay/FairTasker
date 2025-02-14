import 'dart:developer' show log;

import 'package:fairpytasker/Component/custom_vehicle_history_card_view.dart';
import 'package:fairpytasker/Component/empty_widget.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/bloc/vehicle_history_bloc.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/event/vehicle_history_event.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/state/vehicle_history_state.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:sticky_headers/sticky_headers.dart';

class VehicleHistoryViewUI extends StatelessWidget {
  final String? vin;
  final String? vehicleName;
  final bool showHeader;
  final bool showSameTask;
  final String? title;

  const VehicleHistoryViewUI(
      {super.key,
      required this.vin,
      required this.vehicleName,
      this.title,
      this.showHeader = true,
      this.showSameTask = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppC.white,
      appBar: showHeader
          ? AppBar(
        backgroundColor: AppC.appColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Utils.getText(vehicleName ?? '',
            weight: FontWeight.bold, color: AppC.white, size: 16),
        titleSpacing: -8,
      )
          : null,
      body: BlocProvider(
        create: (context) => VehicleHistoryBloc()..add(VehicleInitialEvent(vin, vehicleName)),
        child: BlocListener<VehicleHistoryBloc, VehicleHistoryState>(listener: (context, state) {
          if (state.isLoading) {
            EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
          }
        },
          child: BlocBuilder<VehicleHistoryBloc, VehicleHistoryState> (
            builder: (context, state) => SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      10.height,
                      Utils.getSearchBarUI(
                        searchController: context.read<VehicleHistoryBloc>().searchController,
                        onSearch: (value) => context.read<VehicleHistoryBloc>().add(VehicleHistorySearchEvent(value)),
                      ),
                      10.height,
                      if (state.vehicleDataList.isEmpty)
                        const EmptyWidget(),
                      if (state.vehicleDataList.isNotEmpty)
                      Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: (state.vehicleDataList).keys.length,
                            separatorBuilder: (context, index) => 10.height,
                            itemBuilder: (context, index) {
                              var keyValue = (state.vehicleDataList).keys.elementAt(index);
                              var value = state.vehicleDataList[keyValue];
                              return StickyHeader(
                                  header: Container(
                                    width: double.maxFinite,
                                    padding: 10.padding,
                                    decoration: const BoxDecoration(
                                        color: AppC.appColor,
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(Num.borderRadiusLarge))
                                    ),
                                    child: Text("${keyValue.toFormat(format: "MM-dd-yy")}", style: context.textTheme.labelLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),),
                                  ),
                                  overlapHeaders: false,
                                  content: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: (value?.length ?? 0),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, subIndex) {
                                      var model = value?[subIndex];
                                      String? firstName = (model?['users']?[0]?['first_name']);
                                      String? lastName = (model?['users']?[0]?['last_name']);
                                      if (firstName == null || lastName == null) log("${model['id']} ${model['userIds']} ${model['users']}", name: "LIST_DATA");
                                      var firstLastChar = "${firstName?.substring(0, 1) ?? ""}${lastName?.substring(0, 1) ?? ""}${((model?['users'] as List).length > 1) ? ".." : ""}";
                                      var customId = (model['custom_link_id'] ?? 0);
                                      var customText = (customId == 1) ? "Link" : (customId == 2) ? "TURO" : "GETAROUND";
                                      var time = model['todo_time'].toString().toDateTime(inputFormat: "HH:mm:ss").toFormat(format: "hh:mm a");
                                      var isCompleted = (model['status'] == 'Completed');
                                      return CustomVehicleHistoryCardView(
                                        titleText: model['title'],
                                        userNameText: firstLastChar,
                                        hasParts: ((model['parts'] as List?)?.isNotEmpty ?? false),
                                        hasSupplies: ((model['supplies'] as List?)?.isNotEmpty ?? false),
                                        locationText: model['vendor_name'] ?? model['location'],
                                        notesText: model['notes'],
                                        timeText: time,
                                        cleanCarText: model['clean_required'],
                                        customText: customText,
                                        hasCustom: model['custom_link'] != null,
                                        isCompleted: isCompleted,
                                        confirmDismiss: (direction) async {
                                          context.read<VehicleHistoryBloc>().add(VehicleHistoryCompleteEvent(model['id'], !isCompleted));
                                          return false;
                                        },
                                        onTap: () {
                                          Toaster.showInfo("Tap Under construction");
                                        },
                                        onDelete: () {
                                          Toaster.showInfo("Delete Under construction");
                                        },
                                        onParts: (){
                                          Toaster.showInfo("Parts Under construction");
                                        },
                                        onSupplies: (){
                                          Toaster.showInfo("Supplies Under construction");
                                        },
                                        onUserTap: (){
                                          Toaster.showInfo("User Under construction");
                                        },
                                        onCustom: (){
                                          Toaster.showInfo("Custom Under construction");
                                        },
                                      );
                                    },
                                  ));
                            },
                          )),
                      if (state.vehicleDataList.isNotEmpty)
                      NumberPagination(
                        onPageChanged: (page) => context.read<VehicleHistoryBloc>().add(VehicleHistoryPageEvent(page)),
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
                      // 10.height,
                      /*if (widget.showSameTask)
                    Row(
                      children: [
                        Transform.scale(
                          scale: 0.6,
                          child: Switch(
                            value: sameTask,
                            onChanged: (value) {
                              setState(() {
                                sameTask = value;
                                _filterVehicleDataList(title!);
                                //searchController.text=title!;
                              });
                            },
                            activeTrackColor: AppC.appColor,
                            activeColor: AppC.white,
                            inactiveTrackColor: AppC.white,
                            inactiveThumbColor: AppC.appColor,
                          ),
                        ),
                        Utils.getText(
                          'Same Task',
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),*/
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
      ),
    );
  }

}
