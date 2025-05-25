import 'package:fairpytasker/Component/compact_expansion_tile.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:flutter/material.dart';

class TaskExpansionTile extends StatelessWidget {
  final Map<String, dynamic>? model;
  final TextStyleType? styleType;
  const TaskExpansionTile({super.key, this.model, this.styleType = TextStyleType.titleMedium});

  @override
  Widget build(BuildContext context) {
    return CompactExpansionTile(
      title: CompactText(model?['name'] ?? "", color: AppC.appColor, fontWeight: FontWeight.bold, styleType: styleType ?? TextStyleType.bodyMedium),

    );
  }
}
