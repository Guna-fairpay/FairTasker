import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Finance/Expense/vehicles/vehicle_view/dialog/subcategory_dialog/bloc/subcategory_dialog_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SubcategoryDialog {
  SubcategoryDialog._();

  static void show(BuildContext context, {required dynamic categoryId}) async {
    await showDialog(
        context: context,
        builder: (context) => _SubcategoryDialog(categoryId: categoryId,));
  }
}

class _SubcategoryDialog extends StatelessWidget {
  final dynamic categoryId;
  const _SubcategoryDialog({required this.categoryId,});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubcategoryDialogBloc()..add(InitialEvent(data: categoryId)),
      child: BlocListener<SubcategoryDialogBloc, SubcategoryDialogState>(
          listener: (context, state) {
            if(state is LoadingState){
              if(!EasyLoading.isShow) EasyLoading.show();
            }else{
              if(EasyLoading.isShow) EasyLoading.dismiss();
              switch(state){
                case ErrorState(): Toaster.showError(state.message);
                  break;
                case SuccessState():{
                  Toaster.showSuccess(state.data);
                  context.pop();
                }break;
              }
            }
          },
          child: BlocBuilder<SubcategoryDialogBloc, SubcategoryDialogState>(
              builder: (context, state) {
                return Dialog(
          backgroundColor: AppC.white,
          insetPadding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: SafeArea(
            minimum: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Form(
              key: context.read<SubcategoryDialogBloc>().formKey,
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
                    context.read<SubcategoryDialogBloc>().subCategoryController,
                    autoValidate: AutovalidateMode.onUserInteraction,
                    validator: (value) => (value == null || value.isEmpty) ? 'Please enter name' : null,
                  ),
                  Utils.dropdownBox(
                      'Select Cohort',
                      context.watch<SubcategoryDialogBloc>().expenseTo,
                          (value) => context.read<SubcategoryDialogBloc>().add(
                          ExpenseToDropdownEvent(data: value)),
                      labelKey: 'expense_to'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 10,
                    children: [
                      SuccessButton(
                          text: 'Save',
                          onPressed: () => context.read<SubcategoryDialogBloc>().add(SaveSubcategoryEvent())
                      ),
                      SuccessButton(
                          text: 'Cancel',
                          onPressed: () => Navigator.pop(context),
                          backgroundColor: AppC.redAccent),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      })),
    );
  }
}
