import 'package:fairpytasker/UI/Finance/Expense/UI/Person/person_expense_edit_ui.dart';
import 'package:fairpytasker/UI/Finance/Expense/UI/Person/person_expense_history_ui.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import '../../../dialog/ask_permission_dialog.dart';
import '../../../dialog/show_attachments_dialog.dart';

class ExpensePersonListItem extends StatelessWidget {
  final Map<String, dynamic> expense;
  final void Function(String? value) onDelete;
  final void Function(bool? value)? onChanged;
  final List <dynamic> employeeList;

  const ExpensePersonListItem({
    super.key,
    required this.expense,
    required this.onDelete,
    required this.onChanged,
    required this.employeeList,
  });

  @override
  Widget build(BuildContext context) {
    Color approveColor = expense['approved'] == 1 ? AppC.black : AppC.redAccent;


    Color categoryColor = (expense['payment_method_id']).toString() == '4'
        ? const Color(0xFF13b3b3)
        : AppC.grey;

    List<dynamic> images = expense['attachments'];

    List<dynamic> expenseImages =
        images.map((e) => e['path'].toString().toStorageURL).toList();

    dynamic user = employeeList.firstWhere((element) => element['id'].toString()
        == expense['employee_id'].toString());

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: AppC.redAccent,
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
            onPositivePressed: () => onDelete(expense['id'].toString()));
        return false;
      },
      child: SafeArea(
        minimum: 5.padding,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Row(
                    spacing: 10,
                    children: [
                      Utils.getText(
                        expense['expense_date']?.substring(5) ?? '',
                        color: approveColor,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PersonExpenseEditUI(
                                  id: expense['id'].toString(),
                                ),
                              )),
                          child: Utils.getText(
                              "${user['first_name']??''} "
                                  "${user['last_name']??''}",
                              overFlow: TextOverflow.ellipsis,
                              color: approveColor,
                              weight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                10.width,
                Expanded(
                  child: Visibility(
                    visible: expense['attachments'].isNotEmpty,
                    child: InkWell(
                        onTap: () => ShowAttachmentsDialog.of.show(context,
                            attachments: expenseImages, title: 'Expense Image'),
                        child: const Icon(
                          size: 20,
                          Icons.remove_red_eye,
                          color: AppC.appColor,
                        )),
                  ),
                ),
                10.width,
                Expanded(
                  child: Utils.getText(
                   "${user['first_name'].toString().getInitials()}"
                       "${user['last_name'].toString().getInitials()}",
                    color: approveColor,
                    weight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Utils.getText(
                        "\$${double.tryParse(expense['expense_amount'].toStringAsFixed(2) ?? '0.0') ?? 0.0}",
                        color: approveColor,
                        weight: FontWeight.bold,
                        overFlow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      Expanded(
                        child: Utils.getText(
                          '${expense['category']?['name'] ?? ''} ',
                          overFlow: TextOverflow.ellipsis,
                          color: categoryColor,
                        ),
                      ),
                      Utils.getText(" | ", weight: FontWeight.w900),
                      Expanded(
                        flex: 3,
                        child: Utils.getText(
                          '${expense['subcategory']?['name'] ?? ''}',
                          overFlow: TextOverflow.ellipsis,
                          color: categoryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                28.width,
                Expanded(
                  child: Checkbox(
                    activeColor: AppC.appColor,
                    value: (expense['approved'] == 1),
                    onChanged: onChanged,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PersonExpenseHistoryUI(
                                userId: expense['employee_id'].toString(),
                                userName: "${user['first_name']??''} "
                                    "${user['last_name']??''}",
                              ))),
                        child: Utils.getText(
                          "\$${double.tryParse(expense['approved_amount'].toStringAsFixed(2) ?? '0.0') ?? 0.0}",
                          weight: FontWeight.bold,
                          overFlow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
