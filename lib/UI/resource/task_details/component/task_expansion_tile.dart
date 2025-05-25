import 'package:fairpytasker/Component/compact_expansion_tile.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskExpansionTile extends StatelessWidget {
  final Map<String, dynamic>? model;
  final TextStyleType? styleType;
  const TaskExpansionTile({super.key, this.model, this.styleType = TextStyleType.titleMedium});

  @override
  Widget build(BuildContext context) {
    return CompactExpansionTile(
      title: CompactText(model?['name'] ?? "", color: AppC.appColor, fontWeight: FontWeight.bold, styleType: styleType ?? TextStyleType.bodyMedium),
      child: ListView.separated(
        shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
        var list = List.from(model?['tasks'] ?? []);
        var mod = list[index];
        return CompactExpansionTile(
          title: CompactText(mod['title'] ?? "", color: AppC.appColor, fontWeight: FontWeight.bold, styleType: styleType ?? TextStyleType.bodyMedium),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            minTileHeight: 0,
            title: CompactText(mod['vehicle_name'] ?? ( (List.from(mod['vehicles'] ?? []).length == 1) ? (List.from(mod['vehicles'] ?? []).firstOrNull?['vehicle_name'] ?? "") : "MV") , color: AppC.black, styleType: TextStyleType.bodyMedium),
          ),
        );
      }, separatorBuilder: (context, index) => 5.sp.height, itemCount: List.from(model?['tasks'] ?? []).length),
    );
  }
}
