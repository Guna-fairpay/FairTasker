import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';
import '../../../Todo/todo_edti_expense/bloc/todo_edit_expense_bloc.dart';
import '../Bloc/expense_bloc.dart';
import '../State/expense_state.dart';

class AddNewSubcategoryDialog {
  AddNewSubcategoryDialog._();

  static void show(BuildContext context) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => _AddNewSubcategoryDialog());
  }
}

class _AddNewSubcategoryDialog extends StatelessWidget {
  const _AddNewSubcategoryDialog();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExpenseBloc>(
      create: (context) => ExpenseBloc(),
      child: BlocListener<ExpenseBloc, ExpenseState>(
          listener: (context, state) {
          }, child: BlocBuilder<ExpenseBloc, ExpenseState>(
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
                    5.height,
                    Utils.getText(
                      'Add New SubCategory',
                      weight: FontWeight.bold,
                    ),
                    Utils.getTextFormField('Name', TextEditingController()),
                    Utils.dropdownBox('Select Cohort', [], (value) {},
                        labelKey: 'name'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: 10,
                      children: [
                        Utils.getElevatedButton(text: 'Save', () {}),
                        Utils.getElevatedButton(
                            text: 'Cancel',
                                () => Navigator.pop(context),
                            bgColor: AppC.redAccent
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          })),
    );
  }}
