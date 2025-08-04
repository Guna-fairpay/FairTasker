import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryListItem extends TableRow {
  final Map<String, dynamic>? model;
  final VoidCallback? onEdit, onDelete;
  const CategoryListItem({required this.model, this.onEdit, this.onDelete});

  @override
  List<Widget> get children => [
    TableRowInkWell(onTap: onEdit, child: Padding(padding: 10.spMin.padding, child: Utils.getText("${model?['name'] ?? ""}"))),
    TableCell(child: Row(
      children: [
        IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined), color: AppC.appColor),
        IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline_rounded), color: AppC.redAccent),
      ],
    )),
  ];
}