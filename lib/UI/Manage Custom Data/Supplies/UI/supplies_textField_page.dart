import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/Bloc/supplies_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/Bloc/supplies_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Supplies/Bloc/supplies_state.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Component/success_button.dart';

class SuppliesTextFieldPage extends StatelessWidget {
  const SuppliesTextFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuppliesBloc, SuppliesState>(
        builder: (context, state) => Form(
          key: context.read<SuppliesBloc>().formKey,
          child: Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox.shrink(),
                Utils.getTextFormField(
                  "Name",
                  context.read<SuppliesBloc>().nameController,
                  validator: (value) =>
                  (value?.trim().isNullOrEmpty ?? false)
                      ? "Please enter name"
                      : null,
                  autoValidate: context.read<SuppliesBloc>().autoValidateMode,
                ),
                Utils.getTextFormField(
                  "Description",
                  context.read<SuppliesBloc>().notesController,
                ),
                Row(
                  spacing: 10,
                  children: [
                    SuccessButton(
                        text: (context.watch<SuppliesBloc>().isEdit)
                            ? "Update"
                            : "Save",
                        onPressed: () => context
                            .read<SuppliesBloc>()
                            .add(SaveSuppliesEvent())),
                    if (context.watch<SuppliesBloc>().isEdit)
                      SuccessButton(text: "Cancel", backgroundColor: AppC.redAccent,
                          onPressed: () => context.read<SuppliesBloc>().add(EditCloseEvent())),
                    const Spacer(flex: 1),
                    Expanded(
                      flex: 8,
                      child: CompactSearchView(
                        controller: context.read<SuppliesBloc>().searchController,
                        onChanged: (value) => context.read<SuppliesBloc>().add(SearchSuppliesEvent(value)),
                      ),
                    )
                  ],
                ),
              ]
          ),
        ));
  }
}
