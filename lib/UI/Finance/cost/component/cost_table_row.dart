import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CostTableRow extends TableRow {
  final Map<String, dynamic>? model;
  final BuildContext context;
  final VoidCallback? onTap;
  const CostTableRow(this.context, this.model, {this.onTap});
  
  @override
  List<Widget> get children => [
    TableCell(
      child: Padding(padding: 7.spMin.padding,
        child: CompactText(model?['expense_date'].toString().toFormat(inputFormat: "yyyy-MM-dd", format: "MM-dd-yy") ?? "", color: AppC.lightDark),
      ),
    ),
    TableRowInkWell(
      onTap: onTap,
      child: Padding(padding: 7.spMin.padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CompactText((model?['category']?['name'] ?? ""), styleType: TextStyleType.labelLarge),
            Text.rich(
              TextSpan(
                text: (model?['subcategory']?['name'] ?? ""),
                children: (model?['expense_description'].toString().isNullOrEmpty ?? false) ? [] : [
                  TextSpan(text: " (${model?['expense_description'] ?? ""}) ", style: context.textTheme.labelSmall?.copyWith(color: AppC.bouncieButtonColor))
                ]
              ),
              style: context.textTheme.labelMedium,
            )
          ],
        ),
      ),
    ),
    TableRowInkWell(
      onTap: onTap,
      child: Padding(padding: 7.spMin.padding,
        child: CompactText("\$${(model?['expense_amount'] ?? "")}"),
      ),
    ),
  ];
}