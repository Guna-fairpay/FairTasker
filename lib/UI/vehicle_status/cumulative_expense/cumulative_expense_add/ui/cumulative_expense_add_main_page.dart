
import 'package:fairpytasker/UI/vehicle_status/cumulative_expense/cumulative_expense_add/bloc/cumulative_expense_add_bloc.dart';
import 'package:fairpytasker/UI/vehicle_status/cumulative_expense/cumulative_expense_add/bloc/cumulative_expense_add_event.dart';
import 'package:fairpytasker/UI/vehicle_status/cumulative_expense/cumulative_expense_add/bloc/cumulative_expense_add_state.dart';
import 'package:fairpytasker/UI/vehicle_status/cumulative_expense/cumulative_expense_add/ui/cumulative_expense_add_form_field.dart';
import 'package:fairpytasker/Utilities/appC.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CumulativeExpenseAddMainPage extends StatelessWidget {
  final dynamic model;
  final List<Map<String,dynamic>>? cohort;
  const CumulativeExpenseAddMainPage({super.key,this.model,this.cohort});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('${model?["vehicle_name"]} - ${model?["vin"]}', overflow: TextOverflow.visible, softWrap: true,
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
      body: BlocProvider<CumulativeExpenseAddBloc>(
          create: (context)=>CumulativeExpenseAddBloc()..add(CumulativeExpenseAddInitialEvent(data: model)),
          child: BlocListener<CumulativeExpenseAddBloc, CumulativeExpenseAddState>(
              listener: (context, state) {
                if(state is CumulativeExpenseAddLoadingState){
                  EasyLoading.show();
                }
                else{
                  if (EasyLoading.isShow) EasyLoading.dismiss();
                  if(state is CumulativeExpenseAddSuccessState) context.pop();
                }
              },
              child: const CumulativeExpenseAddFormField())),
    );
  }
}
