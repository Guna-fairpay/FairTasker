import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../Utilities/Utils.dart';
import '../../../../../../Utilities/appC.dart';
import 'expense_bloc.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class CohortDialog {
  CohortDialog._();

  static void show(
    BuildContext context, {
    required dynamic expense,
        // VoidCallback? onCompleted,
  }) async {
    await showDialog(
        context: context,
        builder: (dialogContext) {
          return BlocProvider.value(
            value: BlocProvider.of<ExpenseBloc>(context),
            child: _CohortDialog(
              expense: expense,
                // onCompleted: onCompleted,
            ),
          );
        });
  }
}

class _CohortDialog extends StatelessWidget {
  final dynamic expense;
  // final VoidCallback? onCompleted;
  const _CohortDialog({
    required this.expense,
    // this.onCompleted
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(builder: (context, state) {
      return Dialog(
        backgroundColor: AppC.white,
        insetPadding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Utils.getText(
                      expense['vehicle']?['vehicle_name'] ?? '',
                      weight: FontWeight.w700,
                    ),
                  ),
                  Utils.getText(
                    '\$${expense['expense_amount'] ?? ''}',
                    weight: FontWeight.w700,
                  ),
                ],
              ),
              Utils.getText('Cohort', weight: FontWeight.w300),
              Utils.dropdownBox(
                'Select Cohort',
                state.cohorts,
                (value) => context.read<ExpenseBloc>().add(
                      CohortListEvent(selectedCohort: value),
                    ),
                labelKey: 'name',
                initialSelection: state.selectedCohorts,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 10,
                children: [
                  Utils.getElevatedButton(
                      text: 'Save',
                      () { context
                          .read<ExpenseBloc>()
                          .add(UpdateCohortEvent(expenseData: expense));
                          Navigator.pop(context);
                      },
                  ),
                  Utils.getElevatedButton(
                      text: 'Cancel',
                      () => Navigator.pop(context),
                      bgColor: AppC.redAccent),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
