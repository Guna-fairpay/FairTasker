import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Finance/Expense/other/component/category_dialog/bloc/category_dialog_bloc.dart';
import 'package:fairpytasker/Utilities/num.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryDialogUI {
  CategoryDialogUI._();
  static void show({
    required BuildContext context,
    dynamic model,
  }) async {
    await showDialog(
        context: context,
        builder: (context) => _CategoryDialogUI(model: model,),
        barrierDismissible: false);
  }
}

class _CategoryDialogUI extends StatelessWidget {
  final dynamic model;

  const _CategoryDialogUI({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      CategoryDialogBloc()..add(InitialEvent(model ?? [])),
      child: BlocListener<CategoryDialogBloc, CategoryDialogState>(
        listener: (context, state) {
          if(state is LoadingState){
            EasyLoading.show();
          } else{
            if (state is! SuccessState) if (EasyLoading.isShow) EasyLoading.dismiss();
            if (state is ErrorState) Toaster.showError(state.message);
            if(state is SuccessState){
              Toaster.showSuccess(state.message);
              context.pop();
            }
          }

        },
        child: BlocBuilder<CategoryDialogBloc, CategoryDialogState>(
          builder: (context, state) {
            return AlertDialog(
              insetPadding: 16.spMin.padding,
              contentPadding: 16.spMin.horizontalPadding.copyWith(bottom: 16.spMin),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Num.borderRadiusLarge)),
              alignment: Alignment.center,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              title: ListTile(
                contentPadding: 0.padding.copyWith(left: 16.spMin),
                title: Text(context.read<CategoryDialogBloc>().selectedSubCategory?['name'] ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(onPressed: context.pop, icon: const Icon(Icons.close)),
              ),
              titlePadding: 0.padding,
              content: Container(
                    width: 30,
                    constraints:
                    BoxConstraints(maxHeight: context.height * 0.5),
                    child: Column(
                      spacing: 16.spMin,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Utils.dropdownBox(
                          "Select Category",
                          context.read<CategoryDialogBloc>().category,
                              (value) => context.read<CategoryDialogBloc>().add(
                              CategoryEvent(
                                  selectedCategory: value)),
                          labelKey: 'name',
                          initialSelection: context.watch<CategoryDialogBloc>().selectedCategory,
                          validator: (value) => value == null ? "Select Category" : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        Utils.dropdownBox(
                          "Select Sub Category",
                          context.read<CategoryDialogBloc>().subCategories,
                              (value) => context.read<CategoryDialogBloc>().add(SubCategoryEvent(selectedSubCategory: value)),
                          labelKey: 'name',
                          initialSelection: context.watch<CategoryDialogBloc>().selectedSubCategory,
                          validator: (value) => value == null ? "Select Sub Category" : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        SuccessButton(
                          text: 'Update',
                          onPressed: ()=> context.read<CategoryDialogBloc>().add(UpdateEvent()),
                        ),
                      ],
                    )),
            );
          }
        ),
      ),
    );
  }
}
