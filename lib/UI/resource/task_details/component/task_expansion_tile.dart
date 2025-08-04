import 'package:fairpytasker/Component/compact_expansion_tile.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskExpansionTile extends StatelessWidget {
  final Map<String, dynamic>? model;
  final TextStyleType? styleType;
  final void Function(Map<String, dynamic>? value)? onTap;
  const TaskExpansionTile({super.key, this.model, this.styleType = TextStyleType.titleMedium, this.onTap});

  @override
  Widget build(BuildContext context) {
    var list = List.from(model?['tasks'] ?? []);
    Map<String, dynamic> listTasks = {};
    list.forEach((element) => listTasks[element['title'] ?? ""] = (list.where((e) => e['title'] == element['title']).toList()));
    return CompactExpansionTile(
      title: Row(
        children: [
          Expanded(child: CompactText(model?['name'] ?? "", color: AppC.appColor, fontWeight: FontWeight.bold, styleType: styleType ?? TextStyleType.bodyMedium)),
          CompactText("${list.length ?? 0}", color: AppC.appColor, fontWeight: FontWeight.bold, styleType: styleType ?? TextStyleType.bodyMedium)
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
        var keyVal = listTasks.keys.elementAt(index);
        var subList = List.from(listTasks[keyVal] ?? []);
        return CompactExpansionTile(
          title: Row(
            children: [
              Expanded(child: CompactText(keyVal ?? "", color: AppC.appColor, fontWeight: FontWeight.bold, styleType: styleType ?? TextStyleType.bodyMedium)),
              CompactText("${subList.length ?? 0}", color: AppC.appColor, fontWeight: FontWeight.bold, styleType: styleType ?? TextStyleType.bodyMedium)
            ],
          ),
          child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
            var mod = subList[index];
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              minTileHeight: 0,
              onTap: () => onTap?.call(mod),
              title: CompactText(mod['vehicle_name'] ?? ( (List.from(mod['vehicles'] ?? []).length == 1) ? (List.from(mod['vehicles'] ?? []).firstOrNull?['vehicle_name'] ?? "") : (List.from(mod['vehicles'] ?? []).isNotEmpty) ? "MV" : "") , color: AppC.black, styleType: TextStyleType.labelLarge),
              trailing: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CompactText((mod['todo_date'] ?? "").toString().toDateTime().toFormat(format: "MM-dd-yy") ?? "", styleType: TextStyleType.labelLarge),
                  if (mod['complete_time_taken'].toString().isNotNullOrEmpty)
                    CompactText(mod['complete_time_taken'] ?? "", color: AppC.redAccent, fontWeight: FontWeight.normal, styleType: TextStyleType.bodyMedium),
                ],
              ),
            );
          }, separatorBuilder: (context, index) => Divider(), itemCount: subList.length),
        );
      }, separatorBuilder: (context, index) => 5.sp.height, itemCount: listTasks.length),
    );
  }
}
