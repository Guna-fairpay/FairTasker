import 'package:fairpytasker/core/app/extension/int_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';

class EmployeeWorkingRow extends TableRow {
  final TextAlign? textAlign;
  final Map<String, dynamic>? model;
  final VoidCallback? onHours, onTask, onHash;
  const EmployeeWorkingRow({super.key, this.model, this.textAlign, this.onHours, this.onTask, this.onHash});

  @override
  List<Widget> get children => [
    TableCell(verticalAlignment: TableCellVerticalAlignment.middle,child: Padding(padding: 5.padding, child: Text(model?['name'].toString().split(" ").firstOrNull ?? "", textAlign: TextAlign.start))),
    TableCell(verticalAlignment: TableCellVerticalAlignment.middle,child: Text("${model?['active']}", textAlign: textAlign)),
    TableRowInkWell(onTap: onHours, child: Text("${model?['total_working_hours'].toString().parseDurationToMinutes.minutesToHourMinute}", textAlign: textAlign)),
    TableRowInkWell(onTap: onTask, child: Text("${model?['totalCount'] ?? "0"}", textAlign: textAlign)),
    TableRowInkWell(onTap: onHash, child: Text("${model?['task_count'] ?? "0"}", textAlign: textAlign)),
  ];
}