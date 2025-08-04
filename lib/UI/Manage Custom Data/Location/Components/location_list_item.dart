import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class LocationListItem extends TableRow {
  final Map<String, dynamic>? model;
  final VoidCallback? onEdit, onDelete;

  const LocationListItem({required this.model, this.onEdit, this.onDelete});

  @override
  List<Widget> get children => [
        TableRowInkWell(
            onTap: onEdit,
            child: Padding(
              padding: 10.spMin.padding,
              child: CompactText("${model?['name'] ?? ""}"),
            )),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Icon(Iconsax.location_tick, size: 16.spMin, color: (List.from(model?['addresses'] ?? []).isNotEmpty) ? AppC.appColor : AppC.trans),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: 5.spMin.padding,
            child: Row(
              spacing: 10.spMin,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onEdit,
                  child: Icon(Iconsax.edit_2,
                      color: AppC.appColor, size: 18.spMin),
                ),
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(Iconsax.trash,
                      color: AppC.redAccent, size: 18.spMin),
                ),
              ],
            ),
          ),
        ),
      ];
}
