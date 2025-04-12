import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter/material.dart';

class SubCategoryListItem extends TableRow {
  final Map<String, dynamic>? model;
  final VoidCallback? onEdit, onDelete;
  const SubCategoryListItem({this.model, this.onEdit, this.onDelete});

  @override
  List<Widget> get children => [
    TableRowInkWell(
      onTap: onEdit,
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: Text("${model?['name'] ?? ""}"))),
    TableCell(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: Text("${model?['categoryName'] ?? ""}"))),
    TableCell(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
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
    ))),
  ];
}