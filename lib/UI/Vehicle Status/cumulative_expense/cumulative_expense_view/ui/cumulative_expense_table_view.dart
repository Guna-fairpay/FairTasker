import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CumulativeExpenseTableView extends TableRow {
  final Map<String, dynamic>? model;
  final VoidCallback? onDelete;
  final BuildContext context;

  const CumulativeExpenseTableView(this.context,
      {required this.model, this.onDelete});

  @override
  List<Widget> get children => [
        TableRowInkWell(
            child: Padding(
                padding: 10.sp.padding,
                child: Utils.getText(
                    DateTime.tryParse(model?['expense_date'] ?? '')
                        .toFormat(format: "MM-dd-yyy")
                        .toString(),size:12.sp))),
        TableRowInkWell(
          child: Padding(
            padding: 10.sp.padding,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: model?['category']?['name'].toString(),
                ),
                TextSpan(
                    text: "\n",
                    children: [
                      TextSpan(text: model?['subcategory']?['name'].toString()),
                      TextSpan(
                          text:
                              "\t(${model?['expense_description'].toString()})",
                          style: context.textTheme.labelSmall
                              ?.copyWith(color: AppC.blue))
                    ],
                    style: context.textTheme.labelMedium),
              ], style: context.textTheme.labelLarge),
            ),
          ),
        ),
        TableRowInkWell(
            child: Padding(
                padding: 10.sp.padding,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Utils.getText(size:12.sp,
                      "\$${model?['expense_amount'].toString() ?? ""}"),
                ))),
        TableCell(
          child: IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete_outline,
                size: 20,
              ),
              color: AppC.redAccent),
        ),
      ];
}
