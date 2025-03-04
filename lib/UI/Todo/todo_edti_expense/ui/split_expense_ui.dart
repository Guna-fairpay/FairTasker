
import 'package:fairpytasker/UI/Todo/todo_edti_expense/bloc/todo_edit_expense_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';
import '../event/todo_edit_expense_event.dart';
import '../state/todo_edit_expense_state.dart';


class SplitExpenseUI extends StatelessWidget {

  const SplitExpenseUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoEditExpenseBloc, TodoExpenseState>(
      builder: (context, state) {
        return Column(
            children: [
              ...state.partsList.map((e) => Row(
                children: [
                  Expanded(
                      child: Utils.getText(
                          e['name'])),
                  const Icon(Icons.attach_money),
                  Expanded(
                    child: Utils.getTextFormField(
                      '',
                      hintText: 'enter a amount',
                      context.read<TodoEditExpenseBloc>().partsCostControllers[e['id'].toString()] ?? TextEditingController(text: "000"),
                      textType: TextInputType.number,
                    ),
                  ),
                ],
              )).toList(),
              Row(
                children: [
                  Expanded(child: Utils.getText('Labour')),
                  const Icon(Icons.attach_money),
                  Expanded(
                    child: Utils.getTextFormField(
                      '',
                      hintText: 'enter a amount',
                      context.read<TodoEditExpenseBloc>().labourCostController,
                      textType: TextInputType.number,
                      inputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Utils.getText('Sub Total')),
                  const Icon(Icons.attach_money),
                  Expanded(
                    child: Utils.getTextFormField('',
                        context.watch<TodoEditExpenseBloc>().subTotalController,
                        textType: TextInputType.number,
                        readOnly: true,
                        fillColor: Colors.grey.shade200,
                        borderWidth: 0.4),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Utils.getText('Sales Tax'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                context
                                    .read<TodoEditExpenseBloc>()
                                    .add(TaxIconEvent());
                              },
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                  Border.all(color: AppC.grey, width: 0.5),
                                ),
                                child: context
                                    .watch<TodoEditExpenseBloc>()
                                    .taxIsTapped
                                    ? const Icon(
                                  Icons.monetization_on_outlined,
                                  color: AppC.grey,
                                  size: 20,
                                )
                                    : const Icon(
                                  Icons.percent,
                                  color: AppC.grey,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Utils.getTextFormField(
                                  '',
                                  maxLength: 20,
                                  context
                                      .watch<TodoEditExpenseBloc>()
                                      .percentageOrAmountController,
                                  inputAction: TextInputAction.done,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 1),
                                  textType: TextInputType.number,
                                  textAlign: TextAlign.center),
                            ),
                            const Spacer(flex: 1,),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.attach_money),
                  Expanded(
                    child: Utils.getTextFormField(
                        '',
                        readOnly: true,
                        context.watch<TodoEditExpenseBloc>().saleTaxController,
                        fillColor: Colors.grey.shade200,
                        borderWidth: 0.4),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Utils.getText('Shipping & Handling')),
                  const Icon(Icons.attach_money),
                  Expanded(
                    child: Utils.getTextFormField(
                      '',
                      hintText: 'enter a amount',
                      context.read<TodoEditExpenseBloc>().shippingController,
                      textType: TextInputType.number,
                      inputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Utils.getText('Total')),
                  const Icon(Icons.attach_money),
                  Expanded(
                    child: Utils.getTextFormField(
                        '',
                        context
                            .watch<TodoEditExpenseBloc>()
                            .totalAmountController,
                        readOnly: true,
                        fillColor: Colors.grey.shade200,
                        borderWidth: 0.4),
                  ),
                ],
              ),
            ]
          );
      },
    );
  }
}


