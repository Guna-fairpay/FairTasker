import 'package:date_time/date_time.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/core/app/extension/timeday_extension.dart';
import 'package:fairpytasker/core/initializer/common_initializer.dart';
import 'package:flutter/material.dart';

class WorkingHourRow extends TableRow {
  final Map<String, dynamic>? model;
  final TextAlign? textAlign;
  const WorkingHourRow({super.key, this.model, this.textAlign});

  @override
  List<Widget> get children => [
    TableCell(verticalAlignment: TableCellVerticalAlignment.middle,child: Padding(padding: 5.padding, child: Text("${model?['employee']?['name'].toString().getInitials()}", textAlign: textAlign))),
    TableCell(verticalAlignment: TableCellVerticalAlignment.middle,child: Text("${model?['start_time'].toString().toDateTime(inputFormat: "dd-MM-yyyy HH:mm:ss")?.toFormat(format: "hh:mm a")}", textAlign: textAlign)),
    TableCell(verticalAlignment: TableCellVerticalAlignment.middle,child: Text(model?['end_time'].toString().toDateTime(inputFormat: "dd-MM-yyyy HH:mm:ss")?.toFormat(format: "hh:mm a") ?? "", textAlign: textAlign)),
    TableCell(verticalAlignment: TableCellVerticalAlignment.middle,child: Text(model?['active'] ?? "", textAlign: textAlign)),
    TableCell(verticalAlignment: TableCellVerticalAlignment.middle,child: Text(Time.fromMilliseconds((model?['end_time'].toString().toDateTime(inputFormat: "dd-MM-yyyy HH:mm:ss") ?? getIt<CommonService>().usNow).time.inMilliseconds - (model?['start_time'].toString().toDateTime(inputFormat: "dd-MM-yyyy HH:mm:ss") ?? getIt<CommonService>().usNow).time.inMilliseconds ?? 0).toHM(), textAlign: textAlign)),
  ];
}