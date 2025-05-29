
import 'package:fairpytasker/Component/custom_search_bar.dart';
import 'package:fairpytasker/UI/Finance/Expense/Component/date_range_selection.dart';
import 'package:fairpytasker/UI/offshore_report/operations/bloc/operation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OperationDetailsPage extends StatelessWidget {
  const OperationDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OperationBloc, OperationState>(
        builder: (context, state) => Column(
          spacing: 10,
      children: [
        CustomSearchBar(),
      ],
    ),);
  }
}
