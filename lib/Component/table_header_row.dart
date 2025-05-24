import 'package:fairpytasker/Component/table_header_label.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TableHeaderRow extends TableRow {

  final List<String> labels;
  final Color? backgroundColor;
  final Decoration? tableDecoration;
  const TableHeaderRow({super.key, required this.labels, this.tableDecoration, this.backgroundColor = AppC.lightGray});

  @override
  List<Widget> get children => labels.map((e) => TableHeaderLabel(label: e)).toList();

  @override
  Decoration? get decoration => tableDecoration ?? BoxDecoration(
    borderRadius: BorderRadius.circular(5.sp),
    color: backgroundColor
  );
}