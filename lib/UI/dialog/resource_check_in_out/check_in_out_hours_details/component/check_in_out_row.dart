import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/int_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckInOutRow extends TableRow {
  final Map<String, dynamic>? model;
  final VoidCallback? onTask;
  const CheckInOutRow({required this.model, this.onTask});
  
  @override
  List<Widget> get children => [
    TableCell(child: Padding(padding: 5.spMin.padding, child: Text(model?['date'].toString().toDateTime().toFormat(format: "MM-dd-yy") ?? "", textAlign: TextAlign.start))),
    TableCell(child: Padding(padding: 5.spMin.padding, child: Text(model?['start_time'].toString().parseDurationToMinutes.minutesToHourMinute ?? "", textAlign: TextAlign.center))),
    TableCell(child: Padding(padding: 5.spMin.padding, child: Text(model?['end_time'].toString().parseDurationToMinutes.minutesToHourMinute ?? "", textAlign: TextAlign.center))),
    TableCell(child: Padding(padding: 5.spMin.padding, child: Text(model?['total_hours'].toString().parseDurationToMinutes.minutesToHM ?? "", textAlign: TextAlign.center))),
    TableRowInkWell(onTap: onTask,child: Padding(padding: 5.spMin.padding, child: Text("${model?['task_count'] ?? "0"}", textAlign: TextAlign.center)),),
  ];

}