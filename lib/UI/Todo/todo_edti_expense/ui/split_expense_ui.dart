
import 'package:fairpytasker/UI/Todo/todo_edti_expense/bloc/todo_edit_expense_bloc.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Utilities/utils.dart';
import '../../../../Utilities/appC.dart';
import '../event/todo_edit_expense_event.dart';
import '../state/todo_edit_expense_state.dart';

class SplitExpenseUI extends StatelessWidget {
  const SplitExpenseUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoEditExpenseBloc, TodoExpenseState>(
      builder: (context, state) {
        return Column(spacing: 10, children: [
          if (state.partsList.isNotEmpty)
            ...state.partsList
                .map((e) => Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Utils.getText(
                            (e['name']).toString().toTitleCase(),
                          ),
                        ),
                        //const Icon(Icons.attach_money),
                        Expanded(
                          child: Utils.getTextFormField(
                            '',
                            hintText: 'enter a amount',
                            context
                                    .read<TodoEditExpenseBloc>()
                                    .partsCostControllers[e['id'].toString()] ??
                                TextEditingController(text: "000"),
                            textType: TextInputType.number,
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                "\$",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            onChangeCallback: (value) => context
                                .read<TodoEditExpenseBloc>()
                                .calculateTotal(),
                            labelStyle: context.textTheme.labelMedium
                                ?.copyWith(color: context.theme.hintColor),
                            style: context.textTheme.labelLarge
                                ?.copyWith(fontFamily: "Lato"),
                          ),
                        ),
                      ],
                    ))
                .toList(),
          if (state.suppliesList.isNotEmpty)
            ...state.suppliesList
                .map((e) => Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Utils.getText(
                              (e['name']).toString().toTitleCase(),
                            )),
                        // const Icon(Icons.attach_money),
                        Expanded(
                          child: Utils.getTextFormField(
                            '',
                            hintText: 'enter a amount',
                            context.read<TodoEditExpenseBloc>()
                                .suppliesCostControllers[e['id'].toString()] ??
                                TextEditingController(text: "000"),
                            textType: TextInputType.number,
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                "\$",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            onChangeCallback: (value) => context
                                .read<TodoEditExpenseBloc>()
                                .calculateTotal(),
                            labelStyle: context.textTheme.labelMedium
                                ?.copyWith(color: context.theme.hintColor),
                            style: context.textTheme.labelLarge
                                ?.copyWith(fontFamily: "Lato"),
                          ),
                        ),
                      ],
                    ))
                .toList(),
          Row(
            children: [
              Expanded(flex: 2, child: Utils.getText('Labour')),
              // const Icon(Icons.attach_money),
              Expanded(
                child: Utils.getTextFormField(
                  '',
                  hintText: 'enter a amount',
                  context.read<TodoEditExpenseBloc>().labourCostController,
                  textType: TextInputType.number,
                  inputAction: TextInputAction.done,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      "\$",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  labelStyle: context.textTheme.labelMedium
                      ?.copyWith(color: context.theme.hintColor),
                  style: context.textTheme.labelLarge
                      ?.copyWith(fontFamily: "Lato"),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Utils.getText('Sub Total', weight: FontWeight.bold)),
              // const Icon(Icons.attach_money),
              Expanded(
                child: Utils.getTextFormField(
                  '',
                  context.watch<TodoEditExpenseBloc>().subTotalController,
                  textType: TextInputType.number,
                  readOnly: true,
                  fillColor: Colors.grey.shade200,
                  borderWidth: 0.4,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      "\$",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  labelStyle: context.textTheme.labelMedium
                      ?.copyWith(color: context.theme.hintColor),
                  style: context.textTheme.labelLarge
                      ?.copyWith(fontFamily: "Lato"),
                ),
              ),
            ],
          ),
         Row(
           children: [
             Utils.getText('Sales Tax'),
             10.width,
             InkWell(
               onTap: () {
                 context.read<TodoEditExpenseBloc>().add(TaxIconEvent());
               },
               child: Container(
                 padding: const EdgeInsets.all(1),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(4),
                   border: Border.all(color: AppC.grey, width: 0.5),
                 ),
                 child: context.watch<TodoEditExpenseBloc>().taxIsTapped
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
             10.width,
             Flexible(
               flex: 1,
               child: Utils.getTextFormField(
                 '',
                 maxLength: 20,
                 context
                     .watch<TodoEditExpenseBloc>()
                     .percentageOrAmountController,
                 inputAction: TextInputAction.done,
                 contentPadding: const EdgeInsets.symmetric(
                     horizontal: 10, vertical: 3),
                 textType: TextInputType.number,
                 textAlign: TextAlign.center,
                 labelStyle: context.textTheme.labelMedium
                     ?.copyWith(color: context.theme.hintColor),
                 style: context.textTheme.labelLarge
                     ?.copyWith(fontFamily: "Lato"),
               ),
             ),
             10.width,
             Expanded(
               child: Utils.getTextFormField(
                 '',
                 readOnly: true,
                 context.watch<TodoEditExpenseBloc>().saleTaxController,
                 fillColor: Colors.grey.shade200,
                 borderWidth: 0.4,
                 prefixIcon: const Padding(
                   padding: EdgeInsets.symmetric(horizontal: 5.0),
                   child: Text(
                     "\$",
                     style: TextStyle(fontWeight: FontWeight.bold),
                   ),
                 ),
                 labelStyle: context.textTheme.labelMedium
                     ?.copyWith(color: context.theme.hintColor),
                 style: context.textTheme.labelLarge
                     ?.copyWith(fontFamily: "Lato"),
               ),
             ),
           ],
         ),
         /* Row(
            children: [

                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.read<TodoEditExpenseBloc>().add(TaxIconEvent());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppC.grey, width: 0.5),
                        ),
                        child: context.watch<TodoEditExpenseBloc>().taxIsTapped
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
                      textAlign: TextAlign.center,
                      labelStyle: context.textTheme.labelMedium
                          ?.copyWith(color: context.theme.hintColor),
                      style: context.textTheme.labelLarge
                          ?.copyWith(fontFamily: "Lato"),
                    ),
                  ),
              // const Icon(Icons.attach_money, color: AppC.grey, size: 20,),
              Expanded(
                child: Utils.getTextFormField(
                  '',
                  readOnly: true,
                  context.watch<TodoEditExpenseBloc>().saleTaxController,
                  fillColor: Colors.grey.shade200,
                  borderWidth: 0.4,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      "\$",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  labelStyle: context.textTheme.labelMedium
                      ?.copyWith(color: context.theme.hintColor),
                  style: context.textTheme.labelLarge
                      ?.copyWith(fontFamily: "Lato"),
                ),
              ),
            ],
          ),*/
          Row(
            children: [
              Expanded(flex: 2, child: Utils.getText('Shipping & Handling')),
              //const Icon(Icons.attach_money),
              Expanded(
                child: Utils.getTextFormField(
                  '',
                  hintText: 'enter a amount',
                  context.read<TodoEditExpenseBloc>().shippingController,
                  textType: TextInputType.number,
                  inputAction: TextInputAction.done,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      "\$",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  labelStyle: context.textTheme.labelMedium
                      ?.copyWith(color: context.theme.hintColor),
                  style: context.textTheme.labelLarge
                      ?.copyWith(fontFamily: "Lato"),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Utils.getText('Total', weight: FontWeight.bold)),
              // const Icon(Icons.attach_money),
              Expanded(
                child: Utils.getTextFormField(
                  '',
                  context.watch<TodoEditExpenseBloc>().totalAmountController,
                  readOnly: true,
                  fillColor: Colors.grey.shade200,
                  borderWidth: 0.4,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      "\$",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  labelStyle: context.textTheme.labelMedium
                      ?.copyWith(color: context.theme.hintColor),
                  style: context.textTheme.labelLarge
                      ?.copyWith(fontFamily: "Lato"),
                ),
              ),
            ],
          ),
        ]);
      },
    );
  }
}
