
import 'package:fairpytasker/UI/Finance/Expense/vehicles/vehicle_add_edit/ui/vehicle_add_edit_main_ui.dart';
import 'package:fairpytasker/UI/Vehicle/vehicle_expense_history/ui/vehicle_expense_history_ui.dart';
import 'package:fairpytasker/UI/dialog/ask_permission_dialog.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/datetime_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ExpenseVehicleListItem extends StatelessWidget {
  final Map<String, dynamic> expense;
  final void Function(bool? value)? onChanged;
  final void Function(String? value) onDelete;
  final VoidCallback? onCategoryTapEvent;
  final VoidCallback? onCohortTapEvent;
  final VoidCallback? onResetEvent;

  const ExpenseVehicleListItem({
    super.key,
    required this.expense,
    required this.onChanged,
    required this.onDelete,
    this.onCategoryTapEvent,
    this.onCohortTapEvent,
    this.onResetEvent,
  });

  @override
  Widget build(BuildContext context) {
    Color approveColor = expense['approved'] == 1 ? AppC.black : AppC.redAccent;
    final cohort = expense['expense_to'] == 1
        ? "${expense['expense_to_data']?['expense_to'] ?? ''}"
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

    List<dynamic> images = List.from(expense['attachments'] ?? []);

    List<dynamic> expenseImages =
        images.map((e) => e['path'].toString().toStorageURL).toList();

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        decoration: BoxDecoration(
          color: AppC.redAccent,
          borderRadius: BorderRadius.circular(6)
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
            onPositivePressed: () => onDelete(expense['id'].toString()));
        return false;
      },
      child: SafeArea(
        minimum: 5.padding,
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
                  Row(children: [
                    Expanded(
                      flex: 5,
                      child: Row(
                        spacing: 10,
                        children: [
                          Utils.getText(
                            expense['expense_date'].toString().toDateTime()?.toFormat(format: 'MM-dd') ?? '',
                            color: approveColor,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap:()=> context.push(VehicleAddEditMainUI(editModel: expense)),
                              // onTap:()=> context.push(ExpenseVehicleEditUI(expenseId: "${expense['id']}", vehicleName: expense['vehicle']?['vehicle_name'],),),
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
                  ]),
                  Row(children: [
                    if (cohort.isNotNullOrEmpty)
                      Expanded(
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
                      child: InkWell(
                        onTap: onCategoryTapEvent,
                        child: Utils.getText(
                          '${expense['subcategory']?['name'] ?? ''}',
                          overFlow: TextOverflow.ellipsis,
                          color: categoryColor,
                        ),
                      ),
                    ),
                  ],)
                ],
              ),
            ),
            ((expense['attachments'] ?? []).isNotEmpty)
                ? InkWell(
                onTap: () => ShowAttachmentsDialog.of.show(context,
                    attachments: expenseImages, title: 'Expense Image'),
                child: const Icon(
                  size: 20,
                  Icons.remove_red_eye,
                  color: AppC.appColor,
                ))
                : const Icon(
              Icons.remove_red_eye,
              color: AppC.trans,
            ),
            Expanded(
              child: Column(
                spacing: 10,
                children: [
                Utils.getText(
                  "${expense['employee_name'] ?? ''}",
                  color: approveColor,
                  weight: FontWeight.bold,
                ),
                  FittedBox(
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(14.spMin),
                    child: Checkbox(
                      activeColor: AppC.appColor,
                      value: (expense['approved'] == 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      side: const BorderSide(width: 0.8, color: AppC.appColor),
                      onChanged:
                      onChanged,
                    ),
                  ),
                ),
              ],),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 10,
                children: [
                  Utils.getText(
                    "\$${expense['expense_amount'].toString().toDoubleDigit}",
                    color: approveColor,
                    weight: FontWeight.bold,
                    overFlow: TextOverflow.ellipsis,
                  ),
                  InkWell(
                    onTap: () => context.push(VehicleExpenseHistoryUI(
                      vin: expense['vehicle']['vin'] ?? '',
                      vehicleName: expense['vehicle']['vehicle_name'] ?? '',
                      currentExpenseAmount: expense['approved']==0? double.tryParse(expense['expense_amount'].toString()):0.0,
                      showTotalAmount: true,
                    )),
                    child: Utils.getText(
                      "\$${expense['approveAmount'].toString().toDoubleDigit}",
                      weight: FontWeight.bold,
                      color: AppC.grey,
                      overFlow: TextOverflow.ellipsis,
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
