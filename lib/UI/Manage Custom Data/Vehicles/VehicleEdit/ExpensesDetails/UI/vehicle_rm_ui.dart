
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/Bloc/expense_details_bloc.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/Bloc/expense_details_event.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/Bloc/expense_details_state.dart';
import 'package:fairpytasker/UI/Manage%20Custom%20Data/Vehicles/VehicleEdit/ExpensesDetails/UI/vehicle_rm_listing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VehicleRMUI extends StatelessWidget {
  final String vin;
  const VehicleRMUI({super.key, required this.vin});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExpenseDetailsBloc>(
      create: (context) => ExpenseDetailsBloc()..add(ExpenseDetailsInitialEvent(vin: vin)),
      child: BlocListener<ExpenseDetailsBloc, ExpenseDetailsState>(
        listener: (context, state) {
          if (state is ExpenseDetailsLoadingState) {
            if (!EasyLoading.isShow) EasyLoading.show();
          } else {
            if (EasyLoading.isShow) EasyLoading.dismiss();
          }
        },
        child: const VehicleRMListingPage(),
      ),
    );
  }
}
