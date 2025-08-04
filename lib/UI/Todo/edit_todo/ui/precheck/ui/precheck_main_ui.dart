import 'package:fairpytasker/Component/custom_checkbox.dart';
import 'package:fairpytasker/Component/custom_text/compact_text.dart';
import 'package:fairpytasker/Component/success_button.dart';
import 'package:fairpytasker/UI/Todo/edit_todo/ui/precheck/bloc/precheck_bloc.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'precheck_listing_ui.dart';

class PrecheckMainUI extends StatelessWidget {
  final dynamic model;
  const PrecheckMainUI({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrecheckBloc()..add(InitialEvent(model)),
        child: BlocListener<PrecheckBloc, PrecheckState>(
          listener: (context, state) {

          },
            child: const PrecheckListingUI()
        ),
    );
  }
}
