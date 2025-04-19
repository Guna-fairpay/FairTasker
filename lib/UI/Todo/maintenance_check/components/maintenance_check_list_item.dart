import 'package:fairpytasker/UI/Todo/maintenance_check/components/maintenance_check_item.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MaintenanceCheckListItem extends StatelessWidget {
  final Map<String, dynamic>? model;
  final ValueChanged<Map<String, dynamic>?>? onCreateTask; // NEED TO CHANGE WITH FUNCTION AND PASS CHILD
  final void Function(Map<String, dynamic>? child,bool value)? onCheckChanged;
  final void Function(Map<String, dynamic>? child,Map<String, dynamic>? value)? onDropDownChanged;
  const MaintenanceCheckListItem({super.key, this.model, this.onCreateTask, this.onCheckChanged, this.onDropDownChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.sp,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox.shrink(),
        Text("${model?['name'] ?? ""}", style: context.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
        ...List.from(model?['children'] ?? []).map((e) => MaintenanceCheckItem(model: e, onCreateTask: () => onCreateTask?.call(e), onCheckChanged: (value) => onCheckChanged?.call(e, value), onDropDownChanged: (value) => onDropDownChanged?.call(e, value)))
      ],
    );
  }
}
