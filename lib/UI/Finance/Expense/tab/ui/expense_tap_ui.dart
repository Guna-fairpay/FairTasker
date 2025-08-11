
import 'package:fairpytasker/Component/feedback_tab_button.dart';
import 'package:fairpytasker/UI/Finance/Expense/Bill/UI/bill_main_page.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_List/UI/vehicle_expense_view_ui.dart';
import 'package:fairpytasker/UI/Finance/Expense/other/other_view/ui/other_main_page.dart';
import 'package:fairpytasker/UI/Finance/Expense/person/person_view/ui/person_view_main_ui.dart';
import 'package:fairpytasker/UI/Finance/Expense/tab/bloc/expense_tab_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/vehicles/vehicle_view/ui/vehicle_view_main_ui.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseTab extends StatelessWidget {
  const ExpenseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpenseTabBloc()..add(InitialEvent()),
      child: BlocListener<ExpenseTabBloc, ExpenseTabState>(
        listener: (context, state) {
          if (state is ErrorState) {
            Toaster.showError(state.error);
          }
        },
        child: BlocBuilder<ExpenseTabBloc, ExpenseTabState>(
          builder: (context, state) {
            return SafeArea(
              minimum: 10.verticalPadding,
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
                        children: context.read<ExpenseTabBloc>().tabs.map((tab) {
                          return FeedbackTabButton(
                              buttonText: tab['title'],
                              value: tab['id'],
                              selectedValue: context.watch<ExpenseTabBloc>().selectedTab,
                              onPressed: (val) => context
                                  .read<ExpenseTabBloc>()
                                  .add(TabChangeEvent(tab)));
                        }).toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: switch(context.watch<ExpenseTabBloc>().selectedTab) {
                        //0 => const VehicleViewMainUI(),
                        1 => const ExpenseVehicleViewUI(),
                        2 => const PersonViewMainUI(),
                        3 => const OtherMainPage(),
                        4 => const BillMainPage(),
                        _ => const SizedBox.shrink(),
                      },
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
