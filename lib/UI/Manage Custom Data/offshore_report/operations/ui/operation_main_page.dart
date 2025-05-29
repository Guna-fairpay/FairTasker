import 'package:fairpytasker/UI/Manage%20Custom%20Data/offshore_report/operations/bloc/operation_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/offshore_report/operations/ui/operation_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OperationMainPage extends StatelessWidget {
  const OperationMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => OperationBloc()..add(OperationInitialEvent()),
        child: BlocListener<OperationBloc, OperationState>(
          listener: (context,state){

          },
            child: const OperationDetailsPage())
    );
  }
}
