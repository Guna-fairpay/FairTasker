import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Finance/Expense/vehicles/vehicle_view/dialog/category_change_dialog/bloc/category_change_dialog_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/vehicles/vehicle_view/dialog/subcategory_dialog/ui/subcategory_dialog.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CategoryDialog {
  CategoryDialog._();

  static void show(
      BuildContext context, {
        required dynamic expenseData,
      }) async {
    await showDialog(
      context: context,
      builder: (context) =>
          _CategoryDialog(
            expenseData: expenseData,
          ),
    );
  }
}

class _CategoryDialog extends StatelessWidget {
  final dynamic expenseData;
  const _CategoryDialog({
    required this.expenseData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryChangeDialogBloc()..add(InitialEvent(data: expenseData)),
      child: BlocListener<CategoryChangeDialogBloc, CategoryDialogState>(
        listener: (context, state) {
          if(state is LoadingState){
            if(!EasyLoading.isShow) EasyLoading.show();
          }else{
            if(EasyLoading.isShow) EasyLoading.dismiss();
            switch(state){
              case ErrorState(): Toaster.showError(state.message);
                break;
              case SuccessState():
                {
                  Toaster.showSuccess(state.data);
                  context.pop();
                }break;
              case SubcategoryState():
                {
                  SubcategoryDialog.show(context, categoryId: state.data);
                }break;
            }
          }
        },
        child: BlocBuilder<CategoryChangeDialogBloc, CategoryDialogState>(
            builder: (context, state) {
              var expense = context.watch<CategoryChangeDialogBloc>().model;
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text.rich(TextSpan(
                              children: [
                                TextSpan(
                                  text: expense?['vehicle']?['vehicle_name'] ?? '',
                                ),
                                TextSpan(text:  " (\$${expense?['expense_amount'] ??''})",)
                              ],
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                  color: AppC.appColor
                              ),
                            )),
                          ),
                          IconButton(onPressed: ()=> context.pop(), icon: const Icon(Icons.close, color: AppC.redAccent)),
                        ],
                      ),
                      const CompactText('Category', fontWeight: FontWeight.w300),
                      Utils.dropdownBox(
                        'Select Category',
                        context.watch<CategoryChangeDialogBloc>().category,
                            (value) => context
                            .read<CategoryChangeDialogBloc>()
                            .add(CategoryDropdownEvent(data: value)),
                        labelKey: 'name',
                        initialSelection: context.watch<CategoryChangeDialogBloc>().selectedCategory,
                        selectedKey: context.watch<CategoryChangeDialogBloc>().selectedCategory,
                      ),
                      const CompactText('Sub Category', fontWeight: FontWeight.w300),
                      Utils.dropdownBox(
                        'Select SubCategory',
                        context.watch<CategoryChangeDialogBloc>().subCategories,
                            (value) => context
                            .read<CategoryChangeDialogBloc>()
                            .add(SubcategoryDropdownEvent(data: value)),
                        labelKey: 'name',
                        initialSelection: context.watch<CategoryChangeDialogBloc>().selectedSubCategory,
                        selectedKey: context.watch<CategoryChangeDialogBloc>().selectedSubCategory,
                      ),
                      if ((context.watch<CategoryChangeDialogBloc>().selectedCategory).toString().isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                                onTap: ()=> context.read<CategoryChangeDialogBloc>().add(NavigateSubcategoryEvent(data: expense)),
                                child: const CompactText('+ Add New Sub Category', color: AppC.appColor)),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        spacing: 10,
                        children: [
                          SuccessButton(
                            text: 'Save',
                            onPressed: () => context.read<CategoryChangeDialogBloc>().add(UpdateCategoryEvent()),
                          ),
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
