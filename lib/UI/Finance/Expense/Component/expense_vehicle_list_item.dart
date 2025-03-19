import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import '../../../Vehicle/vehicle_expense_history/ui/vehicle_expense_history_ui.dart';
import '../../../dialog/ask_permission_dialog.dart';
import '../../../dialog/show_attachments_dialog.dart';
import '../UI/Vehicle/vehicle_expense_edit_ui.dart';

class ExpenseVehicleListItem extends StatelessWidget {
  final Map<String, dynamic> expense;
  final void Function(bool? value)? onChanged;
  final void Function(String? value) onDelete;
  final VoidCallback? onCategoryTapEvent;
  final VoidCallback? onCohortTapEvent;

  const ExpenseVehicleListItem({
    super.key,
    required this.expense,
    required this.onChanged,
    required this.onDelete,
    this.onCategoryTapEvent,
    this.onCohortTapEvent,
  });

  @override
  Widget build(BuildContext context) {
    Color approveColor = expense['approved'] == 1 ? AppC.black : AppC.redAccent;
    final cohort = expense['expense_to'] == 1
        ? "${expense['expense_to_data']['expense_to'] ?? ''}"
        : expense['expense_to'] == 4
            ? '${expense['cohort']?['cohort'] ?? ''}'
            : "";

    Color getCategoryColor(String category) {
      switch (category) {
        case 'Fair Returns LP LLC':
          return Colors.blue;
        case 'Fair Returns Prime LP':
          return Colors.green;
        case 'FairFund 2024':
          return Colors.purple;
        case 'Fair Returns Fall 2023':
          return Colors.black;
        case 'Personal Car':
          return Colors.brown;
        case 'Unassigned':
          return Colors.orange;
        default:
          return const Color.fromRGBO(9, 131, 74, 1);
      }
    }

    Color categoryColor = (expense['payment_method_id']).toString() == '4'
        ? const Color(0xFF13b3b3)
        : AppC.grey;

    List<dynamic> images = expense['attachments'];

    List<dynamic> expenseImages =
        images.map((e) => e['path'].toString().toStorageURL).toList();

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
                                builder: (context) =>
                                     ExpenseVehicleEditUI(expenseId: "${expense['id']}",
                                     vehicleName: expense['vehicle']?['vehicle_name'],),
                              )),
                          child: Utils.getText(
                              expense['vehicle']?['vehicle_name'] ?? '',
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
                    "${expense['employee_name'] ?? ''}",
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
              children: [
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: onCohortTapEvent,
                          child: Utils.getText(
                            cohort,
                            overFlow: TextOverflow.ellipsis,
                            color: (expense['expense_to']).toString() == '4'
                                ? getCategoryColor(cohort)
                                : AppC.appColor,
                          ),
                        ),
                      ),
                      Utils.getText(" | ", weight: FontWeight.w900),
                      Expanded(
                        flex: 3,
                        child: InkWell(
                          onTap: onCategoryTapEvent,
                          child: Utils.getText(
                            '${expense['category']?['name'] ?? ''} ',
                            overFlow: TextOverflow.ellipsis,
                            color: categoryColor,
                          ),
                        ),
                      ),
                      Utils.getText(" | ", weight: FontWeight.w900),
                      Expanded(
                        flex: 3,
                        child: InkWell(
                          onTap: onCategoryTapEvent,
                          child: Utils.getText(
                            '${expense['subcategory']?['name'] ?? ''}',
                            overFlow: TextOverflow.ellipsis,
                            color: categoryColor,
                          ),
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
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VehicleExpenseHistoryUI(
                                        vin: expense['vehicle']['vin'] ?? '',
                                        vehicleName: expense['vehicle']
                                                ['vehicle_name'] ??
                                            '',
                                        currentExpenseAmount: double.tryParse(
                                            expense['expense_amount']
                                                .toString()),
                                        showTotalAmount: true,
                                      )));
                        },
                        child: Utils.getText(
                          "\$${double.tryParse(expense['expense_amount'].toStringAsFixed(2) ?? '0.0') ?? 0.0}",
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
