import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:flutter/material.dart';

class ColumnTile extends StatelessWidget {
  final String? label;
  final String? title;
  const ColumnTile({super.key, this.label, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 2.0,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CompactText(label ?? "", styleType: TextStyleType.labelLarge, fontWeight: FontWeight.bold),
        CompactText(title ?? "", styleType: TextStyleType.labelLarge),
      ],
    );
  }
}
