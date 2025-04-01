
import 'package:fairpytasker/UI/Finance/Expense/Event/expense_event.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Bloc/expense_bloc.dart';
import '../State/expense_state.dart';

class SplitExpenseUI extends StatelessWidget {
  const SplitExpenseUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context,state) {
          return Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Utils.getText(
                "Part & Supplies Details",
                weight: FontWeight.bold,
                size: 16,
            ),
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
                      e['controller'],
                      textType: const TextInputType.numberWithOptions(decimal: true),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          "\$",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onChangeCallback: (value) => context
                          .read<ExpenseBloc>()
                          .calculateTotal(),
                      labelStyle: context.textTheme.labelMedium
                          ?.copyWith(color: context.theme.hintColor),
                      style: context.textTheme.labelLarge
                          ?.copyWith(fontFamily: "Lato"),
                      textInputFormatter:[
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
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
                      e['controller'],
                      textType: const TextInputType.numberWithOptions(decimal: true),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          "\$",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onChangeCallback: (value) => context
                          .read<ExpenseBloc>()
                          .calculateTotal(),
                      labelStyle: context.textTheme.labelMedium
                          ?.copyWith(color: context.theme.hintColor),
                      style: context.textTheme.labelLarge
                          ?.copyWith(fontFamily: "Lato"),
                      textInputFormatter:[
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
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
                    context.read<ExpenseBloc>().labourCostController,
                    textType: const TextInputType.numberWithOptions(decimal: true),
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
                    textInputFormatter:[
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
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
                    context.watch<ExpenseBloc>().subTotalController,
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
                    context.read<ExpenseBloc>().add(TaxIconEvent());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppC.grey, width: 0.5),
                    ),
                    child: context.watch<ExpenseBloc>().taxIsTapped
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
                  fit: FlexFit.loose,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(child: Utils.getTextFormField(
                        '',
                        maxLength: 20,
                        context.watch<ExpenseBloc>()
                            .percentageOrAmountController,
                        inputAction: TextInputAction.done,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 3),
                        textType: const TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        labelStyle: context.textTheme.labelMedium
                            ?.copyWith(color: context.theme.hintColor),
                        style: context.textTheme.labelLarge
                            ?.copyWith(fontFamily: "Lato"),
                        textInputFormatter:[
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                      )),
                      const Spacer(flex: 1)
                    ],
                  ),
                ),
                27.width,
                Expanded(
                  child: Utils.getTextFormField(
                    '',
                    readOnly: true,
                    context.watch<ExpenseBloc>().saleTaxController,
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
                Expanded(flex: 2, child: Utils.getText('Shipping & Handling')),
                //const Icon(Icons.attach_money),
                Expanded(
                  child: Utils.getTextFormField(
                    '',
                    hintText: 'enter a amount',
                    context.read<ExpenseBloc>().shippingController,
                    textType: const TextInputType.numberWithOptions(decimal: true),
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
                    textInputFormatter:[
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
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
                    context.watch<ExpenseBloc>().totalAmountController,
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
        }
    );
  }
}
