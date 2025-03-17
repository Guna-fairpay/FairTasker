
import 'package:fairpytasker/UI/Finance/Expense/Bloc/expense_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/add_new_subcategory_dialog.dart';
import 'package:fairpytasker/UI/Finance/Expense/Event/expense_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';
import '../State/expense_state.dart';

class CategorySubcategoryDialog {
  CategorySubcategoryDialog._();

  static void show(
    BuildContext context, {
    required  dynamic expense,
  }) async {
    await showDialog(
        context: context,
        builder: (dialogContext) {
          return BlocProvider.value(
            value: BlocProvider.of<ExpenseBloc>(context),
            child: _CategorySubcategoryDialog(
              expense: expense,),
          );
        });
  }
}

class _CategorySubcategoryDialog extends StatelessWidget {
  final dynamic expense;

  const _CategorySubcategoryDialog(
      { required this.expense,});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(

        builder: (context,state) {

          return Dialog(
              backgroundColor: AppC.white,
              insetPadding: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: SafeArea(
                minimum: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 15),
                child: Column(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Utils.getText(
                      expense['vehicle']?['vehicle_name'] ?? '',
                      weight: FontWeight.w700,
                    ),
                    Utils.getText('Category', weight: FontWeight.w300),
                    Utils.dropdownBox(
                      'Select Category',
                      state.categories,
                          (value) =>
                          context.read<ExpenseBloc>().add(
                              CategoryListEvent(selectedCategory: value)),
                      labelKey: 'name',
                      initialSelection: state.selectedCategory,
                      selectedKey: state.selectedCategory,
                    ),
                    Utils.getText(
                        'Sub Category',
                        weight: FontWeight.w300
                    ),
                    Utils.dropdownBox(
                      'Select SubCategory',
                      state.subCategories,
                          (value) =>
                          context.read<ExpenseBloc>().add(
                              SubCategoryListEvent(selectedSubCategory: value)),
                      labelKey: 'name',
                      initialSelection: state.selectedSubCategory,
                      selectedKey:state.selectedSubCategory,
                    ),
                    if(state.selectedCategory.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () =>
                                  AddNewSubcategoryDialog.show(context),
                              child: Utils.getText('+ Add New Sub Category',
                                  color: AppC.appColor)),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: 10,
                      children: [
                        Utils.getElevatedButton(text: 'Save', () {}),
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
        }

    );
  }
}
