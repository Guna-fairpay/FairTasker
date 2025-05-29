import 'package:fairpytasker/core/app/extension/liststring_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:flutter/material.dart';

class OilChangeTaskExistDialog {
  OilChangeTaskExistDialog._();

  static Future<bool?> show(BuildContext context, {Map<String, dynamic>? model, bool isAddNew = true}) async {
    return await showDialog<bool>(context: context, builder: (context) => _OilChangeDialogView(model: model, isAddNew: isAddNew), barrierDismissible: false);
  }
}

class _OilChangeDialogView extends StatelessWidget {
  final Map<String, dynamic>? model;
  final bool isAddNew;
  const _OilChangeDialogView({this.model, this.isAddNew = true});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: 16.spMin.padding,
      contentPadding: 16.spMin.horizontalPadding.copyWith(bottom: 16.sp),
      titlePadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
      title: ListTile(
        title: const SizedBox.shrink(),
        trailing: GestureDetector(
          onTap: () => Navigator.of(context).pop(false),
          child: const Icon(Icons.close_rounded),
        ),
      ),
      alignment: Alignment.topCenter,
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          spacing: 10.spMin,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text.rich(TextSpan(
              children: [
                TextSpan(text: "${model?['title'] ?? ""}"),
                const TextSpan(text: " present at "),
                TextSpan(text: "${model?['todo_date'].toString().toDateTime().toFormat(format: "MM-dd-yyyy")}"),
                TextSpan(text: " ${model?['todo_time'] ?? ""}"),
                const TextSpan(text: " and assigned to "),
                TextSpan(text: <String>[(model?['users']?['first_name'] ?? ""), (model?['users']?['last_name'] ?? "")].toInitial),
              ]
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SuccessButton(
                  text: "Keep Task",
                  backgroundColor: AppC.lightBlues,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                SuccessButton(
                  text: "Delete & ${(isAddNew) ? "Create New" : "Update"}",
                  backgroundColor: AppC.green,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
