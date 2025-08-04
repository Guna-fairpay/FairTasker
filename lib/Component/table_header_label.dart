import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TableHeaderLabel extends StatelessWidget {
  final String label;
  final TextAlign? textAlign;
  final EdgeInsets? padding;
  const TableHeaderLabel({super.key, required this.label, this.textAlign, this.padding});

  @override
  Widget build(BuildContext context) {
    return TableCell(child: Padding(padding: padding ?? 5.spMin.padding, child: Text(label, style: context.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold), textAlign: textAlign)));
  }
}
