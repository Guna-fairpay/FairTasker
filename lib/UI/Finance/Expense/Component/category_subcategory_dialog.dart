import 'dart:developer';
import 'package:fairpytasker/UI/Finance/Expense/Bloc/expense_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/add_new_subcategory_dialog.dart';
import 'package:fairpytasker/UI/Finance/Expense/Event/expense_event.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';
import '../State/expense_state.dart';

class CategorySubcategoryDialog {
  CategorySubcategoryDialog._();

  static void show(
    BuildContext context, {
    required dynamic expense,
        VoidCallback? onCompleted,
  }) async {
    await showDialog(
        context: context,
        builder: (context) =>
            _CategorySubcategoryDialog(
              expense: expense,
                onCompleted: onCompleted
            ),
          );
  }
}

class _CategorySubcategoryDialog extends StatelessWidget {
  final dynamic expense;
final VoidCallback? onCompleted;
  const _CategorySubcategoryDialog({
    required this.expense,
    this.onCompleted
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExpenseBloc>(
      create: (context) => ExpenseBloc()..add(CategoryDialogEvent(data: expense)),
      child: BlocListener<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          state.isLoading ? EasyLoading.show() : EasyLoading.dismiss();
          if (state.categoriesPop) {
            onCompleted?.call();
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<ExpenseBloc, ExpenseState>(
            builder: (context, state) {
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
                        "\$ ${expense['expense_amount'] ??''}",
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                  Utils.getText('Category', weight: FontWeight.w300),
                  Utils.dropdownBox(
                    'Select Category',
                    state.categories,
                    (value) => context
                        .read<ExpenseBloc>()
                        .add(CategoryListEvent(selectedCategory: value)),
                    labelKey: 'name',
                    initialSelection: state.selectedCategory,
                    selectedKey: state.selectedCategory,
                  ),
                  Utils.getText('Sub Category', weight: FontWeight.w300),
                  Utils.dropdownBox(
                    'Select SubCategory',
                    state.subCategories,
                    (value) => context
                        .read<ExpenseBloc>()
                        .add(SubCategoryListEvent(selectedSubCategory: value)),
                    labelKey: 'name',
                    initialSelection: state.selectedSubCategory,
                    selectedKey: state.selectedSubCategory,
                  ),
                  if ((state.selectedCategory).toString().isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () => AddNewSubcategoryDialog.show(
                                context,
                                categoryId: "${state.selectedCategory['id']}",
                              onRefresh: () => context.read<ExpenseBloc>().add(CategoryDialogEvent(data: expense)),
                            ),
                            child: Utils.getText('+ Add New Sub Category',
                                color: AppC.appColor)),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 10,
                    children: [
                      Utils.getElevatedButton(
                        text: 'Save',
                        () {
                          if (state.selectedSubCategory.isNotEmpty) {
                            context.read<ExpenseBloc>().add(UpdateCategoryEvent(expenseData: expense));
                          }else{
                            Toaster.showSuccess('Please select Sub Category');
                          }
                          return;
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
        }),
      ),
    );
  }
}
