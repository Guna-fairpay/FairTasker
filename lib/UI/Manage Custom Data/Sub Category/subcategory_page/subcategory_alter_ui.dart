import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/custom_dropdown.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Sub%20Category/subcategory_page/bloc/subcategory_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Sub%20Category/subcategory_page/bloc/subcategory_events.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Sub%20Category/subcategory_page/bloc/subcategory_states.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubcategoryAlterUi extends StatelessWidget {
  const SubcategoryAlterUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubCategoryBloc, SubCategoryState>(builder: (context, state) => Form(
        key: context.read<SubCategoryBloc>().formKey,
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            Utils.getTextFormField(
              'Name',
              context.read<SubCategoryBloc>().nameController,
              validator: (val) => (val?.trim().isNullOrEmpty ?? false) ? 'Please enter sub category' : null,
            ),
            Utils.dropdownBox('Select Category', context.watch<SubCategoryBloc>().mainCategories, (selectedValue) => context.read<SubCategoryBloc>().add(SubCategoryCategorySelectEvent(selectedValue)),
                initialSelection: context.watch<SubCategoryBloc>().selectedCategory,
                selectedKey: context.watch<SubCategoryBloc>().selectedCategory,
                labelKey: 'name'),
            Utils.dropdownBox('Select ExpenseTo', context.watch<SubCategoryBloc>().expenseTo, (selectedValue) => context.read<SubCategoryBloc>().add(SubCategoryExpenseToSelectEvent(selectedValue)),
                initialSelection: context.watch<SubCategoryBloc>().selectedExpenseTo,
                selectedKey: context.watch<SubCategoryBloc>().selectedExpenseTo,
                labelKey: 'expense_to'),
            Row(
              spacing: 10,
              children: [
                SuccessButton(onPressed: () => context.read<SubCategoryBloc>().add(SubCategorySaveEvent()), text: (context.watch<SubCategoryBloc>().selectedModel == null) ? "Save" : "Update"),
                if (context.watch<SubCategoryBloc>().selectedModel != null)
                SuccessButton(onPressed: () => context.read<SubCategoryBloc>().add(SubCategoryCancelEvent()), text: "Cancel", backgroundColor: AppC.redAccent),
                const Spacer(flex: 1),
                Expanded(flex: 8, child: CompactSearchView(controller:  context.read<SubCategoryBloc>().searchController, onChanged: (value) =>  context.read<SubCategoryBloc>().add(SubCategorySearchEvent(value))))
              ],
            )
          ],
        )));
  }
}
