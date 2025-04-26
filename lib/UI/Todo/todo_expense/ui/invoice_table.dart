
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvoiceTable extends TableRow {
  final Map<String, dynamic>? model;
  final int index;
  const InvoiceTable({required this.model,required this.index});

  @override
  List<Widget> get children => [
    TableRowInkWell(child: Padding(padding: 5.sp.padding, child: Utils.getText("${index+1}",size: 12.sp))),
    TableRowInkWell(child: Padding(padding: 5.sp.padding, child: Utils.getText("${model?['name'] ?? ""}",size: 12.sp))),
    TableRowInkWell(child: Padding(padding: 5.sp.padding, child: Utils.getText("1",size: 12.sp,align: TextAlign.center))),
    TableRowInkWell(child: Padding(padding: 5.sp.padding, child: Utils.getText("\$${model?['rate']?.toString().toDoubleDigit ?? '0.00'}",size: 12.sp))),
    TableRowInkWell(child: Padding(padding: 5.sp.padding, child: Utils.getText("\$${model?['rate']?.toString().toDoubleDigit ?? '0.00'}",size: 12.sp))),
  ];
}