import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';

class ExpenseVehicleListItem extends StatelessWidget {
  final Map<String, dynamic> expense;
  const ExpenseVehicleListItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    Color color = expense['approved'] == 1
        ? AppC.black
        : AppC.redAccent;
    final cohort = expense['expense_to_data']['expense_to'] ==
        'Cohort'
        ? '${expense['cohort']?['cohort'] ?? ''}'
        : "${expense['expense_to_data']['expense_to'] ?? ''}";

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

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 5,
              child: Row(
                spacing: 10,
                children: [
                  Utils.getText(
                    expense['expense_date']?.substring(5) ??
                        '',
                    color: color,
                  ),
                  Expanded(
                    child: Utils.getText(
                        expense['vehicle']?['vehicle_name'] ??
                            '',
                        overFlow: TextOverflow.ellipsis,
                        color: color,
                        weight: FontWeight.bold
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
                    onTap: () {},
                    child: const Icon(
                      Icons.remove_red_eye,
                      color: AppC.appColor,
                    )),
              ),
            ),
            10.width,
            Expanded(
              child: Utils.getText(
                "${expense['employee_name'] ?? ''}",
                color: color,
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
                    color: color,
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
            Expanded(flex: 5,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Utils.getText(cohort,
                      overFlow: TextOverflow.ellipsis,
                      color: getCategoryColor(cohort),
                    ),
                  ),
                  Utils.getText(" | ",weight: FontWeight.w900),
                  Expanded(
                    flex: 3,
                    child: Utils.getText(
                      '${expense['category']?['name'] ?? ''} ',
                      overFlow: TextOverflow.ellipsis,
                    ),
                  ),
                  Utils.getText(" | ",weight: FontWeight.w900),
                  Expanded(
                    flex: 3,
                    child: Utils.getText(
                      '${expense['subcategory']?['name'] ?? ''}',
                      overFlow: TextOverflow.ellipsis,
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
                onChanged: (bool? value) {},
              ),
            ),
            Expanded(
              flex:2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Utils.getText(
                    "\$${double.tryParse(expense['expense_amount'].toStringAsFixed(2) ?? '0.0') ?? 0.0}",
                    weight: FontWeight.bold,
                    overFlow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
