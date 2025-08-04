import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogTableRow extends TableRow {
  final Map<String, dynamic>? model;
  final VoidCallback? onEdit, onAttachment, onDelete;

  const LogTableRow({this.model, this.onEdit, this.onAttachment, this.onDelete})
      : super();

  @override
  List<Widget> get children => [
        TableRowInkWell(
            onTap: onEdit,
            child: Padding(
              padding:
                  10.spMin.horizontalPadding.copyWith(top: 8.spMin, bottom: 8.spMin),
              child: Text("${model?['title'] ?? ""}"),
            )),
        if (List.from(model?['attachments'] ?? []).isNotEmpty)
          TableRowInkWell(
            onTap: onAttachment,
            child: const Icon(Icons.visibility_rounded),
          )
        else
          const TableCell(
            child: SizedBox.shrink(),
          ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Text(
            <String>[
              (model?['users']?['first_name'] ?? ""),
              (model?['users']?['last_name'] ?? "")
            ].toInitial,
            textAlign: TextAlign.center,
          ),
        ),
        TableCell(
            child: Text(
              textAlign: TextAlign.center,
                "${DateTime.tryParse(model?['updated_at'] ?? "").toFormat(format: "MM-dd-yy")}")),
        TableRowInkWell(
          onTap: onDelete,
          child:
              const Icon(Icons.delete_outline_rounded, color: AppC.redAccent),
        ),
      ];
}
