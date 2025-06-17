


import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';

class LocationListItem extends TableRow {
  final Map<String, dynamic>? model;
  final VoidCallback? onEdit, onDelete;
  const LocationListItem({required this.model, this.onEdit, this.onDelete});

  @override
  List<Widget> get children => [
    TableCell(child: InkWell(onTap: onEdit, child: Padding(
      padding: 5.spMin.padding,
      child: Icon(Icons.add,color: AppC.blue100,),
    ))),
    TableRowInkWell(onTap: onEdit, child: Padding(padding: 5.spMin.padding, child: Utils.getText("${model?['name'] ?? ""}"),)),
    TableCell(
      child: Padding(
        padding: 5.spMin.padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: onEdit,
              child: const Icon(Icons.edit_outlined, color: AppC.appColor,),

            ),
            InkWell(
              onTap: onDelete,
              child: const Icon(Icons.delete_outline_rounded, color: AppC.redAccent,),

            ),
          ],
        ),
      ),
    ),
  ];

}