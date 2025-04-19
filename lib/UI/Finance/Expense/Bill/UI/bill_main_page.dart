
import 'package:fairpytasker/UI/Finance/Expense/Bill/Bloc/bill_bloc.dart';
import 'package:fairpytasker/UI/Finance/Expense/Bill/Bloc/bill_event.dart';
import 'package:fairpytasker/UI/Finance/Expense/Bill/Bloc/bill_state.dart';
import 'package:fairpytasker/UI/Finance/Expense/Bill/UI/bill_listing_page.dart';
import 'package:fairpytasker/UI/Finance/Expense/Bill/UI/bill_text_form_page.dart';
import 'package:fairpytasker/UI/Finance/Expense/Vehicle/Vehicle_Add/UI/vehicle_expense_add_ui.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:fairpytasker/core/app/extension/sized_extension.dart';
import 'package:fairpytasker/core/app/helper/console.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BillMainPage extends StatelessWidget {
  const BillMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BillBloc>(
      create: (context)=>BillBloc()..add(BillInitialEvent()),
      child: BlocListener<BillBloc, BillState>(
          listener: (context, state) {
            if(state is BillLoadingState){
              if (!EasyLoading.isShow) EasyLoading.show();
            }
            else{
              if(EasyLoading.isShow)EasyLoading.dismiss();
              if(state is PassBillToExpenseState){
                context.push(ExpenseVehicleAddUI(model: state.value,));
              }
            }
      },
        child:SafeArea(
          minimum: 10.verticalPadding,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children:  [
              const BillTextFormPage(),
              10.height,
              const BillListingPage()
            ],
          ),
        ),
      )
    );
  }
}

