
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TableViewDetails extends TableRow{

  final String? label;
  final String? value;

  const TableViewDetails({required this.label, this.value});

  @override
  List<Widget> get children => [
    TableCell(child: Padding(padding: 10.spMin.padding, child: Utils.getText('$label', size: 12.spMin, weight: FontWeight.bold))),
    TableCell(child: Padding(padding: 10.spMin.padding, child: Utils.getText('$value',size: 12.spMin, weight: FontWeight.w400))),
     ];
}