import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleGroupItem extends TableRow {
  final int index;
  final Map<String, dynamic>? model;
  final VoidCallback? onEdit, onDelete;
  const VehicleGroupItem({required this.index, this.model, this.onEdit, this.onDelete});

  @override
  List<Widget> get children => [
    TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(padding: EdgeInsets.symmetric(vertical: 5.spMin, horizontal: 10.spMin), child: Text("${index ?? 0}", textAlign: TextAlign.center))),
    TableRowInkWell(
        onTap: onEdit,
        child: Padding(padding: EdgeInsets.symmetric(vertical: 5.spMin, horizontal: 10.spMin), child: Text("${model?['name'] ?? ""}", textAlign: TextAlign.center))),
    TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.spMin, horizontal: 10.spMin),
          child: Row(
            spacing: 5,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: onEdit,
                borderRadius: BorderRadius.circular(Num.borderRadiusLarge),
                child: const Icon(Icons.edit_outlined, color: AppC.appColor),
              ),
              InkWell(
                onTap: onDelete,
                borderRadius: BorderRadius.circular(Num.borderRadiusLarge),
                child: const Icon(Icons.delete_outline_rounded, color: AppC.redAccent),
              ),
            ],
          ),
        )),
  ];

}