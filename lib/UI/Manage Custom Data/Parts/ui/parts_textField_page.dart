import 'package:fairpytasker/Component/custom_compact_search_view.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/Bloc/parts_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/Bloc/parts_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Parts/Bloc/parts_state.dart';
import 'package:fairpytasker/Utilities/Utils.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Component/success_button.dart';

class PartsTextFieldPage extends StatelessWidget {
  const PartsTextFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartsBloc, PartsState>(
        builder: (context, state) => Form(
              key: context.read<PartsBloc>().formKey,
              child: Column(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox.shrink(),
                    Utils.getTextFormField(
                      "Name",
                      context.read<PartsBloc>().nameController,
                      validator: (value) =>
                          (value?.trim().isNullOrEmpty ?? false)
                              ? "Required"
                              : null,
                    ),
                    Utils.getTextFormField(
                      "Notes",
                      context.read<PartsBloc>().notesController,
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        SuccessButton(
                            text: (context.watch<PartsBloc>().selectedData !=
                                    null)
                                ? "Update"
                                : "Save",
                            onPressed: () => context
                                .read<PartsBloc>()
                                .add(SavePartsEvent())),
                        if (context.watch<PartsBloc>().selectedData != null)
                          SuccessButton(text: "Cancel", backgroundColor: AppC.redAccent,
                              onPressed: () => context.read<PartsBloc>().add(EditCloseEvent())),
                        const Spacer(flex: 1),
                        Expanded(
                          flex: 8,
                          child: CompactSearchView(
                            controller: context.read<PartsBloc>().searchController,
                            onChanged: (value) => context.read<PartsBloc>().add(SearchPartsEvent(value)),
                          ),
                        )
                      ],
                    ),
                  ]
              ),
            ));
  }
}
