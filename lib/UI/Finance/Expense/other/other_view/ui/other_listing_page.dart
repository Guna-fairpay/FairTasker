import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtherListingPage extends StatelessWidget {
  final Map<String, dynamic> model;
  final void Function(String? value) onDelete;
  final void Function(bool? value)? onChanged;
  final void Function(dynamic)onEdit;
  final void Function(dynamic)categoryDialog;
  final void Function(dynamic)onDetailsPage;

  const OtherListingPage(
      {super.key,
      required this.model,
      required this.onDelete,
      required this.onChanged,
      required this.onEdit,
      required this.categoryDialog,
        required this.onDetailsPage,
      });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: AppC.redAccent,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.delete_outline, color: AppC.white),
              Utils.getText('Delete', color: AppC.white),
            ],
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        AskPermissionDialog.show(context,
            title: "Are you sure?",
            description: "Do you want to delete this Expense?",
            positiveText: "Yes, delete it!",
            negativeText: "Cancel",
            isReasonRequired: false,
            onPositivePressed: () => onDelete(model['id'].toString()));
        return false;
      },
      child: SafeArea(
        minimum: 5.spMin.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => onEdit(model),
                    child: Row(
                      spacing: 10,
                      children: [
                        Flexible(
                          child: Utils.getText(
                            model['expense_date'].toString().toDateTime().toFormat(format: 'MM-dd') ?? '',
                            color: model['approved'] == 1 ? AppC.text : AppC.red,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Utils.getText(
                              '${model['subcategory']?['name'] ?? ''}',
                              color: model['approved'] == 1 ? AppC.text : AppC.red,
                              overFlow: TextOverflow.ellipsis,
                              weight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => categoryDialog(model),
                    child: Row(
                      children: [
                        Utils.getText(
                          '${model['category']?['name'] ?? ''} ',
                          color: model['approved'] == 1 ? AppC.grey : AppC.red,
                          overFlow: TextOverflow.ellipsis,
                        ),
                        Utils.getText(
                          " | ",
                          weight: FontWeight.w900,
                          color: model['approved'] == 1 ? AppC.grey : AppC.red,
                        ),
                        Expanded(
                          child: Utils.getText(
                            '${model['subcategory']?['name'] ?? ''}',
                            color: model['approved'] == 1 ? AppC.grey : AppC.red,
                            overFlow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            (model['attachments'].isNotEmpty)
                ? InkWell(
                    onTap: () => ShowAttachmentsDialog.of.show(context,
                        attachments: List.from(model['attachments_paths'] ?? []),
                        title: '${model['subcategory']?['name'] ?? ''}'),
                    child: const Icon(
                      size: 20,
                      Icons.remove_red_eye,
                      color: AppC.appColor,
                    ))
                : const Icon(
                    Icons.remove_red_eye,
                    color: AppC.trans,
                  ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: Checkbox(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: const BorderSide(width: 0.8, color: AppC.appColor),
                    activeColor: AppC.appColor,
                    value: (model['approved'] == 1),
                    onChanged: onChanged,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 2,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Utils.getText(
                    "\$${model['expense_amount'].toString().toDoubleDigit}",
                    weight: FontWeight.bold,
                    overFlow: TextOverflow.ellipsis,
                    color: model['approved'] == 1 ? AppC.text : AppC.red,
                  ),
                  InkWell(
                    onTap: () => onDetailsPage(model['id']),
                    child: Utils.getText(
                      "\$${model['approved_amount'].toString().toDoubleDigit}",
                      weight: FontWeight.bold,
                      overFlow: TextOverflow.ellipsis,
                      color: AppC.grey
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
