
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_List/Bloc/expense_event.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../../../Utilities/Utils.dart';
import '../../../../../../Utilities/appC.dart';
import '../Bloc/expense_bloc.dart';
import '../Bloc/expense_state.dart';

class AddNewSubcategoryDialog {
  AddNewSubcategoryDialog._();

  static void show(BuildContext context,
      {required String categoryId, VoidCallback? onRefresh}) async {
    await showDialog(
        context: context,
        builder: (context) => _AddNewSubcategoryDialog(
              categoryId: categoryId,
               onRefresh: onRefresh,));
  }
}

class _AddNewSubcategoryDialog extends StatelessWidget {
  final String categoryId;
  final VoidCallback? onRefresh;
  const _AddNewSubcategoryDialog(
      {required this.categoryId,
        this.onRefresh
      });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExpenseBloc>(
      create: (context) => ExpenseBloc()..add(const GetSubCategoryExpenseTo()),
      child: BlocListener<ExpenseBloc, ExpenseState>(
          listener: (context, state) {
        state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
        if (state.pop) {
          onRefresh?.call();
          Navigator.pop(context);
        }
      }, child:
              BlocBuilder<ExpenseBloc, ExpenseState>(builder: (context, state) {
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
                5.height,
                Utils.getText(
                  'Add New SubCategory',
                  weight: FontWeight.bold,
                ),
                Utils.getTextFormField(
                  'Name',
                  context.read<ExpenseBloc>().subCategoryController,
                ),
                Utils.dropdownBox(
                    'Select Cohort',
                    state.expenseTo,
                    (value) => context.read<ExpenseBloc>().add(
                        SubcategoryDropdownEvent(selectedExpenseTo: value)),
                    labelKey: 'expense_to'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [
                    SuccessButton(
                        text: 'Save',
                        onPressed: () {
                      if (context.read<ExpenseBloc>().subCategoryController
                          .text.isNotEmpty && state.expenseTo.isNotEmpty) {
                        context.read<ExpenseBloc>().add(SaveSubcategory(
                            categoryId: categoryId,
                            name: context.read<ExpenseBloc>().subCategoryController.text,
                            expenseToId: "${state.selectedExpenseTo['id']}"));
                      } else {
                        Toaster.showSuccess('Please fill the fields');
                      }
                      return;
                    }),
                    SuccessButton(
                        text: 'Cancel',
                        onPressed: () => Navigator.pop(context),
                        backgroundColor: AppC.redAccent),
                  ],
                ),
              ],
            ),
          ),
        );
      })),
    );
  }
}
