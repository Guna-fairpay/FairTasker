import 'dart:convert';
import 'dart:developer';

import 'package:fairpytasker/Component/choice_box_widget.dart';
import 'package:fairpytasker/Component/custom_list_widet.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';

class VehicleHistoryDetailsUi extends StatelessWidget {
  final dynamic mapData;
  final dynamic vehicleName;
  const VehicleHistoryDetailsUi({super.key, this.mapData, this.vehicleName});

  @override
  Widget build(BuildContext context) {
    log("mapData ${jsonEncode(mapData)}", name: "VehicleHistoryDetailsUi");
    return Scaffold(
      appBar: AppBar(
        title: (mapData['title'] != null) ? Text("${mapData['title'] ?? ""}") : Container(),
      ),
      body: Padding(
        padding: 10.padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            ListWidget(item: mapData, itemAsString: (item) => "${mapData['todo_date'].toString().toDateTime(inputFormat: "yyyy-MM-dd").toFormat(format: "MM-dd-yyyy")} ${mapData['todo_time'].toString().toDateTime(inputFormat: "HH:mm:ss").toFormat(format: "hh:mm a")}",leadingIcon: Icons.calendar_month_rounded),
            ListWidget(item: mapData, itemAsString: (item) => ((mapData?['users']).map((e) => "${e['first_name'] ?? ""} ${e['last_name'] ?? ""}").join(", ")),leadingIcon: Icons.person_outline_rounded),
            if (mapData['vehicle_name'] != null) ListWidget(item: "${mapData['vehicle_name'] ?? ""}", leadingIcon: Icons.directions_car),
            if ((mapData['vendor_name'] != null) || (mapData['location'] != null)) ListWidget(item: "${mapData['vendor_name'] ?? mapData['location'] ?? ""}", leadingIcon: Icons.person_pin_circle_outlined),
            if (mapData['notes'] != null) ListWidget(item: "${mapData['notes'] ?? ""}", leadingIcon: Icons.note_outlined),
            if (mapData['reason'] != null) ListWidget(item: "${mapData['reason'] ?? ""}", leadingIcon: Icons.notes_rounded),
            if (mapData['resolution_notes'] != null) ListWidget(item: "Resolution Notes - ${mapData['resolution_notes'] ?? ""}", leadingIcon: Icons.sticky_note_2_outlined),
            if ((mapData['parts'] as List?)?.isNotEmpty ?? false) ChoiceBoxWidget<dynamic>(items: (mapData['parts'] as List<dynamic>).distinct((e) => e?['parts_id']), itemAsString: (item) => item['parts_name'] ?? ""),
            if ((mapData['supplies'] as List?)?.isNotEmpty ?? false) ChoiceBoxWidget<dynamic>(items: (mapData['supplies'] as List<dynamic>).distinct((e) => e?['supplies_id']), itemAsString: (item) => item['supplies_name'] ?? ""),
            ListWidget(item: (mapData['mileage'] != null) ? "Odometer - ${mapData['mileage']}" : "No Odometer", leadingIcon: Icons.location_on_outlined),
            if (mapData['expense_id'] != null)
              ...[
                Text("Expense", style: context.textTheme.labelLarge?.copyWith(color: AppC.appColor),),
                ListWidget(item: "${mapData['expense_amount'] ?? "0"}", leadingIcon: Icons.monetization_on_outlined),
                ListWidget(item: "${mapData['expense_description'] ?? ""}", leadingIcon: Icons.layers_outlined),
                ListWidget(item: "${mapData['category_name'] ?? ""}", leadingIcon: Icons.layers_outlined),
                ListWidget(item: "${mapData['subcategory_name'] ?? ""}", leadingIcon: Icons.layers_outlined),
                ListWidget(item: "Attachment", leadingIcon: Icons.attach_file_rounded),
              ],
            if (mapData['reservation_no'] != null) ListWidget(item: "Reservation No - ${mapData['reservation_no'] ?? ""}"),
          ],
        ),
      ),
    );
  }
}
