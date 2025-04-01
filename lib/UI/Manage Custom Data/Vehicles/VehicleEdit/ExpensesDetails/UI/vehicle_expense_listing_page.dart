
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/Bloc/expense_details_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/Bloc/expense_details_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/Bloc/expense_details_state.dart';
import 'package:fairpytasker/UI/dialog/show_attachments_dialog.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VehicleExpenseListingPageUI extends StatelessWidget {
  const VehicleExpenseListingPageUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseDetailsBloc, ExpenseDetailsState>(
      builder: (context, state) => SafeArea(
        minimum: 10.padding,
        child: Column(
          children: [
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: Utils.getSearchBarUI(
                    searchController: context.read<ExpenseDetailsBloc>().searchController,
                    onChange: (value) => context
                        .read<ExpenseDetailsBloc>()
                        .add(SearchExpenseEvent(value)),
                  ),
                ),
                Utils.getText(
                    "Total : ${(context.watch<ExpenseDetailsBloc>().expenseAmount ?? 0.0).toStringAsFixed(2)}")
              ],
            ),
            Expanded(
              child:/*(
                      context.watch<ExpenseDetailsBloc>().expenseDetails.isEmpty
                          && (state is ExpenseDetailsLoadedState))
                      ? const EmptyWidget()
                      :*/ ListView.separated(
                itemCount: context.watch<ExpenseDetailsBloc>().filteredExpenseDetails.length,
                separatorBuilder: (context, index) => const Divider(height: 0.5,),
                itemBuilder: (context, index) {
                  var model = context.watch<ExpenseDetailsBloc>().filteredExpenseDetails[index];
                  final cohort = model['expense_to'] == 1
                      ? "${model['expense_to_data']['expense_to'] ?? ''}"
                      : model['expense_to'] == 4
                      ? '${model['cohort']?['cohort'] ?? ''}'
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
                  List<dynamic> images = model['attachments'];
                  Color categoryColor = (model['payment_method_id']).toString() == '4'
                      ? const Color(0xFF13b3b3)
                      : AppC.grey;

                  List<dynamic> expenseImages =
                  images.map((e) => e['path'].toString().toStorageURL).toList();
                  return SafeArea(
                    minimum: 6.padding,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: Row(
                                spacing: 10,
                                children: [
                                  Utils.getText(
                                    DateFormat('MM-dd-yy').format(DateTime.parse(model['expense_date'])),
                                  ),
                                  Expanded(
                                    child: Utils.getText(
                                        "${model['vehicle']['vehicle_name']} ",
                                        overFlow: TextOverflow.ellipsis,
                                        weight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            10.width,
                            Expanded(
                              child: Visibility(
                                visible: model['attachments'].isNotEmpty,
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
                                "${model['employee_name']??''}",
                                weight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Utils.getText(
                                    "\$${double.tryParse(model["expense_amount"].toStringAsFixed(2) ?? '0.0') ?? 0.0}",
                                    weight: FontWeight.bold,
                                    overFlow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        10.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Utils.getText(
                              "${model["cohortName"]??''}",
                              overFlow: TextOverflow.ellipsis,
                              color: (model['expense_to']).toString() == '4'
                                  ? getCategoryColor(cohort)
                                  : AppC.appColor,
                            ),
                            Utils.getText(" | ", weight: FontWeight.w900),
                            Utils.getText(
                              '${model['category']['name']} ',
                              overFlow: TextOverflow.ellipsis,
                              color: categoryColor,
                            ),
                            Utils.getText(" | ", weight: FontWeight.w900),
                            Expanded(
                              child: Utils.getText(
                                '${model['subcategory']['name']}',
                                overFlow: TextOverflow.ellipsis,
                                color: categoryColor,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
