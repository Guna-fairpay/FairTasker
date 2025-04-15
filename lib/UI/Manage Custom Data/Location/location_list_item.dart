


import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Utilities/Utils.dart';
import '../../../Utilities/appC.dart';

class LocationListItem extends TableRow {
  final Map<String, dynamic>? model;
  final VoidCallback? onEdit, onDelete;
  const LocationListItem({required this.model, this.onEdit, this.onDelete});

  @override
  List<Widget> get children => [
    // First cell: Icon
    TableCell(
      child: IconButton(onPressed: onEdit, icon: Icon(Icons.add), color: AppC.blue100),
    ),

    // Second cell: Category name
    TableRowInkWell(
      onTap: onEdit,
      child: Padding(
        padding: 12.sp.padding,
        child: Utils.getText("${model?['name'] ?? ""}"),
      ),
    ),

    // Third cell: Edit/Delete buttons
    TableCell(
      child: Row(
        children: [
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
            color: AppC.appColor,
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
            color: AppC.redAccent,
          ),
        ],
      ),
    ),
  ];

}