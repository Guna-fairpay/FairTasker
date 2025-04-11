import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Categorys/category_page/bloc/category_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Categorys/category_page/bloc/category_events.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Categorys/category_page/bloc/category_states.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:fairpytasker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryAlterUi extends StatelessWidget {
  const CategoryAlterUi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) => Form(
      key: context.read<CategoryBloc>().formKey,
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox.shrink(),
          Utils.getTextFormField("Name", context.read<CategoryBloc>().nameController,
            validator: (value) => (value?.trim().isNullOrEmpty ?? false) ? "Required" : null,
          ),
          Row(
            spacing: 10,
            children: [
              SuccessButton(text: (context.watch<CategoryBloc>().selectedModel != null) ? "Update" : "Save", onPressed: () => context.read<CategoryBloc>().add(CategorySaveEvent())),
              if (context.watch<CategoryBloc>().selectedModel != null)
                SuccessButton(text: "Cancel", backgroundColor: AppC.redAccent, onPressed: () => context.read<CategoryBloc>().add(CategoryClearEvent())),
              const Spacer(flex: 1),
              Expanded(
                flex: 8,
                child: CompactSearchView(
                  controller: context.read<CategoryBloc>().searchController,
                  onChanged: (value) => context.read<CategoryBloc>().add(CategorySearchEvent(value)),
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
