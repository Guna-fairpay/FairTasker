import 'package:fairpytasker/Component/compact_app_bar.dart';
import 'package:fairpytasker/UI/Finance/Expense/other/other_expense_details/bloc/other_expense_details_bloc.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/Utilities/utils.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtherExpenseDetailsListingPage extends StatelessWidget {
  const OtherExpenseDetailsListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherExpenseDetailsBloc, OtherExpenseDetailsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CompactAppBar(
            titleText: 'Test',
            foregroundColour: AppC.white,
            onClose: context.pop,
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Utils.getText(' Total Expense Till Date : ', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        );
      }
    );
  }
}
