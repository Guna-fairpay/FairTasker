import 'package:collection/collection.dart';
import 'package:fairpytasker/Component/table_header_label.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TableHeaderRow extends TableRow {

  final List<String> labels;
  final TextAlign? textAlign;
  final TextAlign? firstTextAlign;
  final Color? backgroundColor;
  final Decoration? tableDecoration;
  const TableHeaderRow({super.key, required this.labels, this.tableDecoration, this.backgroundColor = AppC.lightGray, this.textAlign, this.firstTextAlign});

  @override
  List<Widget> get children => labels.mapIndexed((i,e) => TableHeaderLabel(label: e, textAlign: (i == 0) ? (firstTextAlign ?? textAlign) : (textAlign))).toList();

  @override
  Decoration? get decoration => tableDecoration ?? BoxDecoration(
    borderRadius: BorderRadius.circular(5.sp),
    color: backgroundColor
  );
}