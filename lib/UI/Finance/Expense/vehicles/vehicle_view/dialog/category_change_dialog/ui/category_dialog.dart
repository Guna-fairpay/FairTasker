import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Finance/Expense/vehicles/vehicle_view/dialog/category_change_dialog/bloc/category_change_dialog_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CategoryDialog {
  CategoryDialog._();

  static void show(
      BuildContext context, {
        required dynamic expense,
      }) async {
    await showDialog(
      context: context,
      builder: (context) =>
          _CategoryDialog(
              expense: expense,
          ),
    );
  }
}

class _CategoryDialog extends StatelessWidget {
  final dynamic expense;
  const _CategoryDialog({
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryChangeDialogBloc()..add(InitialEvent(data: expense)),
      child: BlocListener<CategoryChangeDialogBloc, CategoryDialogState>(
        listener: (context, state) {
          if(state is LoadingState){
            if(!EasyLoading.isShow) EasyLoading.show();
          }else{
            if(EasyLoading.isShow) EasyLoading.dismiss();
            switch(state){
              case ErrorState(): Toaster.showError(state.message);
                break;
              case SuccessState(): Toaster.showSuccess(state.data);
                break;
            }
          }
        },
        child: BlocBuilder<CategoryChangeDialogBloc, CategoryDialogState>(
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
                            child: CompactText(
                              expense['vehicle']?['vehicle_name'] ?? '',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          CompactText(
                            "\$ ${expense['expense_amount'] ??''}",
                            fontWeight: FontWeight.w700,
                          ),
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
                                onTap: () {},
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
            }),
      ),
    );
  }
}
