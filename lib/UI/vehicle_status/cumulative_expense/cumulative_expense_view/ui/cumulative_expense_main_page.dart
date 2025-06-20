
import 'package:fairpytasker/UI/vehicle_status/cumulative_expense/cumulative_expense_view/bloc/cumulative_expense_bloc.dart';
import 'package:fairpytasker/UI/vehicle_status/cumulative_expense/cumulative_expense_view/bloc/cumulative_expense_event.dart';
import 'package:fairpytasker/UI/vehicle_status/cumulative_expense/cumulative_expense_view/bloc/cumulative_expense_state.dart';
import 'package:fairpytasker/UI/vehicle_status/cumulative_expense/cumulative_expense_view/ui/cumulative_expense_listing_page.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CumulativeExpenseMainPage extends StatelessWidget {
  final dynamic data;
  const CumulativeExpenseMainPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('${data?["vehicle_name"]} - ${data?["vin"]}', overflow: TextOverflow.visible, softWrap: true,
        style: context.textTheme.titleMedium?.copyWith(
          color: AppC.white,
          fontWeight: FontWeight.bold
        ),),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff5b9565),
        actions: [
          IconButton(onPressed: context.pop,
              icon: const Icon(Icons.close_outlined,color: Colors.white,))
        ],
      ),
      body: BlocProvider<CumulativeExpenseBloc>(
        create: (context)=>CumulativeExpenseBloc()..add(CumulativeExpenseInitialEvent(data: data)),
        child: BlocListener<CumulativeExpenseBloc, CumulativeExpenseState>(
          listener: (context, state) {
            if(state is CumulativeExpenseLoadingState) EasyLoading.show();
            if(state is CumulativeExpenseCommonState) EasyLoading.dismiss();
          },
          child: const CumulativeExpenseListingPage()
        ),
      )
    );
  }
}
