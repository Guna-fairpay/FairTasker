import 'dart:convert';
import 'package:fairpytasker/Component/choice_box_widget.dart';
import 'package:fairpytasker/Component/custom_list_widet.dart';
import 'package:fairpytasker/Component/image_viewer.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/bloc/vehicle_history_bloc.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/event/vehicle_history_event.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_history/state/vehicle_history_state.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/str.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleHistoryDetailsUiDialog {
  VehicleHistoryDetailsUiDialog._();

  static void show(BuildContext context,
      {Map<String, dynamic>? mapData}) async {
    var bloc = context.read<VehicleHistoryBloc>();
    await showDialog(
        context: context,
        builder: (context) => VehicleHistoryDetailsUi(
              bloc: bloc,
              mapData: mapData ?? {},
            ),
        barrierDismissible: true,
        useSafeArea: true,
        useRootNavigator: true);
  }
}

class VehicleHistoryDetailsUi extends StatelessWidget {
  final VehicleHistoryBloc bloc;
  final Map<String, dynamic> mapData;

  const VehicleHistoryDetailsUi(
      {super.key, required this.bloc, required this.mapData});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleHistoryBloc, VehicleHistoryState>(
      bloc: bloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor:
                (mapData['status'].toString().toLowerCase() == "completed")
                    ? AppC.darkGreen
                    : AppC.appColor,
            foregroundColor: Colors.white,
            leading: IconButton(
                onPressed: () => context.popDialog(),
                icon: Icon(Icons.clear_rounded)),
            leadingWidth: 30,
            title: (mapData['title'] != null)
                ? Text("${mapData['title'] ?? ""}")
                : Container(),
            actionsPadding: 10.horizontalPadding,
            actions: [
              Transform.scale(
                scale: 0.7,
                alignment: AlignmentDirectional.centerEnd,
                child: Switch(
                    value: (mapData['status'].toString().toLowerCase() ==
                        "completed"),
                    onChanged: (value) => bloc.add(
                        VehicleHistoryCompleteEvent(mapData['id'], value))),
              )
            ],
          ),
          body: Padding(
            padding: 10.padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                ListWidget<Map<String, dynamic>>(
                    item: mapData,
                    itemAsString: (item) =>
                        "${mapData['todo_date'].toString().toDateTime(inputFormat: "yyyy-MM-dd").toFormat(format: "MM-dd-yyyy")} ${mapData['todo_time'].toString().toDateTime(inputFormat: "HH:mm:ss").toFormat(format: "hh:mm a")}",
                    leadingIcon: Icons.calendar_month_rounded),
                ListWidget<Map<String, dynamic>>(
                    item: mapData,
                    itemAsString: (item) => ((mapData['users'])
                        .map((e) =>
                            "${e['first_name'] ?? ""} ${e['last_name'] ?? ""}")
                        .join(", ")),
                    leadingIcon: Icons.person_outline_rounded),
                if (mapData['vehicle_name'] != null)
                  ListWidget(
                      item: "${mapData['vehicle_name'] ?? ""}",
                      leadingIcon: Icons.directions_car),
                if ((mapData['vendor_name'] != null) ||
                    (mapData['location'] != null))
                  ListWidget(
                      item:
                          "${mapData['vendor_name'] ?? mapData['location'] ?? ""}",
                      leadingIcon: Icons.person_pin_circle_outlined),
                if (mapData['notes'] != null)
                  ListWidget(
                      item: "${mapData['notes'] ?? ""}",
                      leadingIcon: Icons.note_outlined),
                if (mapData['reason'] != null)
                  ListWidget(
                      item: "${mapData['reason'] ?? ""}",
                      leadingIcon: Icons.notes_rounded),
                if (mapData['resolution_notes'] != null)
                  ListWidget(
                      item:
                          "Resolution Notes - ${mapData['resolution_notes'] ?? ""}",
                      leadingIcon: Icons.sticky_note_2_outlined),
                if ((mapData['parts'] as List?)?.isNotEmpty ?? false)
                  ChoiceBoxWidget<Map<String, dynamic>>(
                      items: (List<Map<String, dynamic>>.from(mapData['parts']))
                          .distinct((e) => e['parts_id']),
                      itemAsString: (item) => item['parts_name'] ?? ""),
                if ((mapData['supplies'] as List?)?.isNotEmpty ?? false)
                  ChoiceBoxWidget<Map<String, dynamic>>(
                      items: (List<Map<String, dynamic>>.from(mapData['supplies']))
                          .distinct((e) => e['supplies_id']),
                      itemAsString: (item) => item['supplies_name'] ?? ""),
                ListWidget(
                    item: (mapData['mileage'] != null)
                        ? "Odometer - ${mapData['mileage']}"
                        : "No Odometer",
                    leadingIcon: Icons.location_on_outlined),
                if (mapData['expense_id'] != null) ...[
                  Text(
                    "Expense",
                    style: context.textTheme.labelLarge
                        ?.copyWith(color: AppC.appColor),
                  ),
                  ListWidget(
                      item: "${mapData['expense_amount'] ?? "0"}",
                      leadingIcon: Icons.monetization_on_outlined),
                  if (mapData['expense_description'] != null)
                    ListWidget(
                        item: "${mapData['expense_description'] ?? ""}",
                        leadingIcon: Icons.layers_outlined),
                  if (mapData['category_name'] != null)
                    ListWidget(
                        item: "${mapData['category_name'] ?? ""}",
                        leadingIcon: Icons.layers_outlined),
                  if (mapData['subcategory_name'] != null)
                    ListWidget(
                        item: "${mapData['subcategory_name'] ?? ""}",
                        leadingIcon: Icons.layers_outlined),
                  if ((mapData['expense_attachment'] != null) &&
                      (jsonDecode(mapData['expense_attachment'].toString()))
                          .isNotEmpty)
                    const ListWidget(
                        item: "Attachment",
                        leadingIcon: Icons.attach_file_rounded),
                  if ((mapData['expense_attachment'] != null) &&
                      (jsonDecode(mapData['expense_attachment'].toString()))
                          .isNotEmpty)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          (jsonDecode(mapData['expense_attachment'].toString()))
                              .values
                              .length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5),
                      itemBuilder: (context, index) => Container(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.sizeOf(context).height,
                            minWidth: MediaQuery.sizeOf(context).width,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppC.grey.withValues(alpha: 0.2)),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: ImageViewer(
                              fit: BoxFit.cover,
                              imageInput: Str.STORAGE_BASE_URL +
                                  (jsonDecode(mapData['expense_attachment']
                                          .toString()))
                                      .values
                                      .elementAt(index))),
                    )
                ],
                if (mapData['reservation_no'] != null)
                  ListWidget(
                      item:
                          "Reservation No - ${mapData['reservation_no'] ?? ""}"),
              ],
            ),
          ),
        );
      },
    );
  }
}
