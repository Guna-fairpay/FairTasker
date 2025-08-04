import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/int_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskCountDetailsRow extends TableRow {
  final Map<String, dynamic>? model;
  final void Function(dynamic value)? onViewNotes;
  const TaskCountDetailsRow({required this.model, this.onViewNotes});

  @override
  List<Widget> get children => [
    TableCell(child: Padding(padding: 5.spMin.padding, child: Text(model?['date'].toString().toDateTime().toFormat(format: "MM-dd-yy") ?? "", textAlign: TextAlign.start))),
    TableCell(child: Padding(padding: 5.spMin.padding, child: CompactText(model?['total_hours'].toString().parseDurationToMinutes.minutesToHM ?? "", textAlign: TextAlign.center,color: AppC.redAccent))),
    TableRowInkWell(onTap: (model?['reason'].toString().isNullOrEmpty ?? false) ? null : () => onViewNotes?.call(model?['reason'] ?? ""),child: Padding(padding: 5.spMin.padding, child: Text("${model?['reason'] ?? ""}", textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis))),
    TableRowInkWell(onTap: (model?['comments'].toString().isNullOrEmpty ?? false) ? null : () => onViewNotes?.call(model?['comments'] ?? ""),child: Padding(padding: 5.spMin.padding, child: Text("${model?['comments'] ?? ""}", textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis))),
  ];
}