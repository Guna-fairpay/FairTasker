
import 'package:fairpytasker/Component/feedback_tab_button.dart';
import 'package:fairpytasker/UI/Finance/Expense/Bloc/expense_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/Event/expense_event.dart';
import 'package:fairpytasker/UI/Finance/Expense/State/expense_state.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'Person/person_expense_view_ui.dart';
import 'Vehicle/vehicle_expense_view_ui.dart';

class ExpenseTab extends StatelessWidget {
  const ExpenseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExpenseBloc>(
      create: (context) => ExpenseBloc(),
      child: BlocListener<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
        },
        child: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, state) {
            return SafeArea(
              minimum: 15.padding,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      border:
                      Border(bottom: BorderSide(color: Colors.grey, width: 0.8)),
                    ),
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: state.tapData.map((tab) {
                          return FeedbackTabButton(
                              buttonText: tab['title'],
                              value: tab['id'],
                              selectedValue: state.selectedTap['id'],
                              onPressed: (val) => context
                                  .read<ExpenseBloc>()
                                  .add(ExpenseTapEvent(tab)));
                        }).toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: state.selectedTap['id'] == 1
                          ?  const ExpenseVehicleViewUI()
                          : state.selectedTap['id'] == 2
                          ? const PersonExpenseViewUI()
                          : state.selectedTap['id'] == 3
                          ? const Text('3')///OtherExpenseViewUI()
                          : const SizedBox(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
