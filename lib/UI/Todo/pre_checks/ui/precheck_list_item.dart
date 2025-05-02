import 'package:fairpytasker/Component/compact_text_field.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreCheckListItem extends StatelessWidget {
  final VoidCallback? onCreateTask;
  final Map<String, dynamic>? model;
  final ValueChanged<bool?>? onChanged;
  const PreCheckListItem({super.key, this.model, this.onCreateTask, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          key: UniqueKey(),
          side: const BorderSide(width: Num.borderWidthThinField),
          activeColor: AppC.grey,
          controlAffinity: ListTileControlAffinity.leading,
          value: (model?['checked'] ?? false), onChanged: onChanged,
          title: Text("${model?['title'] ?? ""}"),
          subtitle: (model?['description'].toString().isNotNullOrEmpty ?? false) ? Text("${model?['description'] ?? ""}") : null,
        ),
        if ((model?['checked'] == false) || ((model?['fix_task'] != null)))
          Padding(padding: 16.sp.horizontalPadding,
        child: Column(
          spacing: 10.sp,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CompactTextField(
              minLines: 3,
              maxLines: 7,
              hintText: "Notes",
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              controller: model?['notes'] ?? TextEditingController(),
            ),
            SuccessButton(
              text: "${(model?['fix_task'] != null)  ? "Update" : "Crate"} Task",
              onPressed: onCreateTask,
            )
          ],
        ))
      ],
    );
  }
}
