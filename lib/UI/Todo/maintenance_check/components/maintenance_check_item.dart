import 'package:fairpytasker/Component/compact_drop_down.dart';
import 'package:fairpytasker/Component/compact_text_field.dart';
import 'package:fairpytasker/Component/custom_dropdown.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Component/custom_checkbox.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MaintenanceCheckItem extends StatelessWidget {
  final VoidCallback? onCreateTask;
  final ValueChanged<bool>? onCheckChanged;
  final ValueChanged<Map<String, dynamic>?>? onDropDownChanged;
  final Map<String, dynamic>? model;
  const MaintenanceCheckItem({super.key, this.onCreateTask, this.onCheckChanged, this.onDropDownChanged, this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5.sp,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomCheckboxListTile(
          title: Text("${model?['name'] ?? ""}", style: context.textTheme.labelLarge?.copyWith(fontSize: 12.sp)),
          spacing: 5.sp,
          padding: EdgeInsets.zero,
          value: (model?['checked'] ?? false),
          activeColor: Colors.grey,
          onChanged: (value) => onCheckChanged?.call(value ?? false),
          mainAxisSize: MainAxisSize.min,
          useExpand: false,
          suffix: Expanded(
            child: Row(
              spacing: 5.sp,
              children: [
                if (List.from(model?['children'] ?? []).isNotEmpty)
                Expanded(
                    child: CompactDropDown<Map<String, dynamic>>(
                        items: List.from(model?['children'] ?? [])..sort((a, b) => a['order'].compareTo(b['order'])),
                        itemAsString: (item) => item['name'].toString(),
                        initialSelection: model?['selectedValue'],
                        onChanged: onDropDownChanged,
                        // contentPadding: 1.sp.padding.copyWith(left: 5.sp, right: 5.sp),
                        hintText: "Not Checked",
                        // labelText: null,
                        // isExpanded: true
                    )),
                if (((model?['selectedValue'] != null) && (model?['selectedValue']?['name'].toString().toLowerCase() != "good")) || ( (List.from(model?['children'] ?? []).isEmpty) && (model?['checked'] == false)))
                Expanded(
                    child: CompactTextField(
                      controller: (model?['comments'] ?? TextEditingController()),
                  hintText: "Comments",
                  minLines: 3,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                ))
              ],
            ),
          ),
        ),
        if (((model?['selectedValue'] != null) && (model?['selectedValue']?['name'].toString().toLowerCase() != "good")) || ( (List.from(model?['children'] ?? []).isEmpty) && (model?['checked'] == false)))
        SuccessButton(text: "${(((model?['fix_task_id'] ?? 0) > 0) && (model?['fix_task'] != null)) ? "Update" :  "Create"} Task", onPressed: onCreateTask)
      ],
    );
  }
}
